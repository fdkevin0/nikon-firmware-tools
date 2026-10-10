#!/usr/bin/env python3
"""Inventory and download publicly linked Nikon Z camera firmware.

Enumerates Nikon's product XML plus annual update indexes. Does not claim to
find delisted historical versions. Downloads binaries, never executes them.
Existing files are retained; conflicting lengths cause an error.
"""

import argparse
from concurrent.futures import ThreadPoolExecutor
from collections import Counter
import csv
from datetime import datetime, timezone
import hashlib
from html.parser import HTMLParser
import json
import os
from pathlib import Path
import re
import urllib.error
import urllib.parse
import urllib.request
import xml.etree.ElementTree as ET


BASE = "https://downloadcenter.nikonimglib.com"
CAMERA = re.compile(r"Z(?:\s*\d+(?:II|III)?|\s*f[c]?|R)", re.I)


class Page(HTMLParser):
    def __init__(self, html):
        super().__init__(convert_charrefs=True)
        self.links, self.text, self.current = [], [], None
        self.feed(html)

    def handle_starttag(self, tag, attrs):
        if tag == "a":
            self.current = [dict(attrs).get("href", ""), []]

    def handle_data(self, text):
        self.text.append(text)
        if self.current is not None:
            self.current[1].append(text)

    def handle_endtag(self, tag):
        if tag == "a" and self.current is not None:
            self.links.append((self.current[0], " ".join("".join(self.current[1]).split())))
            self.current = None


def official_url(url):
    parsed = urllib.parse.urlsplit(url)
    host = parsed.hostname or ""
    if parsed.scheme != "https" or not (host == "nikonimglib.com" or host.endswith(".nikonimglib.com")):
        raise ValueError(f"Not an official Nikon HTTPS URL: {url}")
    return url


class OfficialRedirect(urllib.request.HTTPRedirectHandler):
    def redirect_request(self, request, fp, code, msg, headers, newurl):
        official_url(newurl)
        return super().redirect_request(request, fp, code, msg, headers, newurl)


def open_url(url):
    request = urllib.request.Request(official_url(url), headers={"User-Agent": "Mozilla/5.0 NikonFirmwareResearch/1.0"})
    return urllib.request.build_opener(OfficialRedirect()).open(request, timeout=60)


def get_page(url, cache):
    key = hashlib.sha256(url.encode()).hexdigest()[:20] + ".html"
    path = cache / key
    if path.exists():
        return path.read_text(encoding="utf-8")
    with open_url(url) as response:
        raw = response.read(4 * 1024 * 1024 + 1)
        if len(raw) > 4 * 1024 * 1024:
            raise ValueError("Metadata page exceeds size bound")
    html = raw.decode("utf-8-sig")
    path.write_text(html, encoding="utf-8")
    return html


def product_list(xml):
    return [{"model": product.attrib["name"], "product_url": BASE + product.attrib["href"]}
            for product in ET.fromstring(xml).iter("product")
            if CAMERA.fullmatch(product.get("name", ""))]


def firmware_details(html):
    page = Page(html)
    text = " ".join(page.text)
    names = sorted(set(re.findall(r"\bZ[A-Za-z0-9_]*\.bin\b", text)))
    links = list(dict.fromkeys(url for url, _ in page.links if "crossgate.nikonimglib.com/dsd_redirect/" in url))
    if len(names) != 1 or not links:
        raise ValueError(f"Expected one BIN filename and download links; found {names}, {len(links)} links")
    changes = re.findall(r"Firmware Version\s+(\d+\.\d+)\s+to\s+(\d+\.\d+)", text)
    versions = sorted({version for pair in changes for version in pair}, key=lambda v: tuple(map(int, v.split('.'))))
    return {"filename": names[0], "download_links": links,
            "versions_named_in_changelog": versions,
            "history_note": "Version mentions do not imply a current public download link"}


def download(row, root):
    name = row["filename"]
    if not re.fullmatch(r"Z[A-Za-z0-9_]*\.bin", name):
        raise ValueError("Unsafe firmware filename")
    destination = root / name
    partial = root / "analysis/catalog/downloads" / (name + ".part")
    partial.parent.mkdir(parents=True, exist_ok=True)
    with open_url(row["download_links"][0]) as response:
        actual = urllib.parse.unquote(Path(urllib.parse.urlsplit(response.url).path).name)
        if actual != name:
            raise ValueError(f"Expected {name}, redirected to {actual}")
        expected = int(response.headers["Content-Length"]) if response.headers.get("Content-Length") else None
        result = {"url": response.url, "content_length": expected,
                  "last_modified": response.headers.get("Last-Modified"), "etag": response.headers.get("ETag")}
        if destination.exists():
            if destination.is_symlink() or (expected is not None and destination.stat().st_size != expected):
                raise ValueError(f"Existing firmware conflicts with remote length: {name}")
            result["status"] = "existing"
        else:
            digest, size = hashlib.sha256(), 0
            with partial.open("wb") as file:
                while chunk := response.read(1024 * 1024):
                    if size == 0 and (chunk.lstrip().startswith(b"<") or b"text/html" in response.headers.get("Content-Type", "").encode()):
                        raise ValueError("Download is HTML, not firmware")
                    size += len(chunk)
                    file.write(chunk)
                    digest.update(chunk)
            if not size or (expected is not None and size != expected):
                raise ValueError(f"Incomplete download: {name}, {size}/{expected}")
            # A concurrent appearance of a destination must not overwrite input.
            os.link(partial, destination)
            partial.unlink()
            result.update(status="downloaded", size=size, sha256=digest.hexdigest())
    if "sha256" not in result:
        with destination.open("rb") as file:
            result.update(size=destination.stat().st_size, sha256=hashlib.file_digest(file, "sha256").hexdigest())
    return result


def write_history_coverage(root, catalog):
    rows = []
    for page in catalog["firmware_pages"]:
        if page["metadata_status"] != "ok":
            continue
        prefix, number = Path(page["filename"]).stem.rsplit("_", 1)
        current = f"{int(number[:-2])}.{number[-2:]}"
        for version in page["versions_named_in_changelog"]:
            major, minor = version.split(".")
            filename = f"{prefix}_{int(major):02d}{minor}.bin"
            exists = (root / filename).exists()
            rows.append({"model": page["models"][0], "version": version,
                         "status": "current_downloaded" if version == current and exists else
                                   "retained_local" if exists else "mentioned_no_download_link_discovered",
                         "filename": filename if exists else "", "source_page": page["page_url"]})
    with (root / "analysis/catalog/history_coverage.csv").open("w", newline="") as file:
        writer = csv.DictWriter(file, fieldnames=["model", "version", "status", "filename", "source_page"])
        writer.writeheader()
        writer.writerows(rows)
    catalog["history_coverage"] = {"mentioned_model_versions": len(rows),
                                    "statuses": dict(Counter(row["status"] for row in rows)),
                                    "artifact": "history_coverage.csv",
                                    "limitation": "Factory/shipping versions may never have had a public BIN download"}


def collect(root, through_year, fetch_binaries):
    out = root / "analysis/catalog"
    cache = out / "pages"
    cache.mkdir(parents=True, exist_ok=True)
    catalog = {"collected_at_utc": datetime.now(timezone.utc).isoformat(),
               "scope": "Every camera in Nikon's Z product catalog; publicly linked annual firmware records, 2018 onward",
               "history_limit": "Official indexes omit delisted releases; this is not an exhaustive archive of every historical version",
               "product_xml": BASE + "/en/1/product_data.xml", "models": [], "firmware_pages": [],
               "history_indexes": [], "errors": []}
    models = product_list(get_page(catalog["product_xml"], cache))
    catalog["models"] = models
    pages = {}

    def remember(url, source, model=None, label=None):
        url = urllib.parse.urljoin(BASE, url)
        if not re.fullmatch(r"https://downloadcenter\.nikonimglib\.com/en/download/fw/\d+\.html", url):
            return
        row = pages.setdefault(url, {"page_url": url, "sources": [], "models": [], "labels": []})
        for key, value in [("sources", source), ("models", model), ("labels", label)]:
            if value and value not in row[key]:
                row[key].append(value)

    for model in models:
        try:
            page = Page(get_page(model["product_url"], cache))
            urls = sorted({urllib.parse.urljoin(BASE, url) for url, _ in page.links if re.fullmatch(r"/en/download/fw/\d+\.html", url)})
            model["current_firmware_pages"] = urls
            for url in urls:
                remember(url, model["product_url"], model["model"])
            print(f"Catalog: {model['model']}: {len(urls)} firmware page(s)", flush=True)
        except Exception as error:
            catalog["errors"].append({"url": model["product_url"], "error": str(error)})
    for year in range(2018, through_year + 1):
        url = BASE + f"/en/update/index/{year}.html"
        try:
            page = Page(get_page(url, cache))
            history_rows = []
            for link, label in page.links:
                match = re.fullmatch(r"(.+?) Firmware Version ([\d.]+)", label)
                if match and CAMERA.fullmatch(match[1]):
                    remember(link, url, match[1], label)
                    history_rows.append({"label": label, "url": urllib.parse.urljoin(BASE, link)})
            catalog["history_indexes"].append({"url": url, "camera_firmware_links": history_rows})
        except Exception as error:
            catalog["errors"].append({"url": url, "error": str(error)})
    # Include the previously obtained official Z f 1.21 bridge release even if
    # the current annual index no longer links it.
    if (root / "Z_f_0121.bin").exists():
        remember(BASE + "/en/download/fw/545.html", "previous local investigation", "Z f", "Z f Firmware Version 1.21")
    for row in pages.values():
        try:
            row.update(firmware_details(get_page(row["page_url"], cache)))
            row["metadata_status"] = "ok"
        except Exception as error:
            row.update(metadata_status="unavailable", error=str(error))
        catalog["firmware_pages"].append(row)
    if fetch_binaries:
        unique = {}
        for row in catalog["firmware_pages"]:
            if row["metadata_status"] == "ok":
                unique.setdefault(row["filename"], row)

        def job(row):
            try:
                result = download(row, root)
            except Exception as error:
                result = {"status": "failed", "error": str(error)}
            print(f"Firmware: {row['filename']}: {result['status']}", flush=True)
            return row["filename"], result

        with ThreadPoolExecutor(max_workers=3) as pool:
            downloads = dict(pool.map(job, unique.values()))
        for row in catalog["firmware_pages"]:
            if row["metadata_status"] == "ok":
                row["download"] = downloads[row["filename"]]
    listed = {row.get("filename") for row in catalog["firmware_pages"]}
    catalog["retained_unlisted_samples"] = []
    for path in sorted(root.glob("*.bin")):
        if path.name not in listed:
            with path.open("rb") as file:
                digest = hashlib.file_digest(file, "sha256").hexdigest()
            catalog["retained_unlisted_samples"].append({"filename": path.name, "size": path.stat().st_size,
                                                        "sha256": digest, "status": "retained_local_sample"})
    write_history_coverage(root, catalog)
    (out / "manifest.json").write_text(json.dumps(catalog, indent=2) + "\n")
    print(f"Saved {len(models)} models, {len(pages)} linked firmware pages: {out / 'manifest.json'}", flush=True)
    return catalog


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("directory", type=Path)
    parser.add_argument("--through-year", type=int, default=datetime.now(timezone.utc).year)
    parser.add_argument("--download", action="store_true")
    args = parser.parse_args()
    collect(args.directory, args.through_year, args.download)


if __name__ == "__main__":
    main()
