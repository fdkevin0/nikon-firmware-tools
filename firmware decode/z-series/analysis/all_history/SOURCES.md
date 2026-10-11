# Z-Series Historical Firmware Download Sources Survey

Survey date: 2026-10-05. Across 15 camera bodies and 164 historical version records, official Nikon CDN download URLs were resolved for **148 releases**.
Source discovery and metadata verification operate independently of binary payload downloads, decoding, and checksum verification.

| Model | Known Releases | Official Download URLs | EXE Packages | Missing Packages |
|---|---:|---:|---:|---|
| Z 30 | 4 | 3 | 1 | 1.00 |
| Z 5 | 12 | 11 | 9 | 1.00 |
| Z 50 | 15 | 14 | 12 | 1.00 |
| Z 6 | 18 | 17 | 15 | 1.00 |
| Z 6II | 13 | 12 | 10 | 1.00 |
| Z 7 | 20 | 19 | 17 | 1.00 |
| Z 7II | 13 | 12 | 10 | 1.00 |
| Z 8 | 9 | 8 | 1 | 1.00 |
| Z 9 | 18 | 17 | 11 | 1.00 |
| Z f | 9 | 8 | 0 | 1.00 |
| Z fc | 11 | 10 | 6 | 1.00 |
| Z50II | 7 | 6 | 0 | 1.00 |
| Z5II | 6 | 5 | 0 | 1.00 |
| Z6III | 6 | 4 | 0 | 1.00, 1.01 |
| ZR | 3 | 2 | 0 | 1.01 |

## Version Scope & Download Evidence

Baselined against the [current official releases and change history](../catalog/history_coverage.csv) and cross-referenced with the [Nikon OSS release index](https://imaging.nikon.com/imaging/oss/en/).
Preserves current official pages and established addresses for Z 8 history and Z f 1.10.

Systematic index retrieval through TousLesDrivers Nikon archives resolves exact model/version matches and public HTTP redirects.
**All actual files originate from official `download.nikonimglib.com` CDN endpoints**.
All newly discovered URLs were verified via official CDN HTTP HEAD requests (HTTP 200).

[discovery.json](discovery.json) records official URLs, referral pages, sources, filenames, wrapper names, HTTP status codes, payload sizes, and Last-Modified timestamps.

## Date Semantics

- `official_oss_index`: Release date indicated on Nikon OSS pages; does not independently prove update packages were released on the same day.
- `cdn_last_modified`: Official CDN file timestamp (download metadata); should not be conflated with public release announcements.
- Records without verified dates retain `null` rather than substituting third-party scrape dates.

## 16 Uncollected Releases

14 models' 1.00 factory releases and ZR 1.01 represent launch-day versions without publicly released updater binaries.
Additionally, **Z6III 1.01** is documented in Nikon change histories (adding Nikon Imaging Cloud support in Mainland China), but omitted from official OSS indices and mirrors.
These versions are classified as 'historical presence, binary unobtained'.

## Reproduction

Run `uv run python tools/discover_z_history.py`.
The script retrieves metadata and updates manifests without downloading heavy binary payloads.
