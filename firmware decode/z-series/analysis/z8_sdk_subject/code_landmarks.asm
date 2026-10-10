
; Z8 1.01 property 0x1d005, names are analytical
; setter
0000407fa2b4: f37bbfa9  stp      x19, x30, [sp, #-0x10]!
0000407fa2b8: 13004039  ldrb     w19, [x0]
0000407fa2bc: 80bd9dd2  mov      x0, #0xedec
0000407fa2c0: a072a8f2  movk     x0, #0x4395, lsl #16
0000407fa2c4: 0000c0f2  movk     x0, #0, lsl #32
0000407fa2c8: 0000e0f2  movk     x0, #0, lsl #48
0000407fa2cc: e1071f32  mov      w1, #6
0000407fa2d0: e203132a  mov      w2, w19
0000407fa2d4: 7b36ff97  bl       #0x407c7cc0
0000407fa2d8: e803002a  mov      w8, w0
0000407fa2dc: e97b0032  mov      w9, #0x7fffffff
0000407fa2e0: 1f01096b  cmp      w8, w9
0000407fa2e4: 61000054  b.ne     #0x407fa2f0
0000407fa2e8: 80038452  mov      w0, #0x201c
0000407fa2ec: 0b000014  b        #0x407fa318
0000407fa2f0: 40d38052  mov      w0, #0x69a
0000407fa2f4: 00c0a072  movk     w0, #0x600, lsl #16
0000407fa2f8: e103082a  mov      w1, w8
0000407fa2fc: d8260094  bl       #0x40803e5c
0000407fa300: 088b88d2  mov      x8, #0x4458
0000407fa304: a88ba0f2  movk     x8, #0x45d, lsl #16
0000407fa308: 4801c0f2  movk     x8, #0xa, lsl #32
0000407fa30c: 0800e0f2  movk     x8, #0, lsl #48
0000407fa310: 20008452  mov      w0, #0x2001
0000407fa314: 13010039  strb     w19, [x8]
0000407fa318: f37bc1a8  ldp      x19, x30, [sp], #0x10
0000407fa31c: c0035fd6  ret
; lookup
0000407c7cc0: f37bbfa9  stp      x19, x30, [sp, #-0x10]!
0000407c7cc4: 03008012  mov      w3, #-1
0000407c7cc8: f30300aa  mov      x19, x0
0000407c7ccc: dd3eee97  bl       #0x40357840
0000407c7cd0: 1f040031  cmn      w0, #1
0000407c7cd4: 80000054  b.eq     #0x407c7ce4
0000407c7cd8: 684e208b  add      x8, x19, w0, uxtw #3
0000407c7cdc: 000540b9  ldr      w0, [x8, #4]
0000407c7ce0: 02000014  b        #0x407c7ce8
0000407c7ce4: e07b0032  mov      w0, #0x7fffffff
0000407c7ce8: f37bc1a8  ldp      x19, x30, [sp], #0x10
0000407c7cec: c0035fd6  ret
; search
000040357840: 61010034  cbz      w1, #0x4035786c
000040357844: e8031f2a  mov      w8, wzr
000040357848: 090040b9  ldr      w9, [x0]
00004035784c: 3f01026b  cmp      w9, w2
000040357850: c0000054  b.eq     #0x40357868
000040357854: 08050011  add      w8, w8, #1
000040357858: 00200091  add      x0, x0, #8
00004035785c: 1f01016b  cmp      w8, w1
000040357860: 43ffff54  b.lo     #0x40357848
000040357864: 02000014  b        #0x4035786c
000040357868: e303082a  mov      w3, w8
00004035786c: e003032a  mov      w0, w3
000040357870: c0035fd6  ret
; descriptor_builder
0000407fa14c: ff4302d1  sub      sp, sp, #0x90
0000407fa150: f82b00f9  str      x24, [sp, #0x50]
0000407fa154: f75b06a9  stp      x23, x22, [sp, #0x60]
0000407fa158: f55307a9  stp      x21, x20, [sp, #0x70]
0000407fa15c: f37b08a9  stp      x19, x30, [sp, #0x80]
0000407fa160: f30301aa  mov      x19, x1
0000407fa164: 81c99dd2  mov      x1, #0xee4c
0000407fa168: a172a8f2  movk     x1, #0x4395, lsl #16
0000407fa16c: 0100c0f2  movk     x1, #0, lsl #32
0000407fa170: f40300aa  mov      x20, x0
0000407fa174: 0100e0f2  movk     x1, #0, lsl #48
0000407fa178: e0e30091  add      x0, sp, #0x38
0000407fa17c: e2071d32  mov      w2, #0x18
0000407fa180: f7e30091  add      x23, sp, #0x38
0000407fa184: 9fb32094  bl       #0x41027000
0000407fa188: 081480d2  mov      x8, #0xa0
0000407fa18c: ff7f02a9  stp      xzr, xzr, [sp, #0x20]
0000407fa190: c872a8f2  movk     x8, #0x4396, lsl #16
0000407fa194: 0800c0f2  movk     x8, #0, lsl #32
0000407fa198: 0800e0f2  movk     x8, #0, lsl #48
0000407fa19c: c18c80d2  mov      x1, #0x466
0000407fa1a0: 55d38052  mov      w21, #0x69a
0000407fa1a4: c172a8f2  movk     x1, #0x4396, lsl #16
0000407fa1a8: 0001c03d  ldr      q0, [x8]
0000407fa1ac: 15c0a072  movk     w21, #0x600, lsl #16
0000407fa1b0: 0100c0f2  movk     x1, #0, lsl #32
0000407fa1b4: 0100e0f2  movk     x1, #0, lsl #48
0000407fa1b8: e2208052  mov      w2, #0x107
0000407fa1bc: e003803d  str      q0, [sp]
0000407fa1c0: e003152a  mov      w0, w21
0000407fa1c4: 6c6a1794  bl       #0x40dd4b74
0000407fa1c8: 96bd9dd2  mov      x22, #0xedec
0000407fa1cc: b672a8f2  movk     x22, #0x4395, lsl #16
0000407fa1d0: 1600c0f2  movk     x22, #0, lsl #32
0000407fa1d4: 1600e0f2  movk     x22, #0, lsl #48
0000407fa1d8: e203002a  mov      w2, w0
0000407fa1dc: e1071f32  mov      w1, #6
0000407fa1e0: e00316aa  mov      x0, x22
0000407fa1e4: f8071f32  mov      w24, #6
0000407fa1e8: c236ff97  bl       #0x407c7cf0
0000407fa1ec: 081c0012  and      w8, w0, #0xff
0000407fa1f0: e003152a  mov      w0, w21
0000407fa1f4: e80b00f9  str      x8, [sp, #0x10]
0000407fa1f8: 7e250094  bl       #0x408037f0
0000407fa1fc: e203002a  mov      w2, w0
0000407fa200: e1071f32  mov      w1, #6
0000407fa204: e00316aa  mov      x0, x22
0000407fa208: ba36ff97  bl       #0x407c7cf0
0000407fa20c: 081c0012  and      w8, w0, #0xff
0000407fa210: f8570079  strh     w24, [sp, #0x2a]
0000407fa214: e2030091  mov      x2, sp
0000407fa218: f71b00f9  str      x23, [sp, #0x30]
0000407fa21c: e00314aa  mov      x0, x20
0000407fa220: e10313aa  mov      x1, x19
0000407fa224: e80f00f9  str      x8, [sp, #0x18]
0000407fa228: d13bff97  bl       #0x407c916c
0000407fa22c: f37b48a9  ldp      x19, x30, [sp, #0x80]
0000407fa230: f55347a9  ldp      x21, x20, [sp, #0x70]
0000407fa234: f75b46a9  ldp      x23, x22, [sp, #0x60]
0000407fa238: f82b40f9  ldr      x24, [sp, #0x50]
0000407fa23c: 20008452  mov      w0, #0x2001
0000407fa240: ff430291  add      sp, sp, #0x90
0000407fa244: c0035fd6  ret

; Z8 1.01 property 0x1d006, names are analytical
; setter
0000407fa550: f37bbfa9  stp      x19, x30, [sp, #-0x10]!
0000407fa554: 13004039  ldrb     w19, [x0]
0000407fa558: 80c39dd2  mov      x0, #0xee1c
0000407fa55c: a072a8f2  movk     x0, #0x4395, lsl #16
0000407fa560: 0000c0f2  movk     x0, #0, lsl #32
0000407fa564: 0000e0f2  movk     x0, #0, lsl #48
0000407fa568: e1071f32  mov      w1, #6
0000407fa56c: e203132a  mov      w2, w19
0000407fa570: d435ff97  bl       #0x407c7cc0
0000407fa574: e803002a  mov      w8, w0
0000407fa578: e97b0032  mov      w9, #0x7fffffff
0000407fa57c: 1f01096b  cmp      w8, w9
0000407fa580: 61000054  b.ne     #0x407fa58c
0000407fa584: 80038452  mov      w0, #0x201c
0000407fa588: 0b000014  b        #0x407fa5b4
0000407fa58c: 804a8252  mov      w0, #0x1254
0000407fa590: 00c0a072  movk     w0, #0x600, lsl #16
0000407fa594: e103082a  mov      w1, w8
0000407fa598: 31260094  bl       #0x40803e5c
0000407fa59c: 888b88d2  mov      x8, #0x445c
0000407fa5a0: a88ba0f2  movk     x8, #0x45d, lsl #16
0000407fa5a4: 4801c0f2  movk     x8, #0xa, lsl #32
0000407fa5a8: 0800e0f2  movk     x8, #0, lsl #48
0000407fa5ac: 20008452  mov      w0, #0x2001
0000407fa5b0: 13010039  strb     w19, [x8]
0000407fa5b4: f37bc1a8  ldp      x19, x30, [sp], #0x10
0000407fa5b8: c0035fd6  ret
; lookup
0000407c7cc0: f37bbfa9  stp      x19, x30, [sp, #-0x10]!
0000407c7cc4: 03008012  mov      w3, #-1
0000407c7cc8: f30300aa  mov      x19, x0
0000407c7ccc: dd3eee97  bl       #0x40357840
0000407c7cd0: 1f040031  cmn      w0, #1
0000407c7cd4: 80000054  b.eq     #0x407c7ce4
0000407c7cd8: 684e208b  add      x8, x19, w0, uxtw #3
0000407c7cdc: 000540b9  ldr      w0, [x8, #4]
0000407c7ce0: 02000014  b        #0x407c7ce8
0000407c7ce4: e07b0032  mov      w0, #0x7fffffff
0000407c7ce8: f37bc1a8  ldp      x19, x30, [sp], #0x10
0000407c7cec: c0035fd6  ret
; search
000040357840: 61010034  cbz      w1, #0x4035786c
000040357844: e8031f2a  mov      w8, wzr
000040357848: 090040b9  ldr      w9, [x0]
00004035784c: 3f01026b  cmp      w9, w2
000040357850: c0000054  b.eq     #0x40357868
000040357854: 08050011  add      w8, w8, #1
000040357858: 00200091  add      x0, x0, #8
00004035785c: 1f01016b  cmp      w8, w1
000040357860: 43ffff54  b.lo     #0x40357848
000040357864: 02000014  b        #0x4035786c
000040357868: e303082a  mov      w3, w8
00004035786c: e003032a  mov      w0, w3
000040357870: c0035fd6  ret
; descriptor_builder
0000407fa3e8: ff4302d1  sub      sp, sp, #0x90
0000407fa3ec: f82b00f9  str      x24, [sp, #0x50]
0000407fa3f0: f75b06a9  stp      x23, x22, [sp, #0x60]
0000407fa3f4: f55307a9  stp      x21, x20, [sp, #0x70]
0000407fa3f8: f37b08a9  stp      x19, x30, [sp, #0x80]
0000407fa3fc: f30301aa  mov      x19, x1
0000407fa400: 81c99dd2  mov      x1, #0xee4c
0000407fa404: a172a8f2  movk     x1, #0x4395, lsl #16
0000407fa408: 0100c0f2  movk     x1, #0, lsl #32
0000407fa40c: f40300aa  mov      x20, x0
0000407fa410: 0100e0f2  movk     x1, #0, lsl #48
0000407fa414: e0e30091  add      x0, sp, #0x38
0000407fa418: e2071d32  mov      w2, #0x18
0000407fa41c: f7e30091  add      x23, sp, #0x38
0000407fa420: f8b22094  bl       #0x41027000
0000407fa424: 081680d2  mov      x8, #0xb0
0000407fa428: ff7f02a9  stp      xzr, xzr, [sp, #0x20]
0000407fa42c: c872a8f2  movk     x8, #0x4396, lsl #16
0000407fa430: 0800c0f2  movk     x8, #0, lsl #32
0000407fa434: 0800e0f2  movk     x8, #0, lsl #48
0000407fa438: c18c80d2  mov      x1, #0x466
0000407fa43c: 954a8252  mov      w21, #0x1254
0000407fa440: c172a8f2  movk     x1, #0x4396, lsl #16
0000407fa444: 0001c03d  ldr      q0, [x8]
0000407fa448: 15c0a072  movk     w21, #0x600, lsl #16
0000407fa44c: 0100c0f2  movk     x1, #0, lsl #32
0000407fa450: 0100e0f2  movk     x1, #0, lsl #48
0000407fa454: a2358052  mov      w2, #0x1ad
0000407fa458: e003803d  str      q0, [sp]
0000407fa45c: e003152a  mov      w0, w21
0000407fa460: c5691794  bl       #0x40dd4b74
0000407fa464: 96c39dd2  mov      x22, #0xee1c
0000407fa468: b672a8f2  movk     x22, #0x4395, lsl #16
0000407fa46c: 1600c0f2  movk     x22, #0, lsl #32
0000407fa470: 1600e0f2  movk     x22, #0, lsl #48
0000407fa474: e203002a  mov      w2, w0
0000407fa478: e1071f32  mov      w1, #6
0000407fa47c: e00316aa  mov      x0, x22
0000407fa480: f8071f32  mov      w24, #6
0000407fa484: 1b36ff97  bl       #0x407c7cf0
0000407fa488: 081c0012  and      w8, w0, #0xff
0000407fa48c: e003152a  mov      w0, w21
0000407fa490: e80b00f9  str      x8, [sp, #0x10]
0000407fa494: d7240094  bl       #0x408037f0
0000407fa498: e203002a  mov      w2, w0
0000407fa49c: e1071f32  mov      w1, #6
0000407fa4a0: e00316aa  mov      x0, x22
0000407fa4a4: 1336ff97  bl       #0x407c7cf0
0000407fa4a8: 081c0012  and      w8, w0, #0xff
0000407fa4ac: f8570079  strh     w24, [sp, #0x2a]
0000407fa4b0: e2030091  mov      x2, sp
0000407fa4b4: f71b00f9  str      x23, [sp, #0x30]
0000407fa4b8: e00314aa  mov      x0, x20
0000407fa4bc: e10313aa  mov      x1, x19
0000407fa4c0: e80f00f9  str      x8, [sp, #0x18]
0000407fa4c4: 2a3bff97  bl       #0x407c916c
0000407fa4c8: f37b48a9  ldp      x19, x30, [sp, #0x80]
0000407fa4cc: f55347a9  ldp      x21, x20, [sp, #0x70]
0000407fa4d0: f75b46a9  ldp      x23, x22, [sp, #0x60]
0000407fa4d4: f82b40f9  ldr      x24, [sp, #0x50]
0000407fa4d8: 20008452  mov      w0, #0x2001
0000407fa4dc: ff430291  add      sp, sp, #0x90
0000407fa4e0: c0035fd6  ret

; Z8 2.00 property 0x1d005, names are analytical
; setter
00004081b88c: f37bbfa9  stp      x19, x30, [sp, #-0x10]!
00004081b890: 13004039  ldrb     w19, [x0]
00004081b894: 002399d2  mov      x0, #0xc918
00004081b898: e07ca8f2  movk     x0, #0x43e7, lsl #16
00004081b89c: 0000c0f2  movk     x0, #0, lsl #32
00004081b8a0: 0000e0f2  movk     x0, #0, lsl #48
00004081b8a4: e10b0032  mov      w1, #7
00004081b8a8: e203132a  mov      w2, w19
00004081b8ac: 2c2dff97  bl       #0x407e6d5c
00004081b8b0: e803002a  mov      w8, w0
00004081b8b4: e97b0032  mov      w9, #0x7fffffff
00004081b8b8: 1f01096b  cmp      w8, w9
00004081b8bc: 61000054  b.ne     #0x4081b8c8
00004081b8c0: 80038452  mov      w0, #0x201c
00004081b8c4: 0b000014  b        #0x4081b8f0
00004081b8c8: 40d38052  mov      w0, #0x69a
00004081b8cc: 00c0a072  movk     w0, #0x600, lsl #16
00004081b8d0: e103082a  mov      w1, w8
00004081b8d4: fa260094  bl       #0x408254bc
00004081b8d8: 082095d2  mov      x8, #0xa900
00004081b8dc: 288fa0f2  movk     x8, #0x479, lsl #16
00004081b8e0: 4801c0f2  movk     x8, #0xa, lsl #32
00004081b8e4: 0800e0f2  movk     x8, #0, lsl #48
00004081b8e8: 20008452  mov      w0, #0x2001
00004081b8ec: 13010039  strb     w19, [x8]
00004081b8f0: f37bc1a8  ldp      x19, x30, [sp], #0x10
00004081b8f4: c0035fd6  ret
; lookup
0000407e6d5c: f37bbfa9  stp      x19, x30, [sp, #-0x10]!
0000407e6d60: 03008012  mov      w3, #-1
0000407e6d64: f30300aa  mov      x19, x0
0000407e6d68: 16c4ed97  bl       #0x40357dc0
0000407e6d6c: 1f040031  cmn      w0, #1
0000407e6d70: 80000054  b.eq     #0x407e6d80
0000407e6d74: 684e208b  add      x8, x19, w0, uxtw #3
0000407e6d78: 000540b9  ldr      w0, [x8, #4]
0000407e6d7c: 02000014  b        #0x407e6d84
0000407e6d80: e07b0032  mov      w0, #0x7fffffff
0000407e6d84: f37bc1a8  ldp      x19, x30, [sp], #0x10
0000407e6d88: c0035fd6  ret
; search
000040357dc0: 61010034  cbz      w1, #0x40357dec
000040357dc4: e8031f2a  mov      w8, wzr
000040357dc8: 090040b9  ldr      w9, [x0]
000040357dcc: 3f01026b  cmp      w9, w2
000040357dd0: c0000054  b.eq     #0x40357de8
000040357dd4: 08050011  add      w8, w8, #1
000040357dd8: 00200091  add      x0, x0, #8
000040357ddc: 1f01016b  cmp      w8, w1
000040357de0: 43ffff54  b.lo     #0x40357dc8
000040357de4: 02000014  b        #0x40357dec
000040357de8: e303082a  mov      w3, w8
000040357dec: e003032a  mov      w0, w3
000040357df0: c0035fd6  ret
; descriptor_builder
00004081b724: ff8302d1  sub      sp, sp, #0xa0
00004081b728: f83300f9  str      x24, [sp, #0x60]
00004081b72c: f75b07a9  stp      x23, x22, [sp, #0x70]
00004081b730: f55308a9  stp      x21, x20, [sp, #0x80]
00004081b734: f37b09a9  stp      x19, x30, [sp, #0x90]
00004081b738: f30301aa  mov      x19, x1
00004081b73c: 013199d2  mov      x1, #0xc988
00004081b740: e17ca8f2  movk     x1, #0x43e7, lsl #16
00004081b744: 0100c0f2  movk     x1, #0, lsl #32
00004081b748: f40300aa  mov      x20, x0
00004081b74c: 0100e0f2  movk     x1, #0, lsl #48
00004081b750: e0130191  add      x0, sp, #0x44
00004081b754: e20b1e32  mov      w2, #0x1c
00004081b758: f7130191  add      x23, sp, #0x44
00004081b75c: 29012994  bl       #0x4125bc00
00004081b760: 08749bd2  mov      x8, #0xdba0
00004081b764: ff7f02a9  stp      xzr, xzr, [sp, #0x20]
00004081b768: e87ca8f2  movk     x8, #0x43e7, lsl #16
00004081b76c: 0800c0f2  movk     x8, #0, lsl #32
00004081b770: 0800e0f2  movk     x8, #0, lsl #48
00004081b774: 21f29bd2  mov      x1, #0xdf91
00004081b778: 55d38052  mov      w21, #0x69a
00004081b77c: e17ca8f2  movk     x1, #0x43e7, lsl #16
00004081b780: 0001c03d  ldr      q0, [x8]
00004081b784: 15c0a072  movk     w21, #0x600, lsl #16
00004081b788: 0100c0f2  movk     x1, #0, lsl #32
00004081b78c: 0100e0f2  movk     x1, #0, lsl #48
00004081b790: e2208052  mov      w2, #0x107
00004081b794: e003803d  str      q0, [sp]
00004081b798: e003152a  mov      w0, w21
00004081b79c: 56831f94  bl       #0x40ffc4f4
00004081b7a0: 162399d2  mov      x22, #0xc918
00004081b7a4: f67ca8f2  movk     x22, #0x43e7, lsl #16
00004081b7a8: 1600c0f2  movk     x22, #0, lsl #32
00004081b7ac: 1600e0f2  movk     x22, #0, lsl #48
00004081b7b0: e203002a  mov      w2, w0
00004081b7b4: e10b0032  mov      w1, #7
00004081b7b8: e00316aa  mov      x0, x22
00004081b7bc: f80b0032  mov      w24, #7
00004081b7c0: 732dff97  bl       #0x407e6d8c
00004081b7c4: 081c0012  and      w8, w0, #0xff
00004081b7c8: e003152a  mov      w0, w21
00004081b7cc: e80b00f9  str      x8, [sp, #0x10]
00004081b7d0: 83250094  bl       #0x40824ddc
00004081b7d4: e203002a  mov      w2, w0
00004081b7d8: e10b0032  mov      w1, #7
00004081b7dc: e00316aa  mov      x0, x22
00004081b7e0: 6b2dff97  bl       #0x407e6d8c
00004081b7e4: 081c0012  and      w8, w0, #0xff
00004081b7e8: f8570079  strh     w24, [sp, #0x2a]
00004081b7ec: e2030091  mov      x2, sp
00004081b7f0: f71b00f9  str      x23, [sp, #0x30]
00004081b7f4: e00314aa  mov      x0, x20
00004081b7f8: e10313aa  mov      x1, x19
00004081b7fc: e80f00f9  str      x8, [sp, #0x18]
00004081b800: 1933ff97  bl       #0x407e8464
00004081b804: f37b49a9  ldp      x19, x30, [sp, #0x90]
00004081b808: f55348a9  ldp      x21, x20, [sp, #0x80]
00004081b80c: f75b47a9  ldp      x23, x22, [sp, #0x70]
00004081b810: f83340f9  ldr      x24, [sp, #0x60]
00004081b814: 20008452  mov      w0, #0x2001
00004081b818: ff830291  add      sp, sp, #0xa0
00004081b81c: c0035fd6  ret

; Z8 2.00 property 0x1d006, names are analytical
; setter
00004081bb28: f37bbfa9  stp      x19, x30, [sp, #-0x10]!
00004081bb2c: 13004039  ldrb     w19, [x0]
00004081bb30: 002a99d2  mov      x0, #0xc950
00004081bb34: e07ca8f2  movk     x0, #0x43e7, lsl #16
00004081bb38: 0000c0f2  movk     x0, #0, lsl #32
00004081bb3c: 0000e0f2  movk     x0, #0, lsl #48
00004081bb40: e10b0032  mov      w1, #7
00004081bb44: e203132a  mov      w2, w19
00004081bb48: 852cff97  bl       #0x407e6d5c
00004081bb4c: e803002a  mov      w8, w0
00004081bb50: e97b0032  mov      w9, #0x7fffffff
00004081bb54: 1f01096b  cmp      w8, w9
00004081bb58: 61000054  b.ne     #0x4081bb64
00004081bb5c: 80038452  mov      w0, #0x201c
00004081bb60: 0b000014  b        #0x4081bb8c
00004081bb64: 804a8252  mov      w0, #0x1254
00004081bb68: 00c0a072  movk     w0, #0x600, lsl #16
00004081bb6c: e103082a  mov      w1, w8
00004081bb70: 53260094  bl       #0x408254bc
00004081bb74: 882095d2  mov      x8, #0xa904
00004081bb78: 288fa0f2  movk     x8, #0x479, lsl #16
00004081bb7c: 4801c0f2  movk     x8, #0xa, lsl #32
00004081bb80: 0800e0f2  movk     x8, #0, lsl #48
00004081bb84: 20008452  mov      w0, #0x2001
00004081bb88: 13010039  strb     w19, [x8]
00004081bb8c: f37bc1a8  ldp      x19, x30, [sp], #0x10
00004081bb90: c0035fd6  ret
; lookup
0000407e6d5c: f37bbfa9  stp      x19, x30, [sp, #-0x10]!
0000407e6d60: 03008012  mov      w3, #-1
0000407e6d64: f30300aa  mov      x19, x0
0000407e6d68: 16c4ed97  bl       #0x40357dc0
0000407e6d6c: 1f040031  cmn      w0, #1
0000407e6d70: 80000054  b.eq     #0x407e6d80
0000407e6d74: 684e208b  add      x8, x19, w0, uxtw #3
0000407e6d78: 000540b9  ldr      w0, [x8, #4]
0000407e6d7c: 02000014  b        #0x407e6d84
0000407e6d80: e07b0032  mov      w0, #0x7fffffff
0000407e6d84: f37bc1a8  ldp      x19, x30, [sp], #0x10
0000407e6d88: c0035fd6  ret
; search
000040357dc0: 61010034  cbz      w1, #0x40357dec
000040357dc4: e8031f2a  mov      w8, wzr
000040357dc8: 090040b9  ldr      w9, [x0]
000040357dcc: 3f01026b  cmp      w9, w2
000040357dd0: c0000054  b.eq     #0x40357de8
000040357dd4: 08050011  add      w8, w8, #1
000040357dd8: 00200091  add      x0, x0, #8
000040357ddc: 1f01016b  cmp      w8, w1
000040357de0: 43ffff54  b.lo     #0x40357dc8
000040357de4: 02000014  b        #0x40357dec
000040357de8: e303082a  mov      w3, w8
000040357dec: e003032a  mov      w0, w3
000040357df0: c0035fd6  ret
; descriptor_builder
00004081b9c0: ff8302d1  sub      sp, sp, #0xa0
00004081b9c4: f83300f9  str      x24, [sp, #0x60]
00004081b9c8: f75b07a9  stp      x23, x22, [sp, #0x70]
00004081b9cc: f55308a9  stp      x21, x20, [sp, #0x80]
00004081b9d0: f37b09a9  stp      x19, x30, [sp, #0x90]
00004081b9d4: f30301aa  mov      x19, x1
00004081b9d8: 013199d2  mov      x1, #0xc988
00004081b9dc: e17ca8f2  movk     x1, #0x43e7, lsl #16
00004081b9e0: 0100c0f2  movk     x1, #0, lsl #32
00004081b9e4: f40300aa  mov      x20, x0
00004081b9e8: 0100e0f2  movk     x1, #0, lsl #48
00004081b9ec: e0130191  add      x0, sp, #0x44
00004081b9f0: e20b1e32  mov      w2, #0x1c
00004081b9f4: f7130191  add      x23, sp, #0x44
00004081b9f8: 82002994  bl       #0x4125bc00
00004081b9fc: 08769bd2  mov      x8, #0xdbb0
00004081ba00: ff7f02a9  stp      xzr, xzr, [sp, #0x20]
00004081ba04: e87ca8f2  movk     x8, #0x43e7, lsl #16
00004081ba08: 0800c0f2  movk     x8, #0, lsl #32
00004081ba0c: 0800e0f2  movk     x8, #0, lsl #48
00004081ba10: 21f29bd2  mov      x1, #0xdf91
00004081ba14: 954a8252  mov      w21, #0x1254
00004081ba18: e17ca8f2  movk     x1, #0x43e7, lsl #16
00004081ba1c: 0001c03d  ldr      q0, [x8]
00004081ba20: 15c0a072  movk     w21, #0x600, lsl #16
00004081ba24: 0100c0f2  movk     x1, #0, lsl #32
00004081ba28: 0100e0f2  movk     x1, #0, lsl #48
00004081ba2c: a2358052  mov      w2, #0x1ad
00004081ba30: e003803d  str      q0, [sp]
00004081ba34: e003152a  mov      w0, w21
00004081ba38: af821f94  bl       #0x40ffc4f4
00004081ba3c: 162a99d2  mov      x22, #0xc950
00004081ba40: f67ca8f2  movk     x22, #0x43e7, lsl #16
00004081ba44: 1600c0f2  movk     x22, #0, lsl #32
00004081ba48: 1600e0f2  movk     x22, #0, lsl #48
00004081ba4c: e203002a  mov      w2, w0
00004081ba50: e10b0032  mov      w1, #7
00004081ba54: e00316aa  mov      x0, x22
00004081ba58: f80b0032  mov      w24, #7
00004081ba5c: cc2cff97  bl       #0x407e6d8c
00004081ba60: 081c0012  and      w8, w0, #0xff
00004081ba64: e003152a  mov      w0, w21
00004081ba68: e80b00f9  str      x8, [sp, #0x10]
00004081ba6c: dc240094  bl       #0x40824ddc
00004081ba70: e203002a  mov      w2, w0
00004081ba74: e10b0032  mov      w1, #7
00004081ba78: e00316aa  mov      x0, x22
00004081ba7c: c42cff97  bl       #0x407e6d8c
00004081ba80: 081c0012  and      w8, w0, #0xff
00004081ba84: f8570079  strh     w24, [sp, #0x2a]
00004081ba88: e2030091  mov      x2, sp
00004081ba8c: f71b00f9  str      x23, [sp, #0x30]
00004081ba90: e00314aa  mov      x0, x20
00004081ba94: e10313aa  mov      x1, x19
00004081ba98: e80f00f9  str      x8, [sp, #0x18]
00004081ba9c: 7232ff97  bl       #0x407e8464
00004081baa0: f37b49a9  ldp      x19, x30, [sp, #0x90]
00004081baa4: f55348a9  ldp      x21, x20, [sp, #0x80]
00004081baa8: f75b47a9  ldp      x23, x22, [sp, #0x70]
00004081baac: f83340f9  ldr      x24, [sp, #0x60]
00004081bab0: 20008452  mov      w0, #0x2001
00004081bab4: ff830291  add      sp, sp, #0xa0
00004081bab8: c0035fd6  ret

; Z8 2.01 property 0x1d005, names are analytical
; setter
00004081b764: f37bbfa9  stp      x19, x30, [sp, #-0x10]!
00004081b768: 13004039  ldrb     w19, [x0]
00004081b76c: 002399d2  mov      x0, #0xc918
00004081b770: e07ca8f2  movk     x0, #0x43e7, lsl #16
00004081b774: 0000c0f2  movk     x0, #0, lsl #32
00004081b778: 0000e0f2  movk     x0, #0, lsl #48
00004081b77c: e10b0032  mov      w1, #7
00004081b780: e203132a  mov      w2, w19
00004081b784: 2c2dff97  bl       #0x407e6c34
00004081b788: e803002a  mov      w8, w0
00004081b78c: e97b0032  mov      w9, #0x7fffffff
00004081b790: 1f01096b  cmp      w8, w9
00004081b794: 61000054  b.ne     #0x4081b7a0
00004081b798: 80038452  mov      w0, #0x201c
00004081b79c: 0b000014  b        #0x4081b7c8
00004081b7a0: 40d38052  mov      w0, #0x69a
00004081b7a4: 00c0a072  movk     w0, #0x600, lsl #16
00004081b7a8: e103082a  mov      w1, w8
00004081b7ac: fa260094  bl       #0x40825394
00004081b7b0: 082097d2  mov      x8, #0xb900
00004081b7b4: 288fa0f2  movk     x8, #0x479, lsl #16
00004081b7b8: 4801c0f2  movk     x8, #0xa, lsl #32
00004081b7bc: 0800e0f2  movk     x8, #0, lsl #48
00004081b7c0: 20008452  mov      w0, #0x2001
00004081b7c4: 13010039  strb     w19, [x8]
00004081b7c8: f37bc1a8  ldp      x19, x30, [sp], #0x10
00004081b7cc: c0035fd6  ret
; lookup
0000407e6c34: f37bbfa9  stp      x19, x30, [sp, #-0x10]!
0000407e6c38: 03008012  mov      w3, #-1
0000407e6c3c: f30300aa  mov      x19, x0
0000407e6c40: 60c4ed97  bl       #0x40357dc0
0000407e6c44: 1f040031  cmn      w0, #1
0000407e6c48: 80000054  b.eq     #0x407e6c58
0000407e6c4c: 684e208b  add      x8, x19, w0, uxtw #3
0000407e6c50: 000540b9  ldr      w0, [x8, #4]
0000407e6c54: 02000014  b        #0x407e6c5c
0000407e6c58: e07b0032  mov      w0, #0x7fffffff
0000407e6c5c: f37bc1a8  ldp      x19, x30, [sp], #0x10
0000407e6c60: c0035fd6  ret
; search
000040357dc0: 61010034  cbz      w1, #0x40357dec
000040357dc4: e8031f2a  mov      w8, wzr
000040357dc8: 090040b9  ldr      w9, [x0]
000040357dcc: 3f01026b  cmp      w9, w2
000040357dd0: c0000054  b.eq     #0x40357de8
000040357dd4: 08050011  add      w8, w8, #1
000040357dd8: 00200091  add      x0, x0, #8
000040357ddc: 1f01016b  cmp      w8, w1
000040357de0: 43ffff54  b.lo     #0x40357dc8
000040357de4: 02000014  b        #0x40357dec
000040357de8: e303082a  mov      w3, w8
000040357dec: e003032a  mov      w0, w3
000040357df0: c0035fd6  ret
; descriptor_builder
00004081b5fc: ff8302d1  sub      sp, sp, #0xa0
00004081b600: f83300f9  str      x24, [sp, #0x60]
00004081b604: f75b07a9  stp      x23, x22, [sp, #0x70]
00004081b608: f55308a9  stp      x21, x20, [sp, #0x80]
00004081b60c: f37b09a9  stp      x19, x30, [sp, #0x90]
00004081b610: f30301aa  mov      x19, x1
00004081b614: 013199d2  mov      x1, #0xc988
00004081b618: e17ca8f2  movk     x1, #0x43e7, lsl #16
00004081b61c: 0100c0f2  movk     x1, #0, lsl #32
00004081b620: f40300aa  mov      x20, x0
00004081b624: 0100e0f2  movk     x1, #0, lsl #48
00004081b628: e0130191  add      x0, sp, #0x44
00004081b62c: e20b1e32  mov      w2, #0x1c
00004081b630: f7130191  add      x23, sp, #0x44
00004081b634: 53022994  bl       #0x4125bf80
00004081b638: 08749bd2  mov      x8, #0xdba0
00004081b63c: ff7f02a9  stp      xzr, xzr, [sp, #0x20]
00004081b640: e87ca8f2  movk     x8, #0x43e7, lsl #16
00004081b644: 0800c0f2  movk     x8, #0, lsl #32
00004081b648: 0800e0f2  movk     x8, #0, lsl #48
00004081b64c: 21f29bd2  mov      x1, #0xdf91
00004081b650: 55d38052  mov      w21, #0x69a
00004081b654: e17ca8f2  movk     x1, #0x43e7, lsl #16
00004081b658: 0001c03d  ldr      q0, [x8]
00004081b65c: 15c0a072  movk     w21, #0x600, lsl #16
00004081b660: 0100c0f2  movk     x1, #0, lsl #32
00004081b664: 0100e0f2  movk     x1, #0, lsl #48
00004081b668: e2208052  mov      w2, #0x107
00004081b66c: e003803d  str      q0, [sp]
00004081b670: e003152a  mov      w0, w21
00004081b674: ba831f94  bl       #0x40ffc55c
00004081b678: 162399d2  mov      x22, #0xc918
00004081b67c: f67ca8f2  movk     x22, #0x43e7, lsl #16
00004081b680: 1600c0f2  movk     x22, #0, lsl #32
00004081b684: 1600e0f2  movk     x22, #0, lsl #48
00004081b688: e203002a  mov      w2, w0
00004081b68c: e10b0032  mov      w1, #7
00004081b690: e00316aa  mov      x0, x22
00004081b694: f80b0032  mov      w24, #7
00004081b698: 732dff97  bl       #0x407e6c64
00004081b69c: 081c0012  and      w8, w0, #0xff
00004081b6a0: e003152a  mov      w0, w21
00004081b6a4: e80b00f9  str      x8, [sp, #0x10]
00004081b6a8: 83250094  bl       #0x40824cb4
00004081b6ac: e203002a  mov      w2, w0
00004081b6b0: e10b0032  mov      w1, #7
00004081b6b4: e00316aa  mov      x0, x22
00004081b6b8: 6b2dff97  bl       #0x407e6c64
00004081b6bc: 081c0012  and      w8, w0, #0xff
00004081b6c0: f8570079  strh     w24, [sp, #0x2a]
00004081b6c4: e2030091  mov      x2, sp
00004081b6c8: f71b00f9  str      x23, [sp, #0x30]
00004081b6cc: e00314aa  mov      x0, x20
00004081b6d0: e10313aa  mov      x1, x19
00004081b6d4: e80f00f9  str      x8, [sp, #0x18]
00004081b6d8: 1933ff97  bl       #0x407e833c
00004081b6dc: f37b49a9  ldp      x19, x30, [sp, #0x90]
00004081b6e0: f55348a9  ldp      x21, x20, [sp, #0x80]
00004081b6e4: f75b47a9  ldp      x23, x22, [sp, #0x70]
00004081b6e8: f83340f9  ldr      x24, [sp, #0x60]
00004081b6ec: 20008452  mov      w0, #0x2001
00004081b6f0: ff830291  add      sp, sp, #0xa0
00004081b6f4: c0035fd6  ret

; Z8 2.01 property 0x1d006, names are analytical
; setter
00004081ba00: f37bbfa9  stp      x19, x30, [sp, #-0x10]!
00004081ba04: 13004039  ldrb     w19, [x0]
00004081ba08: 002a99d2  mov      x0, #0xc950
00004081ba0c: e07ca8f2  movk     x0, #0x43e7, lsl #16
00004081ba10: 0000c0f2  movk     x0, #0, lsl #32
00004081ba14: 0000e0f2  movk     x0, #0, lsl #48
00004081ba18: e10b0032  mov      w1, #7
00004081ba1c: e203132a  mov      w2, w19
00004081ba20: 852cff97  bl       #0x407e6c34
00004081ba24: e803002a  mov      w8, w0
00004081ba28: e97b0032  mov      w9, #0x7fffffff
00004081ba2c: 1f01096b  cmp      w8, w9
00004081ba30: 61000054  b.ne     #0x4081ba3c
00004081ba34: 80038452  mov      w0, #0x201c
00004081ba38: 0b000014  b        #0x4081ba64
00004081ba3c: 804a8252  mov      w0, #0x1254
00004081ba40: 00c0a072  movk     w0, #0x600, lsl #16
00004081ba44: e103082a  mov      w1, w8
00004081ba48: 53260094  bl       #0x40825394
00004081ba4c: 882097d2  mov      x8, #0xb904
00004081ba50: 288fa0f2  movk     x8, #0x479, lsl #16
00004081ba54: 4801c0f2  movk     x8, #0xa, lsl #32
00004081ba58: 0800e0f2  movk     x8, #0, lsl #48
00004081ba5c: 20008452  mov      w0, #0x2001
00004081ba60: 13010039  strb     w19, [x8]
00004081ba64: f37bc1a8  ldp      x19, x30, [sp], #0x10
00004081ba68: c0035fd6  ret
; lookup
0000407e6c34: f37bbfa9  stp      x19, x30, [sp, #-0x10]!
0000407e6c38: 03008012  mov      w3, #-1
0000407e6c3c: f30300aa  mov      x19, x0
0000407e6c40: 60c4ed97  bl       #0x40357dc0
0000407e6c44: 1f040031  cmn      w0, #1
0000407e6c48: 80000054  b.eq     #0x407e6c58
0000407e6c4c: 684e208b  add      x8, x19, w0, uxtw #3
0000407e6c50: 000540b9  ldr      w0, [x8, #4]
0000407e6c54: 02000014  b        #0x407e6c5c
0000407e6c58: e07b0032  mov      w0, #0x7fffffff
0000407e6c5c: f37bc1a8  ldp      x19, x30, [sp], #0x10
0000407e6c60: c0035fd6  ret
; search
000040357dc0: 61010034  cbz      w1, #0x40357dec
000040357dc4: e8031f2a  mov      w8, wzr
000040357dc8: 090040b9  ldr      w9, [x0]
000040357dcc: 3f01026b  cmp      w9, w2
000040357dd0: c0000054  b.eq     #0x40357de8
000040357dd4: 08050011  add      w8, w8, #1
000040357dd8: 00200091  add      x0, x0, #8
000040357ddc: 1f01016b  cmp      w8, w1
000040357de0: 43ffff54  b.lo     #0x40357dc8
000040357de4: 02000014  b        #0x40357dec
000040357de8: e303082a  mov      w3, w8
000040357dec: e003032a  mov      w0, w3
000040357df0: c0035fd6  ret
; descriptor_builder
00004081b898: ff8302d1  sub      sp, sp, #0xa0
00004081b89c: f83300f9  str      x24, [sp, #0x60]
00004081b8a0: f75b07a9  stp      x23, x22, [sp, #0x70]
00004081b8a4: f55308a9  stp      x21, x20, [sp, #0x80]
00004081b8a8: f37b09a9  stp      x19, x30, [sp, #0x90]
00004081b8ac: f30301aa  mov      x19, x1
00004081b8b0: 013199d2  mov      x1, #0xc988
00004081b8b4: e17ca8f2  movk     x1, #0x43e7, lsl #16
00004081b8b8: 0100c0f2  movk     x1, #0, lsl #32
00004081b8bc: f40300aa  mov      x20, x0
00004081b8c0: 0100e0f2  movk     x1, #0, lsl #48
00004081b8c4: e0130191  add      x0, sp, #0x44
00004081b8c8: e20b1e32  mov      w2, #0x1c
00004081b8cc: f7130191  add      x23, sp, #0x44
00004081b8d0: ac012994  bl       #0x4125bf80
00004081b8d4: 08769bd2  mov      x8, #0xdbb0
00004081b8d8: ff7f02a9  stp      xzr, xzr, [sp, #0x20]
00004081b8dc: e87ca8f2  movk     x8, #0x43e7, lsl #16
00004081b8e0: 0800c0f2  movk     x8, #0, lsl #32
00004081b8e4: 0800e0f2  movk     x8, #0, lsl #48
00004081b8e8: 21f29bd2  mov      x1, #0xdf91
00004081b8ec: 954a8252  mov      w21, #0x1254
00004081b8f0: e17ca8f2  movk     x1, #0x43e7, lsl #16
00004081b8f4: 0001c03d  ldr      q0, [x8]
00004081b8f8: 15c0a072  movk     w21, #0x600, lsl #16
00004081b8fc: 0100c0f2  movk     x1, #0, lsl #32
00004081b900: 0100e0f2  movk     x1, #0, lsl #48
00004081b904: a2358052  mov      w2, #0x1ad
00004081b908: e003803d  str      q0, [sp]
00004081b90c: e003152a  mov      w0, w21
00004081b910: 13831f94  bl       #0x40ffc55c
00004081b914: 162a99d2  mov      x22, #0xc950
00004081b918: f67ca8f2  movk     x22, #0x43e7, lsl #16
00004081b91c: 1600c0f2  movk     x22, #0, lsl #32
00004081b920: 1600e0f2  movk     x22, #0, lsl #48
00004081b924: e203002a  mov      w2, w0
00004081b928: e10b0032  mov      w1, #7
00004081b92c: e00316aa  mov      x0, x22
00004081b930: f80b0032  mov      w24, #7
00004081b934: cc2cff97  bl       #0x407e6c64
00004081b938: 081c0012  and      w8, w0, #0xff
00004081b93c: e003152a  mov      w0, w21
00004081b940: e80b00f9  str      x8, [sp, #0x10]
00004081b944: dc240094  bl       #0x40824cb4
00004081b948: e203002a  mov      w2, w0
00004081b94c: e10b0032  mov      w1, #7
00004081b950: e00316aa  mov      x0, x22
00004081b954: c42cff97  bl       #0x407e6c64
00004081b958: 081c0012  and      w8, w0, #0xff
00004081b95c: f8570079  strh     w24, [sp, #0x2a]
00004081b960: e2030091  mov      x2, sp
00004081b964: f71b00f9  str      x23, [sp, #0x30]
00004081b968: e00314aa  mov      x0, x20
00004081b96c: e10313aa  mov      x1, x19
00004081b970: e80f00f9  str      x8, [sp, #0x18]
00004081b974: 7232ff97  bl       #0x407e833c
00004081b978: f37b49a9  ldp      x19, x30, [sp, #0x90]
00004081b97c: f55348a9  ldp      x21, x20, [sp, #0x80]
00004081b980: f75b47a9  ldp      x23, x22, [sp, #0x70]
00004081b984: f83340f9  ldr      x24, [sp, #0x60]
00004081b988: 20008452  mov      w0, #0x2001
00004081b98c: ff830291  add      sp, sp, #0xa0
00004081b990: c0035fd6  ret

; Z8 2.10 property 0x1d005, names are analytical
; setter
000040823040: f37bbfa9  stp      x19, x30, [sp, #-0x10]!
000040823044: 13004039  ldrb     w19, [x0]
000040823048: 00d08cd2  mov      x0, #0x6680
00004082304c: 607da8f2  movk     x0, #0x43eb, lsl #16
000040823050: 0000c0f2  movk     x0, #0, lsl #32
000040823054: 0000e0f2  movk     x0, #0, lsl #48
000040823058: e10b0032  mov      w1, #7
00004082305c: e203132a  mov      w2, w19
000040823060: eb27ff97  bl       #0x407ed00c
000040823064: e803002a  mov      w8, w0
000040823068: e97b0032  mov      w9, #0x7fffffff
00004082306c: 1f01096b  cmp      w8, w9
000040823070: 61000054  b.ne     #0x4082307c
000040823074: 80038452  mov      w0, #0x201c
000040823078: 0b000014  b        #0x408230a4
00004082307c: 40d38052  mov      w0, #0x69a
000040823080: 00c0a072  movk     w0, #0x600, lsl #16
000040823084: e103082a  mov      w1, w8
000040823088: fa260094  bl       #0x4082cc70
00004082308c: 081299d2  mov      x8, #0xc890
000040823090: 488fa0f2  movk     x8, #0x47a, lsl #16
000040823094: 4801c0f2  movk     x8, #0xa, lsl #32
000040823098: 0800e0f2  movk     x8, #0, lsl #48
00004082309c: 20008452  mov      w0, #0x2001
0000408230a0: 13010039  strb     w19, [x8]
0000408230a4: f37bc1a8  ldp      x19, x30, [sp], #0x10
0000408230a8: c0035fd6  ret
; lookup
0000407ed00c: f37bbfa9  stp      x19, x30, [sp, #-0x10]!
0000407ed010: 03008012  mov      w3, #-1
0000407ed014: f30300aa  mov      x19, x0
0000407ed018: 90abed97  bl       #0x40357e58
0000407ed01c: 1f040031  cmn      w0, #1
0000407ed020: 80000054  b.eq     #0x407ed030
0000407ed024: 684e208b  add      x8, x19, w0, uxtw #3
0000407ed028: 000540b9  ldr      w0, [x8, #4]
0000407ed02c: 02000014  b        #0x407ed034
0000407ed030: e07b0032  mov      w0, #0x7fffffff
0000407ed034: f37bc1a8  ldp      x19, x30, [sp], #0x10
0000407ed038: c0035fd6  ret
; search
000040357e58: 61010034  cbz      w1, #0x40357e84
000040357e5c: e8031f2a  mov      w8, wzr
000040357e60: 090040b9  ldr      w9, [x0]
000040357e64: 3f01026b  cmp      w9, w2
000040357e68: c0000054  b.eq     #0x40357e80
000040357e6c: 08050011  add      w8, w8, #1
000040357e70: 00200091  add      x0, x0, #8
000040357e74: 1f01016b  cmp      w8, w1
000040357e78: 43ffff54  b.lo     #0x40357e60
000040357e7c: 02000014  b        #0x40357e84
000040357e80: e303082a  mov      w3, w8
000040357e84: e003032a  mov      w0, w3
000040357e88: c0035fd6  ret
; descriptor_builder
000040822ed8: ff8302d1  sub      sp, sp, #0xa0
000040822edc: f83300f9  str      x24, [sp, #0x60]
000040822ee0: f75b07a9  stp      x23, x22, [sp, #0x70]
000040822ee4: f55308a9  stp      x21, x20, [sp, #0x80]
000040822ee8: f37b09a9  stp      x19, x30, [sp, #0x90]
000040822eec: f30301aa  mov      x19, x1
000040822ef0: 01de8cd2  mov      x1, #0x66f0
000040822ef4: 617da8f2  movk     x1, #0x43eb, lsl #16
000040822ef8: 0100c0f2  movk     x1, #0, lsl #32
000040822efc: f40300aa  mov      x20, x0
000040822f00: 0100e0f2  movk     x1, #0, lsl #48
000040822f04: e0130191  add      x0, sp, #0x44
000040822f08: e20b1e32  mov      w2, #0x1c
000040822f0c: f7130191  add      x23, sp, #0x44
000040822f10: 9c032994  bl       #0x41263d80
000040822f14: 08228fd2  mov      x8, #0x7910
000040822f18: ff7f02a9  stp      xzr, xzr, [sp, #0x20]
000040822f1c: 687da8f2  movk     x8, #0x43eb, lsl #16
000040822f20: 0800c0f2  movk     x8, #0, lsl #32
000040822f24: 0800e0f2  movk     x8, #0, lsl #48
000040822f28: 21a08fd2  mov      x1, #0x7d01
000040822f2c: 55d38052  mov      w21, #0x69a
000040822f30: 617da8f2  movk     x1, #0x43eb, lsl #16
000040822f34: 0001c03d  ldr      q0, [x8]
000040822f38: 15c0a072  movk     w21, #0x600, lsl #16
000040822f3c: 0100c0f2  movk     x1, #0, lsl #32
000040822f40: 0100e0f2  movk     x1, #0, lsl #48
000040822f44: e2208052  mov      w2, #0x107
000040822f48: e003803d  str      q0, [sp]
000040822f4c: e003152a  mov      w0, w21
000040822f50: d87b1f94  bl       #0x41001eb0
000040822f54: 16d08cd2  mov      x22, #0x6680
000040822f58: 767da8f2  movk     x22, #0x43eb, lsl #16
000040822f5c: 1600c0f2  movk     x22, #0, lsl #32
000040822f60: 1600e0f2  movk     x22, #0, lsl #48
000040822f64: e203002a  mov      w2, w0
000040822f68: e10b0032  mov      w1, #7
000040822f6c: e00316aa  mov      x0, x22
000040822f70: f80b0032  mov      w24, #7
000040822f74: 3228ff97  bl       #0x407ed03c
000040822f78: 081c0012  and      w8, w0, #0xff
000040822f7c: e003152a  mov      w0, w21
000040822f80: e80b00f9  str      x8, [sp, #0x10]
000040822f84: 83250094  bl       #0x4082c590
000040822f88: e203002a  mov      w2, w0
000040822f8c: e10b0032  mov      w1, #7
000040822f90: e00316aa  mov      x0, x22
000040822f94: 2a28ff97  bl       #0x407ed03c
000040822f98: 081c0012  and      w8, w0, #0xff
000040822f9c: f8570079  strh     w24, [sp, #0x2a]
000040822fa0: e2030091  mov      x2, sp
000040822fa4: f71b00f9  str      x23, [sp, #0x30]
000040822fa8: e00314aa  mov      x0, x20
000040822fac: e10313aa  mov      x1, x19
000040822fb0: e80f00f9  str      x8, [sp, #0x18]
000040822fb4: d82dff97  bl       #0x407ee714
000040822fb8: f37b49a9  ldp      x19, x30, [sp, #0x90]
000040822fbc: f55348a9  ldp      x21, x20, [sp, #0x80]
000040822fc0: f75b47a9  ldp      x23, x22, [sp, #0x70]
000040822fc4: f83340f9  ldr      x24, [sp, #0x60]
000040822fc8: 20008452  mov      w0, #0x2001
000040822fcc: ff830291  add      sp, sp, #0xa0
000040822fd0: c0035fd6  ret

; Z8 2.10 property 0x1d006, names are analytical
; setter
0000408232dc: f37bbfa9  stp      x19, x30, [sp, #-0x10]!
0000408232e0: 13004039  ldrb     w19, [x0]
0000408232e4: 00d78cd2  mov      x0, #0x66b8
0000408232e8: 607da8f2  movk     x0, #0x43eb, lsl #16
0000408232ec: 0000c0f2  movk     x0, #0, lsl #32
0000408232f0: 0000e0f2  movk     x0, #0, lsl #48
0000408232f4: e10b0032  mov      w1, #7
0000408232f8: e203132a  mov      w2, w19
0000408232fc: 4427ff97  bl       #0x407ed00c
000040823300: e803002a  mov      w8, w0
000040823304: e97b0032  mov      w9, #0x7fffffff
000040823308: 1f01096b  cmp      w8, w9
00004082330c: 61000054  b.ne     #0x40823318
000040823310: 80038452  mov      w0, #0x201c
000040823314: 0b000014  b        #0x40823340
000040823318: 804a8252  mov      w0, #0x1254
00004082331c: 00c0a072  movk     w0, #0x600, lsl #16
000040823320: e103082a  mov      w1, w8
000040823324: 53260094  bl       #0x4082cc70
000040823328: 881299d2  mov      x8, #0xc894
00004082332c: 488fa0f2  movk     x8, #0x47a, lsl #16
000040823330: 4801c0f2  movk     x8, #0xa, lsl #32
000040823334: 0800e0f2  movk     x8, #0, lsl #48
000040823338: 20008452  mov      w0, #0x2001
00004082333c: 13010039  strb     w19, [x8]
000040823340: f37bc1a8  ldp      x19, x30, [sp], #0x10
000040823344: c0035fd6  ret
; lookup
0000407ed00c: f37bbfa9  stp      x19, x30, [sp, #-0x10]!
0000407ed010: 03008012  mov      w3, #-1
0000407ed014: f30300aa  mov      x19, x0
0000407ed018: 90abed97  bl       #0x40357e58
0000407ed01c: 1f040031  cmn      w0, #1
0000407ed020: 80000054  b.eq     #0x407ed030
0000407ed024: 684e208b  add      x8, x19, w0, uxtw #3
0000407ed028: 000540b9  ldr      w0, [x8, #4]
0000407ed02c: 02000014  b        #0x407ed034
0000407ed030: e07b0032  mov      w0, #0x7fffffff
0000407ed034: f37bc1a8  ldp      x19, x30, [sp], #0x10
0000407ed038: c0035fd6  ret
; search
000040357e58: 61010034  cbz      w1, #0x40357e84
000040357e5c: e8031f2a  mov      w8, wzr
000040357e60: 090040b9  ldr      w9, [x0]
000040357e64: 3f01026b  cmp      w9, w2
000040357e68: c0000054  b.eq     #0x40357e80
000040357e6c: 08050011  add      w8, w8, #1
000040357e70: 00200091  add      x0, x0, #8
000040357e74: 1f01016b  cmp      w8, w1
000040357e78: 43ffff54  b.lo     #0x40357e60
000040357e7c: 02000014  b        #0x40357e84
000040357e80: e303082a  mov      w3, w8
000040357e84: e003032a  mov      w0, w3
000040357e88: c0035fd6  ret
; descriptor_builder
000040823174: ff8302d1  sub      sp, sp, #0xa0
000040823178: f83300f9  str      x24, [sp, #0x60]
00004082317c: f75b07a9  stp      x23, x22, [sp, #0x70]
000040823180: f55308a9  stp      x21, x20, [sp, #0x80]
000040823184: f37b09a9  stp      x19, x30, [sp, #0x90]
000040823188: f30301aa  mov      x19, x1
00004082318c: 01de8cd2  mov      x1, #0x66f0
000040823190: 617da8f2  movk     x1, #0x43eb, lsl #16
000040823194: 0100c0f2  movk     x1, #0, lsl #32
000040823198: f40300aa  mov      x20, x0
00004082319c: 0100e0f2  movk     x1, #0, lsl #48
0000408231a0: e0130191  add      x0, sp, #0x44
0000408231a4: e20b1e32  mov      w2, #0x1c
0000408231a8: f7130191  add      x23, sp, #0x44
0000408231ac: f5022994  bl       #0x41263d80
0000408231b0: 08248fd2  mov      x8, #0x7920
0000408231b4: ff7f02a9  stp      xzr, xzr, [sp, #0x20]
0000408231b8: 687da8f2  movk     x8, #0x43eb, lsl #16
0000408231bc: 0800c0f2  movk     x8, #0, lsl #32
0000408231c0: 0800e0f2  movk     x8, #0, lsl #48
0000408231c4: 21a08fd2  mov      x1, #0x7d01
0000408231c8: 954a8252  mov      w21, #0x1254
0000408231cc: 617da8f2  movk     x1, #0x43eb, lsl #16
0000408231d0: 0001c03d  ldr      q0, [x8]
0000408231d4: 15c0a072  movk     w21, #0x600, lsl #16
0000408231d8: 0100c0f2  movk     x1, #0, lsl #32
0000408231dc: 0100e0f2  movk     x1, #0, lsl #48
0000408231e0: a2358052  mov      w2, #0x1ad
0000408231e4: e003803d  str      q0, [sp]
0000408231e8: e003152a  mov      w0, w21
0000408231ec: 317b1f94  bl       #0x41001eb0
0000408231f0: 16d78cd2  mov      x22, #0x66b8
0000408231f4: 767da8f2  movk     x22, #0x43eb, lsl #16
0000408231f8: 1600c0f2  movk     x22, #0, lsl #32
0000408231fc: 1600e0f2  movk     x22, #0, lsl #48
000040823200: e203002a  mov      w2, w0
000040823204: e10b0032  mov      w1, #7
000040823208: e00316aa  mov      x0, x22
00004082320c: f80b0032  mov      w24, #7
000040823210: 8b27ff97  bl       #0x407ed03c
000040823214: 081c0012  and      w8, w0, #0xff
000040823218: e003152a  mov      w0, w21
00004082321c: e80b00f9  str      x8, [sp, #0x10]
000040823220: dc240094  bl       #0x4082c590
000040823224: e203002a  mov      w2, w0
000040823228: e10b0032  mov      w1, #7
00004082322c: e00316aa  mov      x0, x22
000040823230: 8327ff97  bl       #0x407ed03c
000040823234: 081c0012  and      w8, w0, #0xff
000040823238: f8570079  strh     w24, [sp, #0x2a]
00004082323c: e2030091  mov      x2, sp
000040823240: f71b00f9  str      x23, [sp, #0x30]
000040823244: e00314aa  mov      x0, x20
000040823248: e10313aa  mov      x1, x19
00004082324c: e80f00f9  str      x8, [sp, #0x18]
000040823250: 312dff97  bl       #0x407ee714
000040823254: f37b49a9  ldp      x19, x30, [sp, #0x90]
000040823258: f55348a9  ldp      x21, x20, [sp, #0x80]
00004082325c: f75b47a9  ldp      x23, x22, [sp, #0x70]
000040823260: f83340f9  ldr      x24, [sp, #0x60]
000040823264: 20008452  mov      w0, #0x2001
000040823268: ff830291  add      sp, sp, #0xa0
00004082326c: c0035fd6  ret

; Z8 3.00 property 0x1d005, names are analytical
; setter
00004084ca84: f40f1ef8  str      x20, [sp, #-0x20]!
00004084ca88: f37b01a9  stp      x19, x30, [sp, #0x10]
00004084ca8c: f40300aa  mov      x20, x0
00004084ca90: f30301aa  mov      x19, x1
00004084ca94: e1330091  add      x1, sp, #0xc
00004084ca98: 803e40b9  ldr      w0, [x20, #0x3c]
00004084ca9c: e2030032  mov      w2, #1
00004084caa0: e30313aa  mov      x3, x19
00004084caa4: 782fec97  bl       #0x40358884
00004084caa8: 80b089d2  mov      x0, #0x4d84
00004084caac: e2334039  ldrb     w2, [sp, #0xc]
00004084cab0: e081a8f2  movk     x0, #0x440f, lsl #16
00004084cab4: 0000c0f2  movk     x0, #0, lsl #32
00004084cab8: 0000e0f2  movk     x0, #0, lsl #48
00004084cabc: e10b0032  mov      w1, #7
00004084cac0: ab13ff97  bl       #0x4081196c
00004084cac4: e803002a  mov      w8, w0
00004084cac8: e97b0032  mov      w9, #0x7fffffff
00004084cacc: 1f01096b  cmp      w8, w9
00004084cad0: 61000054  b.ne     #0x4084cadc
00004084cad4: 80038452  mov      w0, #0x201c
00004084cad8: 0b000014  b        #0x4084cb04
00004084cadc: 40d38052  mov      w0, #0x69a
00004084cae0: 00c0a072  movk     w0, #0x600, lsl #16
00004084cae4: e103082a  mov      w1, w8
00004084cae8: 84270094  bl       #0x408568f8
00004084caec: 803e40b9  ldr      w0, [x20, #0x3c]
00004084caf0: e30313aa  mov      x3, x19
00004084caf4: 812640f9  ldr      x1, [x20, #0x48]
00004084caf8: 825240b9  ldr      w2, [x20, #0x50]
00004084cafc: 622fec97  bl       #0x40358884
00004084cb00: 20008452  mov      w0, #0x2001
00004084cb04: f37b41a9  ldp      x19, x30, [sp, #0x10]
00004084cb08: f40742f8  ldr      x20, [sp], #0x20
00004084cb0c: c0035fd6  ret
; lookup
00004081196c: f37bbfa9  stp      x19, x30, [sp, #-0x10]!
000040811970: 03008012  mov      w3, #-1
000040811974: f30300aa  mov      x19, x0
000040811978: fd19ed97  bl       #0x4035816c
00004081197c: 1f040031  cmn      w0, #1
000040811980: 80000054  b.eq     #0x40811990
000040811984: 684e208b  add      x8, x19, w0, uxtw #3
000040811988: 000540b9  ldr      w0, [x8, #4]
00004081198c: 02000014  b        #0x40811994
000040811990: e07b0032  mov      w0, #0x7fffffff
000040811994: f37bc1a8  ldp      x19, x30, [sp], #0x10
000040811998: c0035fd6  ret
; search
00004035816c: 61010034  cbz      w1, #0x40358198
000040358170: e8031f2a  mov      w8, wzr
000040358174: 090040b9  ldr      w9, [x0]
000040358178: 3f01026b  cmp      w9, w2
00004035817c: c0000054  b.eq     #0x40358194
000040358180: 08050011  add      w8, w8, #1
000040358184: 00200091  add      x0, x0, #8
000040358188: 1f01016b  cmp      w8, w1
00004035818c: 43ffff54  b.lo     #0x40358174
000040358190: 02000014  b        #0x40358198
000040358194: e303082a  mov      w3, w8
000040358198: e003032a  mov      w0, w3
00004035819c: c0035fd6  ret
; descriptor_builder
00004084c95c: ff8302d1  sub      sp, sp, #0xa0
00004084c960: f83300f9  str      x24, [sp, #0x60]
00004084c964: f75b07a9  stp      x23, x22, [sp, #0x70]
00004084c968: f55308a9  stp      x21, x20, [sp, #0x80]
00004084c96c: f37b09a9  stp      x19, x30, [sp, #0x90]
00004084c970: f40301aa  mov      x20, x1
00004084c974: 81b789d2  mov      x1, #0x4dbc
00004084c978: e181a8f2  movk     x1, #0x440f, lsl #16
00004084c97c: 0100c0f2  movk     x1, #0, lsl #32
00004084c980: f30302aa  mov      x19, x2
00004084c984: f50300aa  mov      x21, x0
00004084c988: 0100e0f2  movk     x1, #0, lsl #48
00004084c98c: e0130191  add      x0, sp, #0x44
00004084c990: e20b1e32  mov      w2, #0x1c
00004084c994: f7130191  add      x23, sp, #0x44
00004084c998: 4ab82894  bl       #0x4127aac0
00004084c99c: ff7f03a9  stp      xzr, xzr, [sp, #0x30]
00004084c9a0: e00315aa  mov      x0, x21
00004084c9a4: a80240b9  ldr      w8, [x21]
00004084c9a8: ea230091  add      x10, sp, #8
00004084c9ac: a93e40b9  ldr      w9, [x21, #0x3c]
00004084c9b0: 56610091  add      x22, x10, #0x18
00004084c9b4: ff7f02a9  stp      xzr, xzr, [sp, #0x20]
00004084c9b8: e8270129  stp      w8, w9, [sp, #8]
00004084c9bc: dc17ff97  bl       #0x4081292c
00004084c9c0: e8031f32  mov      w8, #2
00004084c9c4: c1128bd2  mov      x1, #0x5896
00004084c9c8: e181a8f2  movk     x1, #0x440f, lsl #16
00004084c9cc: e0230229  stp      w0, w8, [sp, #0x10]
00004084c9d0: 40d38052  mov      w0, #0x69a
00004084c9d4: 0100c0f2  movk     x1, #0, lsl #32
00004084c9d8: 00c0a072  movk     w0, #0x600, lsl #16
00004084c9dc: 0100e0f2  movk     x1, #0, lsl #48
00004084c9e0: 62308052  mov      w2, #0x183
00004084c9e4: c2191f94  bl       #0x410130ec
00004084c9e8: e203002a  mov      w2, w0
00004084c9ec: 80b089d2  mov      x0, #0x4d84
00004084c9f0: e081a8f2  movk     x0, #0x440f, lsl #16
00004084c9f4: 0000c0f2  movk     x0, #0, lsl #32
00004084c9f8: 0000e0f2  movk     x0, #0, lsl #48
00004084c9fc: e10b0032  mov      w1, #7
00004084ca00: f80b0032  mov      w24, #7
00004084ca04: e613ff97  bl       #0x4081199c
00004084ca08: a84640f9  ldr      x8, [x21, #0x88]
00004084ca0c: 091c0012  and      w9, w0, #0xff
00004084ca10: e2031d32  mov      w2, #8
00004084ca14: e00315aa  mov      x0, x21
00004084ca18: e10316aa  mov      x1, x22
00004084ca1c: e90f00f9  str      x9, [sp, #0x18]
00004084ca20: 00013fd6  blr      x8
00004084ca24: e2230091  add      x2, sp, #8
00004084ca28: f8670079  strh     w24, [sp, #0x32]
00004084ca2c: e00314aa  mov      x0, x20
00004084ca30: f71f00f9  str      x23, [sp, #0x38]
00004084ca34: e10313aa  mov      x1, x19
00004084ca38: d119ff97  bl       #0x4081317c
00004084ca3c: f37b49a9  ldp      x19, x30, [sp, #0x90]
00004084ca40: f55348a9  ldp      x21, x20, [sp, #0x80]
00004084ca44: f75b47a9  ldp      x23, x22, [sp, #0x70]
00004084ca48: f83340f9  ldr      x24, [sp, #0x60]
00004084ca4c: 20008452  mov      w0, #0x2001
00004084ca50: ff830291  add      sp, sp, #0xa0
00004084ca54: c0035fd6  ret

; Z8 3.00 property 0x1d006, names are analytical
; setter
00004084cd70: f40f1ef8  str      x20, [sp, #-0x20]!
00004084cd74: f37b01a9  stp      x19, x30, [sp, #0x10]
00004084cd78: f40300aa  mov      x20, x0
00004084cd7c: f30301aa  mov      x19, x1
00004084cd80: e1330091  add      x1, sp, #0xc
00004084cd84: 803e40b9  ldr      w0, [x20, #0x3c]
00004084cd88: e2030032  mov      w2, #1
00004084cd8c: e30313aa  mov      x3, x19
00004084cd90: bd2eec97  bl       #0x40358884
00004084cd94: 00bb89d2  mov      x0, #0x4dd8
00004084cd98: e2334039  ldrb     w2, [sp, #0xc]
00004084cd9c: e081a8f2  movk     x0, #0x440f, lsl #16
00004084cda0: 0000c0f2  movk     x0, #0, lsl #32
00004084cda4: 0000e0f2  movk     x0, #0, lsl #48
00004084cda8: e10b0032  mov      w1, #7
00004084cdac: f012ff97  bl       #0x4081196c
00004084cdb0: e803002a  mov      w8, w0
00004084cdb4: e97b0032  mov      w9, #0x7fffffff
00004084cdb8: 1f01096b  cmp      w8, w9
00004084cdbc: 61000054  b.ne     #0x4084cdc8
00004084cdc0: 80038452  mov      w0, #0x201c
00004084cdc4: 0b000014  b        #0x4084cdf0
00004084cdc8: 804a8252  mov      w0, #0x1254
00004084cdcc: 00c0a072  movk     w0, #0x600, lsl #16
00004084cdd0: e103082a  mov      w1, w8
00004084cdd4: c9260094  bl       #0x408568f8
00004084cdd8: 803e40b9  ldr      w0, [x20, #0x3c]
00004084cddc: e30313aa  mov      x3, x19
00004084cde0: 812640f9  ldr      x1, [x20, #0x48]
00004084cde4: 825240b9  ldr      w2, [x20, #0x50]
00004084cde8: a72eec97  bl       #0x40358884
00004084cdec: 20008452  mov      w0, #0x2001
00004084cdf0: f37b41a9  ldp      x19, x30, [sp, #0x10]
00004084cdf4: f40742f8  ldr      x20, [sp], #0x20
00004084cdf8: c0035fd6  ret
; lookup
00004081196c: f37bbfa9  stp      x19, x30, [sp, #-0x10]!
000040811970: 03008012  mov      w3, #-1
000040811974: f30300aa  mov      x19, x0
000040811978: fd19ed97  bl       #0x4035816c
00004081197c: 1f040031  cmn      w0, #1
000040811980: 80000054  b.eq     #0x40811990
000040811984: 684e208b  add      x8, x19, w0, uxtw #3
000040811988: 000540b9  ldr      w0, [x8, #4]
00004081198c: 02000014  b        #0x40811994
000040811990: e07b0032  mov      w0, #0x7fffffff
000040811994: f37bc1a8  ldp      x19, x30, [sp], #0x10
000040811998: c0035fd6  ret
; search
00004035816c: 61010034  cbz      w1, #0x40358198
000040358170: e8031f2a  mov      w8, wzr
000040358174: 090040b9  ldr      w9, [x0]
000040358178: 3f01026b  cmp      w9, w2
00004035817c: c0000054  b.eq     #0x40358194
000040358180: 08050011  add      w8, w8, #1
000040358184: 00200091  add      x0, x0, #8
000040358188: 1f01016b  cmp      w8, w1
00004035818c: 43ffff54  b.lo     #0x40358174
000040358190: 02000014  b        #0x40358198
000040358194: e303082a  mov      w3, w8
000040358198: e003032a  mov      w0, w3
00004035819c: c0035fd6  ret
; descriptor_builder
00004084cc48: ff8302d1  sub      sp, sp, #0xa0
00004084cc4c: f83300f9  str      x24, [sp, #0x60]
00004084cc50: f75b07a9  stp      x23, x22, [sp, #0x70]
00004084cc54: f55308a9  stp      x21, x20, [sp, #0x80]
00004084cc58: f37b09a9  stp      x19, x30, [sp, #0x90]
00004084cc5c: f40301aa  mov      x20, x1
00004084cc60: 81b789d2  mov      x1, #0x4dbc
00004084cc64: e181a8f2  movk     x1, #0x440f, lsl #16
00004084cc68: 0100c0f2  movk     x1, #0, lsl #32
00004084cc6c: f30302aa  mov      x19, x2
00004084cc70: f50300aa  mov      x21, x0
00004084cc74: 0100e0f2  movk     x1, #0, lsl #48
00004084cc78: e0130191  add      x0, sp, #0x44
00004084cc7c: e20b1e32  mov      w2, #0x1c
00004084cc80: f7130191  add      x23, sp, #0x44
00004084cc84: 8fb72894  bl       #0x4127aac0
00004084cc88: ff7f03a9  stp      xzr, xzr, [sp, #0x30]
00004084cc8c: e00315aa  mov      x0, x21
00004084cc90: a80240b9  ldr      w8, [x21]
00004084cc94: ea230091  add      x10, sp, #8
00004084cc98: a93e40b9  ldr      w9, [x21, #0x3c]
00004084cc9c: 56610091  add      x22, x10, #0x18
00004084cca0: ff7f02a9  stp      xzr, xzr, [sp, #0x20]
00004084cca4: e8270129  stp      w8, w9, [sp, #8]
00004084cca8: 2117ff97  bl       #0x4081292c
00004084ccac: e8031f32  mov      w8, #2
00004084ccb0: c1128bd2  mov      x1, #0x5896
00004084ccb4: e181a8f2  movk     x1, #0x440f, lsl #16
00004084ccb8: e0230229  stp      w0, w8, [sp, #0x10]
00004084ccbc: 804a8252  mov      w0, #0x1254
00004084ccc0: 0100c0f2  movk     x1, #0, lsl #32
00004084ccc4: 00c0a072  movk     w0, #0x600, lsl #16
00004084ccc8: 0100e0f2  movk     x1, #0, lsl #48
00004084cccc: a2478052  mov      w2, #0x23d
00004084ccd0: 07191f94  bl       #0x410130ec
00004084ccd4: e203002a  mov      w2, w0
00004084ccd8: 00bb89d2  mov      x0, #0x4dd8
00004084ccdc: e081a8f2  movk     x0, #0x440f, lsl #16
00004084cce0: 0000c0f2  movk     x0, #0, lsl #32
00004084cce4: 0000e0f2  movk     x0, #0, lsl #48
00004084cce8: e10b0032  mov      w1, #7
00004084ccec: f80b0032  mov      w24, #7
00004084ccf0: 2b13ff97  bl       #0x4081199c
00004084ccf4: a84640f9  ldr      x8, [x21, #0x88]
00004084ccf8: 091c0012  and      w9, w0, #0xff
00004084ccfc: e2031d32  mov      w2, #8
00004084cd00: e00315aa  mov      x0, x21
00004084cd04: e10316aa  mov      x1, x22
00004084cd08: e90f00f9  str      x9, [sp, #0x18]
00004084cd0c: 00013fd6  blr      x8
00004084cd10: e2230091  add      x2, sp, #8
00004084cd14: f8670079  strh     w24, [sp, #0x32]
00004084cd18: e00314aa  mov      x0, x20
00004084cd1c: f71f00f9  str      x23, [sp, #0x38]
00004084cd20: e10313aa  mov      x1, x19
00004084cd24: 1619ff97  bl       #0x4081317c
00004084cd28: f37b49a9  ldp      x19, x30, [sp, #0x90]
00004084cd2c: f55348a9  ldp      x21, x20, [sp, #0x80]
00004084cd30: f75b47a9  ldp      x23, x22, [sp, #0x70]
00004084cd34: f83340f9  ldr      x24, [sp, #0x60]
00004084cd38: 20008452  mov      w0, #0x2001
00004084cd3c: ff830291  add      sp, sp, #0xa0
00004084cd40: c0035fd6  ret

; Z8 3.01 property 0x1d005, names are analytical
; setter
00004084ca84: f40f1ef8  str      x20, [sp, #-0x20]!
00004084ca88: f37b01a9  stp      x19, x30, [sp, #0x10]
00004084ca8c: f40300aa  mov      x20, x0
00004084ca90: f30301aa  mov      x19, x1
00004084ca94: e1330091  add      x1, sp, #0xc
00004084ca98: 803e40b9  ldr      w0, [x20, #0x3c]
00004084ca9c: e2030032  mov      w2, #1
00004084caa0: e30313aa  mov      x3, x19
00004084caa4: 782fec97  bl       #0x40358884
00004084caa8: 80ae89d2  mov      x0, #0x4d74
00004084caac: e2334039  ldrb     w2, [sp, #0xc]
00004084cab0: e081a8f2  movk     x0, #0x440f, lsl #16
00004084cab4: 0000c0f2  movk     x0, #0, lsl #32
00004084cab8: 0000e0f2  movk     x0, #0, lsl #48
00004084cabc: e10b0032  mov      w1, #7
00004084cac0: ab13ff97  bl       #0x4081196c
00004084cac4: e803002a  mov      w8, w0
00004084cac8: e97b0032  mov      w9, #0x7fffffff
00004084cacc: 1f01096b  cmp      w8, w9
00004084cad0: 61000054  b.ne     #0x4084cadc
00004084cad4: 80038452  mov      w0, #0x201c
00004084cad8: 0b000014  b        #0x4084cb04
00004084cadc: 40d38052  mov      w0, #0x69a
00004084cae0: 00c0a072  movk     w0, #0x600, lsl #16
00004084cae4: e103082a  mov      w1, w8
00004084cae8: 84270094  bl       #0x408568f8
00004084caec: 803e40b9  ldr      w0, [x20, #0x3c]
00004084caf0: e30313aa  mov      x3, x19
00004084caf4: 812640f9  ldr      x1, [x20, #0x48]
00004084caf8: 825240b9  ldr      w2, [x20, #0x50]
00004084cafc: 622fec97  bl       #0x40358884
00004084cb00: 20008452  mov      w0, #0x2001
00004084cb04: f37b41a9  ldp      x19, x30, [sp, #0x10]
00004084cb08: f40742f8  ldr      x20, [sp], #0x20
00004084cb0c: c0035fd6  ret
; lookup
00004081196c: f37bbfa9  stp      x19, x30, [sp, #-0x10]!
000040811970: 03008012  mov      w3, #-1
000040811974: f30300aa  mov      x19, x0
000040811978: fd19ed97  bl       #0x4035816c
00004081197c: 1f040031  cmn      w0, #1
000040811980: 80000054  b.eq     #0x40811990
000040811984: 684e208b  add      x8, x19, w0, uxtw #3
000040811988: 000540b9  ldr      w0, [x8, #4]
00004081198c: 02000014  b        #0x40811994
000040811990: e07b0032  mov      w0, #0x7fffffff
000040811994: f37bc1a8  ldp      x19, x30, [sp], #0x10
000040811998: c0035fd6  ret
; search
00004035816c: 61010034  cbz      w1, #0x40358198
000040358170: e8031f2a  mov      w8, wzr
000040358174: 090040b9  ldr      w9, [x0]
000040358178: 3f01026b  cmp      w9, w2
00004035817c: c0000054  b.eq     #0x40358194
000040358180: 08050011  add      w8, w8, #1
000040358184: 00200091  add      x0, x0, #8
000040358188: 1f01016b  cmp      w8, w1
00004035818c: 43ffff54  b.lo     #0x40358174
000040358190: 02000014  b        #0x40358198
000040358194: e303082a  mov      w3, w8
000040358198: e003032a  mov      w0, w3
00004035819c: c0035fd6  ret
; descriptor_builder
00004084c95c: ff8302d1  sub      sp, sp, #0xa0
00004084c960: f83300f9  str      x24, [sp, #0x60]
00004084c964: f75b07a9  stp      x23, x22, [sp, #0x70]
00004084c968: f55308a9  stp      x21, x20, [sp, #0x80]
00004084c96c: f37b09a9  stp      x19, x30, [sp, #0x90]
00004084c970: f40301aa  mov      x20, x1
00004084c974: 81b589d2  mov      x1, #0x4dac
00004084c978: e181a8f2  movk     x1, #0x440f, lsl #16
00004084c97c: 0100c0f2  movk     x1, #0, lsl #32
00004084c980: f30302aa  mov      x19, x2
00004084c984: f50300aa  mov      x21, x0
00004084c988: 0100e0f2  movk     x1, #0, lsl #48
00004084c98c: e0130191  add      x0, sp, #0x44
00004084c990: e20b1e32  mov      w2, #0x1c
00004084c994: f7130191  add      x23, sp, #0x44
00004084c998: 4ab82894  bl       #0x4127aac0
00004084c99c: ff7f03a9  stp      xzr, xzr, [sp, #0x30]
00004084c9a0: e00315aa  mov      x0, x21
00004084c9a4: a80240b9  ldr      w8, [x21]
00004084c9a8: ea230091  add      x10, sp, #8
00004084c9ac: a93e40b9  ldr      w9, [x21, #0x3c]
00004084c9b0: 56610091  add      x22, x10, #0x18
00004084c9b4: ff7f02a9  stp      xzr, xzr, [sp, #0x20]
00004084c9b8: e8270129  stp      w8, w9, [sp, #8]
00004084c9bc: dc17ff97  bl       #0x4081292c
00004084c9c0: e8031f32  mov      w8, #2
00004084c9c4: c1108bd2  mov      x1, #0x5886
00004084c9c8: e181a8f2  movk     x1, #0x440f, lsl #16
00004084c9cc: e0230229  stp      w0, w8, [sp, #0x10]
00004084c9d0: 40d38052  mov      w0, #0x69a
00004084c9d4: 0100c0f2  movk     x1, #0, lsl #32
00004084c9d8: 00c0a072  movk     w0, #0x600, lsl #16
00004084c9dc: 0100e0f2  movk     x1, #0, lsl #48
00004084c9e0: 62308052  mov      w2, #0x183
00004084c9e4: c2191f94  bl       #0x410130ec
00004084c9e8: e203002a  mov      w2, w0
00004084c9ec: 80ae89d2  mov      x0, #0x4d74
00004084c9f0: e081a8f2  movk     x0, #0x440f, lsl #16
00004084c9f4: 0000c0f2  movk     x0, #0, lsl #32
00004084c9f8: 0000e0f2  movk     x0, #0, lsl #48
00004084c9fc: e10b0032  mov      w1, #7
00004084ca00: f80b0032  mov      w24, #7
00004084ca04: e613ff97  bl       #0x4081199c
00004084ca08: a84640f9  ldr      x8, [x21, #0x88]
00004084ca0c: 091c0012  and      w9, w0, #0xff
00004084ca10: e2031d32  mov      w2, #8
00004084ca14: e00315aa  mov      x0, x21
00004084ca18: e10316aa  mov      x1, x22
00004084ca1c: e90f00f9  str      x9, [sp, #0x18]
00004084ca20: 00013fd6  blr      x8
00004084ca24: e2230091  add      x2, sp, #8
00004084ca28: f8670079  strh     w24, [sp, #0x32]
00004084ca2c: e00314aa  mov      x0, x20
00004084ca30: f71f00f9  str      x23, [sp, #0x38]
00004084ca34: e10313aa  mov      x1, x19
00004084ca38: d119ff97  bl       #0x4081317c
00004084ca3c: f37b49a9  ldp      x19, x30, [sp, #0x90]
00004084ca40: f55348a9  ldp      x21, x20, [sp, #0x80]
00004084ca44: f75b47a9  ldp      x23, x22, [sp, #0x70]
00004084ca48: f83340f9  ldr      x24, [sp, #0x60]
00004084ca4c: 20008452  mov      w0, #0x2001
00004084ca50: ff830291  add      sp, sp, #0xa0
00004084ca54: c0035fd6  ret

; Z8 3.01 property 0x1d006, names are analytical
; setter
00004084cd70: f40f1ef8  str      x20, [sp, #-0x20]!
00004084cd74: f37b01a9  stp      x19, x30, [sp, #0x10]
00004084cd78: f40300aa  mov      x20, x0
00004084cd7c: f30301aa  mov      x19, x1
00004084cd80: e1330091  add      x1, sp, #0xc
00004084cd84: 803e40b9  ldr      w0, [x20, #0x3c]
00004084cd88: e2030032  mov      w2, #1
00004084cd8c: e30313aa  mov      x3, x19
00004084cd90: bd2eec97  bl       #0x40358884
00004084cd94: 00b989d2  mov      x0, #0x4dc8
00004084cd98: e2334039  ldrb     w2, [sp, #0xc]
00004084cd9c: e081a8f2  movk     x0, #0x440f, lsl #16
00004084cda0: 0000c0f2  movk     x0, #0, lsl #32
00004084cda4: 0000e0f2  movk     x0, #0, lsl #48
00004084cda8: e10b0032  mov      w1, #7
00004084cdac: f012ff97  bl       #0x4081196c
00004084cdb0: e803002a  mov      w8, w0
00004084cdb4: e97b0032  mov      w9, #0x7fffffff
00004084cdb8: 1f01096b  cmp      w8, w9
00004084cdbc: 61000054  b.ne     #0x4084cdc8
00004084cdc0: 80038452  mov      w0, #0x201c
00004084cdc4: 0b000014  b        #0x4084cdf0
00004084cdc8: 804a8252  mov      w0, #0x1254
00004084cdcc: 00c0a072  movk     w0, #0x600, lsl #16
00004084cdd0: e103082a  mov      w1, w8
00004084cdd4: c9260094  bl       #0x408568f8
00004084cdd8: 803e40b9  ldr      w0, [x20, #0x3c]
00004084cddc: e30313aa  mov      x3, x19
00004084cde0: 812640f9  ldr      x1, [x20, #0x48]
00004084cde4: 825240b9  ldr      w2, [x20, #0x50]
00004084cde8: a72eec97  bl       #0x40358884
00004084cdec: 20008452  mov      w0, #0x2001
00004084cdf0: f37b41a9  ldp      x19, x30, [sp, #0x10]
00004084cdf4: f40742f8  ldr      x20, [sp], #0x20
00004084cdf8: c0035fd6  ret
; lookup
00004081196c: f37bbfa9  stp      x19, x30, [sp, #-0x10]!
000040811970: 03008012  mov      w3, #-1
000040811974: f30300aa  mov      x19, x0
000040811978: fd19ed97  bl       #0x4035816c
00004081197c: 1f040031  cmn      w0, #1
000040811980: 80000054  b.eq     #0x40811990
000040811984: 684e208b  add      x8, x19, w0, uxtw #3
000040811988: 000540b9  ldr      w0, [x8, #4]
00004081198c: 02000014  b        #0x40811994
000040811990: e07b0032  mov      w0, #0x7fffffff
000040811994: f37bc1a8  ldp      x19, x30, [sp], #0x10
000040811998: c0035fd6  ret
; search
00004035816c: 61010034  cbz      w1, #0x40358198
000040358170: e8031f2a  mov      w8, wzr
000040358174: 090040b9  ldr      w9, [x0]
000040358178: 3f01026b  cmp      w9, w2
00004035817c: c0000054  b.eq     #0x40358194
000040358180: 08050011  add      w8, w8, #1
000040358184: 00200091  add      x0, x0, #8
000040358188: 1f01016b  cmp      w8, w1
00004035818c: 43ffff54  b.lo     #0x40358174
000040358190: 02000014  b        #0x40358198
000040358194: e303082a  mov      w3, w8
000040358198: e003032a  mov      w0, w3
00004035819c: c0035fd6  ret
; descriptor_builder
00004084cc48: ff8302d1  sub      sp, sp, #0xa0
00004084cc4c: f83300f9  str      x24, [sp, #0x60]
00004084cc50: f75b07a9  stp      x23, x22, [sp, #0x70]
00004084cc54: f55308a9  stp      x21, x20, [sp, #0x80]
00004084cc58: f37b09a9  stp      x19, x30, [sp, #0x90]
00004084cc5c: f40301aa  mov      x20, x1
00004084cc60: 81b589d2  mov      x1, #0x4dac
00004084cc64: e181a8f2  movk     x1, #0x440f, lsl #16
00004084cc68: 0100c0f2  movk     x1, #0, lsl #32
00004084cc6c: f30302aa  mov      x19, x2
00004084cc70: f50300aa  mov      x21, x0
00004084cc74: 0100e0f2  movk     x1, #0, lsl #48
00004084cc78: e0130191  add      x0, sp, #0x44
00004084cc7c: e20b1e32  mov      w2, #0x1c
00004084cc80: f7130191  add      x23, sp, #0x44
00004084cc84: 8fb72894  bl       #0x4127aac0
00004084cc88: ff7f03a9  stp      xzr, xzr, [sp, #0x30]
00004084cc8c: e00315aa  mov      x0, x21
00004084cc90: a80240b9  ldr      w8, [x21]
00004084cc94: ea230091  add      x10, sp, #8
00004084cc98: a93e40b9  ldr      w9, [x21, #0x3c]
00004084cc9c: 56610091  add      x22, x10, #0x18
00004084cca0: ff7f02a9  stp      xzr, xzr, [sp, #0x20]
00004084cca4: e8270129  stp      w8, w9, [sp, #8]
00004084cca8: 2117ff97  bl       #0x4081292c
00004084ccac: e8031f32  mov      w8, #2
00004084ccb0: c1108bd2  mov      x1, #0x5886
00004084ccb4: e181a8f2  movk     x1, #0x440f, lsl #16
00004084ccb8: e0230229  stp      w0, w8, [sp, #0x10]
00004084ccbc: 804a8252  mov      w0, #0x1254
00004084ccc0: 0100c0f2  movk     x1, #0, lsl #32
00004084ccc4: 00c0a072  movk     w0, #0x600, lsl #16
00004084ccc8: 0100e0f2  movk     x1, #0, lsl #48
00004084cccc: a2478052  mov      w2, #0x23d
00004084ccd0: 07191f94  bl       #0x410130ec
00004084ccd4: e203002a  mov      w2, w0
00004084ccd8: 00b989d2  mov      x0, #0x4dc8
00004084ccdc: e081a8f2  movk     x0, #0x440f, lsl #16
00004084cce0: 0000c0f2  movk     x0, #0, lsl #32
00004084cce4: 0000e0f2  movk     x0, #0, lsl #48
00004084cce8: e10b0032  mov      w1, #7
00004084ccec: f80b0032  mov      w24, #7
00004084ccf0: 2b13ff97  bl       #0x4081199c
00004084ccf4: a84640f9  ldr      x8, [x21, #0x88]
00004084ccf8: 091c0012  and      w9, w0, #0xff
00004084ccfc: e2031d32  mov      w2, #8
00004084cd00: e00315aa  mov      x0, x21
00004084cd04: e10316aa  mov      x1, x22
00004084cd08: e90f00f9  str      x9, [sp, #0x18]
00004084cd0c: 00013fd6  blr      x8
00004084cd10: e2230091  add      x2, sp, #8
00004084cd14: f8670079  strh     w24, [sp, #0x32]
00004084cd18: e00314aa  mov      x0, x20
00004084cd1c: f71f00f9  str      x23, [sp, #0x38]
00004084cd20: e10313aa  mov      x1, x19
00004084cd24: 1619ff97  bl       #0x4081317c
00004084cd28: f37b49a9  ldp      x19, x30, [sp, #0x90]
00004084cd2c: f55348a9  ldp      x21, x20, [sp, #0x80]
00004084cd30: f75b47a9  ldp      x23, x22, [sp, #0x70]
00004084cd34: f83340f9  ldr      x24, [sp, #0x60]
00004084cd38: 20008452  mov      w0, #0x2001
00004084cd3c: ff830291  add      sp, sp, #0xa0
00004084cd40: c0035fd6  ret

; Z8 3.10 property 0x1d005, names are analytical
; setter
00004084cd54: f40f1ef8  str      x20, [sp, #-0x20]!
00004084cd58: f37b01a9  stp      x19, x30, [sp, #0x10]
00004084cd5c: f40300aa  mov      x20, x0
00004084cd60: f30301aa  mov      x19, x1
00004084cd64: e1330091  add      x1, sp, #0xc
00004084cd68: 803e40b9  ldr      w0, [x20, #0x3c]
00004084cd6c: e2030032  mov      w2, #1
00004084cd70: e30313aa  mov      x3, x19
00004084cd74: c42eec97  bl       #0x40358884
00004084cd78: 80b089d2  mov      x0, #0x4d84
00004084cd7c: e2334039  ldrb     w2, [sp, #0xc]
00004084cd80: e081a8f2  movk     x0, #0x440f, lsl #16
00004084cd84: 0000c0f2  movk     x0, #0, lsl #32
00004084cd88: 0000e0f2  movk     x0, #0, lsl #48
00004084cd8c: e10b0032  mov      w1, #7
00004084cd90: ab13ff97  bl       #0x40811c3c
00004084cd94: e803002a  mov      w8, w0
00004084cd98: e97b0032  mov      w9, #0x7fffffff
00004084cd9c: 1f01096b  cmp      w8, w9
00004084cda0: 61000054  b.ne     #0x4084cdac
00004084cda4: 80038452  mov      w0, #0x201c
00004084cda8: 0b000014  b        #0x4084cdd4
00004084cdac: 40d38052  mov      w0, #0x69a
00004084cdb0: 00c0a072  movk     w0, #0x600, lsl #16
00004084cdb4: e103082a  mov      w1, w8
00004084cdb8: 84270094  bl       #0x40856bc8
00004084cdbc: 803e40b9  ldr      w0, [x20, #0x3c]
00004084cdc0: e30313aa  mov      x3, x19
00004084cdc4: 812640f9  ldr      x1, [x20, #0x48]
00004084cdc8: 825240b9  ldr      w2, [x20, #0x50]
00004084cdcc: ae2eec97  bl       #0x40358884
00004084cdd0: 20008452  mov      w0, #0x2001
00004084cdd4: f37b41a9  ldp      x19, x30, [sp, #0x10]
00004084cdd8: f40742f8  ldr      x20, [sp], #0x20
00004084cddc: c0035fd6  ret
; lookup
000040811c3c: f37bbfa9  stp      x19, x30, [sp, #-0x10]!
000040811c40: 03008012  mov      w3, #-1
000040811c44: f30300aa  mov      x19, x0
000040811c48: 4919ed97  bl       #0x4035816c
000040811c4c: 1f040031  cmn      w0, #1
000040811c50: 80000054  b.eq     #0x40811c60
000040811c54: 684e208b  add      x8, x19, w0, uxtw #3
000040811c58: 000540b9  ldr      w0, [x8, #4]
000040811c5c: 02000014  b        #0x40811c64
000040811c60: e07b0032  mov      w0, #0x7fffffff
000040811c64: f37bc1a8  ldp      x19, x30, [sp], #0x10
000040811c68: c0035fd6  ret
; search
00004035816c: 61010034  cbz      w1, #0x40358198
000040358170: e8031f2a  mov      w8, wzr
000040358174: 090040b9  ldr      w9, [x0]
000040358178: 3f01026b  cmp      w9, w2
00004035817c: c0000054  b.eq     #0x40358194
000040358180: 08050011  add      w8, w8, #1
000040358184: 00200091  add      x0, x0, #8
000040358188: 1f01016b  cmp      w8, w1
00004035818c: 43ffff54  b.lo     #0x40358174
000040358190: 02000014  b        #0x40358198
000040358194: e303082a  mov      w3, w8
000040358198: e003032a  mov      w0, w3
00004035819c: c0035fd6  ret
; descriptor_builder
00004084cc2c: ff8302d1  sub      sp, sp, #0xa0
00004084cc30: f83300f9  str      x24, [sp, #0x60]
00004084cc34: f75b07a9  stp      x23, x22, [sp, #0x70]
00004084cc38: f55308a9  stp      x21, x20, [sp, #0x80]
00004084cc3c: f37b09a9  stp      x19, x30, [sp, #0x90]
00004084cc40: f40301aa  mov      x20, x1
00004084cc44: 81b789d2  mov      x1, #0x4dbc
00004084cc48: e181a8f2  movk     x1, #0x440f, lsl #16
00004084cc4c: 0100c0f2  movk     x1, #0, lsl #32
00004084cc50: f30302aa  mov      x19, x2
00004084cc54: f50300aa  mov      x21, x0
00004084cc58: 0100e0f2  movk     x1, #0, lsl #48
00004084cc5c: e0130191  add      x0, sp, #0x44
00004084cc60: e20b1e32  mov      w2, #0x1c
00004084cc64: f7130191  add      x23, sp, #0x44
00004084cc68: c6b62894  bl       #0x4127a780
00004084cc6c: ff7f03a9  stp      xzr, xzr, [sp, #0x30]
00004084cc70: e00315aa  mov      x0, x21
00004084cc74: a80240b9  ldr      w8, [x21]
00004084cc78: ea230091  add      x10, sp, #8
00004084cc7c: a93e40b9  ldr      w9, [x21, #0x3c]
00004084cc80: 56610091  add      x22, x10, #0x18
00004084cc84: ff7f02a9  stp      xzr, xzr, [sp, #0x20]
00004084cc88: e8270129  stp      w8, w9, [sp, #8]
00004084cc8c: dc17ff97  bl       #0x40812bfc
00004084cc90: e8031f32  mov      w8, #2
00004084cc94: c1128bd2  mov      x1, #0x5896
00004084cc98: e181a8f2  movk     x1, #0x440f, lsl #16
00004084cc9c: e0230229  stp      w0, w8, [sp, #0x10]
00004084cca0: 40d38052  mov      w0, #0x69a
00004084cca4: 0100c0f2  movk     x1, #0, lsl #32
00004084cca8: 00c0a072  movk     w0, #0x600, lsl #16
00004084ccac: 0100e0f2  movk     x1, #0, lsl #48
00004084ccb0: 62308052  mov      w2, #0x183
00004084ccb4: a0181f94  bl       #0x41012f34
00004084ccb8: e203002a  mov      w2, w0
00004084ccbc: 80b089d2  mov      x0, #0x4d84
00004084ccc0: e081a8f2  movk     x0, #0x440f, lsl #16
00004084ccc4: 0000c0f2  movk     x0, #0, lsl #32
00004084ccc8: 0000e0f2  movk     x0, #0, lsl #48
00004084cccc: e10b0032  mov      w1, #7
00004084ccd0: f80b0032  mov      w24, #7
00004084ccd4: e613ff97  bl       #0x40811c6c
00004084ccd8: a84640f9  ldr      x8, [x21, #0x88]
00004084ccdc: 091c0012  and      w9, w0, #0xff
00004084cce0: e2031d32  mov      w2, #8
00004084cce4: e00315aa  mov      x0, x21
00004084cce8: e10316aa  mov      x1, x22
00004084ccec: e90f00f9  str      x9, [sp, #0x18]
00004084ccf0: 00013fd6  blr      x8
00004084ccf4: e2230091  add      x2, sp, #8
00004084ccf8: f8670079  strh     w24, [sp, #0x32]
00004084ccfc: e00314aa  mov      x0, x20
00004084cd00: f71f00f9  str      x23, [sp, #0x38]
00004084cd04: e10313aa  mov      x1, x19
00004084cd08: d119ff97  bl       #0x4081344c
00004084cd0c: f37b49a9  ldp      x19, x30, [sp, #0x90]
00004084cd10: f55348a9  ldp      x21, x20, [sp, #0x80]
00004084cd14: f75b47a9  ldp      x23, x22, [sp, #0x70]
00004084cd18: f83340f9  ldr      x24, [sp, #0x60]
00004084cd1c: 20008452  mov      w0, #0x2001
00004084cd20: ff830291  add      sp, sp, #0xa0
00004084cd24: c0035fd6  ret

; Z8 3.10 property 0x1d006, names are analytical
; setter
00004084d040: f40f1ef8  str      x20, [sp, #-0x20]!
00004084d044: f37b01a9  stp      x19, x30, [sp, #0x10]
00004084d048: f40300aa  mov      x20, x0
00004084d04c: f30301aa  mov      x19, x1
00004084d050: e1330091  add      x1, sp, #0xc
00004084d054: 803e40b9  ldr      w0, [x20, #0x3c]
00004084d058: e2030032  mov      w2, #1
00004084d05c: e30313aa  mov      x3, x19
00004084d060: 092eec97  bl       #0x40358884
00004084d064: 00bb89d2  mov      x0, #0x4dd8
00004084d068: e2334039  ldrb     w2, [sp, #0xc]
00004084d06c: e081a8f2  movk     x0, #0x440f, lsl #16
00004084d070: 0000c0f2  movk     x0, #0, lsl #32
00004084d074: 0000e0f2  movk     x0, #0, lsl #48
00004084d078: e10b0032  mov      w1, #7
00004084d07c: f012ff97  bl       #0x40811c3c
00004084d080: e803002a  mov      w8, w0
00004084d084: e97b0032  mov      w9, #0x7fffffff
00004084d088: 1f01096b  cmp      w8, w9
00004084d08c: 61000054  b.ne     #0x4084d098
00004084d090: 80038452  mov      w0, #0x201c
00004084d094: 0b000014  b        #0x4084d0c0
00004084d098: 804a8252  mov      w0, #0x1254
00004084d09c: 00c0a072  movk     w0, #0x600, lsl #16
00004084d0a0: e103082a  mov      w1, w8
00004084d0a4: c9260094  bl       #0x40856bc8
00004084d0a8: 803e40b9  ldr      w0, [x20, #0x3c]
00004084d0ac: e30313aa  mov      x3, x19
00004084d0b0: 812640f9  ldr      x1, [x20, #0x48]
00004084d0b4: 825240b9  ldr      w2, [x20, #0x50]
00004084d0b8: f32dec97  bl       #0x40358884
00004084d0bc: 20008452  mov      w0, #0x2001
00004084d0c0: f37b41a9  ldp      x19, x30, [sp, #0x10]
00004084d0c4: f40742f8  ldr      x20, [sp], #0x20
00004084d0c8: c0035fd6  ret
; lookup
000040811c3c: f37bbfa9  stp      x19, x30, [sp, #-0x10]!
000040811c40: 03008012  mov      w3, #-1
000040811c44: f30300aa  mov      x19, x0
000040811c48: 4919ed97  bl       #0x4035816c
000040811c4c: 1f040031  cmn      w0, #1
000040811c50: 80000054  b.eq     #0x40811c60
000040811c54: 684e208b  add      x8, x19, w0, uxtw #3
000040811c58: 000540b9  ldr      w0, [x8, #4]
000040811c5c: 02000014  b        #0x40811c64
000040811c60: e07b0032  mov      w0, #0x7fffffff
000040811c64: f37bc1a8  ldp      x19, x30, [sp], #0x10
000040811c68: c0035fd6  ret
; search
00004035816c: 61010034  cbz      w1, #0x40358198
000040358170: e8031f2a  mov      w8, wzr
000040358174: 090040b9  ldr      w9, [x0]
000040358178: 3f01026b  cmp      w9, w2
00004035817c: c0000054  b.eq     #0x40358194
000040358180: 08050011  add      w8, w8, #1
000040358184: 00200091  add      x0, x0, #8
000040358188: 1f01016b  cmp      w8, w1
00004035818c: 43ffff54  b.lo     #0x40358174
000040358190: 02000014  b        #0x40358198
000040358194: e303082a  mov      w3, w8
000040358198: e003032a  mov      w0, w3
00004035819c: c0035fd6  ret
; descriptor_builder
00004084cf18: ff8302d1  sub      sp, sp, #0xa0
00004084cf1c: f83300f9  str      x24, [sp, #0x60]
00004084cf20: f75b07a9  stp      x23, x22, [sp, #0x70]
00004084cf24: f55308a9  stp      x21, x20, [sp, #0x80]
00004084cf28: f37b09a9  stp      x19, x30, [sp, #0x90]
00004084cf2c: f40301aa  mov      x20, x1
00004084cf30: 81b789d2  mov      x1, #0x4dbc
00004084cf34: e181a8f2  movk     x1, #0x440f, lsl #16
00004084cf38: 0100c0f2  movk     x1, #0, lsl #32
00004084cf3c: f30302aa  mov      x19, x2
00004084cf40: f50300aa  mov      x21, x0
00004084cf44: 0100e0f2  movk     x1, #0, lsl #48
00004084cf48: e0130191  add      x0, sp, #0x44
00004084cf4c: e20b1e32  mov      w2, #0x1c
00004084cf50: f7130191  add      x23, sp, #0x44
00004084cf54: 0bb62894  bl       #0x4127a780
00004084cf58: ff7f03a9  stp      xzr, xzr, [sp, #0x30]
00004084cf5c: e00315aa  mov      x0, x21
00004084cf60: a80240b9  ldr      w8, [x21]
00004084cf64: ea230091  add      x10, sp, #8
00004084cf68: a93e40b9  ldr      w9, [x21, #0x3c]
00004084cf6c: 56610091  add      x22, x10, #0x18
00004084cf70: ff7f02a9  stp      xzr, xzr, [sp, #0x20]
00004084cf74: e8270129  stp      w8, w9, [sp, #8]
00004084cf78: 2117ff97  bl       #0x40812bfc
00004084cf7c: e8031f32  mov      w8, #2
00004084cf80: c1128bd2  mov      x1, #0x5896
00004084cf84: e181a8f2  movk     x1, #0x440f, lsl #16
00004084cf88: e0230229  stp      w0, w8, [sp, #0x10]
00004084cf8c: 804a8252  mov      w0, #0x1254
00004084cf90: 0100c0f2  movk     x1, #0, lsl #32
00004084cf94: 00c0a072  movk     w0, #0x600, lsl #16
00004084cf98: 0100e0f2  movk     x1, #0, lsl #48
00004084cf9c: a2478052  mov      w2, #0x23d
00004084cfa0: e5171f94  bl       #0x41012f34
00004084cfa4: e203002a  mov      w2, w0
00004084cfa8: 00bb89d2  mov      x0, #0x4dd8
00004084cfac: e081a8f2  movk     x0, #0x440f, lsl #16
00004084cfb0: 0000c0f2  movk     x0, #0, lsl #32
00004084cfb4: 0000e0f2  movk     x0, #0, lsl #48
00004084cfb8: e10b0032  mov      w1, #7
00004084cfbc: f80b0032  mov      w24, #7
00004084cfc0: 2b13ff97  bl       #0x40811c6c
00004084cfc4: a84640f9  ldr      x8, [x21, #0x88]
00004084cfc8: 091c0012  and      w9, w0, #0xff
00004084cfcc: e2031d32  mov      w2, #8
00004084cfd0: e00315aa  mov      x0, x21
00004084cfd4: e10316aa  mov      x1, x22
00004084cfd8: e90f00f9  str      x9, [sp, #0x18]
00004084cfdc: 00013fd6  blr      x8
00004084cfe0: e2230091  add      x2, sp, #8
00004084cfe4: f8670079  strh     w24, [sp, #0x32]
00004084cfe8: e00314aa  mov      x0, x20
00004084cfec: f71f00f9  str      x23, [sp, #0x38]
00004084cff0: e10313aa  mov      x1, x19
00004084cff4: 1619ff97  bl       #0x4081344c
00004084cff8: f37b49a9  ldp      x19, x30, [sp, #0x90]
00004084cffc: f55348a9  ldp      x21, x20, [sp, #0x80]
00004084d000: f75b47a9  ldp      x23, x22, [sp, #0x70]
00004084d004: f83340f9  ldr      x24, [sp, #0x60]
00004084d008: 20008452  mov      w0, #0x2001
00004084d00c: ff830291  add      sp, sp, #0xa0
00004084d010: c0035fd6  ret

; Z8 3.11 property 0x1d005, names are analytical
; setter
00004084cd58: f40f1ef8  str      x20, [sp, #-0x20]!
00004084cd5c: f37b01a9  stp      x19, x30, [sp, #0x10]
00004084cd60: f40300aa  mov      x20, x0
00004084cd64: f30301aa  mov      x19, x1
00004084cd68: e1330091  add      x1, sp, #0xc
00004084cd6c: 803e40b9  ldr      w0, [x20, #0x3c]
00004084cd70: e2030032  mov      w2, #1
00004084cd74: e30313aa  mov      x3, x19
00004084cd78: c32eec97  bl       #0x40358884
00004084cd7c: 80b089d2  mov      x0, #0x4d84
00004084cd80: e2334039  ldrb     w2, [sp, #0xc]
00004084cd84: e081a8f2  movk     x0, #0x440f, lsl #16
00004084cd88: 0000c0f2  movk     x0, #0, lsl #32
00004084cd8c: 0000e0f2  movk     x0, #0, lsl #48
00004084cd90: e10b0032  mov      w1, #7
00004084cd94: ab13ff97  bl       #0x40811c40
00004084cd98: e803002a  mov      w8, w0
00004084cd9c: e97b0032  mov      w9, #0x7fffffff
00004084cda0: 1f01096b  cmp      w8, w9
00004084cda4: 61000054  b.ne     #0x4084cdb0
00004084cda8: 80038452  mov      w0, #0x201c
00004084cdac: 0b000014  b        #0x4084cdd8
00004084cdb0: 40d38052  mov      w0, #0x69a
00004084cdb4: 00c0a072  movk     w0, #0x600, lsl #16
00004084cdb8: e103082a  mov      w1, w8
00004084cdbc: 84270094  bl       #0x40856bcc
00004084cdc0: 803e40b9  ldr      w0, [x20, #0x3c]
00004084cdc4: e30313aa  mov      x3, x19
00004084cdc8: 812640f9  ldr      x1, [x20, #0x48]
00004084cdcc: 825240b9  ldr      w2, [x20, #0x50]
00004084cdd0: ad2eec97  bl       #0x40358884
00004084cdd4: 20008452  mov      w0, #0x2001
00004084cdd8: f37b41a9  ldp      x19, x30, [sp, #0x10]
00004084cddc: f40742f8  ldr      x20, [sp], #0x20
00004084cde0: c0035fd6  ret
; lookup
000040811c40: f37bbfa9  stp      x19, x30, [sp, #-0x10]!
000040811c44: 03008012  mov      w3, #-1
000040811c48: f30300aa  mov      x19, x0
000040811c4c: 4819ed97  bl       #0x4035816c
000040811c50: 1f040031  cmn      w0, #1
000040811c54: 80000054  b.eq     #0x40811c64
000040811c58: 684e208b  add      x8, x19, w0, uxtw #3
000040811c5c: 000540b9  ldr      w0, [x8, #4]
000040811c60: 02000014  b        #0x40811c68
000040811c64: e07b0032  mov      w0, #0x7fffffff
000040811c68: f37bc1a8  ldp      x19, x30, [sp], #0x10
000040811c6c: c0035fd6  ret
; search
00004035816c: 61010034  cbz      w1, #0x40358198
000040358170: e8031f2a  mov      w8, wzr
000040358174: 090040b9  ldr      w9, [x0]
000040358178: 3f01026b  cmp      w9, w2
00004035817c: c0000054  b.eq     #0x40358194
000040358180: 08050011  add      w8, w8, #1
000040358184: 00200091  add      x0, x0, #8
000040358188: 1f01016b  cmp      w8, w1
00004035818c: 43ffff54  b.lo     #0x40358174
000040358190: 02000014  b        #0x40358198
000040358194: e303082a  mov      w3, w8
000040358198: e003032a  mov      w0, w3
00004035819c: c0035fd6  ret
; descriptor_builder
00004084cc30: ff8302d1  sub      sp, sp, #0xa0
00004084cc34: f83300f9  str      x24, [sp, #0x60]
00004084cc38: f75b07a9  stp      x23, x22, [sp, #0x70]
00004084cc3c: f55308a9  stp      x21, x20, [sp, #0x80]
00004084cc40: f37b09a9  stp      x19, x30, [sp, #0x90]
00004084cc44: f40301aa  mov      x20, x1
00004084cc48: 81b789d2  mov      x1, #0x4dbc
00004084cc4c: e181a8f2  movk     x1, #0x440f, lsl #16
00004084cc50: 0100c0f2  movk     x1, #0, lsl #32
00004084cc54: f30302aa  mov      x19, x2
00004084cc58: f50300aa  mov      x21, x0
00004084cc5c: 0100e0f2  movk     x1, #0, lsl #48
00004084cc60: e0130191  add      x0, sp, #0x44
00004084cc64: e20b1e32  mov      w2, #0x1c
00004084cc68: f7130191  add      x23, sp, #0x44
00004084cc6c: 25b72894  bl       #0x4127a900
00004084cc70: ff7f03a9  stp      xzr, xzr, [sp, #0x30]
00004084cc74: e00315aa  mov      x0, x21
00004084cc78: a80240b9  ldr      w8, [x21]
00004084cc7c: ea230091  add      x10, sp, #8
00004084cc80: a93e40b9  ldr      w9, [x21, #0x3c]
00004084cc84: 56610091  add      x22, x10, #0x18
00004084cc88: ff7f02a9  stp      xzr, xzr, [sp, #0x20]
00004084cc8c: e8270129  stp      w8, w9, [sp, #8]
00004084cc90: dc17ff97  bl       #0x40812c00
00004084cc94: e8031f32  mov      w8, #2
00004084cc98: c1128bd2  mov      x1, #0x5896
00004084cc9c: e181a8f2  movk     x1, #0x440f, lsl #16
00004084cca0: e0230229  stp      w0, w8, [sp, #0x10]
00004084cca4: 40d38052  mov      w0, #0x69a
00004084cca8: 0100c0f2  movk     x1, #0, lsl #32
00004084ccac: 00c0a072  movk     w0, #0x600, lsl #16
00004084ccb0: 0100e0f2  movk     x1, #0, lsl #48
00004084ccb4: 62308052  mov      w2, #0x183
00004084ccb8: a7181f94  bl       #0x41012f54
00004084ccbc: e203002a  mov      w2, w0
00004084ccc0: 80b089d2  mov      x0, #0x4d84
00004084ccc4: e081a8f2  movk     x0, #0x440f, lsl #16
00004084ccc8: 0000c0f2  movk     x0, #0, lsl #32
00004084cccc: 0000e0f2  movk     x0, #0, lsl #48
00004084ccd0: e10b0032  mov      w1, #7
00004084ccd4: f80b0032  mov      w24, #7
00004084ccd8: e613ff97  bl       #0x40811c70
00004084ccdc: a84640f9  ldr      x8, [x21, #0x88]
00004084cce0: 091c0012  and      w9, w0, #0xff
00004084cce4: e2031d32  mov      w2, #8
00004084cce8: e00315aa  mov      x0, x21
00004084ccec: e10316aa  mov      x1, x22
00004084ccf0: e90f00f9  str      x9, [sp, #0x18]
00004084ccf4: 00013fd6  blr      x8
00004084ccf8: e2230091  add      x2, sp, #8
00004084ccfc: f8670079  strh     w24, [sp, #0x32]
00004084cd00: e00314aa  mov      x0, x20
00004084cd04: f71f00f9  str      x23, [sp, #0x38]
00004084cd08: e10313aa  mov      x1, x19
00004084cd0c: d119ff97  bl       #0x40813450
00004084cd10: f37b49a9  ldp      x19, x30, [sp, #0x90]
00004084cd14: f55348a9  ldp      x21, x20, [sp, #0x80]
00004084cd18: f75b47a9  ldp      x23, x22, [sp, #0x70]
00004084cd1c: f83340f9  ldr      x24, [sp, #0x60]
00004084cd20: 20008452  mov      w0, #0x2001
00004084cd24: ff830291  add      sp, sp, #0xa0
00004084cd28: c0035fd6  ret

; Z8 3.11 property 0x1d006, names are analytical
; setter
00004084d044: f40f1ef8  str      x20, [sp, #-0x20]!
00004084d048: f37b01a9  stp      x19, x30, [sp, #0x10]
00004084d04c: f40300aa  mov      x20, x0
00004084d050: f30301aa  mov      x19, x1
00004084d054: e1330091  add      x1, sp, #0xc
00004084d058: 803e40b9  ldr      w0, [x20, #0x3c]
00004084d05c: e2030032  mov      w2, #1
00004084d060: e30313aa  mov      x3, x19
00004084d064: 082eec97  bl       #0x40358884
00004084d068: 00bb89d2  mov      x0, #0x4dd8
00004084d06c: e2334039  ldrb     w2, [sp, #0xc]
00004084d070: e081a8f2  movk     x0, #0x440f, lsl #16
00004084d074: 0000c0f2  movk     x0, #0, lsl #32
00004084d078: 0000e0f2  movk     x0, #0, lsl #48
00004084d07c: e10b0032  mov      w1, #7
00004084d080: f012ff97  bl       #0x40811c40
00004084d084: e803002a  mov      w8, w0
00004084d088: e97b0032  mov      w9, #0x7fffffff
00004084d08c: 1f01096b  cmp      w8, w9
00004084d090: 61000054  b.ne     #0x4084d09c
00004084d094: 80038452  mov      w0, #0x201c
00004084d098: 0b000014  b        #0x4084d0c4
00004084d09c: 804a8252  mov      w0, #0x1254
00004084d0a0: 00c0a072  movk     w0, #0x600, lsl #16
00004084d0a4: e103082a  mov      w1, w8
00004084d0a8: c9260094  bl       #0x40856bcc
00004084d0ac: 803e40b9  ldr      w0, [x20, #0x3c]
00004084d0b0: e30313aa  mov      x3, x19
00004084d0b4: 812640f9  ldr      x1, [x20, #0x48]
00004084d0b8: 825240b9  ldr      w2, [x20, #0x50]
00004084d0bc: f22dec97  bl       #0x40358884
00004084d0c0: 20008452  mov      w0, #0x2001
00004084d0c4: f37b41a9  ldp      x19, x30, [sp, #0x10]
00004084d0c8: f40742f8  ldr      x20, [sp], #0x20
00004084d0cc: c0035fd6  ret
; lookup
000040811c40: f37bbfa9  stp      x19, x30, [sp, #-0x10]!
000040811c44: 03008012  mov      w3, #-1
000040811c48: f30300aa  mov      x19, x0
000040811c4c: 4819ed97  bl       #0x4035816c
000040811c50: 1f040031  cmn      w0, #1
000040811c54: 80000054  b.eq     #0x40811c64
000040811c58: 684e208b  add      x8, x19, w0, uxtw #3
000040811c5c: 000540b9  ldr      w0, [x8, #4]
000040811c60: 02000014  b        #0x40811c68
000040811c64: e07b0032  mov      w0, #0x7fffffff
000040811c68: f37bc1a8  ldp      x19, x30, [sp], #0x10
000040811c6c: c0035fd6  ret
; search
00004035816c: 61010034  cbz      w1, #0x40358198
000040358170: e8031f2a  mov      w8, wzr
000040358174: 090040b9  ldr      w9, [x0]
000040358178: 3f01026b  cmp      w9, w2
00004035817c: c0000054  b.eq     #0x40358194
000040358180: 08050011  add      w8, w8, #1
000040358184: 00200091  add      x0, x0, #8
000040358188: 1f01016b  cmp      w8, w1
00004035818c: 43ffff54  b.lo     #0x40358174
000040358190: 02000014  b        #0x40358198
000040358194: e303082a  mov      w3, w8
000040358198: e003032a  mov      w0, w3
00004035819c: c0035fd6  ret
; descriptor_builder
00004084cf1c: ff8302d1  sub      sp, sp, #0xa0
00004084cf20: f83300f9  str      x24, [sp, #0x60]
00004084cf24: f75b07a9  stp      x23, x22, [sp, #0x70]
00004084cf28: f55308a9  stp      x21, x20, [sp, #0x80]
00004084cf2c: f37b09a9  stp      x19, x30, [sp, #0x90]
00004084cf30: f40301aa  mov      x20, x1
00004084cf34: 81b789d2  mov      x1, #0x4dbc
00004084cf38: e181a8f2  movk     x1, #0x440f, lsl #16
00004084cf3c: 0100c0f2  movk     x1, #0, lsl #32
00004084cf40: f30302aa  mov      x19, x2
00004084cf44: f50300aa  mov      x21, x0
00004084cf48: 0100e0f2  movk     x1, #0, lsl #48
00004084cf4c: e0130191  add      x0, sp, #0x44
00004084cf50: e20b1e32  mov      w2, #0x1c
00004084cf54: f7130191  add      x23, sp, #0x44
00004084cf58: 6ab62894  bl       #0x4127a900
00004084cf5c: ff7f03a9  stp      xzr, xzr, [sp, #0x30]
00004084cf60: e00315aa  mov      x0, x21
00004084cf64: a80240b9  ldr      w8, [x21]
00004084cf68: ea230091  add      x10, sp, #8
00004084cf6c: a93e40b9  ldr      w9, [x21, #0x3c]
00004084cf70: 56610091  add      x22, x10, #0x18
00004084cf74: ff7f02a9  stp      xzr, xzr, [sp, #0x20]
00004084cf78: e8270129  stp      w8, w9, [sp, #8]
00004084cf7c: 2117ff97  bl       #0x40812c00
00004084cf80: e8031f32  mov      w8, #2
00004084cf84: c1128bd2  mov      x1, #0x5896
00004084cf88: e181a8f2  movk     x1, #0x440f, lsl #16
00004084cf8c: e0230229  stp      w0, w8, [sp, #0x10]
00004084cf90: 804a8252  mov      w0, #0x1254
00004084cf94: 0100c0f2  movk     x1, #0, lsl #32
00004084cf98: 00c0a072  movk     w0, #0x600, lsl #16
00004084cf9c: 0100e0f2  movk     x1, #0, lsl #48
00004084cfa0: a2478052  mov      w2, #0x23d
00004084cfa4: ec171f94  bl       #0x41012f54
00004084cfa8: e203002a  mov      w2, w0
00004084cfac: 00bb89d2  mov      x0, #0x4dd8
00004084cfb0: e081a8f2  movk     x0, #0x440f, lsl #16
00004084cfb4: 0000c0f2  movk     x0, #0, lsl #32
00004084cfb8: 0000e0f2  movk     x0, #0, lsl #48
00004084cfbc: e10b0032  mov      w1, #7
00004084cfc0: f80b0032  mov      w24, #7
00004084cfc4: 2b13ff97  bl       #0x40811c70
00004084cfc8: a84640f9  ldr      x8, [x21, #0x88]
00004084cfcc: 091c0012  and      w9, w0, #0xff
00004084cfd0: e2031d32  mov      w2, #8
00004084cfd4: e00315aa  mov      x0, x21
00004084cfd8: e10316aa  mov      x1, x22
00004084cfdc: e90f00f9  str      x9, [sp, #0x18]
00004084cfe0: 00013fd6  blr      x8
00004084cfe4: e2230091  add      x2, sp, #8
00004084cfe8: f8670079  strh     w24, [sp, #0x32]
00004084cfec: e00314aa  mov      x0, x20
00004084cff0: f71f00f9  str      x23, [sp, #0x38]
00004084cff4: e10313aa  mov      x1, x19
00004084cff8: 1619ff97  bl       #0x40813450
00004084cffc: f37b49a9  ldp      x19, x30, [sp, #0x90]
00004084d000: f55348a9  ldp      x21, x20, [sp, #0x80]
00004084d004: f75b47a9  ldp      x23, x22, [sp, #0x70]
00004084d008: f83340f9  ldr      x24, [sp, #0x60]
00004084d00c: 20008452  mov      w0, #0x2001
00004084d010: ff830291  add      sp, sp, #0xa0
00004084d014: c0035fd6  ret

; Z8 3.11 brightness_subject_setting_excerpt, NOT a complete function
000040da41b4: 88020034  cbz      w8, #0x40da4204
000040da41b8: 97958dd2  mov      x23, #0x6cac
000040da41bc: d753a0f2  movk     x23, #0x29e, lsl #16
000040da41c0: 48d38052  mov      w8, #0x69a
000040da41c4: 5701c0f2  movk     x23, #0xa, lsl #32
000040da41c8: 08c0a072  movk     w8, #0x600, lsl #16
000040da41cc: 1700e0f2  movk     x23, #0, lsl #48
000040da41d0: 00e92e11  add      w0, w8, #0xbba
000040da41d4: 42328052  mov      w2, #0x192
000040da41d8: e10317aa  mov      x1, x23
000040da41dc: aaba0994  bl       #0x41012c84
000040da41e0: f503002a  mov      w21, w0
000040da41e4: a0328452  mov      w0, #0x2195
000040da41e8: 62328052  mov      w2, #0x193
000040da41ec: e10317aa  mov      x1, x23
000040da41f0: a5ba0994  bl       #0x41012c84
000040da41f4: f603002a  mov      w22, w0
000040da41f8: 40328452  mov      w0, #0x2192
000040da41fc: 82328052  mov      w2, #0x194
000040da4200: 12000014  b        #0x40da4248
000040da4204: 97958dd2  mov      x23, #0x6cac
000040da4208: d753a0f2  movk     x23, #0x29e, lsl #16
000040da420c: 5701c0f2  movk     x23, #0xa, lsl #32
000040da4210: 40d38052  mov      w0, #0x69a
000040da4214: 1700e0f2  movk     x23, #0, lsl #48
000040da4218: 00c0a072  movk     w0, #0x600, lsl #16
000040da421c: 62318052  mov      w2, #0x18b
000040da4220: e10317aa  mov      x1, x23
000040da4224: 98ba0994  bl       #0x41012c84
000040da4228: f503002a  mov      w21, w0
000040da422c: 202d8452  mov      w0, #0x2169
000040da4230: 82318052  mov      w2, #0x18c
000040da4234: e10317aa  mov      x1, x23
000040da4238: 93ba0994  bl       #0x41012c84
000040da423c: f603002a  mov      w22, w0
000040da4240: a0248452  mov      w0, #0x2125
000040da4244: a2318052  mov      w2, #0x18d
000040da4248: e10317aa  mov      x1, x23
000040da424c: 8eba0994  bl       #0x41012c84
000040da4250: 880240f9  ldr      x8, [x20]
000040da4254: 08f144f9  ldr      x8, [x8, #0x9e0]
000040da4258: 09055bb9  ldr      w9, [x8, #0x1b04]
000040da425c: 0a410e91  add      x10, x8, #0x390
000040da4260: f5db1229  stp      w21, w22, [sp, #0x94]
000040da4264: e0a700b9  str      w0, [sp, #0xa4]
000040da4268: e0e30291  add      x0, sp, #0xb8
000040da426c: 0b8943b9  ldr      w11, [x8, #0x388]
000040da4270: 3f010071  cmp      w9, #0
000040da4274: 09d10e91  add      x9, x8, #0x3b4
000040da4278: 29018a9a  csel     x9, x9, x10, eq

; Z8 3.11 capability_movie_setting_excerpt, NOT a complete function
000040f3ead4: 01d682d2  mov      x1, #0x16b0
000040f3ead8: 08208252  mov      w8, #0x1100
000040f3eadc: c154a0f2  movk     x1, #0x2a6, lsl #16
000040f3eae0: 08c0a072  movk     w8, #0x600, lsl #16
000040f3eae4: 4101c0f2  movk     x1, #0xa, lsl #32
000040f3eae8: 00510511  add      w0, w8, #0x154
000040f3eaec: 0100e0f2  movk     x1, #0, lsl #48
000040f3eaf0: e2268152  mov      w2, #0x937
000040f3eaf4: 64500394  bl       #0x41012c84
000040f3eaf8: 606604b9  str      w0, [x19, #0x464]
000040f3eafc: 39120014  b        #0x40f433e0
