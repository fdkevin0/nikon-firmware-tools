# Nikon Z-Series Camera Release Timeline

This document catalogs official product announcement dates, processor generations, and verified container packaging types across the 15 Nikon Z-series cameras in this repository scope. It includes full-frame (FX), DX crop, and Z CINEMA (ZR) bodies. Kit variations, colorways, special editions, RED-branded products, lenses, and accessories are excluded.

Last verified: **2026-10-05**.

"Release date" uniformly refers to the date published on Nikon's official press announcement, prioritizing Nikon Global, with regional press releases noted where applicable. Development announcements, preorder openings, regional market availability, and shipping deliveries are distinct events and do not override announcement dates. Dates are recorded as original strings without timezone conversions.

| Official Announcement | Model | Sensor Format | Image Processor | Checked Firmware | Container Format | Announcement Source |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| 2018-08-23 | Z7 | FX Full-frame | EXPEED 6 | 3.80 | Legacy XOR | [Nikon Global Z7 / Z6 Press Release](https://www.nikon.com/company/news/2018/0823_mirrorless_01/) |
| 2018-08-23 | Z6 | FX Full-frame | EXPEED 6 | 3.80 | Legacy XOR | [Nikon Global Z7 / Z6 Press Release](https://www.nikon.com/company/news/2018/0823_mirrorless_01/) |
| 2019-10-10 | Z50 | DX APS-C | EXPEED 6 | 2.60 | Legacy XOR | [Nikon Global Z50 Press Release](https://www.nikon.com/company/news/2019/1010_zmount_01/) |
| 2020-07-21 | Z5 | FX Full-frame | EXPEED 6 | 1.50 | Legacy XOR | [Nikon USA Z5 Press Release](https://www.nikonusa.com/press-room/new-z-5) |
| 2020-10-14 | Z6II | FX Full-frame | Dual EXPEED 6 | 1.70 | Legacy XOR | [Nikon USA Z6II / Z7II Press Release](https://www.nikonusa.com/press-room/z7ii-z6ii) |
| 2020-10-14 | Z7II | FX Full-frame | Dual EXPEED 6 | 1.70 | Legacy XOR | [Nikon USA Z6II / Z7II Press Release](https://www.nikonusa.com/press-room/z7ii-z6ii) |
| 2021-06-29 | Z fc | DX APS-C | EXPEED 6 | 1.81 | Legacy XOR | [Nikon USA Z fc Press Release](https://www.nikonusa.com/press-room/z-fc) |
| 2021-10-28 | Z9 | FX Full-frame | EXPEED 7 | 5.32 | Legacy XOR | [Nikon Global Z9 Press Release](https://www.nikon.com/company/news/2021/1028_mirrorless_01/) |
| 2022-06-29 | Z30 | DX APS-C | EXPEED 6 | 1.20 | Legacy XOR | [Nikon Global Z30 Press Release](https://www.nikon.com/company/news/2022/0629_mirrorless_01/) |
| 2023-05-10 | Z8 | FX Full-frame | EXPEED 7 | 3.11 | Legacy XOR | [Nikon Global Z8 Press Release](https://www.nikon.com/company/news/2023/0510_mirrorless_01/) |
| **2023-09-20** | **Z f** | FX Full-frame | EXPEED 7 | **1.10, 1.21, 3.01** | **New 0x260 Prefix** | [Nikon Global Z f Press Release](https://www.nikon.com/company/news/2023/0920_mirrorless_01/) |
| 2024-06-17 | Z6III | FX Full-frame | EXPEED 7 | 2.00 | New 0x260 Prefix | [Nikon Global Z6III Press Release](https://www.nikon.com/company/news/2024/0617_imaging_01/) |
| 2024-11-07 | Z50II | DX APS-C | EXPEED 7 | 1.11 | New 0x260 Prefix | [Nikon Global Z50II Press Release](https://www.nikon.com/company/news/2024/1107_imaging_01/) |
| 2025-04-03 | Z5II | FX Full-frame | EXPEED 7 | 1.20 | New 0x260 Prefix | [Nikon Global Z5II Press Release](https://www.nikon.com/company/news/2025/0403_imaging_01/) |
| 2025-09-10 | ZR | FX Full-frame, Z CINEMA | EXPEED 7 | 1.11 | New 0x260 Prefix | [Nikon Global ZR Press Release](https://www.nikon.com/company/news/2025/0910_imaging_01/) |

Processor designations are verified against the [official Nikon EXPEED model index](https://nij.nikon.com/support/faq/products/article?articleNo=000055730); dual-processor configurations for Z6II/Z7II are corroborated by their respective press announcements.

Z50II exhibits a slight regional announcement date discrepancy: the US press release is dated **2024-11-06**, while global is **2024-11-07**. The table retains the global date.

---

## Container Packaging Distribution

- **Legacy Packaging**: Packages decoded using Nikon Hacker's 3-table XOR algorithm, with space padding at offset `0x20`.
- **New Packaging**: Packages featuring fixed extended headers and space markers shifted to `0x260`.

In chronological order of camera announcements, **Z f and subsequent models use the new packaging format**, whereas all earlier ten models use legacy XOR packaging.

Notably, Z8 and Z9 utilize EXPEED 7 but retain legacy packaging; conversely, Z50II is DX format but uses new packaging. Thus, processor generation and sensor format alone do not dictate container format.
