# Nikon 机身与镜头通信协议研究资料 (Lens Communication)

[English](#english) | 中文说明

## 中文说明

### 简介与背景
本目录保存了关于 **Nikon F 卡口机身与镜头之间电气通信协议**的珍贵历史研究资料。

这些内容最早由作者 **Gazalou** 发表在 [NikonPassion](http://www.nikonpassion.com/) 论坛与网站上。由于原始文章及其配图在互联网上已无法访问，用户 **ubmtdc** 为社区提供了这些页面的 PDF 存档副本及英文翻译。

### 目录文件清单

1. **协议分析文档 (PDF)**：
   - [Interpretation des signaux boitier-objectif 1.pdf](Interpretation%20des%20signaux%20boitier-objectif%201.pdf)：Gazalou 撰写的第一部分原始文章（法文原版）。
   - [Interpretation des signaux boitier-objectif 2.pdf](Interpretation%20des%20signaux%20boitier-objectif%202.pdf)：第二部分原始文章（法文原版）。
   - [Body-Lens signal interpretation 1 - Translated.pdf](Body-Lens%20signal%20interpretation%201%20-%20Translated.pdf)：第一部分英文翻译版。
   - [Body-Lens signal interpretation 2 - Translated.pdf](Body-Lens%20signal%20interpretation%202%20-%20Translated.pdf)：第二部分英文翻译版。

2. **引脚与通信实现源码**：
   - [pins.txt](pins.txt)：Joseph Wisniewski 整理的 Nikon 卡口通信引脚定义说明。
   - [orig.translated.c](orig.translated.c)：Gazalou 编写的早期 C 语言原型源码（使用 PIC 单片机模拟尼康镜头通信，法语注释已翻译为英文）。

### 历史讨论
- [NikonHacker 论坛讨论帖](http://nikonhacker.com/viewtopic.php?f=8&t=671) `[历史归档]`

---

<a name="english"></a>
## English

### Overview
This directory contains copies of historical documents covering the serial communication protocol and pinouts between Nikon camera bodies and lenses.

Originally authored by **Gazalou** on [NikonPassion](http://www.nikonpassion.com/). Because the original articles went offline and images were lost on the Wayback Machine, user **ubmtdc** kindly provided PDF captures and English translations.

### Included Files
- `Interpretation des signaux boitier-objectif 1.pdf` & `2.pdf`: Original articles in French by Gazalou.
- `Body-Lens signal interpretation 1 - Translated.pdf` & `2.pdf`: English translations.
- `pins.txt`: Pinout and signal definitions collected by Joseph Wisniewski.
- `orig.translated.c`: Prototype C source code by Gazalou emulating a Nikon lens on a PIC microcontroller.
