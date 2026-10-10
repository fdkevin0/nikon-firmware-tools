#!/usr/bin/env python3
"""Fetch discovered official Nikon history; statically unpack wrappers, never run them."""
import argparse
import binascii
from concurrent.futures import ThreadPoolExecutor, as_completed
from datetime import datetime, timezone
import hashlib
import json
import os
from pathlib import Path
import re
import subprocess
from urllib.parse import urlsplit
from collect_z_series import open_url
from collect_z8_history import extract_rar_sfx


def sha_file(path):
    with path.open('rb') as stream:
        return hashlib.file_digest(stream, 'sha256').hexdigest()


def member_record(listing, expected):
    records = []
    for block in listing.split('\n\n'):
        fields = dict(line.split(' = ', 1) for line in block.splitlines() if ' = ' in line)
        name = fields.get('Path', '')
        pattern = re.escape(Path(expected).stem) + r'(?:_\d{2})?\.bin'
        if re.fullmatch(pattern, Path(name).name, re.I):
            records.append(fields)
    if len(records) != 1:
        raise ValueError(f'Expected one archive member {expected}, found {len(records)}')
    return records[0]


def fetch(row, root):
    name = row['filename']
    if not re.fullmatch(r'Z[A-Za-z0-9_]*\.bin', name):
        raise ValueError('Unsafe BIN filename')
    destination = root / name
    if destination.exists():
        if destination.is_symlink():
            raise ValueError('Refusing symlink input')
        return {'status': 'existing', 'path': name, 'size': destination.stat().st_size,
                'sha256': sha_file(destination), 'url': row.get('final_cdn_url') or row['download_links'][0]}
    url = row.get('final_cdn_url') or row['download_links'][0]
    folder = root / 'analysis/all_history/downloads'
    folder.mkdir(parents=True, exist_ok=True)
    remote_name = Path(urlsplit(url).path).name
    wrapper = folder / (hashlib.sha256(url.encode()).hexdigest()[:12] + '_' + remote_name)
    metadata = {'url': url}
    with open_url(url) as response:
        expected = int(response.headers['Content-Length'])
        if not 1024 < expected < 512 * 1024 * 1024:
            raise ValueError('Download size outside bounds')
        metadata.update(url=response.url, content_length=expected, last_modified=response.headers.get('Last-Modified'))
        if not wrapper.exists():
            temporary = wrapper.with_suffix(wrapper.suffix + '.part')
            count = 0
            with temporary.open('wb') as file:
                while chunk := response.read(1024 * 1024):
                    if count == 0 and (chunk.lstrip().startswith(b'<') or 'text/html' in response.headers.get('Content-Type', '')):
                        raise ValueError('HTML response instead of binary')
                    count += len(chunk)
                    if count > expected:
                        raise ValueError('Download exceeds declared length')
                    file.write(chunk)
            if count != expected:
                raise ValueError('Truncated download')
            os.link(temporary, wrapper)
            temporary.unlink()
        if wrapper.is_symlink() or wrapper.stat().st_size != expected:
            raise ValueError('Conflicting cached download')
    metadata.update(sha256=sha_file(wrapper), path=str(wrapper.relative_to(root)))
    result = {'status': 'downloaded', 'path': name, 'url': metadata['url'], 'source_file': metadata}
    if remote_name.lower().endswith('.bin'):
        if remote_name.lower() != name.lower():
            raise ValueError('Remote BIN filename mismatch')
        data = wrapper.read_bytes()
        result['extraction'] = 'direct BIN'
    else:
        listing = subprocess.run(['7z', 'l', '-slt', str(wrapper)], capture_output=True, text=True, check=True).stdout
        wrapper.with_suffix(wrapper.suffix + '.listing.txt').write_text(listing)
        member = member_record(listing, name)
        name = Path(member['Path']).name
        destination = root / name
        result['path'] = name
        unpack = subprocess.run(['7z', 'e', '-so', str(wrapper), member['Path']], capture_output=True)
        method = '7z e -so'
        if unpack.returncode:
            data = extract_rar_sfx(wrapper, member['Path'])
            method = 'libarchive RAR reader'
        else:
            data = unpack.stdout
        if len(data) != int(member['Size']):
            raise ValueError('Archive output size mismatch')
        crc = f'{binascii.crc32(data):08X}'
        if member.get('CRC') and member['CRC'].upper() != crc:
            raise ValueError('Archive CRC mismatch')
        result.update(extraction=method, archive_member=member['Path'], archive_crc32=crc)
    if not 1024 < len(data) < 256 * 1024 * 1024:
        raise ValueError('BIN size outside bounds')
    result.update(size=len(data), sha256=hashlib.sha256(data).hexdigest())
    if destination.exists():
        if destination.is_symlink() or sha_file(destination) != result['sha256']:
            raise ValueError('Existing BIN conflicts with extracted archive member')
        result['status'] = 'existing'
        return result
    temp = folder / (name + '.part')
    temp.write_bytes(data)
    os.link(temp, destination)
    temp.unlink()
    return result


def collect(root):
    out = root / 'analysis/all_history'
    discovery = json.loads((out / 'discovery.json').read_text())
    path = out / 'downloads.json'
    previous = json.loads(path.read_text()) if path.exists() else {'versions': []}
    prior = {(r['model'], r['version']): r for r in previous['versions']}
    rows = [dict(r) for r in discovery['versions']]
    def job(row):
        old = prior.get((row['model'], row['version']), {}).get('download', {})
        if old.get('sha256'):
            local = root / old.get('path', row['filename'])
            if local.exists() and sha_file(local) == old['sha256']:
                return old
        if not row.get('download_links'):
            return {'status': 'no_verified_link'}
        errors = []
        for _ in range(3):
            try:
                return fetch(row, root)
            except Exception as error:
                errors.append(str(error))
        return {'status': 'failed', 'errors': errors}
    with ThreadPoolExecutor(max_workers=3) as pool:
        futures = {pool.submit(job, row): row for row in rows}
        for future in as_completed(futures):
            row = futures[future]
            row['download'] = future.result()
            print(row['model'], row['version'], row['download']['status'], row['download'].get('errors', ''), flush=True)
            temp = path.with_suffix('.json.tmp')
            temp.write_text(json.dumps({'collected_at_utc': datetime.now(timezone.utc).isoformat(), 'versions': rows}, indent=2) + '\n')
            temp.replace(path)


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('directory', type=Path)
    collect(parser.parse_args().directory)
