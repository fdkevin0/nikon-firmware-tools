
; service_callback_registration_and_parameter_binding [0x40f588bc, 0x40f58948); SHA-256 6bf1572ddc55528c07943337d1ebaded8844400d0793e4b8896983531b825ceb
40f588bc 804891d2 mov      x0, #0x8a44
40f588c0 a01ea8f2 movk     x0, #0x40f5, lsl #16
40f588c4 0000c0f2 movk     x0, #0, lsl #32
40f588c8 0000e0f2 movk     x0, #0, lsl #48
40f588cc f8ed0794 bl       #0x411540ac
40f588d0 806892d2 mov      x0, #0x9344
40f588d4 a01ea8f2 movk     x0, #0x40f5, lsl #16
40f588d8 0000c0f2 movk     x0, #0, lsl #32
40f588dc 0000e0f2 movk     x0, #0, lsl #48
40f588e0 fced0794 bl       #0x411540d0
40f588e4 008092d2 mov      x0, #0x9400
40f588e8 a01ea8f2 movk     x0, #0x40f5, lsl #16
40f588ec 0000c0f2 movk     x0, #0, lsl #32
40f588f0 0000e0f2 movk     x0, #0, lsl #48
40f588f4 6a230094 bl       #0x40f6169c
40f588f8 00d692d2 mov      x0, #0x96b0
40f588fc a01ea8f2 movk     x0, #0x40f5, lsl #16
40f58900 0000c0f2 movk     x0, #0, lsl #32
40f58904 0000e0f2 movk     x0, #0, lsl #48
40f58908 6e230094 bl       #0x40f616c0
40f5890c 000493d2 mov      x0, #0x9820
40f58910 a01ea8f2 movk     x0, #0x40f5, lsl #16
40f58914 0000c0f2 movk     x0, #0, lsl #32
40f58918 0000e0f2 movk     x0, #0, lsl #48
40f5891c 72230094 bl       #0x40f616e4
40f58920 807793d2 mov      x0, #0x9bbc
40f58924 a01ea8f2 movk     x0, #0x40f5, lsl #16
40f58928 0000c0f2 movk     x0, #0, lsl #32
40f5892c 0000e0f2 movk     x0, #0, lsl #48
40f58930 ad360094 bl       #0x40f663e4
40f58934 2f230094 bl       #0x40f615f0
40f58938 76360094 bl       #0x40f66310
40f5893c 800b8052 mov      w0, #0x5c
40f58940 ed4af897 bl       #0x40d6b4f4
40f58944 eced0794 bl       #0x411540f4

; backend_callback_registration [0x411540ac, 0x411540f8); SHA-256 edb7e3d17e74badfc26ac820b50746c94a81f7a60d6aedeb0e3db51160baa87f
411540ac 084b9ed2 mov      x8, #0xf258
411540b0 c892a0f2 movk     x8, #0x496, lsl #16
411540b4 4801c0f2 movk     x8, #0xa, lsl #32
411540b8 0800e0f2 movk     x8, #0, lsl #48
411540bc 090140f9 ldr      x9, [x8]
411540c0 490000b4 cbz      x9, #0x411540c8
411540c4 c0035fd6 ret
411540c8 000100f9 str      x0, [x8]
411540cc c0035fd6 ret
411540d0 084c9ed2 mov      x8, #0xf260
411540d4 c892a0f2 movk     x8, #0x496, lsl #16
411540d8 4801c0f2 movk     x8, #0xa, lsl #32
411540dc 0800e0f2 movk     x8, #0, lsl #48
411540e0 090140f9 ldr      x9, [x8]
411540e4 490000b4 cbz      x9, #0x411540ec
411540e8 c0035fd6 ret
411540ec 000100f9 str      x0, [x8]
411540f0 c0035fd6 ret
411540f4 184b0014 b        #0x41166d54

; backend_event_0201000a [0x41151b50, 0x41151b80); SHA-256 0864ef0f42236bbdce0c4ec4dc66a5f909227ba14b3d510587d4965abf95a2ea
41151b50 08018052 mov      w8, #8
41151b54 2840a072 movk     w8, #0x201, lsl #16
41151b58 14090011 add      w20, w8, #2
41151b5c 084b9ed2 mov      x8, #0xf258
41151b60 c892a0f2 movk     x8, #0x496, lsl #16
41151b64 4801c0f2 movk     x8, #0xa, lsl #32
41151b68 0800e0f2 movk     x8, #0, lsl #48
41151b6c 080140f9 ldr      x8, [x8]
41151b70 880000b4 cbz      x8, #0x41151b80
41151b74 e003142a mov      w0, w20
41151b78 e10313aa mov      x1, x19
41151b7c 00013fd6 blr      x8

; service_event_dispatch_excerpt [0x40f58a44, 0x40f58b24); SHA-256 9f91f543d51e138a6c1f4e4cecaacdcdb2f0061bf8e35c361b2fa706ed5dd6f7
40f58a44 ff4301d1 sub      sp, sp, #0x50
40f58a48 f61300f9 str      x22, [sp, #0x20]
40f58a4c f55303a9 stp      x21, x20, [sp, #0x30]
40f58a50 f37b04a9 stp      x19, x30, [sp, #0x40]
40f58a54 2840a012 mov      w8, #-0x2010001
40f58a58 f40301aa mov      x20, x1
40f58a5c 0800080b add      w8, w0, w8
40f58a60 1f350071 cmp      w8, #0xd
40f58a64 e8040054 b.hi     #0x40f58b00
40f58a68 098891d2 mov      x9, #0x8c40
40f58a6c a953a0f2 movk     x9, #0x29d, lsl #16
40f58a70 4901c0f2 movk     x9, #0xa, lsl #32
40f58a74 0900e0f2 movk     x9, #0, lsl #48
40f58a78 287968f8 ldr      x8, [x9, x8, lsl #3]
40f58a7c 00011fd6 br       x8
40f58a80 097a97d2 mov      x9, #0xbbd0
40f58a84 6977a0f2 movk     x9, #0x3bb, lsl #16
40f58a88 887a97d2 mov      x8, #0xbbd4
40f58a8c 4901c0f2 movk     x9, #0xa, lsl #32
40f58a90 0900e0f2 movk     x9, #0, lsl #48
40f58a94 6877a0f2 movk     x8, #0x3bb, lsl #16
40f58a98 4801c0f2 movk     x8, #0xa, lsl #32
40f58a9c 0800e0f2 movk     x8, #0, lsl #48
40f58aa0 2a0140b9 ldr      w10, [x9]
40f58aa4 0b0140b9 ldr      w11, [x8]
40f58aa8 4a01142a orr      w10, w10, w20
40f58aac 7f01006b cmp      w11, w0
40f58ab0 2a0100b9 str      w10, [x9]
40f58ab4 42000054 b.hs     #0x40f58abc
40f58ab8 000100b9 str      w0, [x8]
40f58abc 009c96d2 mov      x0, #0xb4e0
40f58ac0 6077a0f2 movk     x0, #0x3bb, lsl #16
40f58ac4 4001c0f2 movk     x0, #0xa, lsl #32
40f58ac8 0000e0f2 movk     x0, #0, lsl #48
40f58acc e1030932 mov      w1, #0x800000
40f58ad0 f37b44a9 ldp      x19, x30, [sp, #0x40]
40f58ad4 f55343a9 ldp      x21, x20, [sp, #0x30]
40f58ad8 f61340f9 ldr      x22, [sp, #0x20]
40f58adc ff430191 add      sp, sp, #0x50
40f58ae0 f09df217 b        #0x40c002a0
40f58ae4 687297d2 mov      x8, #0xbb93
40f58ae8 6877a0f2 movk     x8, #0x3bb, lsl #16
40f58aec 4801c0f2 movk     x8, #0xa, lsl #32
40f58af0 0800e0f2 movk     x8, #0, lsl #48
40f58af4 e9030032 mov      w9, #1
40f58af8 09010039 strb     w9, [x8]
40f58afc fa010014 b        #0x40f592e4
40f58b00 f37b44a9 ldp      x19, x30, [sp, #0x40]
40f58b04 f55343a9 ldp      x21, x20, [sp, #0x30]
40f58b08 f61340f9 ldr      x22, [sp, #0x20]
40f58b0c e2b38552 mov      w2, #0x2d9f
40f58b10 e1030032 mov      w1, #1
40f58b14 e0031f2a mov      w0, wzr
40f58b18 e3031f2a mov      w3, wzr
40f58b1c ff430191 add      sp, sp, #0x50
40f58b20 f4480014 b        #0x40f6aef0

; configuration_request [0x41158850, 0x41158c04); SHA-256 8ba25f164596b725d7e0442e3d30107a868de065f6d5f583c723f6505b9bce5a
41158850 ff8302d1 sub      sp, sp, #0xa0
41158854 f63b00f9 str      x22, [sp, #0x70]
41158858 f55308a9 stp      x21, x20, [sp, #0x80]
4115885c f37b09a9 stp      x19, x30, [sp, #0x90]
41158860 f30300aa mov      x19, x0
41158864 e0070032 mov      w0, #3
41158868 e3031f2a mov      w3, wzr
4115886c 610240b9 ldr      w1, [x19]
41158870 620e40b9 ldr      w2, [x19, #0xc]
41158874 977e0094 bl       #0x411782d0
41158878 169d9bd2 mov      x22, #0xdce8
4115887c 69ae4079 ldrh     w9, [x19, #0x56]
41158880 080c9ed2 mov      x8, #0xf060
41158884 ffff04a9 stp      xzr, xzr, [sp, #0x48]
41158888 7653a0f2 movk     x22, #0x29b, lsl #16
4115888c ffff05a9 stp      xzr, xzr, [sp, #0x58]
41158890 c892a0f2 movk     x8, #0x496, lsl #16
41158894 5601c0f2 movk     x22, #0xa, lsl #32
41158898 4801c0f2 movk     x8, #0xa, lsl #32
4115889c 1600e0f2 movk     x22, #0, lsl #48
411588a0 0800e0f2 movk     x8, #0, lsl #48
411588a4 c9760079 strh     w9, [x22, #0x3a]
411588a8 09310079 strh     w9, [x8, #0x18]
411588ac 680240f9 ldr      x8, [x19]
411588b0 ff3700f9 str      xzr, [sp, #0x68]
411588b4 6a2e4129 ldp      w10, w11, [x19, #8]
411588b8 e82300f9 str      x8, [sp, #0x40]
411588bc 681640b9 ldr      w8, [x19, #0x14]
411588c0 ea4b00b9 str      w10, [sp, #0x48]
411588c4 69aa4329 ldp      w9, w10, [x19, #0x1c]
411588c8 e9a30929 stp      w9, w8, [sp, #0x4c]
411588cc e8030032 mov      w8, #1
411588d0 69664239 ldrb     w9, [x19, #0x99]
411588d4 ea5f00b9 str      w10, [sp, #0x5c]
411588d8 eba30a29 stp      w11, w8, [sp, #0x54]
411588dc ff830139 strb     wzr, [sp, #0x60]
411588e0 49000035 cbnz     w9, #0x411588e8
411588e4 689e40b9 ldr      w8, [x19, #0x9c]
411588e8 e0030191 add      x0, sp, #0x40
411588ec e86b00b9 str      w8, [sp, #0x68]
411588f0 ffdb0079 strh     wzr, [sp, #0x6c]
411588f4 c0630094 bl       #0x411717f4
411588f8 c00200b9 str      w0, [x22]
411588fc e8031f32 mov      w8, #2
41158900 699e40b9 ldr      w9, [x19, #0x9c]
41158904 c80e00b9 str      w8, [x22, #0xc]
41158908 df260d29 stp      wzr, w9, [x22, #0x68]
4115890c 680e40b9 ldr      w8, [x19, #0xc]
41158910 c8aa00b9 str      w8, [x22, #0xa8]
41158914 68424039 ldrb     w8, [x19, #0x10]
41158918 c8b20239 strb     w8, [x22, #0xac]
4115891c 68a64229 ldp      w8, w9, [x19, #0x14]
41158920 c8a60029 stp      w8, w9, [x22, #4]
41158924 e90313aa mov      x9, x19
41158928 682240b9 ldr      w8, [x19, #0x20]
4115892c c8ba00b9 str      w8, [x22, #0xb8]
41158930 284d42b8 ldr      w8, [x9, #0x24]!
41158934 2a2d4129 ldp      w10, w11, [x9, #8]
41158938 34610091 add      x20, x9, #0x18
4115893c e00314aa mov      x0, x20
41158940 6a7d60b3 bfi      x10, x11, #0x20, #0x20
41158944 ea1700f9 str      x10, [sp, #0x28]
41158948 2a0540b9 ldr      w10, [x9, #4]
4115894c 487d60b3 bfi      x8, x10, #0x20, #0x20
41158950 e81300f9 str      x8, [sp, #0x20]
41158954 e00bc03d ldr      q0, [sp, #0x20]
41158958 e00f803d str      q0, [sp, #0x30]
4115895c e81f40f9 ldr      x8, [sp, #0x38]
41158960 c80e00f9 str      x8, [x22, #0x18]
41158964 e81b40f9 ldr      x8, [sp, #0x30]
41158968 2a4146f8 ldur     x10, [x9, #0x64]
4115896c c80a00f9 str      x8, [x22, #0x10]
41158970 cab200f9 str      x10, [x22, #0x160]
41158974 ff7eec97 bl       #0x40c78570
41158978 00010036 tbz      w0, #0, #0x41158998
4115897c 880240b9 ldr      w8, [x20]
41158980 1f050071 cmp      w8, #1
41158984 ab000054 b.lt     #0x41158998
41158988 c1820091 add      x1, x22, #0x20
4115898c e00314aa mov      x0, x20
41158990 9f650094 bl       #0x4117200c
41158994 04000014 b        #0x411589a4
41158998 68a64629 ldp      w8, w9, [x19, #0x34]
4115899c 287d60b3 bfi      x8, x9, #0x20, #0x20
411589a0 c81200f9 str      x8, [x22, #0x20]
411589a4 e90313aa mov      x9, x19
411589a8 684a40b9 ldr      w8, [x19, #0x48]
411589ac 2a4d44b8 ldr      w10, [x9, #0x44]!
411589b0 0a7d60b3 bfi      x10, x8, #0x20, #0x20
411589b4 ea0300f9 str      x10, [sp]
411589b8 28254129 ldp      w8, w9, [x9, #8]
411589bc 287d60b3 bfi      x8, x9, #0x20, #0x20
411589c0 e80700f9 str      x8, [sp, #8]
411589c4 e003c03d ldr      q0, [sp]
411589c8 e007803d str      q0, [sp, #0x10]
411589cc e80f40f9 ldr      x8, [sp, #0x18]
411589d0 69aa4079 ldrh     w9, [x19, #0x54]
411589d4 6a5a40b9 ldr      w10, [x19, #0x58]
411589d8 cb5240b9 ldr      w11, [x22, #0x50]
411589dc c81a00f9 str      x8, [x22, #0x30]
411589e0 e80b40f9 ldr      x8, [sp, #0x10]
411589e4 c9720079 strh     w9, [x22, #0x38]
411589e8 cabe00b9 str      w10, [x22, #0xbc]
411589ec 696a40b9 ldr      w9, [x19, #0x68]
411589f0 c81600f9 str      x8, [x22, #0x28]
411589f4 680240b9 ldr      w8, [x19]
411589f8 6aca4079 ldrh     w10, [x19, #0x64]
411589fc 7f01096b cmp      w11, w9
41158a00 c84600b9 str      w8, [x22, #0x44]
41158a04 ca9a0079 strh     w10, [x22, #0x4c]
41158a08 61000054 b.ne     #0x41158a14
41158a0c e8031f2a mov      w8, wzr
41158a10 03000014 b        #0x41158a1c
41158a14 e8030032 mov      w8, #1
41158a18 c95200b9 str      w9, [x22, #0x50]
41158a1c 09849ed2 mov      x9, #0xf420
41158a20 6bea4079 ldrh     w11, [x19, #0x74]
41158a24 c992a0f2 movk     x9, #0x496, lsl #16
41158a28 6caa4d29 ldp      w12, w10, [x19, #0x6c]
41158a2c 4901c0f2 movk     x9, #0xa, lsl #32
41158a30 f40316aa mov      x20, x22
41158a34 f50316aa mov      x21, x22
41158a38 0900e0f2 movk     x9, #0, lsl #48
41158a3c 8a8e05b8 str      w10, [x20, #0x58]!
41158a40 abce0578 strh     w11, [x21, #0x5c]!
41158a44 28010039 strb     w8, [x9]
41158a48 c2820091 add      x2, x22, #0x20
41158a4c 68264f29 ldp      w8, w9, [x19, #0x78]
41158a50 c00240b9 ldr      w0, [x22]
41158a54 c4320191 add      x4, x22, #0x4c
41158a58 e10314aa mov      x1, x20
41158a5c cc5600b9 str      w12, [x22, #0x54]
41158a60 e30315aa mov      x3, x21
41158a64 c86200b9 str      w8, [x22, #0x60]
41158a68 c97200b9 str      w9, [x22, #0x70]
41158a6c eb720094 bl       #0x41175618
41158a70 800240b9 ldr      w0, [x20]
41158a74 a1024079 ldrh     w1, [x21]
41158a78 79700094 bl       #0x41174c5c
41158a7c c0e200b9 str      w0, [x22, #0xe0]
41158a80 69724139 ldrb     w9, [x19, #0x5c]
41158a84 c8b240b9 ldr      w8, [x22, #0xb0]
41158a88 c9060339 strb     w9, [x22, #0xc1]
41158a8c 696240b9 ldr      w9, [x19, #0x60]
41158a90 dfc20539 strb     wzr, [x22, #0x170]
41158a94 c9a61829 stp      w9, w9, [x22, #0xc4]
41158a98 48000034 cbz      w8, #0x41158aa0
41158a9c dfb200b9 str      wzr, [x22, #0xb0]
41158aa0 638240b9 ldr      w3, [x19, #0x80]
41158aa4 dffe0729 stp      wzr, wzr, [x22, #0x3c]
41158aa8 c00240b9 ldr      w0, [x22]
41158aac c3b600b9 str      w3, [x22, #0xb4]
41158ab0 680a4179 ldrh     w8, [x19, #0x84]
41158ab4 df020339 strb     wzr, [x22, #0xc0]
41158ab8 df7601b9 str      wzr, [x22, #0x174]
41158abc df9e0179 strh     wzr, [x22, #0xce]
41158ac0 c8020379 strh     w8, [x22, #0x180]
41158ac4 08540051 sub      w8, w0, #0x15
41158ac8 1f090071 cmp      w8, #2
41158acc dfda00b9 str      wzr, [x22, #0xd8]
41158ad0 df4a00f9 str      xzr, [x22, #0x90]
41158ad4 df9a00b9 str      wzr, [x22, #0x98]
41158ad8 dfd200b9 str      wzr, [x22, #0xd0]
41158adc e2000054 b.hs     #0x41158af8
41158ae0 df4a00b9 str      wzr, [x22, #0x48]
41158ae4 df520339 strb     wzr, [x22, #0xd4]
41158ae8 03020034 cbz      w3, #0x41158b28
41158aec 1f540071 cmp      w0, #0x15
41158af0 00030054 b.eq     #0x41158b50
41158af4 0d000014 b        #0x41158b28
41158af8 68424239 ldrb     w8, [x19, #0x90]
41158afc a8000034 cbz      w8, #0x41158b10
41158b00 1f050071 cmp      w8, #1
41158b04 a1000054 b.ne     #0x41158b18
41158b08 e9031f32 mov      w9, #2
41158b0c 05000014 b        #0x41158b20
41158b10 e9031f2a mov      w9, wzr
41158b14 03000014 b        #0x41158b20
41158b18 e9031f2a mov      w9, wzr
41158b1c e8031f2a mov      w8, wzr
41158b20 c94a00b9 str      w9, [x22, #0x48]
41158b24 c8520339 strb     w8, [x22, #0xd4]
41158b28 c1aa40b9 ldr      w1, [x22, #0xa8]
41158b2c c5620091 add      x5, x22, #0x18
41158b30 c4b24239 ldrb     w4, [x22, #0xac]
41158b34 e2031f2a mov      w2, wzr
41158b38 4b6f0094 bl       #0x41174864
41158b3c c80240b9 ldr      w8, [x22]
41158b40 e103002a mov      w1, w0
41158b44 e003082a mov      w0, w8
41158b48 e0740094 bl       #0x41175ec8
41158b4c c08e0239 strb     w0, [x22, #0xa3]
41158b50 68464239 ldrb     w8, [x19, #0x91]
41158b54 c8760239 strb     w8, [x22, #0x9d]
41158b58 684a4239 ldrb     w8, [x19, #0x92]
41158b5c c87a0239 strb     w8, [x22, #0x9e]
41158b60 684e4239 ldrb     w8, [x19, #0x93]
41158b64 c87e0239 strb     w8, [x22, #0x9f]
41158b68 68524239 ldrb     w8, [x19, #0x94]
41158b6c c8720239 strb     w8, [x22, #0x9c]
41158b70 68564239 ldrb     w8, [x19, #0x95]
41158b74 69964239 ldrb     w9, [x19, #0xa5]
41158b78 6a924239 ldrb     w10, [x19, #0xa4]
41158b7c c8860239 strb     w8, [x22, #0xa1]
41158b80 685a4239 ldrb     w8, [x19, #0x96]
41158b84 c94e0639 strb     w9, [x22, #0x193]
41158b88 699a4239 ldrb     w9, [x19, #0xa6]
41158b8c c9520639 strb     w9, [x22, #0x194]
41158b90 699e4239 ldrb     w9, [x19, #0xa7]
41158b94 c95a0639 strb     w9, [x22, #0x196]
41158b98 69a24239 ldrb     w9, [x19, #0xa8]
41158b9c c95e0639 strb     w9, [x22, #0x197]
41158ba0 69a64239 ldrb     w9, [x19, #0xa9]
41158ba4 c9620639 strb     w9, [x22, #0x198]
41158ba8 69aa4239 ldrb     w9, [x19, #0xaa]
41158bac c9660639 strb     w9, [x22, #0x199]
41158bb0 69ae4239 ldrb     w9, [x19, #0xab]
41158bb4 c88a0239 strb     w8, [x22, #0xa2]
41158bb8 ca820239 strb     w10, [x22, #0xa0]
41158bbc c9820639 strb     w9, [x22, #0x1a0]
41158bc0 72720094 bl       #0x41175588
41158bc4 08000012 and      w8, w0, #1
41158bc8 c8460639 strb     w8, [x22, #0x191]
41158bcc 9f9b0094 bl       #0x4117fa48
41158bd0 08000012 and      w8, w0, #1
41158bd4 e0070032 mov      w0, #3
41158bd8 e1031f2a mov      w1, wzr
41158bdc e2031f2a mov      w2, wzr
41158be0 c84a0639 strb     w8, [x22, #0x192]
41158be4 e3031f2a mov      w3, wzr
41158be8 ce7d0094 bl       #0x41178320
41158bec f37b49a9 ldp      x19, x30, [sp, #0x90]
41158bf0 f55348a9 ldp      x21, x20, [sp, #0x80]
41158bf4 f63b40f9 ldr      x22, [sp, #0x70]
41158bf8 e0031f2a mov      w0, wzr
41158bfc ff830291 add      sp, sp, #0xa0
41158c00 c0035fd6 ret

; apply_configuration_excerpt [0x41158c04, 0x41158ce0); SHA-256 7ccf118510504f5919a4217665e34600e223810c9e56282779b49853c1a7b0d3
41158c04 ff8303d1 sub      sp, sp, #0xe0
41158c08 fc6f08a9 stp      x28, x27, [sp, #0x80]
41158c0c fa6709a9 stp      x26, x25, [sp, #0x90]
41158c10 f85f0aa9 stp      x24, x23, [sp, #0xa0]
41158c14 f6570ba9 stp      x22, x21, [sp, #0xb0]
41158c18 f44f0ca9 stp      x20, x19, [sp, #0xc0]
41158c1c fd7b0da9 stp      x29, x30, [sp, #0xd0]
41158c20 f703012a mov      w23, w1
41158c24 f503002a mov      w21, w0
41158c28 f6020012 and      w22, w23, #1
41158c2c a1020012 and      w1, w21, #1
41158c30 e0031e32 mov      w0, #4
41158c34 e203162a mov      w2, w22
41158c38 e3031f2a mov      w3, wzr
41158c3c a57d0094 bl       #0x411782d0
41158c40 14fc9dd2 mov      x20, #0xefe0
41158c44 d492a0f2 movk     x20, #0x496, lsl #16
41158c48 5401c0f2 movk     x20, #0xa, lsl #32
41158c4c 1400e0f2 movk     x20, #0, lsl #48
41158c50 81008052 mov      w1, #4
41158c54 0101a072 movk     w1, #8, lsl #16
41158c58 e00314aa mov      x0, x20
41158c5c 1b4cef97 bl       #0x40d2bcc8
41158c60 1b859ed2 mov      x27, #0xf428
41158c64 db92a0f2 movk     x27, #0x496, lsl #16
41158c68 5b01c0f2 movk     x27, #0xa, lsl #32
41158c6c 1b00e0f2 movk     x27, #0, lsl #48
41158c70 e0031baa mov      x0, x27
41158c74 de6c0094 bl       #0x41173fec
41158c78 139d9bd2 mov      x19, #0xdce8
41158c7c 7353a0f2 movk     x19, #0x29b, lsl #16
41158c80 5301c0f2 movk     x19, #0xa, lsl #32
41158c84 1300e0f2 movk     x19, #0, lsl #48
41158c88 e00313aa mov      x0, x19
41158c8c fd640094 bl       #0x41172080
41158c90 f903002a mov      w25, w0
41158c94 e00313aa mov      x0, x19
41158c98 ba660094 bl       #0x41172780
41158c9c 68ee4179 ldrh     w8, [x19, #0xf6]
41158ca0 fa03002a mov      w26, w0
41158ca4 69d64179 ldrh     w9, [x19, #0xea]
41158ca8 e00313aa mov      x0, x19
41158cac 6a4e4279 ldrh     w10, [x19, #0x126]
41158cb0 68ea0179 strh     w8, [x19, #0xf4]
41158cb4 69d20179 strh     w9, [x19, #0xe8]
41158cb8 6a4a0279 strh     w10, [x19, #0x124]
41158cbc 37690094 bl       #0x41173198
41158cc0 f803002a mov      w24, w0
41158cc4 e00313aa mov      x0, x19
41158cc8 9c6c0094 bl       #0x41173f38
41158ccc e00313aa mov      x0, x19
41158cd0 696c0094 bl       #0x41173e74
41158cd4 e0031baa mov      x0, x27
41158cd8 e10313aa mov      x1, x19
41158cdc cb6c0094 bl       #0x41174008

; request_to_backend_mode [0x411717f4, 0x41171964); SHA-256 72cbba6f9ce9b1463e684c0103f071fd0c25f3595283a0348679c0c963b1c7a8
411717f4 e80300aa mov      x8, x0
411717f8 e0031f2a mov      w0, wzr
411717fc 090140b9 ldr      w9, [x8]
41171800 3f210071 cmp      w9, #8
41171804 28080054 b.hi     #0x41171908
41171808 0aef92d2 mov      x10, #0x9778
4117180c 2a55a0f2 movk     x10, #0x2a9, lsl #16
41171810 4a01c0f2 movk     x10, #0xa, lsl #32
41171814 0a00e0f2 movk     x10, #0, lsl #48
41171818 497969f8 ldr      x9, [x10, x9, lsl #3]
4117181c 20011fd6 br       x9
41171820 090540b9 ldr      w9, [x8, #4]
41171824 3f090071 cmp      w9, #2
41171828 01040054 b.ne     #0x411718a8
4117182c e0031e32 mov      w0, #4
41171830 c0035fd6 ret
41171834 80028052 mov      w0, #0x14
41171838 c0035fd6 ret
4117183c 090d40b9 ldr      w9, [x8, #0xc]
41171840 3f050071 cmp      w9, #1
41171844 00050054 b.eq     #0x411718e4
41171848 3f090071 cmp      w9, #2
4117184c 00060054 b.eq     #0x4117190c
41171850 3f0d0071 cmp      w9, #3
41171854 41040054 b.ne     #0x411718dc
41171858 080540b9 ldr      w8, [x8, #4]
4117185c e90b0032 mov      w9, #7
41171860 ea0f0032 mov      w10, #0xf
41171864 1f210071 cmp      w8, #8
41171868 4a01891a csel     w10, w10, w9, eq
4117186c 1f110071 cmp      w8, #4
41171870 20018a1a csel     w0, w9, w10, eq
41171874 c0035fd6 ret
41171878 a0028052 mov      w0, #0x15
4117187c c0035fd6 ret
41171880 c0028052 mov      w0, #0x16
41171884 c0035fd6 ret
41171888 080540b9 ldr      w8, [x8, #4]
4117188c 48050034 cbz      w8, #0x41171934
41171890 1f1d0071 cmp      w8, #7
41171894 00020054 b.eq     #0x411718d4
41171898 1f110071 cmp      w8, #4
4117189c c1010054 b.ne     #0x411718d4
411718a0 e00b0032 mov      w0, #7
411718a4 c0035fd6 ret
411718a8 09814039 ldrb     w9, [x8, #0x20]
411718ac 89040034 cbz      w9, #0x4117193c
411718b0 082580b9 ldrsw    x8, [x8, #0x24]
411718b4 1f110071 cmp      w8, #4
411718b8 22010054 b.hs     #0x411718dc
411718bc 092695d2 mov      x9, #0xa930
411718c0 4955a0f2 movk     x9, #0x2aa, lsl #16
411718c4 4901c0f2 movk     x9, #0xa, lsl #32
411718c8 0900e0f2 movk     x9, #0, lsl #48
411718cc 207968b8 ldr      w0, [x9, x8, lsl #2]
411718d0 c0035fd6 ret
411718d4 e00b1f32 mov      w0, #0xe
411718d8 c0035fd6 ret
411718dc e0031f2a mov      w0, wzr
411718e0 c0035fd6 ret
411718e4 080540b9 ldr      w8, [x8, #4]
411718e8 08150051 sub      w8, w8, #5
411718ec 1f110071 cmp      w8, #4
411718f0 e2020054 b.hs     #0x4117194c
411718f4 092895d2 mov      x9, #0xa940
411718f8 4955a0f2 movk     x9, #0x2aa, lsl #16
411718fc 4901c0f2 movk     x9, #0xa, lsl #32
41171900 0900e0f2 movk     x9, #0, lsl #48
41171904 20d968b8 ldr      w0, [x9, w8, sxtw #2]
41171908 c0035fd6 ret
4117190c 080540b9 ldr      w8, [x8, #4]
41171910 08110051 sub      w8, w8, #4
41171914 1f150071 cmp      w8, #5
41171918 e2010054 b.hs     #0x41171954
4117191c 09ca94d2 mov      x9, #0xa650
41171920 4955a0f2 movk     x9, #0x2aa, lsl #16
41171924 4901c0f2 movk     x9, #0xa, lsl #32
41171928 0900e0f2 movk     x9, #0, lsl #48
4117192c 20d968b8 ldr      w0, [x9, w8, sxtw #2]
41171930 c0035fd6 ret
41171934 e0031f32 mov      w0, #2
41171938 c0035fd6 ret
4117193c 09b14039 ldrb     w9, [x8, #0x2c]
41171940 e9000034 cbz      w9, #0x4117195c
41171944 e0030032 mov      w0, #1
41171948 c0035fd6 ret
4117194c 20028052 mov      w0, #0x11
41171950 c0035fd6 ret
41171954 e00f0032 mov      w0, #0xf
41171958 c0035fd6 ret
4117195c 00b54039 ldrb     w0, [x8, #0x2d]
41171960 c0035fd6 ret

; parameter_pointer_setter [0x41166d54, 0x41166d6c); SHA-256 0e1371b0b4081d0ceceb65a44512d44de4f5c658e9b436cbf5a14664b0014305
41166d54 08d49ed2 mov      x8, #0xf6a0
41166d58 c892a0f2 movk     x8, #0x496, lsl #16
41166d5c 4801c0f2 movk     x8, #0xa, lsl #32
41166d60 0800e0f2 movk     x8, #0, lsl #48
41166d64 000100f9 str      x0, [x8]
41166d68 c0035fd6 ret

; command_dispatcher [0x41166d6c, 0x411679dc); SHA-256 946babc20b11a1820faf50c829bbe5d9e41b703c53c39ac61c5fb9dfe34fca0a
41166d6c ff0301d1 sub      sp, sp, #0x40
41166d70 f60b00f9 str      x22, [sp, #0x10]
41166d74 f55302a9 stp      x21, x20, [sp, #0x20]
41166d78 f37b03a9 stp      x19, x30, [sp, #0x30]
41166d7c f30301aa mov      x19, x1
41166d80 f403002a mov      w20, w0
41166d84 e00313aa mov      x0, x19
41166d88 15030094 bl       #0x411679dc
41166d8c e83f0032 mov      w8, #0xffff
41166d90 1f00086b cmp      w0, w8
41166d94 200e0054 b.eq     #0x41166f58
41166d98 16ce93d2 mov      x22, #0x9e70
41166d9c e803142a mov      w8, w20
41166da0 3655a0f2 movk     x22, #0x2a9, lsl #16
41166da4 09ed7cd3 lsl      x9, x8, #4
41166da8 5601c0f2 movk     x22, #0xa, lsl #32
41166dac 294134cb sub      x9, x9, w20, uxtw
41166db0 1600e0f2 movk     x22, #0, lsl #48
41166db4 c902098b add      x9, x22, x9
41166db8 35496038 ldrb     w21, [x9, w0, uxtw]
41166dbc bffe03f1 cmp      x21, #0xff
41166dc0 c00c0054 b.eq     #0x41166f58
41166dc4 9fba0071 cmp      w20, #0x2e
41166dc8 28030054 b.hi     #0x41166e2c
41166dcc 091692d2 mov      x9, #0x90b0
41166dd0 2955a0f2 movk     x9, #0x2a9, lsl #16
41166dd4 4901c0f2 movk     x9, #0xa, lsl #32
41166dd8 0900e0f2 movk     x9, #0, lsl #48
41166ddc 287968f8 ldr      x8, [x9, x8, lsl #3]
41166de0 00011fd6 br       x8
41166de4 75d64179 ldrh     w21, [x19, #0xea]
41166de8 9f1e0071 cmp      w20, #7
41166dec 813d0054 b.ne     #0x4116759c
41166df0 e00313aa mov      x0, x19
41166df4 fa020094 bl       #0x411679dc
41166df8 c842208b add      x8, x22, w0, uxtw
41166dfc 08a54139 ldrb     w8, [x8, #0x69]
41166e00 1ffd03f1 cmp      x8, #0xff
41166e04 a00a0054 b.eq     #0x41166f58
41166e08 09d49ed2 mov      x9, #0xf6a0
41166e0c c992a0f2 movk     x9, #0x496, lsl #16
41166e10 4901c0f2 movk     x9, #0xa, lsl #32
41166e14 0900e0f2 movk     x9, #0, lsl #48
41166e18 290140f9 ldr      x9, [x9]
41166e1c 2811088b add      x8, x9, x8, lsl #4
41166e20 095a8f52 mov      w9, #0x7ad0
41166e24 c901a072 movk     w9, #0xe, lsl #16
41166e28 e4010014 b        #0x411675b8
41166e2c e0031f2a mov      w0, wzr
41166e30 ca010014 b        #0x41167558
41166e34 08d49ed2 mov      x8, #0xf6a0
41166e38 c892a0f2 movk     x8, #0x496, lsl #16
41166e3c 4801c0f2 movk     x8, #0xa, lsl #32
41166e40 0800e0f2 movk     x8, #0, lsl #48
41166e44 09108152 mov      w9, #0x880
41166e48 0a028952 mov      w10, #0x4810
41166e4c 080140f9 ldr      x8, [x8]
41166e50 0b188a52 mov      w11, #0x50c0
41166e54 1f010014 b        #0x411672d0
41166e58 08d49ed2 mov      x8, #0xf6a0
41166e5c c892a0f2 movk     x8, #0x496, lsl #16
41166e60 4801c0f2 movk     x8, #0xa, lsl #32
41166e64 0800e0f2 movk     x8, #0, lsl #48
41166e68 09588a52 mov      w9, #0x52c0
41166e6c 0a5e8a52 mov      w10, #0x52f0
41166e70 54010014 b        #0x411673c0
41166e74 08d49ed2 mov      x8, #0xf6a0
41166e78 c892a0f2 movk     x8, #0x496, lsl #16
41166e7c 4801c0f2 movk     x8, #0xa, lsl #32
41166e80 0800e0f2 movk     x8, #0, lsl #48
41166e84 e9071c32 mov      w9, #0x30
41166e88 0a7e8a52 mov      w10, #0x53f0
41166e8c 080140f9 ldr      x8, [x8]
41166e90 0b908a52 mov      w11, #0x5480
41166e94 0f010014 b        #0x411672d0
41166e98 08d49ed2 mov      x8, #0xf6a0
41166e9c c892a0f2 movk     x8, #0x496, lsl #16
41166ea0 4801c0f2 movk     x8, #0xa, lsl #32
41166ea4 0800e0f2 movk     x8, #0, lsl #48
41166ea8 09b08a52 mov      w9, #0x5580
41166eac 0ab68a52 mov      w10, #0x55b0
41166eb0 44010014 b        #0x411673c0
41166eb4 08d49ed2 mov      x8, #0xf6a0
41166eb8 c892a0f2 movk     x8, #0x496, lsl #16
41166ebc 4801c0f2 movk     x8, #0xa, lsl #32
41166ec0 0800e0f2 movk     x8, #0, lsl #48
41166ec4 09d68a52 mov      w9, #0x56b0
41166ec8 0ae28a52 mov      w10, #0x5710
41166ecc e3000014 b        #0x41167258
41166ed0 08d49ed2 mov      x8, #0xf6a0
41166ed4 c892a0f2 movk     x8, #0x496, lsl #16
41166ed8 4801c0f2 movk     x8, #0xa, lsl #32
41166edc 0800e0f2 movk     x8, #0, lsl #48
41166ee0 0a028b52 mov      w10, #0x5810
41166ee4 06000014 b        #0x41166efc
41166ee8 08d49ed2 mov      x8, #0xf6a0
41166eec c892a0f2 movk     x8, #0x496, lsl #16
41166ef0 4801c0f2 movk     x8, #0xa, lsl #32
41166ef4 0800e0f2 movk     x8, #0, lsl #48
41166ef8 0a988e52 mov      w10, #0x74c0
41166efc f3031f2a mov      w19, wzr
41166f00 080140f9 ldr      x8, [x8]
41166f04 09368052 mov      w9, #0x1b0
41166f08 ca01a072 movk     w10, #0xe, lsl #16
41166f0c 0b3a8f52 mov      w11, #0x79d0
41166f10 a922099b madd     x9, x21, x9, x8
41166f14 cb01a072 movk     w11, #0xe, lsl #16
41166f18 f2000014 b        #0x411672e0
41166f1c e00313aa mov      x0, x19
41166f20 af020094 bl       #0x411679dc
41166f24 c842208b add      x8, x22, w0, uxtw
41166f28 081d4239 ldrb     w8, [x8, #0x87]
41166f2c 1ffd03f1 cmp      x8, #0xff
41166f30 40010054 b.eq     #0x41166f58
41166f34 09d49ed2 mov      x9, #0xf6a0
41166f38 c992a0f2 movk     x9, #0x496, lsl #16
41166f3c 4901c0f2 movk     x9, #0xa, lsl #32
41166f40 0900e0f2 movk     x9, #0, lsl #48
41166f44 290140f9 ldr      x9, [x9]
41166f48 2811088b add      x8, x9, x8, lsl #4
41166f4c 09a88f52 mov      w9, #0x7d40
41166f50 c901a072 movk     w9, #0xe, lsl #16
41166f54 0a000014 b        #0x41166f7c
41166f58 e0030032 mov      w0, #1
41166f5c 7f010014 b        #0x41167558
41166f60 08d49ed2 mov      x8, #0xf6a0
41166f64 c892a0f2 movk     x8, #0x496, lsl #16
41166f68 4801c0f2 movk     x8, #0xa, lsl #32
41166f6c 0800e0f2 movk     x8, #0, lsl #48
41166f70 09ca8f52 mov      w9, #0x7e50
41166f74 c901a072 movk     w9, #0xe, lsl #16
41166f78 080140f9 ldr      x8, [x8]
41166f7c e00313aa mov      x0, x19
41166f80 e1031faa mov      x1, xzr
41166f84 1401098b add      x20, x8, x9
41166f88 8b1a0094 bl       #0x4116d9b4
41166f8c e80300aa mov      x8, x0
41166f90 6a724279 ldrh     w10, [x19, #0x138]
41166f94 80ff9fd2 mov      x0, #0xfffc
41166f98 69824279 ldrh     w9, [x19, #0x140]
41166f9c c092a0f2 movk     x0, #0x496, lsl #16
41166fa0 4001c0f2 movk     x0, #0xa, lsl #32
41166fa4 0000e0f2 movk     x0, #0, lsl #48
41166fa8 4b7d0853 lsr      w11, w10, #8
41166fac 2d7d0853 lsr      w13, w9, #8
41166fb0 0b100039 strb     w11, [x0, #4]
41166fb4 810780d2 mov      x1, #0x3c
41166fb8 09140039 strb     w9, [x0, #5]
41166fbc e192a0f2 movk     x1, #0x497, lsl #16
41166fc0 0d180039 strb     w13, [x0, #6]
41166fc4 4101c0f2 movk     x1, #0xa, lsl #32
41166fc8 8b0e4039 ldrb     w11, [x20, #3]
41166fcc ac0c8052 mov      w12, #0x65
41166fd0 ed031d32 mov      w13, #8
41166fd4 0a0c0039 strb     w10, [x0, #3]
41166fd8 0100e0f2 movk     x1, #0, lsl #48
41166fdc 0c080039 strb     w12, [x0, #2]
41166fe0 29108052 mov      w9, #0x81
41166fe4 0b1c0039 strb     w11, [x0, #7]
41166fe8 0bd49ed2 mov      x11, #0xf6a0
41166fec 6a0d8052 mov      w10, #0x6b
41166ff0 2d000079 strh     w13, [x1]
41166ff4 cb92a0f2 movk     x11, #0x496, lsl #16
41166ff8 6cea4439 ldrb     w12, [x19, #0x13a]
41166ffc 4b01c0f2 movk     x11, #0xa, lsl #32
41167000 09100079 strh     w9, [x0, #8]
41167004 0b00e0f2 movk     x11, #0, lsl #48
41167008 0a280039 strb     w10, [x0, #0xa]
4116700c 8d1e4039 ldrb     w13, [x20, #7]
41167010 0c300039 strb     w12, [x0, #0xc]
41167014 0c8a8852 mov      w12, #0x4450
41167018 6a0140f9 ldr      x10, [x11]
4116701c cc01a072 movk     w12, #0xe, lsl #16
41167020 8b2e4039 ldrb     w11, [x20, #0xb]
41167024 6e0a4539 ldrb     w14, [x19, #0x142]
41167028 0d2c0039 strb     w13, [x0, #0xb]
4116702c ed0b0032 mov      w13, #7
41167030 4c696c38 ldrb     w12, [x10, x12]
41167034 0b340039 strb     w11, [x0, #0xd]
41167038 0bfd60d3 lsr      x11, x8, #0x20
4116703c 0e380039 strb     w14, [x0, #0xe]
41167040 2d040079 strh     w13, [x1, #2]
41167044 09000079 strh     w9, [x0]
41167048 ec3500b4 cbz      x12, #0x41167704
4116704c 9f390071 cmp      w12, #0xe
41167050 e9350054 b.ls     #0x4116770c
41167054 ec031f2a mov      w12, wzr
41167058 c6010014 b        #0x41167770
4116705c 08d49ed2 mov      x8, #0xf6a0
41167060 c892a0f2 movk     x8, #0x496, lsl #16
41167064 4801c0f2 movk     x8, #0xa, lsl #32
41167068 0800e0f2 movk     x8, #0, lsl #48
4116706c 09f68f52 mov      w9, #0x7fb0
41167070 06000014 b        #0x41167088
41167074 08d49ed2 mov      x8, #0xf6a0
41167078 c892a0f2 movk     x8, #0x496, lsl #16
4116707c 4801c0f2 movk     x8, #0xa, lsl #32
41167080 0800e0f2 movk     x8, #0, lsl #48
41167084 093a9052 mov      w9, #0x81d0
41167088 c901a072 movk     w9, #0xe, lsl #16
4116708c 080140f9 ldr      x8, [x8]
41167090 0a469052 mov      w10, #0x8230
41167094 09000014 b        #0x411670b8
41167098 08d49ed2 mov      x8, #0xf6a0
4116709c c892a0f2 movk     x8, #0x496, lsl #16
411670a0 4801c0f2 movk     x8, #0xa, lsl #32
411670a4 0800e0f2 movk     x8, #0, lsl #48
411670a8 09669052 mov      w9, #0x8330
411670ac 0aaa9052 mov      w10, #0x8550
411670b0 080140f9 ldr      x8, [x8]
411670b4 c901a072 movk     w9, #0xe, lsl #16
411670b8 ca01a072 movk     w10, #0xe, lsl #16
411670bc 0b15158b add      x11, x8, x21, lsl #5
411670c0 e4000014 b        #0x41167450
411670c4 08d49ed2 mov      x8, #0xf6a0
411670c8 c892a0f2 movk     x8, #0x496, lsl #16
411670cc 4801c0f2 movk     x8, #0xa, lsl #32
411670d0 0800e0f2 movk     x8, #0, lsl #48
411670d4 09ca9052 mov      w9, #0x8650
411670d8 0a0e9152 mov      w10, #0x8870
411670dc 5f000014 b        #0x41167258
411670e0 08d49ed2 mov      x8, #0xf6a0
411670e4 c892a0f2 movk     x8, #0x496, lsl #16
411670e8 4801c0f2 movk     x8, #0xa, lsl #32
411670ec 0800e0f2 movk     x8, #0, lsl #48
411670f0 092e9152 mov      w9, #0x8970
411670f4 0a729152 mov      w10, #0x8b90
411670f8 58000014 b        #0x41167258
411670fc 08d49ed2 mov      x8, #0xf6a0
41167100 c892a0f2 movk     x8, #0x496, lsl #16
41167104 4801c0f2 movk     x8, #0xa, lsl #32
41167108 0800e0f2 movk     x8, #0, lsl #48
4116710c 09929152 mov      w9, #0x8c90
41167110 0ad69152 mov      w10, #0x8eb0
41167114 51000014 b        #0x41167258
41167118 08d49ed2 mov      x8, #0xf6a0
4116711c c892a0f2 movk     x8, #0x496, lsl #16
41167120 4801c0f2 movk     x8, #0xa, lsl #32
41167124 0800e0f2 movk     x8, #0, lsl #48
41167128 09f69152 mov      w9, #0x8fb0
4116712c 06000014 b        #0x41167144
41167130 08d49ed2 mov      x8, #0xf6a0
41167134 c892a0f2 movk     x8, #0x496, lsl #16
41167138 4801c0f2 movk     x8, #0xa, lsl #32
4116713c 0800e0f2 movk     x8, #0, lsl #48
41167140 093a9252 mov      w9, #0x91d0
41167144 f3031f2a mov      w19, wzr
41167148 080140f9 ldr      x8, [x8]
4116714c c901a072 movk     w9, #0xe, lsl #16
41167150 0a469252 mov      w10, #0x9230
41167154 44000014 b        #0x41167264
41167158 08d49ed2 mov      x8, #0xf6a0
4116715c c892a0f2 movk     x8, #0x496, lsl #16
41167160 4801c0f2 movk     x8, #0xa, lsl #32
41167164 0800e0f2 movk     x8, #0, lsl #48
41167168 09669252 mov      w9, #0x9330
4116716c 0a889252 mov      w10, #0x9440
41167170 94000014 b        #0x411673c0
41167174 08d49ed2 mov      x8, #0xf6a0
41167178 c892a0f2 movk     x8, #0x496, lsl #16
4116717c 4801c0f2 movk     x8, #0xa, lsl #32
41167180 0800e0f2 movk     x8, #0, lsl #48
41167184 09a89252 mov      w9, #0x9540
41167188 0aca9252 mov      w10, #0x9650
4116718c 8d000014 b        #0x411673c0
41167190 08d49ed2 mov      x8, #0xf6a0
41167194 c892a0f2 movk     x8, #0x496, lsl #16
41167198 4801c0f2 movk     x8, #0xa, lsl #32
4116719c 0800e0f2 movk     x8, #0, lsl #48
411671a0 e9071c32 mov      w9, #0x30
411671a4 0aea9252 mov      w10, #0x9750
411671a8 080140f9 ldr      x8, [x8]
411671ac 0b509352 mov      w11, #0x9a80
411671b0 48000014 b        #0x411672d0
411671b4 08d49ed2 mov      x8, #0xf6a0
411671b8 c892a0f2 movk     x8, #0x496, lsl #16
411671bc 4801c0f2 movk     x8, #0xa, lsl #32
411671c0 0800e0f2 movk     x8, #0, lsl #48
411671c4 09709352 mov      w9, #0x9b80
411671c8 0ab49352 mov      w10, #0x9da0
411671cc 23000014 b        #0x41167258
411671d0 08d49ed2 mov      x8, #0xf6a0
411671d4 c892a0f2 movk     x8, #0x496, lsl #16
411671d8 4801c0f2 movk     x8, #0xa, lsl #32
411671dc 0800e0f2 movk     x8, #0, lsl #48
411671e0 09d49352 mov      w9, #0x9ea0
411671e4 0af69352 mov      w10, #0x9fb0
411671e8 76000014 b        #0x411673c0
411671ec 08d49ed2 mov      x8, #0xf6a0
411671f0 c892a0f2 movk     x8, #0x496, lsl #16
411671f4 4801c0f2 movk     x8, #0xa, lsl #32
411671f8 0800e0f2 movk     x8, #0, lsl #48
411671fc 09169452 mov      w9, #0xa0b0
41167200 0a389452 mov      w10, #0xa1c0
41167204 6f000014 b        #0x411673c0
41167208 08d49ed2 mov      x8, #0xf6a0
4116720c c892a0f2 movk     x8, #0x496, lsl #16
41167210 4801c0f2 movk     x8, #0xa, lsl #32
41167214 0800e0f2 movk     x8, #0, lsl #48
41167218 09589452 mov      w9, #0xa2c0
4116721c 0a7a9452 mov      w10, #0xa3d0
41167220 68000014 b        #0x411673c0
41167224 08d49ed2 mov      x8, #0xf6a0
41167228 c892a0f2 movk     x8, #0x496, lsl #16
4116722c 4801c0f2 movk     x8, #0xa, lsl #32
41167230 0800e0f2 movk     x8, #0, lsl #48
41167234 099a9452 mov      w9, #0xa4d0
41167238 0ade9452 mov      w10, #0xa6f0
4116723c 07000014 b        #0x41167258
41167240 08d49ed2 mov      x8, #0xf6a0
41167244 c892a0f2 movk     x8, #0x496, lsl #16
41167248 4801c0f2 movk     x8, #0xa, lsl #32
4116724c 0800e0f2 movk     x8, #0, lsl #48
41167250 09fe9452 mov      w9, #0xa7f0
41167254 0a429552 mov      w10, #0xaa10
41167258 080140f9 ldr      x8, [x8]
4116725c f3031f2a mov      w19, wzr
41167260 c901a072 movk     w9, #0xe, lsl #16
41167264 ca01a072 movk     w10, #0xe, lsl #16
41167268 0b15158b add      x11, x8, x21, lsl #5
4116726c b5000014 b        #0x41167540
41167270 08d49ed2 mov      x8, #0xf6a0
41167274 c892a0f2 movk     x8, #0x496, lsl #16
41167278 4801c0f2 movk     x8, #0xa, lsl #32
4116727c 0800e0f2 movk     x8, #0, lsl #48
41167280 09629552 mov      w9, #0xab10
41167284 0a849552 mov      w10, #0xac20
41167288 4e000014 b        #0x411673c0
4116728c 08d49ed2 mov      x8, #0xf6a0
41167290 c892a0f2 movk     x8, #0x496, lsl #16
41167294 4801c0f2 movk     x8, #0xa, lsl #32
41167298 0800e0f2 movk     x8, #0, lsl #48
4116729c e9071a32 mov      w9, #0xc0
411672a0 0aa49552 mov      w10, #0xad20
411672a4 080140f9 ldr      x8, [x8]
411672a8 0b3c9752 mov      w11, #0xb9e0
411672ac 09000014 b        #0x411672d0
411672b0 08d49ed2 mov      x8, #0xf6a0
411672b4 c892a0f2 movk     x8, #0x496, lsl #16
411672b8 4801c0f2 movk     x8, #0xa, lsl #32
411672bc 0800e0f2 movk     x8, #0, lsl #48
411672c0 e9071c32 mov      w9, #0x30
411672c4 0a5c9752 mov      w10, #0xbae0
411672c8 080140f9 ldr      x8, [x8]
411672cc 0bc29752 mov      w11, #0xbe10
411672d0 f3031f2a mov      w19, wzr
411672d4 ca01a072 movk     w10, #0xe, lsl #16
411672d8 cb01a072 movk     w11, #0xe, lsl #16
411672dc a922099b madd     x9, x21, x9, x8
411672e0 34010a8b add      x20, x9, x10
411672e4 15010b8b add      x21, x8, x11
411672e8 98000014 b        #0x41167548
411672ec 08d49ed2 mov      x8, #0xf6a0
411672f0 c892a0f2 movk     x8, #0x496, lsl #16
411672f4 4801c0f2 movk     x8, #0xa, lsl #32
411672f8 0800e0f2 movk     x8, #0, lsl #48
411672fc 09e29752 mov      w9, #0xbf10
41167300 0a6a9852 mov      w10, #0xc350
41167304 07000014 b        #0x41167320
41167308 08d49ed2 mov      x8, #0xf6a0
4116730c c892a0f2 movk     x8, #0x496, lsl #16
41167310 4801c0f2 movk     x8, #0xa, lsl #32
41167314 0800e0f2 movk     x8, #0, lsl #48
41167318 098a9852 mov      w9, #0xc450
4116731c 0a129952 mov      w10, #0xc890
41167320 080140f9 ldr      x8, [x8]
41167324 f3031f2a mov      w19, wzr
41167328 c901a072 movk     w9, #0xe, lsl #16
4116732c ca01a072 movk     w10, #0xe, lsl #16
41167330 0b19158b add      x11, x8, x21, lsl #6
41167334 83000014 b        #0x41167540
41167338 08d49ed2 mov      x8, #0xf6a0
4116733c c892a0f2 movk     x8, #0x496, lsl #16
41167340 4801c0f2 movk     x8, #0xa, lsl #32
41167344 0800e0f2 movk     x8, #0, lsl #48
41167348 09329952 mov      w9, #0xc990
4116734c 0a389952 mov      w10, #0xc9c0
41167350 1c000014 b        #0x411673c0
41167354 08d49ed2 mov      x8, #0xf6a0
41167358 c892a0f2 movk     x8, #0x496, lsl #16
4116735c 4801c0f2 movk     x8, #0xa, lsl #32
41167360 0800e0f2 movk     x8, #0, lsl #48
41167364 09589952 mov      w9, #0xcac0
41167368 0a5e9952 mov      w10, #0xcaf0
4116736c 15000014 b        #0x411673c0
41167370 08d49ed2 mov      x8, #0xf6a0
41167374 c892a0f2 movk     x8, #0x496, lsl #16
41167378 4801c0f2 movk     x8, #0xa, lsl #32
4116737c 0800e0f2 movk     x8, #0, lsl #48
41167380 097e9952 mov      w9, #0xcbf0
41167384 0a849952 mov      w10, #0xcc20
41167388 0e000014 b        #0x411673c0
4116738c 08d49ed2 mov      x8, #0xf6a0
41167390 c892a0f2 movk     x8, #0x496, lsl #16
41167394 4801c0f2 movk     x8, #0xa, lsl #32
41167398 0800e0f2 movk     x8, #0, lsl #48
4116739c 09a49952 mov      w9, #0xcd20
411673a0 0ac69952 mov      w10, #0xce30
411673a4 07000014 b        #0x411673c0
411673a8 08d49ed2 mov      x8, #0xf6a0
411673ac c892a0f2 movk     x8, #0x496, lsl #16
411673b0 4801c0f2 movk     x8, #0xa, lsl #32
411673b4 0800e0f2 movk     x8, #0, lsl #48
411673b8 09e69952 mov      w9, #0xcf30
411673bc 0a089a52 mov      w10, #0xd040
411673c0 080140f9 ldr      x8, [x8]
411673c4 f3031f2a mov      w19, wzr
411673c8 c901a072 movk     w9, #0xe, lsl #16
411673cc ca01a072 movk     w10, #0xe, lsl #16
411673d0 5b000014 b        #0x4116753c
411673d4 a9010094 bl       #0x41167a78
411673d8 08d49ed2 mov      x8, #0xf6a0
411673dc c892a0f2 movk     x8, #0x496, lsl #16
411673e0 4801c0f2 movk     x8, #0xa, lsl #32
411673e4 0800e0f2 movk     x8, #0, lsl #48
411673e8 09289a52 mov      w9, #0xd140
411673ec 0ae89d52 mov      w10, #0xef40
411673f0 08000014 b        #0x41167410
411673f4 a1010094 bl       #0x41167a78
411673f8 08d49ed2 mov      x8, #0xf6a0
411673fc c892a0f2 movk     x8, #0x496, lsl #16
41167400 4801c0f2 movk     x8, #0xa, lsl #32
41167404 0800e0f2 movk     x8, #0, lsl #48
41167408 09089e52 mov      w9, #0xf040
4116740c 0a889e52 mov      w10, #0xf440
41167410 080140f9 ldr      x8, [x8]
41167414 f303002a mov      w19, w0
41167418 c901a072 movk     w9, #0xe, lsl #16
4116741c ca01a072 movk     w10, #0xe, lsl #16
41167420 0b25158b add      x11, x8, x21, lsl #9
41167424 47000014 b        #0x41167540
41167428 08d49ed2 mov      x8, #0xf6a0
4116742c c892a0f2 movk     x8, #0x496, lsl #16
41167430 4801c0f2 movk     x8, #0xa, lsl #32
41167434 0800e0f2 movk     x8, #0, lsl #48
41167438 09a89e52 mov      w9, #0xf540
4116743c 0ac88052 mov      w10, #0x640
41167440 080140f9 ldr      x8, [x8]
41167444 c901a072 movk     w9, #0xe, lsl #16
41167448 ea01a072 movk     w10, #0xf, lsl #16
4116744c 0b21158b add      x11, x8, x21, lsl #8
41167450 15010a8b add      x21, x8, x10
41167454 7401098b add      x20, x11, x9
41167458 62720591 add      x2, x19, #0x15c
4116745c e00314aa mov      x0, x20
41167460 e10315aa mov      x1, x21
41167464 69010094 bl       #0x41167a08
41167468 f3031f2a mov      w19, wzr
4116746c 37000014 b        #0x41167548
41167470 08d49ed2 mov      x8, #0xf6a0
41167474 c892a0f2 movk     x8, #0x496, lsl #16
41167478 4801c0f2 movk     x8, #0xa, lsl #32
4116747c 0800e0f2 movk     x8, #0, lsl #48
41167480 09ec8052 mov      w9, #0x760
41167484 0aee8052 mov      w10, #0x770
41167488 29000014 b        #0x4116752c
4116748c 08d49ed2 mov      x8, #0xf6a0
41167490 c892a0f2 movk     x8, #0x496, lsl #16
41167494 4801c0f2 movk     x8, #0xa, lsl #32
41167498 0800e0f2 movk     x8, #0, lsl #48
4116749c 090e8152 mov      w9, #0x870
411674a0 0a108152 mov      w10, #0x880
411674a4 22000014 b        #0x4116752c
411674a8 000b80d2 mov      x0, #0x58
411674ac 6b764539 ldrb     w11, [x19, #0x15d]
411674b0 010c80d2 mov      x1, #0x60
411674b4 e092a0f2 movk     x0, #0x497, lsl #16
411674b8 e192a0f2 movk     x1, #0x497, lsl #16
411674bc 4001c0f2 movk     x0, #0xa, lsl #32
411674c0 4101c0f2 movk     x1, #0xa, lsl #32
411674c4 28508052 mov      w8, #0x281
411674c8 49038052 mov      w9, #0x1a
411674cc ea031e32 mov      w10, #4
411674d0 0000e0f2 movk     x0, #0, lsl #48
411674d4 0100e0f2 movk     x1, #0, lsl #48
411674d8 08000079 strh     w8, [x0]
411674dc 09080039 strb     w9, [x0, #2]
411674e0 0b0c0039 strb     w11, [x0, #3]
411674e4 2a0000b9 str      w10, [x1]
411674e8 a5010094 bl       #0x41167b7c
411674ec 68764539 ldrb     w8, [x19, #0x15d]
411674f0 68720539 strb     w8, [x19, #0x15c]
411674f4 19000014 b        #0x41167558
411674f8 08d49ed2 mov      x8, #0xf6a0
411674fc c892a0f2 movk     x8, #0x496, lsl #16
41167500 4801c0f2 movk     x8, #0xa, lsl #32
41167504 0800e0f2 movk     x8, #0, lsl #48
41167508 09548152 mov      w9, #0xaa0
4116750c 0a568152 mov      w10, #0xab0
41167510 07000014 b        #0x4116752c
41167514 08d49ed2 mov      x8, #0xf6a0
41167518 c892a0f2 movk     x8, #0x496, lsl #16
4116751c 4801c0f2 movk     x8, #0xa, lsl #32
41167520 0800e0f2 movk     x8, #0, lsl #48
41167524 09588152 mov      w9, #0xac0
41167528 0a5a8152 mov      w10, #0xad0
4116752c 080140f9 ldr      x8, [x8]
41167530 f3031f2a mov      w19, wzr
41167534 e901a072 movk     w9, #0xf, lsl #16
41167538 ea01a072 movk     w10, #0xf, lsl #16
4116753c 0b11158b add      x11, x8, x21, lsl #4
41167540 7401098b add      x20, x11, x9
41167544 15010a8b add      x21, x8, x10
41167548 e00314aa mov      x0, x20
4116754c e10315aa mov      x1, x21
41167550 8b010094 bl       #0x41167b7c
41167554 0000132a orr      w0, w0, w19
41167558 f37b43a9 ldp      x19, x30, [sp, #0x30]
4116755c f55342a9 ldp      x21, x20, [sp, #0x20]
41167560 f60b40f9 ldr      x22, [sp, #0x10]
41167564 ff030191 add      sp, sp, #0x40
41167568 c0035fd6 ret
4116756c 08d49ed2 mov      x8, #0xf6a0
41167570 c892a0f2 movk     x8, #0x496, lsl #16
41167574 4801c0f2 movk     x8, #0xa, lsl #32
41167578 0800e0f2 movk     x8, #0, lsl #48
4116757c e9071c32 mov      w9, #0x30
41167580 0a5c8152 mov      w10, #0xae0
41167584 080140f9 ldr      x8, [x8]
41167588 0b628152 mov      w11, #0xb10
4116758c f3031f2a mov      w19, wzr
41167590 ea01a072 movk     w10, #0xf, lsl #16
41167594 eb01a072 movk     w11, #0xf, lsl #16
41167598 51ffff17 b        #0x411672dc
4116759c 08d49ed2 mov      x8, #0xf6a0
411675a0 c892a0f2 movk     x8, #0x496, lsl #16
411675a4 4801c0f2 movk     x8, #0xa, lsl #32
411675a8 0800e0f2 movk     x8, #0, lsl #48
411675ac 097c8f52 mov      w9, #0x7be0
411675b0 c901a072 movk     w9, #0xe, lsl #16
411675b4 080140f9 ldr      x8, [x8]
411675b8 00fa9fd2 mov      x0, #0xffd0
411675bc c092a0f2 movk     x0, #0x496, lsl #16
411675c0 4001c0f2 movk     x0, #0xa, lsl #32
411675c4 0801098b add      x8, x8, x9
411675c8 e9031faa mov      x9, xzr
411675cc 0000e0f2 movk     x0, #0, lsl #48
411675d0 0a696938 ldrb     w10, [x8, x9]
411675d4 2b050091 add      x11, x9, #1
411675d8 7f1100f1 cmp      x11, #4
411675dc 0a682938 strb     w10, [x0, x9]
411675e0 e9030baa mov      x9, x11
411675e4 61ffff54 b.ne     #0x411675d0
411675e8 01fe9fd2 mov      x1, #0xfff0
411675ec 680240b9 ldr      w8, [x19]
411675f0 c192a0f2 movk     x1, #0x496, lsl #16
411675f4 4101c0f2 movk     x1, #0xa, lsl #32
411675f8 0100e0f2 movk     x1, #0, lsl #48
411675fc 1f590071 cmp      w8, #0x16
41167600 29000079 strh     w9, [x1]
41167604 60000054 b.eq     #0x41167610
41167608 1f050071 cmp      w8, #1
4116760c 41000054 b.ne     #0x41167614
41167610 f53f0032 mov      w21, #0xffff
41167614 a8098052 mov      w8, #0x4d
41167618 694e4279 ldrh     w9, [x19, #0x126]
4116761c 6a524279 ldrh     w10, [x19, #0x128]
41167620 08180039 strb     w8, [x0, #6]
41167624 685a4279 ldrh     w8, [x19, #0x12c]
41167628 091c0039 strb     w9, [x0, #7]
4116762c 29350853 ubfx     w9, w9, #8, #6
41167630 0a240039 strb     w10, [x0, #9]
41167634 4a2d0853 ubfx     w10, w10, #8, #4
41167638 09200039 strb     w9, [x0, #8]
4116763c 490a8052 mov      w9, #0x52
41167640 0a280039 strb     w10, [x0, #0xa]
41167644 6a5e4279 ldrh     w10, [x19, #0x12e]
41167648 09340039 strb     w9, [x0, #0xd]
4116764c 09350853 ubfx     w9, w8, #8, #6
41167650 08380039 strb     w8, [x0, #0xe]
41167654 093c0039 strb     w9, [x0, #0xf]
41167658 69564279 ldrh     w9, [x19, #0x12a]
4116765c 482d0853 ubfx     w8, w10, #8, #4
41167660 0a400039 strb     w10, [x0, #0x10]
41167664 ea131e32 mov      w10, #0x7c
41167668 6b624279 ldrh     w11, [x19, #0x130]
4116766c 08440039 strb     w8, [x0, #0x11]
41167670 0a500039 strb     w10, [x0, #0x14]
41167674 282d0853 ubfx     w8, w9, #8, #4
41167678 0a0e95d2 mov      x10, #0xa870
4116767c 09540039 strb     w9, [x0, #0x15]
41167680 4a55a0f2 movk     x10, #0x2aa, lsl #16
41167684 08580039 strb     w8, [x0, #0x16]
41167688 29108052 mov      w9, #0x81
4116768c 0b5c0039 strb     w11, [x0, #0x17]
41167690 682d0853 ubfx     w8, w11, #8, #4
41167694 1f140039 strb     wzr, [x0, #5]
41167698 4a01c0f2 movk     x10, #0xa, lsl #32
4116769c 15700039 strb     w21, [x0, #0x1c]
411676a0 0a00e0f2 movk     x10, #0, lsl #48
411676a4 08600039 strb     w8, [x0, #0x18]
411676a8 68018052 mov      w8, #0xb
411676ac 09100039 strb     w9, [x0, #4]
411676b0 092c0039 strb     w9, [x0, #0xb]
411676b4 09480039 strb     w9, [x0, #0x12]
411676b8 09640039 strb     w9, [x0, #0x19]
411676bc 29078052 mov      w9, #0x39
411676c0 4a0140f9 ldr      x10, [x10]
411676c4 08680039 strb     w8, [x0, #0x1a]
411676c8 e80301aa mov      x8, x1
411676cc 096c0039 strb     w9, [x0, #0x1b]
411676d0 a97e0853 lsr      w9, w21, #8
411676d4 1f300039 strb     wzr, [x0, #0xc]
411676d8 0a2d0078 strh     w10, [x8, #2]!
411676dc 4bfd70d3 lsr      x11, x10, #0x30
411676e0 09740039 strb     w9, [x0, #0x1d]
411676e4 49fd60d3 lsr      x9, x10, #0x20
411676e8 1f4c0039 strb     wzr, [x0, #0x13]
411676ec 4afd50d3 lsr      x10, x10, #0x10
411676f0 0b0d0079 strh     w11, [x8, #6]
411676f4 09090079 strh     w9, [x8, #4]
411676f8 2a080079 strh     w10, [x1, #4]
411676fc 3f140079 strh     wzr, [x1, #0xa]
41167700 ac000014 b        #0x411679b0
41167704 ec070032 mov      w12, #3
41167708 1a000014 b        #0x41167770
4116770c 8c050051 sub      w12, w12, #1
41167710 0d328752 mov      w13, #0x3990
41167714 cd01a072 movk     w13, #0xe, lsl #16
41167718 4c452c8b add      x12, x10, w12, uxtw #1
4116771c 6f559552 mov      w15, #0xaaab
41167720 4f55a572 movk     w15, #0x2aaa, lsl #16
41167724 8c696d38 ldrb     w12, [x12, x13]
41167728 6d424529 ldp      w13, w16, [x19, #0x28]
4116772c 8e7d081b mul      w14, w12, w8
41167730 ac7d0c1b mul      w12, w13, w12
41167734 cd7d2f9b smull    x13, w14, w15
41167738 8c7d2f9b smull    x12, w12, w15
4116773c aefd7fd3 lsr      x14, x13, #0x3f
41167740 adfd60d3 lsr      x13, x13, #0x20
41167744 ad010e0b add      w13, w13, w14
41167748 8efd7fd3 lsr      x14, x12, #0x3f
4116774c 8cfd60d3 lsr      x12, x12, #0x20
41167750 bf010b6b cmp      w13, w11
41167754 8e010e0b add      w14, w12, w14
41167758 ec031f32 mov      w12, #2
4116775c edc79f1a cset     w13, le
41167760 8cc58c1a cinc     w12, w12, le
41167764 1f020e6b cmp      w16, w14
41167768 4a000054 b.ge     #0x41167770
4116776c ec030d2a mov      w12, w13
41167770 0c480039 strb     w12, [x0, #0x12]
41167774 0d809052 mov      w13, #0x8400
41167778 8c008052 mov      w12, #4
4116777c 6e3e41b9 ldr      w14, [x19, #0x13c]
41167780 cc00a072 movk     w12, #6, lsl #16
41167784 093c0039 strb     w9, [x0, #0xf]
41167788 0d200079 strh     w13, [x0, #0x10]
4116778c 0d409c52 mov      w13, #0xe200
41167790 2c0400b9 str      w12, [x1, #4]
41167794 cc7d0853 lsr      w12, w14, #8
41167798 0d280079 strh     w13, [x0, #0x14]
4116779c 0e580039 strb     w14, [x0, #0x16]
411677a0 0c5c0039 strb     w12, [x0, #0x17]
411677a4 cc7d1053 lsr      w12, w14, #0x10
411677a8 6d4641b9 ldr      w13, [x19, #0x144]
411677ac 0c600039 strb     w12, [x0, #0x18]
411677b0 0cc09c52 mov      w12, #0xe600
411677b4 094c0039 strb     w9, [x0, #0x13]
411677b8 09640039 strb     w9, [x0, #0x19]
411677bc 0c340079 strh     w12, [x0, #0x1a]
411677c0 ac7d0853 lsr      w12, w13, #8
411677c4 0d700039 strb     w13, [x0, #0x1c]
411677c8 ad7d1053 lsr      w13, w13, #0x10
411677cc 0c740039 strb     w12, [x0, #0x1d]
411677d0 0d780039 strb     w13, [x0, #0x1e]
411677d4 ed071f32 mov      w13, #6
411677d8 6c0240b9 ldr      w12, [x19]
411677dc 2d100079 strh     w13, [x1, #8]
411677e0 8e050051 sub      w14, w12, #1
411677e4 df110071 cmp      w14, #4
411677e8 83000054 b.lo     #0x411677f8
411677ec cc0e0034 cbz      w12, #0x411679c4
411677f0 9f510071 cmp      w12, #0x14
411677f4 e10e0054 b.ne     #0x411679d0
411677f8 ed031faa mov      x13, xzr
411677fc ec031f2a mov      w12, wzr
41167800 0f328752 mov      w15, #0x3990
41167804 70559552 mov      w16, #0xaaab
41167808 ae018052 mov      w14, #0xd
4116780c cf01a072 movk     w15, #0xe, lsl #16
41167810 5055a572 movk     w16, #0x2aaa, lsl #16
41167814 51452e8b add      x17, x10, w14, uxtw #1
41167818 316a6f38 ldrb     w17, [x17, x15]
4116781c 317e081b mul      w17, w17, w8
41167820 317e309b smull    x17, w17, w16
41167824 32fe7fd3 lsr      x18, x17, #0x3f
41167828 31fe60d3 lsr      x17, x17, #0x20
4116782c 3102120b add      w17, w17, w18
41167830 3f020b6b cmp      w17, w11
41167834 6d000054 b.le     #0x41167840
41167838 ce050071 subs     w14, w14, #1
4116783c c1feff54 b.ne     #0x41167814
41167840 88bc8552 mov      w8, #0x2de4
41167844 abbc8552 mov      w11, #0x2de5
41167848 c801a072 movk     w8, #0xe, lsl #16
4116784c cb01a072 movk     w11, #0xe, lsl #16
41167850 0f0d8052 mov      w15, #0x68
41167854 48696838 ldrb     w8, [x10, x8]
41167858 ad017db3 bfi      x13, x13, #3, #1
4116785c ce29af9b umaddl   x14, w14, w15, x10
41167860 4a696b38 ldrb     w10, [x10, x11]
41167864 0b548752 mov      w11, #0x3aa0
41167868 097c0039 strb     w9, [x0, #0x1f]
4116786c cb01a072 movk     w11, #0xe, lsl #16
41167870 cb010b8b add      x11, x14, x11
41167874 0a1d1833 bfi      w10, w8, #8, #8
41167878 5f010071 cmp      w10, #0
4116787c ea179f1a cset     w10, eq
41167880 9f090071 cmp      w12, #2
41167884 6d010d8b add      x13, x11, x13
41167888 6b452c8b add      x11, x11, w12, uxtw #1
4116788c ec179f1a cset     w12, eq
41167890 28308352 mov      w8, #0x1981
41167894 8a010a2a orr      w10, w12, w10
41167898 4c168052 mov      w12, #0xb2
4116789c 0e438952 mov      w14, #0x4a18
411678a0 08480079 strh     w8, [x0, #0x24]
411678a4 5f010071 cmp      w10, #0
411678a8 6a490091 add      x10, x11, #0x12
411678ac 0c980039 strb     w12, [x0, #0x26]
411678b0 6b4d0091 add      x11, x11, #0x13
411678b4 0e400079 strh     w14, [x0, #0x20]
411678b8 6b058d9a csinc    x11, x11, x13, eq
411678bc ae194039 ldrb     w14, [x13, #6]
411678c0 a8118a9a csel     x8, x13, x10, ne
411678c4 2ad08052 mov      w10, #0x681
411678c8 6c118052 mov      w12, #0x8b
411678cc 6b014039 ldrb     w11, [x11]
411678d0 08014039 ldrb     w8, [x8]
411678d4 0a500079 strh     w10, [x0, #0x28]
411678d8 0ca80039 strb     w12, [x0, #0x2a]
411678dc aa094039 ldrb     w10, [x13, #2]
411678e0 0e8c0039 strb     w14, [x0, #0x23]
411678e4 08880039 strb     w8, [x0, #0x22]
411678e8 e8131f32 mov      w8, #0x3e
411678ec 0b9c0039 strb     w11, [x0, #0x27]
411678f0 0aac0039 strb     w10, [x0, #0x2b]
411678f4 ea071a32 mov      w10, #0xc0
411678f8 ab0d4039 ldrb     w11, [x13, #3]
411678fc 08b40039 strb     w8, [x0, #0x2d]
41167900 28b08252 mov      w8, #0x1581
41167904 0ab80039 strb     w10, [x0, #0x2e]
41167908 ea030032 mov      w10, #1
4116790c 09b00039 strb     w9, [x0, #0x2c]
41167910 0bbc0039 strb     w11, [x0, #0x2f]
41167914 ab114039 ldrb     w11, [x13, #4]
41167918 08600079 strh     w8, [x0, #0x30]
4116791c 0ac80039 strb     w10, [x0, #0x32]
41167920 aa154039 ldrb     w10, [x13, #5]
41167924 08680079 strh     w8, [x0, #0x34]
41167928 082095d2 mov      x8, #0xa900
4116792c 4855a0f2 movk     x8, #0x2aa, lsl #16
41167930 0bcc0039 strb     w11, [x0, #0x33]
41167934 2bd08752 mov      w11, #0x3e81
41167938 09d80039 strb     w9, [x0, #0x36]
4116793c 4801c0f2 movk     x8, #0xa, lsl #32
41167940 0adc0039 strb     w10, [x0, #0x37]
41167944 0800e0f2 movk     x8, #0, lsl #48
41167948 0b700079 strh     w11, [x0, #0x38]
4116794c 69018052 mov      w9, #0xb
41167950 aa1d4039 ldrb     w10, [x13, #7]
41167954 ab214039 ldrb     w11, [x13, #8]
41167958 0001c03d ldr      q0, [x8]
4116795c 09e80039 strb     w9, [x0, #0x3a]
41167960 0aec0039 strb     w10, [x0, #0x3b]
41167964 ea0301aa mov      x10, x1
41167968 0bf00039 strb     w11, [x0, #0x3c]
4116796c e003803d str      q0, [sp]
41167970 e80740f9 ldr      x8, [sp, #8]
41167974 09fd50d3 lsr      x9, x8, #0x10
41167978 29280079 strh     w9, [x1, #0x14]
4116797c e90340f9 ldr      x9, [sp]
41167980 2bfd70d3 lsr      x11, x9, #0x30
41167984 2cfd60d3 lsr      x12, x9, #0x20
41167988 49ad0078 strh     w9, [x10, #0xa]!
4116798c 4b0d0079 strh     w11, [x10, #6]
41167990 29fd50d3 lsr      x9, x9, #0x10
41167994 4c090079 strh     w12, [x10, #4]
41167998 0bfd70d3 lsr      x11, x8, #0x30
4116799c 488d0078 strh     w8, [x10, #8]!
411679a0 08fd60d3 lsr      x8, x8, #0x20
411679a4 29180079 strh     w9, [x1, #0xc]
411679a8 4b0d0079 strh     w11, [x10, #6]
411679ac 48090079 strh     w8, [x10, #4]
411679b0 f37b43a9 ldp      x19, x30, [sp, #0x30]
411679b4 f55342a9 ldp      x21, x20, [sp, #0x20]
411679b8 f60b40f9 ldr      x22, [sp, #0x10]
411679bc ff030191 add      sp, sp, #0x40
411679c0 6f000014 b        #0x41167b7c
411679c4 ed031faa mov      x13, xzr
411679c8 ec030032 mov      w12, #1
411679cc 8dffff17 b        #0x41167800
411679d0 ec031f32 mov      w12, #2
411679d4 ed030032 mov      w13, #1
411679d8 8affff17 b        #0x41167800

; mode_to_command_column [0x411679dc, 0x41167a08); SHA-256 05123ef089c7de2e3d337bcc5b0cd34054662c088ad975cdb3ef393cab479112
411679dc 080080b9 ldrsw    x8, [x0]
411679e0 1f590071 cmp      w8, #0x16
411679e4 e8000054 b.hi     #0x41167a00
411679e8 097a94d2 mov      x9, #0xa3d0
411679ec 4955a0f2 movk     x9, #0x2aa, lsl #16
411679f0 4901c0f2 movk     x9, #0xa, lsl #32
411679f4 0900e0f2 movk     x9, #0, lsl #48
411679f8 207968b8 ldr      w0, [x9, x8, lsl #2]
411679fc c0035fd6 ret
41167a00 e03f0032 mov      w0, #0xffff
41167a04 c0035fd6 ret

; stream_sender [0x41167b7c, 0x41167bd8); SHA-256 e5ab7042e261250eb76ec9dc9f482022343b79c23b1a9599e675a80712cbad8f
41167b7c f60f1df8 str      x22, [sp, #-0x30]!
41167b80 f55301a9 stp      x21, x20, [sp, #0x10]
41167b84 f37b02a9 stp      x19, x30, [sp, #0x20]
41167b88 f30301aa mov      x19, x1
41167b8c f40300aa mov      x20, x0
41167b90 68024079 ldrh     w8, [x19]
41167b94 88010034 cbz      w8, #0x41167bc4
41167b98 f6031f2a mov      w22, wzr
41167b9c 153d0012 and      w21, w8, #0xffff
41167ba0 e00314aa mov      x0, x20
41167ba4 e103152a mov      w1, w21
41167ba8 99400094 bl       #0x41177e0c
41167bac e0000035 cbnz     w0, #0x41167bc8
41167bb0 d6060011 add      w22, w22, #1
41167bb4 c83e4092 and      x8, x22, #0xffff
41167bb8 9402158b add      x20, x20, x21
41167bbc 687a6878 ldrh     w8, [x19, x8, lsl #1]
41167bc0 e8feff35 cbnz     w8, #0x41167b9c
41167bc4 e0031f2a mov      w0, wzr
41167bc8 f37b42a9 ldp      x19, x30, [sp, #0x20]
41167bcc f55341a9 ldp      x21, x20, [sp, #0x10]
41167bd0 f60743f8 ldr      x22, [sp], #0x30
41167bd4 c0035fd6 ret

; mode_to_timing_row [0x41167e40, 0x41167ecc); SHA-256 d9c39601a8e481edc4d1ceedecc3685f268531dee8ab61d27068ebbd58f352c9
41167e40 1f500071 cmp      w0, #0x14
41167e44 68020054 b.hi     #0x41167e90
41167e48 094592d2 mov      x9, #0x9228
41167e4c 2955a0f2 movk     x9, #0x2a9, lsl #16
41167e50 4901c0f2 movk     x9, #0xa, lsl #32
41167e54 e803002a mov      w8, w0
41167e58 0900e0f2 movk     x9, #0, lsl #48
41167e5c e0031f32 mov      w0, #2
41167e60 287968f8 ldr      x8, [x9, x8, lsl #3]
41167e64 00011fd6 br       x8
41167e68 e0031e32 mov      w0, #4
41167e6c c0035fd6 ret
41167e70 e00b0032 mov      w0, #7
41167e74 c0035fd6 ret
41167e78 a0008052 mov      w0, #5
41167e7c c0035fd6 ret
41167e80 e0071f32 mov      w0, #6
41167e84 c0035fd6 ret
41167e88 20018052 mov      w0, #9
41167e8c c0035fd6 ret
41167e90 a0018052 mov      w0, #0xd
41167e94 c0035fd6 ret
41167e98 3f040071 cmp      w1, #1
41167e9c e0179f1a cset     w0, eq
41167ea0 c0035fd6 ret
41167ea4 e0070032 mov      w0, #3
41167ea8 c0035fd6 ret
41167eac e0031d32 mov      w0, #8
41167eb0 c0035fd6 ret
41167eb4 40018052 mov      w0, #0xa
41167eb8 c0035fd6 ret
41167ebc 60018052 mov      w0, #0xb
41167ec0 c0035fd6 ret
41167ec4 e0071e32 mov      w0, #0xc
41167ec8 c0035fd6 ret

; timing_queries [0x41171e4c, 0x41171ea8); SHA-256 0c48c09ea74c1f1af3c0d056d1745a547f1c7fa80c56e9549262a1c51b62c4b5
41171e4c 090040b9 ldr      w9, [x0]
41171e50 080441b9 ldr      w8, [x0, #0x104]
41171e54 c9000035 cbnz     w9, #0x41171e6c
41171e58 097441b9 ldr      w9, [x0, #0x174]
41171e5c 3f050071 cmp      w9, #1
41171e60 61000054 b.ne     #0x41171e6c
41171e64 091841b9 ldr      w9, [x0, #0x118]
41171e68 2801080b add      w8, w9, w8
41171e6c 09ec4179 ldrh     w9, [x0, #0xf6]
41171e70 087d091b mul      w8, w8, w9
41171e74 29c79152 mov      w9, #0x8e39
41171e78 691ca772 movk     w9, #0x38e3, lsl #16
41171e7c 087da99b umull    x8, w8, w9
41171e80 00fd64d3 lsr      x0, x8, #0x24
41171e84 c0035fd6 ret
41171e88 08ec4179 ldrh     w8, [x0, #0xf6]
41171e8c 09d44179 ldrh     w9, [x0, #0xea]
41171e90 287d081b mul      w8, w9, w8
41171e94 29c79152 mov      w9, #0x8e39
41171e98 691ca772 movk     w9, #0x38e3, lsl #16
41171e9c 087da99b umull    x8, w8, w9
41171ea0 00fd64d3 lsr      x0, x8, #0x24
41171ea4 c0035fd6 ret

; timing_parameter_access_excerpt [0x41172080, 0x411721b8); SHA-256 34fa90491eb880237fcdeb683d9b24b8157f2362183e12e3cda6b9f76c834d80
41172080 ff4301d1 sub      sp, sp, #0x50
41172084 f75b02a9 stp      x23, x22, [sp, #0x20]
41172088 f55303a9 stp      x21, x20, [sp, #0x30]
4117208c f37b04a9 stp      x19, x30, [sp, #0x40]
41172090 f30300aa mov      x19, x0
41172094 ff7f0129 stp      wzr, wzr, [sp, #8]
41172098 750240b9 ldr      w21, [x19]
4117209c 747641b9 ldr      w20, [x19, #0x174]
411720a0 68ee4179 ldrh     w8, [x19, #0xf6]
411720a4 69d64179 ldrh     w9, [x19, #0xea]
411720a8 e003152a mov      w0, w21
411720ac 7fd60179 strh     wzr, [x19, #0xea]
411720b0 e103142a mov      w1, w20
411720b4 7fde0179 strh     wzr, [x19, #0xee]
411720b8 68ea0179 strh     w8, [x19, #0xf4]
411720bc 69d20179 strh     w9, [x19, #0xe8]
411720c0 7ff200b9 str      wzr, [x19, #0xf0]
411720c4 7fee0179 strh     wzr, [x19, #0xf6]
411720c8 7ffe00b9 str      wzr, [x19, #0xfc]
411720cc 7f1201b9 str      wzr, [x19, #0x110]
411720d0 7f0e01b9 str      wzr, [x19, #0x10c]
411720d4 7f0a01b9 str      wzr, [x19, #0x108]
411720d8 7f0601b9 str      wzr, [x19, #0x104]
411720dc 59d7ff97 bl       #0x41167e40
411720e0 08d49ed2 mov      x8, #0xf6a0
411720e4 69e240b9 ldr      w9, [x19, #0xe0]
411720e8 c892a0f2 movk     x8, #0x496, lsl #16
411720ec 4801c0f2 movk     x8, #0xa, lsl #32
411720f0 0800e0f2 movk     x8, #0, lsl #48
411720f4 ea071a32 mov      w10, #0xc0
411720f8 eb071c32 mov      w11, #0x30
411720fc 080140f9 ldr      x8, [x8]
41172100 177d8052 mov      w23, #0x3e8
41172104 0a20aa9b umaddl   x10, w0, w10, x8
41172108 2a290b9b madd     x10, x9, x11, x10
4117210c 4bdb8552 mov      w11, #0x2eda
41172110 cb01a072 movk     w11, #0xe, lsl #16
41172114 4a696b78 ldrh     w10, [x10, x11]
41172118 2bc79152 mov      w11, #0x8e39
4117211c 6b1ca772 movk     w11, #0x38e3, lsl #16
41172120 4a7d171b mul      w10, w10, w23
41172124 4a7dab9b umull    x10, w10, w11
41172128 ab999952 mov      w11, #0xcccd
4117212c 8b99b972 movk     w11, #0xcccc, lsl #16
41172130 4afd64d3 lsr      x10, x10, #0x24
41172134 4a150011 add      w10, w10, #5
41172138 4a7dab9b umull    x10, w10, w11
4117213c 4afd63d3 lsr      x10, x10, #0x23
41172140 4a090a0b add      w10, w10, w10, lsl #2
41172144 4b791f53 lsl      w11, w10, #1
41172148 aa1a0051 sub      w10, w21, #6
4117214c 5f410071 cmp      w10, #0x10
41172150 6bfa00b9 str      w11, [x19, #0xf8]
41172154 22030054 b.hs     #0x411721b8
41172158 e1330091 add      x1, sp, #0xc
4117215c e2230091 add      x2, sp, #8
41172160 e00313aa mov      x0, x19
41172164 01010094 bl       #0x41172568
41172168 e9234129 ldp      w9, w8, [sp, #8]
4117216c 6a824239 ldrb     w10, [x19, #0xa0]
41172170 68ee0179 strh     w8, [x19, #0xf6]
41172174 69d60179 strh     w9, [x19, #0xea]
41172178 4a010034 cbz      w10, #0x411721a0
4117217c 690240b9 ldr      w9, [x19]
41172180 09010035 cbnz     w9, #0x411721a0
41172184 89ed9fd2 mov      x9, #0xff6c
41172188 c992a0f2 movk     x9, #0x496, lsl #16
4117218c 4901c0f2 movk     x9, #0xa, lsl #32
41172190 0900e0f2 movk     x9, #0, lsl #48
41172194 29014079 ldrh     w9, [x9]
41172198 0801090b add      w8, w8, w9
4117219c 68ee0179 strh     w8, [x19, #0xf6]
411721a0 f37b44a9 ldp      x19, x30, [sp, #0x40]
411721a4 f55343a9 ldp      x21, x20, [sp, #0x30]
411721a8 f75b42a9 ldp      x23, x22, [sp, #0x20]
411721ac e0031f2a mov      w0, wzr
411721b0 ff430191 add      sp, sp, #0x50
411721b4 c0035fd6 ret

; resource_getter [0x40d6b4f4, 0x40d6b538); SHA-256 7566e79b81effc106b8dfe50bd5b1359f4a665b0fa62a96cf648dd454121987c
40d6b4f4 f37bbfa9 stp      x19, x30, [sp, #-0x10]!
40d6b4f8 f303002a mov      w19, w0
40d6b4fc 7f720171 cmp      w19, #0x5c
40d6b500 89000054 b.ls     #0x40d6b510
40d6b504 e0031faa mov      x0, xzr
40d6b508 f37bc1a8 ldp      x19, x30, [sp], #0x10
40d6b50c c0035fd6 ret
40d6b510 e10b0032 mov      w1, #7
40d6b514 e003132a mov      w0, w19
40d6b518 fc0d0094 bl       #0x40d6ed08
40d6b51c 80000036 tbz      w0, #0, #0x40d6b52c
40d6b520 e003132a mov      w0, w19
40d6b524 f37bc1a8 ldp      x19, x30, [sp], #0x10
40d6b528 d1050014 b        #0x40d6cc6c
40d6b52c e003132a mov      w0, w19
40d6b530 f37bc1a8 ldp      x19, x30, [sp], #0x10
40d6b534 d8050014 b        #0x40d6cc94

; resource_pointer_paths [0x40d6cc6c, 0x40d6ccd8); SHA-256 d3edb12583f68bfa15034ab544f41e69cb575551d43e778b63fb33d14ad992c8
40d6cc6c 1f700171 cmp      w0, #0x5c
40d6cc70 69000054 b.ls     #0x40d6cc7c
40d6cc74 e0031faa mov      x0, xzr
40d6cc78 c0035fd6 ret
40d6cc7c fe0f1ff8 str      x30, [sp, #-0x10]!
40d6cc80 92110094 bl       #0x40d712c8
40d6cc84 fe0741f8 ldr      x30, [sp], #0x10
40d6cc88 400000b4 cbz      x0, #0x40d6cc90
40d6cc8c 000840f9 ldr      x0, [x0, #0x10]
40d6cc90 c0035fd6 ret
40d6cc94 f37bbfa9 stp      x19, x30, [sp, #-0x10]!
40d6cc98 1f700171 cmp      w0, #0x5c
40d6cc9c 69000054 b.ls     #0x40d6cca8
40d6cca0 e0031faa mov      x0, xzr
40d6cca4 0b000014 b        #0x40d6ccd0
40d6cca8 88110094 bl       #0x40d712c8
40d6ccac f30300aa mov      x19, x0
40d6ccb0 130100b4 cbz      x19, #0x40d6ccd0
40d6ccb4 602640b9 ldr      w0, [x19, #0x24]
40d6ccb8 7d110094 bl       #0x40d712ac
40d6ccbc a00000b4 cbz      x0, #0x40d6ccd0
40d6ccc0 080040f9 ldr      x8, [x0]
40d6ccc4 e8feffb4 cbz      x8, #0x40d6cca0
40d6ccc8 690640f9 ldr      x9, [x19, #8]
40d6cccc 2001088b add      x0, x9, x8
40d6ccd0 f37bc1a8 ldp      x19, x30, [sp], #0x10
40d6ccd4 c0035fd6 ret

; resource_descriptors [0x40d712ac, 0x40d712fc); SHA-256 c861d56576932d99fc2c3226315ea2a1f78fe1afcdeb13f6bfd1a6e2298d209f
40d712ac 08579bd2 mov      x8, #0xdab8
40d712b0 2852a0f2 movk     x8, #0x291, lsl #16
40d712b4 4801c0f2 movk     x8, #0xa, lsl #32
40d712b8 09058052 mov      w9, #0x28
40d712bc 0800e0f2 movk     x8, #0, lsl #48
40d712c0 0020a99b umaddl   x0, w0, w9, x8
40d712c4 c0035fd6 ret
40d712c8 1f700171 cmp      w0, #0x5c
40d712cc 68010054 b.hi     #0x40d712f8
40d712d0 082999d2 mov      x8, #0xc948
40d712d4 2852a0f2 movk     x8, #0x291, lsl #16
40d712d8 4801c0f2 movk     x8, #0xa, lsl #32
40d712dc e9071c32 mov      w9, #0x30
40d712e0 0800e0f2 movk     x8, #0, lsl #48
40d712e4 0820a99b umaddl   x8, w0, w9, x8
40d712e8 090140b9 ldr      w9, [x8]
40d712ec 3f01006b cmp      w9, w0
40d712f0 00019f9a csel     x0, x8, xzr, eq
40d712f4 c0035fd6 ret
40d712f8 e0031faa mov      x0, xzr
