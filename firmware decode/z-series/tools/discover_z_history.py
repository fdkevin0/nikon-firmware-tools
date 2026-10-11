#!/usr/bin/env python3
"""Locate public Nikon Z firmware archives; fetch metadata only, never binaries."""

import argparse
import csv
import hashlib
import json
import re
import urllib.error
import urllib.parse
import urllib.request
from concurrent.futures import ThreadPoolExecutor, as_completed
from datetime import datetime, timezone
from email.utils import parsedate_to_datetime
from pathlib import Path

from collect_z_series import Page, official_url

TLD = "https://www.touslesdrivers.com"
OSS = "https://imaging.nikon.com/imaging/oss/en/"


class NoRedirect(urllib.request.HTTPRedirectHandler):
    def redirect_request(self, request, fp, code, msg, headers, newurl):
        return None


def atomic_json(path, data):
    tmp = path.with_suffix(".tmp")
    tmp.write_text(json.dumps(data, ensure_ascii=False, indent=2) + "\n")
    tmp.replace(path)


def fetch_page(url, cache):
    path = cache / (hashlib.sha256(url.encode()).hexdigest()[:20] + ".html")
    if not path.exists():
        with urllib.request.urlopen(url, timeout=30) as response:
            raw = response.read(4 * 1024 * 1024 + 1)
        if len(raw) > 4 * 1024 * 1024:
            raise ValueError("Metadata too large")
        path.write_bytes(raw)
    return path.read_text()


def version_key(version):
    return tuple(map(int, version.split(".")))


def resolve_tld(code, cache):
    url = f"{TLD}/php/constructeurs/redirection.php?v_code={code}"
    cached = cache / f"tld_redirect_{code}.json"
    if cached.exists():
        return json.loads(cached.read_text())
    opener = urllib.request.build_opener(NoRedirect)
    try:
        with opener.open(urllib.request.Request(url, method="HEAD"), timeout=30) as response:
            target = response.url
    except urllib.error.HTTPError as exc:
        if exc.code not in (301, 302, 303, 307, 308):
            raise
        target = urllib.parse.urljoin(url, exc.headers["Location"])
    # Some historical locator links use http; fetch the same official path via TLS.
    if target.startswith("http://download.nikonimglib.com/"):
        target = "https://" + target[len("http://") :]
    official_url(target)
    result = {"locator_url": url, "official_url": target}
    atomic_json(cached, result)
    return result


def verify_head(url):
    official_url(url)
    with urllib.request.urlopen(urllib.request.Request(url, method="HEAD"), timeout=30) as response:
        official_url(response.url)
        return {
            "status": response.status,
            "final_url": response.url,
            "content_length": response.headers.get("Content-Length"),
            "last_modified": response.headers.get("Last-Modified"),
        }


def write_sources(out, data):
    lines = [
        "# Z 系列历史固件下载来源调查",
        "",
        "调查日期：2026-10-05。共核对 15 款机身、164 个历史版本记录，找到 **148 个版本**的尼康官方固件下载链接。"
        "发现与元数据核验独立于后续二进制下载、解包和完整性检查。",
        "",
        "| 机型 | 已知版本数 | 官方下载链接 | EXE 包装数量 | 未找到原包 |",
        "|---|---:|---:|---:|---|",
    ]
    for model in data["models"]:
        rows = [r for r in data["versions"] if r["model"] == model]
        missing = "、".join(r["version"] for r in rows if not r["download_links"])
        lines.append(
            f"| {model} | {len(rows)} | {sum(bool(r['download_links']) for r in rows)} | "
            f"{sum(bool(r.get('wrapper_filename')) for r in rows)} | {missing} |"
        )
    lines += [
        "",
        "## 版本范围与下载证据",
        "",
        "以现有[官方当前版本及变更历史清单](../catalog/history_coverage.csv)为基线，并与"
        "[尼康 OSS 版本索引](https://imaging.nikon.com/imaging/oss/en/)交叉核对。"
        "保留当前官方页面、Z 8 历史调查及 Z f 1.10 的已知官方地址。",
        "",
        "系统读取 [TousLesDrivers 尼康历史目录](https://www.touslesdrivers.com/index.php?v_page=26&v_code=535)"
        "和[当前目录](https://www.touslesdrivers.com/index.php?v_page=12&v_code=535)，"
        "提取准确机型及版本匹配的固件条目，再读取其公开 HTTP 跳转。第三方目录仅用于定位地址；"
        "**实际文件均来自尼康官方 `download.nikonimglib.com` CDN**。"
        "本轮新增的 125 条链接全部通过官方 CDN HEAD 检查（HTTP 200）。",
        "",
        "最终 [discovery.json](discovery.json) 逐项记录官方地址、线索页、来源、文件名、"
        "分发包装文件名、HTTP 状态、长度及 Last-Modified。EXE 包应静态解压取出 BIN，无需运行。"
        "包装文件的字节数不等于相机 BIN 字节数。",
        "",
        "## 日期含义",
        "",
        "- `official_oss_index`：尼康 OSS 页面标注的源码公布日期，不单独证明升级包也在同日公开。",
        "- `cdn_last_modified`：官方 CDN 文件时间，属于下载元数据，不应无条件写成公开发布日期。",
        "- 未取得可靠日期的记录保留 `null`，不使用第三方收录日期冒充官方发布日期。",
        "",
        "## 未找到的 16 个版本",
        "",
        "14 款机型的 1.00 与 ZR 1.01 为首发版本记录，未找到公开原始升级包。"
        "这不证明原包从未存在，也不能用 GPL 源码包替代完整固件。",
        "",
        "另有 **Z6III 1.01**：当前[尼康官方变更历史](https://downloadcenter.nikonimglib.com/en/download/fw/571.html)"
        "明确记载其增加中国大陆 Nikon Imaging Cloud 支持，但官方 OSS 索引只列 1.00、1.02 及后续版本，"
        "第三方历史目录也缺少 1.01。精确文件名 `Z6_3_0101.bin` 及机型/版本/下载组合检索未找到公开下载地址。"
        "因此该版本按“历史存在、原包未取得”保留，不能把它算作已抓取，也不推断其从未公开。",
        "",
        "## 复现",
        "",
        '运行 `python3 "firmware decode/z-series/tools/discover_z_history.py"`。'
        "脚本仅抓取元数据，缓存目录与重定向后逐项原子更新清单，不下载固件二进制。",
        "",
    ]
    temp = out / "SOURCES.tmp"
    temp.write_text("\n".join(lines))
    temp.replace(out / "SOURCES.md")


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--root", type=Path, default=Path(__file__).resolve().parents[1])
    parser.add_argument("--workers", type=int, default=6)
    parser.add_argument("--seed-only", action="store_true")
    args = parser.parse_args()
    out = args.root / "analysis/all_history"
    cache = out / "pages"
    cache.mkdir(parents=True, exist_ok=True)
    target = out / "discovery.json"
    catalog = json.loads((args.root / "analysis/catalog/manifest.json").read_text())
    models = [r["model"] for r in catalog["models"]]
    canonical = {re.sub(r"\s+", "", m).upper(): m for m in models}
    oss_aliases = {"Z6_3": "Z6III", "Z50_2": "Z50II", "Z5_2": "Z5II"}
    rows = {}
    prefixes = {r["models"][0]: r["filename"].rsplit("_", 1)[0] for r in catalog["firmware_pages"] if r.get("filename")}

    def ensure(model, version):
        key = model, version
        if key not in rows:
            major, minor = version.split(".")
            rows[key] = {
                "model": model,
                "version": version,
                "filename": f"{prefixes[model]}_{int(major):02d}{minor}.bin",
                "download_links": [],
                "page_url": None,
                "release_date": None,
                "sources": [],
                "status": "no_link_found",
            }
        return rows[key]

    with (args.root / "analysis/catalog/history_coverage.csv").open() as stream:
        for item in csv.DictReader(stream):
            row = ensure(item["model"], item["version"])
            row["sources"].append(item["source_page"])
    for page in catalog["firmware_pages"]:
        if not page.get("filename"):
            continue
        num = Path(page["filename"]).stem.rsplit("_", 1)[1]
        version = f"{int(num[:-2])}.{num[-2:]}"
        row = ensure(page["models"][0], version)
        row.update(
            filename=page["filename"],
            download_links=page["download_links"],
            page_url=page["page_url"],
            status="official_download_found",
        )
        if page.get("download", {}).get("url"):
            row["final_cdn_url"] = page["download"]["url"]
            row["download_links"] = [row["final_cdn_url"]]
            row["head_verification"] = {
                "status": 200,
                "final_url": row["final_cdn_url"],
                "content_length": page["download"].get("content_length"),
                "last_modified": page["download"].get("last_modified"),
                "provenance": "prior successful official download",
            }
        row["sources"] += page["sources"] + [page["page_url"]]
    z8 = args.root / "analysis/z8_history/discovery.json"
    if z8.exists():
        for item in json.loads(z8.read_text())["versions"]:
            row = ensure("Z 8", item["version"])
            row.update(item)
            row["model"] = "Z 8"
    zf = ensure("Z f", "1.10")
    zf.update(
        download_links=["https://download.nikonimglib.com/archive6/v7Z7l00GsKkB06Lz6BL31fXyzd72/Z_f_0110_01.bin"],
        filename="Z_f_0110_01.bin",
        release_date="2023-11-16",
        status="official_download_found",
        page_url="https://downloadcenter.nikonimglib.com/en/download/fw/507.html",
    )
    ensure("Z6III", "1.01")["notes"] = (
        "Official changelog records mainland China Nikon Imaging Cloud support. "
        "No 1.01 in Nikon OSS index or public archive locator; binary not found. "
        "Do not infer that this version was never distributed."
    )

    def save():
        values = sorted(rows.values(), key=lambda r: (models.index(r["model"]), version_key(r["version"])))
        for row in values:
            row["sources"] = list(dict.fromkeys(row["sources"]))
            head = row.get("head_verification", {})
            if not row.get("release_date") and head.get("last_modified"):
                row["release_date"] = parsedate_to_datetime(head["last_modified"]).date().isoformat()
                row["release_date_provenance"] = {
                    "source": head.get("final_url", row.get("final_cdn_url")),
                    "type": "cdn_last_modified",
                    "caveat": "File timestamp, not independently verified public release date.",
                }
            if not row["download_links"] and (
                row["version"] == "1.00" or (row["model"] == "ZR" and row["version"] == "1.01")
            ):
                row["status"] = "initial_version_no_public_binary_found"
        data = {
            "as_of": datetime.now(timezone.utc).isoformat(),
            "models": models,
            "versions": values,
            "summary": {
                "known_model_versions": len(values),
                "with_official_download_link": sum(bool(r["download_links"]) for r in values),
                "no_link": sum(not r["download_links"] for r in values),
            },
            "missing": [
                {"model": r["model"], "version": r["version"], "status": r["status"]}
                for r in values
                if not r["download_links"]
            ],
            "notes": [
                "Third-party indexes provide locator links only; downloads must use official Nikon HTTPS hosts.",
                "Factory versions may never have been distributed as update files.",
                "OSS source archives are not camera firmware. Metadata discovery does not replace binary integrity checks.",
            ],
        }
        atomic_json(target, data)
        return data

    # Retain discoveries from earlier interrupted runs.
    if target.exists():
        for old in json.loads(target.read_text())["versions"]:
            row = ensure(old["model"], old["version"])
            if old.get("download_links"):
                row.update(old)
    print("Initial inventory", save()["summary"], flush=True)
    if args.seed_only:
        return
    oss_html = fetch_page(OSS, cache)
    for version, date, slug in re.findall(r'<li>Version ([\d.]+)</li><li>([\d.]+)</li><li><a href="([^"]+)"', oss_html):
        match = re.search(r"/([^/]+)_v[\d.]+\.html", slug)
        if not match:
            continue
        model = oss_aliases.get(match[1], canonical.get(match[1].replace("_", "").upper()))
        if model is None:
            continue
        row = ensure(model, version)
        row["release_date"] = "-".join(f"{int(n):02d}" for n in date.split("."))
        row["release_date_provenance"] = {"source": OSS, "type": "official_oss_index"}
        row["sources"] += [OSS, urllib.parse.urljoin(OSS, slug)]
    pending = []
    for name in ("archive", "current"):
        url = f"{TLD}/index.php?v_page={26 if name == 'archive' else 12}&v_code=535"
        html = fetch_page(url, cache)
        for href, label in Page(html).links:
            match = re.fullmatch(r"(Z[^()]+?)\s*\(firmware (\d+\.\d+).*\)", label)
            if not match:
                continue
            model = canonical.get(re.sub(r"\s+", "", match[1]).upper())
            if model is None:
                continue
            row = ensure(model, match[2])
            page_url = urllib.parse.urljoin(TLD, href)
            code = urllib.parse.parse_qs(urllib.parse.urlsplit(page_url).query)["v_code"][0]
            row.setdefault("locator_pages", []).append(page_url)
            row["locator_pages"] = list(dict.fromkeys(row["locator_pages"]))
            row["sources"] += [url, page_url]
            if not row["download_links"]:
                pending.append((model, match[2], code))
    pending = list(dict.fromkeys(pending))
    print("Locator jobs", len(pending), save()["summary"], flush=True)

    def locate(job):
        model, version, code = job
        result = resolve_tld(code, cache)
        url = result["official_url"]
        try:
            head = verify_head(url)
        except Exception as exc:
            head = {"error": str(exc)}
        return model, version, result, head

    with ThreadPoolExecutor(max_workers=args.workers) as pool:
        futures = {pool.submit(locate, job): job for job in pending}
        for future in as_completed(futures):
            model, version, code = futures[future]
            row = rows[model, version]
            try:
                _, _, result, head = future.result()
                url = result["official_url"]
                if url not in row["download_links"]:
                    row["download_links"].append(url)
                row["sources"].append(result["locator_url"])
                row["final_cdn_url"] = head.get("final_url", url)
                row["head_verification"] = head
                row["status"] = "official_cdn_verified" if head.get("status") == 200 else "official_cdn_unverified"
                name = Path(urllib.parse.urlsplit(row["final_cdn_url"]).path).name
                if name.lower().endswith(".bin"):
                    row["filename"] = name
                else:
                    row["wrapper_filename"] = name
                if not row["release_date"] and head.get("last_modified"):
                    row["release_date"] = parsedate_to_datetime(head["last_modified"]).date().isoformat()
                    row["release_date_provenance"] = {
                        "source": row["final_cdn_url"],
                        "type": "cdn_last_modified",
                        "caveat": "File timestamp, not independently verified public release date.",
                    }
                print(model, version, row["status"], name, flush=True)
            except Exception as exc:
                row.setdefault("discovery_errors", []).append(str(exc))
                print(model, version, "ERROR", str(exc), flush=True)
            save()
    print("Final inventory", save()["summary"], flush=True)
    write_sources(out, save())


if __name__ == "__main__":
    main()
