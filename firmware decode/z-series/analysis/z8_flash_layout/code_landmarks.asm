
; eg_update_target_initialization [0x41023014, 0x41023034); SHA-256 a0e5425b4c9e19848fe3972ce6a83410e9165670efc18bd1eca7c31e16a322b5
041023014 f37bbfa9 stp      x19, x30, [sp, #-0x10]!
041023018 01b591d2 mov      x1, #0x8da8
04102301c 217ca0f2 movk     x1, #0x3e1, lsl #16
041023020 4101c0f2 movk     x1, #0xa, lsl #32
041023024 0100e0f2 movk     x1, #0, lsl #48
041023028 e0031f32 mov      w0, #2
04102302c 0d21f597 bl       #0x40d6b460
041023030 20020036 tbz      w0, #0, #0x41023074

; eg_device_update [0x41026598, 0x4102667c); SHA-256 b019d1381a82d2ffff8aa0d1631f43e6e54685738d010d2761257e25bfc1a30d
041026598 ff0302d1 sub      sp, sp, #0x80
04102659c ffe303a9 stp      xzr, x24, [sp, #0x38]
0410265a0 f75b05a9 stp      x23, x22, [sp, #0x50]
0410265a4 f55306a9 stp      x21, x20, [sp, #0x60]
0410265a8 f37b07a9 stp      x19, x30, [sp, #0x70]
0410265ac f30300aa mov      x19, x0
0410265b0 ffff02a9 stp      xzr, xzr, [sp, #0x28]
0410265b4 00198052 mov      w0, #0xc8
0410265b8 ff1300f9 str      xzr, [sp, #0x20]
0410265bc f40303aa mov      x20, x3
0410265c0 f503022a mov      w21, w2
0410265c4 f603012a mov      w22, w1
0410265c8 231cf497 bl       #0x40d2d654
0410265cc a0008052 mov      w0, #5
0410265d0 e1031f2a mov      w1, wzr
0410265d4 e2031f2a mov      w2, wzr
0410265d8 e3031f2a mov      w3, wzr
0410265dc 87faff97 bl       #0x41024ff8
0410265e0 e0031f32 mov      w0, #2
0410265e4 e1830091 add      x1, sp, #0x20
0410265e8 f7031f32 mov      w23, #2
0410265ec 9d13f597 bl       #0x40d6b460
0410265f0 80030036 tbz      w0, #0, #0x41026660
0410265f4 f83b40b9 ldr      w24, [sp, #0x38]
0410265f8 7f0640f2 tst      x19, #3
0410265fc e0000054 b.eq     #0x41026618
041026600 77f67e92 and      x23, x19, #0xfffffffffffffffc
041026604 e203162a mov      w2, w22
041026608 e00317aa mov      x0, x23
04102660c e10313aa mov      x1, x19
041026610 1c510994 bl       #0x4127aa80
041026614 f30317aa mov      x19, x23
041026618 f703162a mov      w23, w22
04102661c 0203166b subs     w2, w24, w22
041026620 89000054 b.ls     #0x41026630
041026624 6002178b add      x0, x19, x23
041026628 e11f0032 mov      w1, #0xff
04102662c 45510994 bl       #0x4127ab40
041026630 e2230091 add      x2, sp, #8
041026634 f50b00b9 str      w21, [sp, #8]
041026638 e00313aa mov      x0, x19
04102663c f47f01a9 stp      x20, xzr, [sp, #0x10]
041026640 e10317aa mov      x1, x23
041026644 c76bef97 bl       #0x40c01560
041026648 357a0594 bl       #0x41184f1c
04102664c 007d8052 mov      w0, #0x3e8
041026650 011cf497 bl       #0x40d2d654
041026654 276cef97 bl       #0x40c016f0
041026658 9602f297 bl       #0x40ca70b0
04102665c f7031f2a mov      w23, wzr
041026660 e003172a mov      w0, w23
041026664 f82340f9 ldr      x24, [sp, #0x40]
041026668 f37b47a9 ldp      x19, x30, [sp, #0x70]
04102666c f55346a9 ldp      x21, x20, [sp, #0x60]
041026670 f75b45a9 ldp      x23, x22, [sp, #0x50]
041026674 ff030291 add      sp, sp, #0x80
041026678 c0035fd6 ret

; resource_info [0x40d6b460, 0x40d6b4e0); SHA-256 176b3075959c54636e5dca310f8b75bd2a4189a205ebd394b4f74ea252882a1f
040d6b460 ff4301d1 sub      sp, sp, #0x50
040d6b464 f41b00f9 str      x20, [sp, #0x30]
040d6b468 f37b04a9 stp      x19, x30, [sp, #0x40]
040d6b46c f30301aa mov      x19, x1
040d6b470 f403002a mov      w20, w0
040d6b474 9f720171 cmp      w20, #0x5c
040d6b478 a8020054 b.hi     #0x40d6b4cc
040d6b47c e003142a mov      w0, w20
040d6b480 92170094 bl       #0x40d712c8
040d6b484 600200b4 cbz      x0, #0x40d6b4d0
040d6b488 080440f9 ldr      x8, [x0, #8]
040d6b48c e1430091 add      x1, sp, #0x10
040d6b490 e003142a mov      w0, w20
040d6b494 681200b9 str      w8, [x19, #0x10]
040d6b498 29040094 bl       #0x40d6c53c
040d6b49c 80010036 tbz      w0, #0, #0x40d6b4cc
040d6b4a0 e007c03d ldr      q0, [sp, #0x10]
040d6b4a4 e0030032 mov      w0, #1
040d6b4a8 e91340f9 ldr      x9, [sp, #0x20]
040d6b4ac e003803d str      q0, [sp]
040d6b4b0 e80740f9 ldr      x8, [sp, #8]
040d6b4b4 2afd60d3 lsr      x10, x9, #0x20
040d6b4b8 680600f9 str      x8, [x19, #8]
040d6b4bc e80340f9 ldr      x8, [sp]
040d6b4c0 69aa0229 stp      w9, w10, [x19, #0x14]
040d6b4c4 680200f9 str      x8, [x19]
040d6b4c8 02000014 b        #0x40d6b4d0
040d6b4cc e0031f2a mov      w0, wzr
040d6b4d0 f37b44a9 ldp      x19, x30, [sp, #0x40]
040d6b4d4 f41b40f9 ldr      x20, [sp, #0x30]
040d6b4d8 ff430191 add      sp, sp, #0x50
040d6b4dc c0035fd6 ret

; resource_info_fields [0x40d6c53c, 0x40d6c628); SHA-256 f8a7874908de102584a5e117ee3a70dd1232a511cb50b1b74a981b467db2eab9
040d6c53c ff8301d1 sub      sp, sp, #0x60
040d6c540 f61b00f9 str      x22, [sp, #0x30]
040d6c544 f55304a9 stp      x21, x20, [sp, #0x40]
040d6c548 f37b05a9 stp      x19, x30, [sp, #0x50]
040d6c54c f30301aa mov      x19, x1
040d6c550 f403002a mov      w20, w0
040d6c554 e0031f2a mov      w0, wzr
040d6c558 9f720171 cmp      w20, #0x5c
040d6c55c 7f0200f9 str      xzr, [x19]
040d6c560 7f1200b9 str      wzr, [x19, #0x10]
040d6c564 88050054 b.hi     #0x40d6c614
040d6c568 e003142a mov      w0, w20
040d6c56c 57130094 bl       #0x40d712c8
040d6c570 f50300aa mov      x21, x0
040d6c574 150500b4 cbz      x21, #0x40d6c614
040d6c578 a80240b9 ldr      w8, [x21]
040d6c57c 1f01146b cmp      w8, w20
040d6c580 a1030054 b.ne     #0x40d6c5f4
040d6c584 a02640b9 ldr      w0, [x21, #0x24]
040d6c588 49130094 bl       #0x40d712ac
040d6c58c f40300aa mov      x20, x0
040d6c590 340400b4 cbz      x20, #0x40d6c614
040d6c594 a80a40f9 ldr      x8, [x21, #0x10]
040d6c598 f60314aa mov      x22, x20
040d6c59c 680200f9 str      x8, [x19]
040d6c5a0 a01a40b9 ldr      w0, [x21, #0x18]
040d6c5a4 601200b9 str      w0, [x19, #0x10]
040d6c5a8 c88e40f8 ldr      x8, [x22, #8]!
040d6c5ac 880200b4 cbz      x8, #0x40d6c5fc
040d6c5b0 a8a64329 ldp      w8, w9, [x21, #0x1c]
040d6c5b4 f50314aa mov      x21, x20
040d6c5b8 e1230091 add      x1, sp, #8
040d6c5bc 287d60b3 bfi      x8, x9, #0x20, #0x20
040d6c5c0 89720091 add      x9, x20, #0x1c
040d6c5c4 e80700f9 str      x8, [sp, #8]
040d6c5c8 880240f9 ldr      x8, [x20]
040d6c5cc e80b00f9 str      x8, [sp, #0x10]
040d6c5d0 880640f9 ldr      x8, [x20, #8]
040d6c5d4 e80f00f9 str      x8, [sp, #0x18]
040d6c5d8 a80e41b8 ldr      w8, [x21, #0x10]!
040d6c5dc e82300b9 str      w8, [sp, #0x20]
040d6c5e0 e91700f9 str      x9, [sp, #0x28]
040d6c5e4 f50d0094 bl       #0x40d6fdb8
040d6c5e8 1f040071 cmp      w0, #1
040d6c5ec 94b2969a csel     x20, x20, x22, lt
040d6c5f0 04000014 b        #0x40d6c600
040d6c5f4 e0031f2a mov      w0, wzr
040d6c5f8 07000014 b        #0x40d6c614
040d6c5fc 95420091 add      x21, x20, #0x10
040d6c600 880240f9 ldr      x8, [x20]
040d6c604 e0030032 mov      w0, #1
040d6c608 680600f9 str      x8, [x19, #8]
040d6c60c a80240b9 ldr      w8, [x21]
040d6c610 681600b9 str      w8, [x19, #0x14]
040d6c614 f37b45a9 ldp      x19, x30, [sp, #0x50]
040d6c618 f55344a9 ldp      x21, x20, [sp, #0x40]
040d6c61c f61b40f9 ldr      x22, [sp, #0x30]
040d6c620 ff830191 add      sp, sp, #0x60
040d6c624 c0035fd6 ret

; update_writer_setup_in_ram [0xa02ab3dd4, 0xa02ab3ed4); SHA-256 803d89928f3218c594ea5152f039dcf3442cdb769c277ac984573b54f37e4b77
a02ab3dd4 4ba840a9 ldp      x11, x10, [x2, #8]
a02ab3dd8 88da87d2 mov      x8, #0x3ed4
a02ab3ddc 6855a0f2 movk     x8, #0x2ab, lsl #16
a02ab3de0 4801c0f2 movk     x8, #0xa, lsl #32
a02ab3de4 0800e0f2 movk     x8, #0, lsl #48
a02ab3de8 7f0100f1 cmp      x11, #0
a02ab3dec 095290d2 mov      x9, #0x8290
a02ab3df0 0c9a97d2 mov      x12, #0xbcd0
a02ab3df4 0b018b9a csel     x11, x8, x11, eq
a02ab3df8 089b97d2 mov      x8, #0xbcd8
a02ab3dfc e952a0f2 movk     x9, #0x297, lsl #16
a02ab3e00 2c7ca0f2 movk     x12, #0x3e1, lsl #16
a02ab3e04 287ca0f2 movk     x8, #0x3e1, lsl #16
a02ab3e08 4901c0f2 movk     x9, #0xa, lsl #32
a02ab3e0c 4c01c0f2 movk     x12, #0xa, lsl #32
a02ab3e10 4801c0f2 movk     x8, #0xa, lsl #32
a02ab3e14 0900e0f2 movk     x9, #0, lsl #48
a02ab3e18 0c00e0f2 movk     x12, #0, lsl #48
a02ab3e1c 0800e0f2 movk     x8, #0, lsl #48
a02ab3e20 2b0100f9 str      x11, [x9]
a02ab3e24 800100f9 str      x0, [x12]
a02ab3e28 ea0000b4 cbz      x10, #0xa02ab3e44
a02ab3e2c 490140b9 ldr      w9, [x10]
a02ab3e30 a9000034 cbz      w9, #0xa02ab3e44
a02ab3e34 4a110091 add      x10, x10, #4
a02ab3e38 094500b8 str      w9, [x8], #4
a02ab3e3c 494540b8 ldr      w9, [x10], #4
a02ab3e40 c9ffff35 cbnz     w9, #0xa02ab3e38
a02ab3e44 1f0100b9 str      wzr, [x8]
a02ab3e48 09a097d2 mov      x9, #0xbd00
a02ab3e4c 480040b9 ldr      w8, [x2]
a02ab3e50 297ca0f2 movk     x9, #0x3e1, lsl #16
a02ab3e54 4a018052 mov      w10, #0xa
a02ab3e58 4901c0f2 movk     x9, #0xa, lsl #32
a02ab3e5c 0900e0f2 movk     x9, #0, lsl #48
a02ab3e60 4a01084b sub      w10, w10, w8
a02ab3e64 4d7d0153 lsr      w13, w10, #1
a02ab3e68 4a054a4b sub      w10, w10, w10, lsr #1
a02ab3e6c 280100b9 str      w8, [x9]
a02ab3e70 8ba097d2 mov      x11, #0xbd04
a02ab3e74 0ca197d2 mov      x12, #0xbd08
a02ab3e78 2efc51d3 lsr      x14, x1, #0x11
a02ab3e7c 0fa297d2 mov      x15, #0xbd10
a02ab3e80 c909cd1a udiv     w9, w14, w13
a02ab3e84 50050051 sub      w16, w10, #1
a02ab3e88 88a297d2 mov      x8, #0xbd14
a02ab3e8c 2b7ca0f2 movk     x11, #0x3e1, lsl #16
a02ab3e90 ce09d01a udiv     w14, w14, w16
a02ab3e94 2c7ca0f2 movk     x12, #0x3e1, lsl #16
a02ab3e98 2f7ca0f2 movk     x15, #0x3e1, lsl #16
a02ab3e9c 287ca0f2 movk     x8, #0x3e1, lsl #16
a02ab3ea0 4b01c0f2 movk     x11, #0xa, lsl #32
a02ab3ea4 4c01c0f2 movk     x12, #0xa, lsl #32
a02ab3ea8 4f01c0f2 movk     x15, #0xa, lsl #32
a02ab3eac 4801c0f2 movk     x8, #0xa, lsl #32
a02ab3eb0 0b00e0f2 movk     x11, #0, lsl #48
a02ab3eb4 0c00e0f2 movk     x12, #0, lsl #48
a02ab3eb8 0f00e0f2 movk     x15, #0, lsl #48
a02ab3ebc 0800e0f2 movk     x8, #0, lsl #48
a02ab3ec0 6d0100b9 str      w13, [x11]
a02ab3ec4 8a0100b9 str      w10, [x12]
a02ab3ec8 e90100b9 str      w9, [x15]
a02ab3ecc 0e0100b9 str      w14, [x8]
a02ab3ed0 c0035fd6 ret

; update_writer_in_ram [0xa02ab3eec, 0xa02ab4214); SHA-256 0d41d53c1b21d9896ea5ceee5e84e052ee4081af367f6898ea0fac162f9f3949
a02ab3eec ffc301d1 sub      sp, sp, #0x70
a02ab3ef0 fc6f01a9 stp      x28, x27, [sp, #0x10]
a02ab3ef4 fa6702a9 stp      x26, x25, [sp, #0x20]
a02ab3ef8 f85f03a9 stp      x24, x23, [sp, #0x30]
a02ab3efc f65704a9 stp      x22, x21, [sp, #0x40]
a02ab3f00 f44f05a9 stp      x20, x19, [sp, #0x50]
a02ab3f04 fd7b06a9 stp      x29, x30, [sp, #0x60]
a02ab3f08 089b97d2 mov      x8, #0xbcd8
a02ab3f0c 287ca0f2 movk     x8, #0x3e1, lsl #16
a02ab3f10 4801c0f2 movk     x8, #0xa, lsl #32
a02ab3f14 0800e0f2 movk     x8, #0, lsl #48
a02ab3f18 094540b8 ldr      w9, [x8], #4
a02ab3f1c e9ffff35 cbnz     w9, #0xa02ab3f18
a02ab3f20 04feff97 bl       #0xa02ab3730
a02ab3f24 089a97d2 mov      x8, #0xbcd0
a02ab3f28 287ca0f2 movk     x8, #0x3e1, lsl #16
a02ab3f2c 4801c0f2 movk     x8, #0xa, lsl #32
a02ab3f30 0800e0f2 movk     x8, #0, lsl #48
a02ab3f34 97a097d2 mov      x23, #0xbd04
a02ab3f38 18b591d2 mov      x24, #0x8da8
a02ab3f3c e80700f9 str      x8, [sp, #8]
a02ab3f40 1ba197d2 mov      x27, #0xbd08
a02ab3f44 88a297d2 mov      x8, #0xbd14
a02ab3f48 377ca0f2 movk     x23, #0x3e1, lsl #16
a02ab3f4c 387ca0f2 movk     x24, #0x3e1, lsl #16
a02ab3f50 3b7ca0f2 movk     x27, #0x3e1, lsl #16
a02ab3f54 287ca0f2 movk     x8, #0x3e1, lsl #16
a02ab3f58 5701c0f2 movk     x23, #0xa, lsl #32
a02ab3f5c 5801c0f2 movk     x24, #0xa, lsl #32
a02ab3f60 5b01c0f2 movk     x27, #0xa, lsl #32
a02ab3f64 4801c0f2 movk     x8, #0xa, lsl #32
a02ab3f68 f6071f32 mov      w22, #6
a02ab3f6c 1700e0f2 movk     x23, #0, lsl #48
a02ab3f70 1800e0f2 movk     x24, #0, lsl #48
a02ab3f74 1b00e0f2 movk     x27, #0, lsl #48
a02ab3f78 0800e0f2 movk     x8, #0, lsl #48
a02ab3f7c e80300f9 str      x8, [sp]
a02ab3f80 080740f9 ldr      x8, [x24, #8]
a02ab3f84 e94b62b2 mov      x9, #0x1ffffc0000000
a02ab3f88 f40240b9 ldr      w20, [x23]
a02ab3f8c e1030032 mov      w1, #1
a02ab3f90 0801098b add      x8, x8, x9
a02ab3f94 13fd51d3 lsr      x19, x8, #0x11
a02ab3f98 e003132a mov      w0, w19
a02ab3f9c 61fcff97 bl       #0xa02ab3120
a02ab3fa0 a00f0035 cbnz     w0, #0xa02ab4194
a02ab3fa4 9c000094 bl       #0xa02ab4214
a02ab3fa8 081b40b9 ldr      w8, [x24, #0x18]
a02ab3fac 08390f12 and      w8, w8, #0xfffe0000
a02ab3fb0 1f814071 cmp      w8, #0x20, lsl #12
a02ab3fb4 81030054 b.ne     #0xa02ab4024
a02ab3fb8 e80740f9 ldr      x8, [sp, #8]
a02ab3fbc 790340b9 ldr      w25, [x27]
a02ab3fc0 130140f9 ldr      x19, [x8]
a02ab3fc4 94000094 bl       #0xa02ab4214
a02ab3fc8 081b40b9 ldr      w8, [x24, #0x18]
a02ab3fcc 09390f12 and      w9, w8, #0xfffe0000
a02ab3fd0 3f814071 cmp      w9, #0x20, lsl #12
a02ab3fd4 a1080054 b.ne     #0xa02ab40e8
a02ab3fd8 fa030032 mov      w26, #1
a02ab3fdc 5f03196b cmp      w26, w25
a02ab3fe0 48000054 b.hi     #0xa02ab3fe8
a02ab3fe4 8c000094 bl       #0xa02ab4214
a02ab3fe8 140740f9 ldr      x20, [x24, #8]
a02ab3fec e1031132 mov      w1, #0x8000
a02ab3ff0 e20313aa mov      x2, x19
a02ab3ff4 e003142a mov      w0, w20
a02ab3ff8 31fcff97 bl       #0xa02ab30bc
a02ab3ffc c00c0035 cbnz     w0, #0xa02ab4194
a02ab4000 e8031faa mov      x8, xzr
a02ab4004 696a68f8 ldr      x9, [x19, x8]
a02ab4008 8a6a68f8 ldr      x10, [x20, x8]
a02ab400c 3f010aeb cmp      x9, x10
a02ab4010 210c0054 b.ne     #0xa02ab4194
a02ab4014 08210091 add      x8, x8, #8
a02ab4018 1f8140f1 cmp      x8, #0x20, lsl #12
a02ab401c 41ffff54 b.ne     #0xa02ab4004
a02ab4020 69000014 b        #0xa02ab41c4
a02ab4024 fa031f2a mov      w26, wzr
a02ab4028 f5031f2a mov      w21, wzr
a02ab402c f9030032 mov      w25, #1
a02ab4030 08a297d2 mov      x8, #0xbd10
a02ab4034 287ca0f2 movk     x8, #0x3e1, lsl #16
a02ab4038 4801c0f2 movk     x8, #0xa, lsl #32
a02ab403c 0800e0f2 movk     x8, #0, lsl #48
a02ab4040 73060011 add      w19, w19, #1
a02ab4044 5a070011 add      w26, w26, #1
a02ab4048 080140b9 ldr      w8, [x8]
a02ab404c 1f011a6b cmp      w8, w26
a02ab4050 c2000054 b.hs     #0xa02ab4068
a02ab4054 39070011 add      w25, w25, #1
a02ab4058 3f03146b cmp      w25, w20
a02ab405c 48000054 b.hi     #0xa02ab4064
a02ab4060 6d000094 bl       #0xa02ab4214
a02ab4064 fa031f2a mov      w26, wzr
a02ab4068 683a0f53 lsl      w8, w19, #0x11
a02ab406c e9030232 mov      w9, #0x40000000
a02ab4070 1c01098b add      x28, x8, x9
a02ab4074 28008852 mov      w8, #0x4001
a02ab4078 e9031caa mov      x9, x28
a02ab407c 2a0140f9 ldr      x10, [x9]
a02ab4080 5f0500b1 cmn      x10, #1
a02ab4084 c1000054 b.ne     #0xa02ab409c
a02ab4088 29210091 add      x9, x9, #8
a02ab408c 08050051 sub      w8, w8, #1
a02ab4090 1f050071 cmp      w8, #1
a02ab4094 48ffff54 b.hi     #0xa02ab407c
a02ab4098 0d000014 b        #0xa02ab40cc
a02ab409c e1030032 mov      w1, #1
a02ab40a0 e003132a mov      w0, w19
a02ab40a4 1ffcff97 bl       #0xa02ab3120
a02ab40a8 60070035 cbnz     w0, #0xa02ab4194
a02ab40ac 28008852 mov      w8, #0x4001
a02ab40b0 890340f9 ldr      x9, [x28]
a02ab40b4 3f0500b1 cmn      x9, #1
a02ab40b8 e1060054 b.ne     #0xa02ab4194
a02ab40bc 9c230091 add      x28, x28, #8
a02ab40c0 08050051 sub      w8, w8, #1
a02ab40c4 1f050071 cmp      w8, #1
a02ab40c8 48ffff54 b.hi     #0xa02ab40b0
a02ab40cc 081b40b9 ldr      w8, [x24, #0x18]
a02ab40d0 b5060011 add      w21, w21, #1
a02ab40d4 087d1153 lsr      w8, w8, #0x11
a02ab40d8 08050051 sub      w8, w8, #1
a02ab40dc bf02086b cmp      w21, w8
a02ab40e0 83faff54 b.lo     #0xa02ab4030
a02ab40e4 b5ffff17 b        #0xa02ab3fb8
a02ab40e8 140740f9 ldr      x20, [x24, #8]
a02ab40ec fc031f2a mov      w28, wzr
a02ab40f0 fd031f2a mov      w29, wzr
a02ab40f4 fa030032 mov      w26, #1
a02ab40f8 f50313aa mov      x21, x19
a02ab40fc e90340f9 ldr      x9, [sp]
a02ab4100 94824091 add      x20, x20, #0x20, lsl #12
a02ab4104 9c070011 add      w28, w28, #1
a02ab4108 290140b9 ldr      w9, [x9]
a02ab410c 3f011c6b cmp      w9, w28
a02ab4110 e2000054 b.hs     #0xa02ab412c
a02ab4114 5a070011 add      w26, w26, #1
a02ab4118 5f03196b cmp      w26, w25
a02ab411c 68000054 b.hi     #0xa02ab4128
a02ab4120 3d000094 bl       #0xa02ab4214
a02ab4124 081b40b9 ldr      w8, [x24, #0x18]
a02ab4128 fc031f2a mov      w28, wzr
a02ab412c 090740f9 ldr      x9, [x24, #8]
a02ab4130 2841288b add      x8, x9, w8, uxtw
a02ab4134 088140d1 sub      x8, x8, #0x20, lsl #12
a02ab4138 9f0208eb cmp      x20, x8
a02ab413c c8020054 b.hi     #0xa02ab4194
a02ab4140 b5824091 add      x21, x21, #0x20, lsl #12
a02ab4144 e1031132 mov      w1, #0x8000
a02ab4148 e003142a mov      w0, w20
a02ab414c e20315aa mov      x2, x21
a02ab4150 dbfbff97 bl       #0xa02ab30bc
a02ab4154 00020035 cbnz     w0, #0xa02ab4194
a02ab4158 e8031faa mov      x8, xzr
a02ab415c a96a68f8 ldr      x9, [x21, x8]
a02ab4160 8a6a68f8 ldr      x10, [x20, x8]
a02ab4164 3f010aeb cmp      x9, x10
a02ab4168 61010054 b.ne     #0xa02ab4194
a02ab416c 08210091 add      x8, x8, #8
a02ab4170 1f8140f1 cmp      x8, #0x20, lsl #12
a02ab4174 41ffff54 b.ne     #0xa02ab415c
a02ab4178 081b40b9 ldr      w8, [x24, #0x18]
a02ab417c bd070011 add      w29, w29, #1
a02ab4180 097d1153 lsr      w9, w8, #0x11
a02ab4184 29050051 sub      w9, w9, #1
a02ab4188 bf03096b cmp      w29, w9
a02ab418c 83fbff54 b.lo     #0xa02ab40fc
a02ab4190 93ffff17 b        #0xa02ab3fdc
a02ab4194 d6060071 subs     w22, w22, #1
a02ab4198 48efff54 b.hi     #0xa02ab3f80
a02ab419c 085290d2 mov      x8, #0x8290
a02ab41a0 e852a0f2 movk     x8, #0x297, lsl #16
a02ab41a4 4801c0f2 movk     x8, #0xa, lsl #32
a02ab41a8 0800e0f2 movk     x8, #0, lsl #48
a02ab41ac 080140f9 ldr      x8, [x8]
a02ab41b0 e80100b4 cbz      x8, #0xa02ab41ec
a02ab41b4 c0008052 mov      w0, #6
a02ab41b8 a080a072 movk     w0, #0x405, lsl #16
a02ab41bc e1030032 mov      w1, #1
a02ab41c0 0a000014 b        #0xa02ab41e8
a02ab41c4 085290d2 mov      x8, #0x8290
a02ab41c8 e852a0f2 movk     x8, #0x297, lsl #16
a02ab41cc 4801c0f2 movk     x8, #0xa, lsl #32
a02ab41d0 0800e0f2 movk     x8, #0, lsl #48
a02ab41d4 080140f9 ldr      x8, [x8]
a02ab41d8 a80000b4 cbz      x8, #0xa02ab41ec
a02ab41dc c0008052 mov      w0, #6
a02ab41e0 a080a072 movk     w0, #0x405, lsl #16
a02ab41e4 e1031faa mov      x1, xzr
a02ab41e8 00013fd6 blr      x8
a02ab41ec 46000094 bl       #0xa02ab4304
a02ab41f0 66000094 bl       #0xa02ab4388
a02ab41f4 fd7b46a9 ldp      x29, x30, [sp, #0x60]
a02ab41f8 f44f45a9 ldp      x20, x19, [sp, #0x50]
a02ab41fc f65744a9 ldp      x22, x21, [sp, #0x40]
a02ab4200 f85f43a9 ldp      x24, x23, [sp, #0x30]
a02ab4204 fa6742a9 ldp      x26, x25, [sp, #0x20]
a02ab4208 fc6f41a9 ldp      x28, x27, [sp, #0x10]
a02ab420c ffc30191 add      sp, sp, #0x70
a02ab4210 6f000014 b        #0xa02ab43cc

; program_words_frontend [0xa02ab30bc, 0xa02ab3120); SHA-256 bd53708b8e2de3644aacd84123571fe1dceae59d0f1aa6026d9b6cdc39dcf1a9
a02ab30bc f553bea9 stp      x21, x20, [sp, #-0x20]!
a02ab30c0 f37b01a9 stp      x19, x30, [sp, #0x10]
a02ab30c4 f30302aa mov      x19, x2
a02ab30c8 f403012a mov      w20, w1
a02ab30cc f503002a mov      w21, w0
a02ab30d0 e0030032 mov      w0, #1
a02ab30d4 e8030732 mov      w8, #0x2000000
a02ab30d8 9f02086b cmp      w20, w8
a02ab30dc c8010054 b.hi     #0xa02ab3114
a02ab30e0 e8070232 mov      w8, #-0x40000000
a02ab30e4 a802080b add      w8, w21, w8
a02ab30e8 e9030532 mov      w9, #0x8000000
a02ab30ec 1f01096b cmp      w8, w9
a02ab30f0 28010054 b.hi     #0xa02ab3114
a02ab30f4 130100b4 cbz      x19, #0xa02ab3114
a02ab30f8 18010094 bl       #0xa02ab3558
a02ab30fc e003152a mov      w0, w21
a02ab3100 e103142a mov      w1, w20
a02ab3104 e20313aa mov      x2, x19
a02ab3108 6fffff97 bl       #0xa02ab2ec4
a02ab310c 60010094 bl       #0xa02ab368c
a02ab3110 e0031f2a mov      w0, wzr
a02ab3114 f37b41a9 ldp      x19, x30, [sp, #0x10]
a02ab3118 f553c2a8 ldp      x21, x20, [sp], #0x20
a02ab311c c0035fd6 ret

; program_word_loop_excerpt [0xa02ab2ec4, 0xa02ab2f8c); SHA-256 56d2e061e26922bf129b3d33b4f2db7dee85c5f0718895d6c741ce24a41bfd03
a02ab2ec4 08008ed2 mov      x8, #0x7000
a02ab2ec8 08c0a1f2 movk     x8, #0xe00, lsl #16
a02ab2ecc 0800c0f2 movk     x8, #0, lsl #32
a02ab2ed0 29008052 mov      w9, #1
a02ab2ed4 0800e0f2 movk     x8, #0, lsl #48
a02ab2ed8 09c0a072 movk     w9, #0x600, lsl #16
a02ab2edc 099100b9 str      w9, [x8, #0x90]
a02ab2ee0 099140b9 ldr      w9, [x8, #0x90]
a02ab2ee4 e9ff0f37 tbnz     w9, #1, #0xa02ab2ee0
a02ab2ee8 2a198052 mov      w10, #0xc9
a02ab2eec 0a20a072 movk     w10, #0x100, lsl #16
a02ab2ef0 ad008052 mov      w13, #5
a02ab2ef4 eb070232 mov      w11, #-0x40000000
a02ab2ef8 ec031e32 mov      w12, #4
a02ab2efc 0a0100b9 str      w10, [x8]
a02ab2f00 2d80a172 movk     w13, #0xc01, lsl #16
a02ab2f04 e903002a mov      w9, w0
a02ab2f08 0b000b0b add      w11, w0, w11
a02ab2f0c 0c4500b9 str      w12, [x8, #0x44]
a02ab2f10 0a1c0072 ands     w10, w0, #0xff
a02ab2f14 0d3900b9 str      w13, [x8, #0x38]
a02ab2f18 1f5900b9 str      wzr, [x8, #0x58]
a02ab2f1c c0000054 b.eq     #0xa02ab2f34
a02ab2f20 ed031a32 mov      w13, #0x40
a02ab2f24 2c084a0b add      w12, w1, w10, lsr #2
a02ab2f28 aa094a4b sub      w10, w13, w10, lsr #2
a02ab2f2c 9f010171 cmp      w12, #0x40
a02ab2f30 03000014 b        #0xa02ab2f3c
a02ab2f34 3f000171 cmp      w1, #0x40
a02ab2f38 ea031a32 mov      w10, #0x40
a02ab2f3c 0c4140b9 ldr      w12, [x8, #0x40]
a02ab2f40 2a308a1a csel     w10, w1, w10, lo
a02ab2f44 ee030032 mov      w14, #1
a02ab2f48 4d751e53 lsl      w13, w10, #2
a02ab2f4c 8c011e32 orr      w12, w12, #4
a02ab2f50 0c4100b9 str      w12, [x8, #0x40]
a02ab2f54 ec071f32 mov      w12, #6
a02ab2f58 0b1d00b9 str      w11, [x8, #0x1c]
a02ab2f5c 0b7900b9 str      w11, [x8, #0x78]
a02ab2f60 0d7d00b9 str      w13, [x8, #0x7c]
a02ab2f64 0c8100b9 str      w12, [x8, #0x80]
a02ab2f68 0e7100b9 str      w14, [x8, #0x70]
a02ab2f6c 0a010034 cbz      w10, #0xa02ab2f8c
a02ab2f70 ec030a2a mov      w12, w10
a02ab2f74 ee0302aa mov      x14, x2
a02ab2f78 ef0309aa mov      x15, x9
a02ab2f7c d04540b8 ldr      w16, [x14], #4
a02ab2f80 8c0500f1 subs     x12, x12, #1
a02ab2f84 f04500b8 str      w16, [x15], #4
a02ab2f88 a1ffff54 b.ne     #0xa02ab2f7c

; address_to_128k_block [0x40d6bf88, 0x40d6bf98); SHA-256 1d8ba7e3c7ec3785a3cb9a2f8edcf77c940f63af44cf92c7df91ad5ca31325b1
040d6bf88 e84b62b2 mov      x8, #0x1ffffc0000000
040d6bf8c 0800088b add      x8, x0, x8
040d6bf90 00fd51d3 lsr      x0, x8, #0x11
040d6bf94 c0035fd6 ret

; ai_device_update [0x41028cb8, 0x41028dd0); SHA-256 c3a3e222a7229122f5c41197d321d20c3889b76c57ef03cbf8d26b70f0ded9e3
041028cb8 f75bbda9 stp      x23, x22, [sp, #-0x30]!
041028cbc f55301a9 stp      x21, x20, [sp, #0x10]
041028cc0 f37b02a9 stp      x19, x30, [sp, #0x20]
041028cc4 14198052 mov      w20, #0xc8
041028cc8 f30300aa mov      x19, x0
041028ccc e003142a mov      w0, w20
041028cd0 6112f497 bl       #0x40d2d654
041028cd4 e0030732 mov      w0, #0x2000000
041028cd8 e1031faa mov      x1, xzr
041028cdc ffefff97 bl       #0x41024cd8
041028ce0 f7070032 mov      w23, #3
041028ce4 3b09f597 bl       #0x40d6b1d0
041028ce8 f50300aa mov      x21, x0
041028cec 150400b4 cbz      x21, #0x41028d6c
041028cf0 e00315aa mov      x0, x21
041028cf4 a50cf597 bl       #0x40d6bf88
041028cf8 f603002a mov      w22, w0
041028cfc 96030034 cbz      w22, #0x41028d6c
041028d00 e003142a mov      w0, w20
041028d04 5412f497 bl       #0x40d2d654
041028d08 e1030032 mov      w1, #1
041028d0c e003162a mov      w0, w22
041028d10 6862ef97 bl       #0x40c016b0
041028d14 c0020035 cbnz     w0, #0x41028d6c
041028d18 e8031faa mov      x8, xzr
041028d1c a96a68f8 ldr      x9, [x21, x8]
041028d20 3f0500b1 cmn      x9, #1
041028d24 41020054 b.ne     #0x41028d6c
041028d28 08210091 add      x8, x8, #8
041028d2c 1f814071 cmp      w8, #0x20, lsl #12
041028d30 61ffff54 b.ne     #0x41028d1c
041028d34 e1031132 mov      w1, #0x8000
041028d38 e003152a mov      w0, w21
041028d3c e20313aa mov      x2, x19
041028d40 1462ef97 bl       #0x40c01590
041028d44 40010035 cbnz     w0, #0x41028d6c
041028d48 e8031faa mov      x8, xzr
041028d4c a96a68f8 ldr      x9, [x21, x8]
041028d50 6a6a68f8 ldr      x10, [x19, x8]
041028d54 3f010aeb cmp      x9, x10
041028d58 a1000054 b.ne     #0x41028d6c
041028d5c 08210091 add      x8, x8, #8
041028d60 1f814071 cmp      w8, #0x20, lsl #12
041028d64 41ffff54 b.ne     #0x41028d4c
041028d68 0e000014 b        #0x41028da0
041028d6c f7060071 subs     w23, w23, #1
041028d70 a1fbff54 b.ne     #0x41028ce4
041028d74 00198052 mov      w0, #0xc8
041028d78 3712f497 bl       #0x40d2d654
041028d7c e00315aa mov      x0, x21
041028d80 820cf597 bl       #0x40d6bf88
041028d84 e1030032 mov      w1, #1
041028d88 f3030032 mov      w19, #1
041028d8c 4962ef97 bl       #0x40c016b0
041028d90 41018052 mov      w1, #0xa
041028d94 e0030732 mov      w0, #0x2000000
041028d98 d0efff97 bl       #0x41024cd8
041028d9c 08000014 b        #0x41028dbc
041028da0 41018052 mov      w1, #0xa
041028da4 e0030732 mov      w0, #0x2000000
041028da8 ccefff97 bl       #0x41024cd8
041028dac e0031e32 mov      w0, #4
041028db0 e1031faa mov      x1, xzr
041028db4 c9efff97 bl       #0x41024cd8
041028db8 f3031f2a mov      w19, wzr
041028dbc e003132a mov      w0, w19
041028dc0 f37b42a9 ldp      x19, x30, [sp, #0x20]
041028dc4 f55341a9 ldp      x21, x20, [sp, #0x10]
041028dc8 f75bc3a8 ldp      x23, x22, [sp], #0x30
041028dcc c0035fd6 ret

; ai_block_address [0x41273110, 0x41273118); SHA-256 d280866269f6982285563fc703915b371fbdeaf07faf8b8ad59b681837782585
041273110 00c9a852 mov      w0, #0x46480000
041273114 c0035fd6 ret
