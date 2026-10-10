
; sdk_size_setter: [0x408401ec, 0x408403b4)
; sha256 8b559b5a82ad339ef292927fd7324b011628845ec2d9d5c91d76976688be6ad4
408401ec ffc301d1 sub      sp, sp, #0x70
408401f0 fa1300f9 str      x26, [sp, #0x20]
408401f4 f96303a9 stp      x25, x24, [sp, #0x30]
408401f8 f75b04a9 stp      x23, x22, [sp, #0x40]
408401fc f55305a9 stp      x21, x20, [sp, #0x50]
40840200 f37b06a9 stp      x19, x30, [sp, #0x60]
40840204 e80300aa mov      x8, x0
40840208 190c4039 ldrb     w25, [x0, #3]
4084020c 14084039 ldrb     w20, [x0, #2]
40840210 1a044039 ldrb     w26, [x0, #1]
40840214 17004039 ldrb     w23, [x0]
40840218 134d4038 ldrb     w19, [x8, #4]!
4084021c 16144039 ldrb     w22, [x0, #5]
40840220 e0a30091 add      x0, sp, #0x28
40840224 180d4039 ldrb     w24, [x8, #3]
40840228 15094039 ldrb     w21, [x8, #2]
4084022c 98060094 bl       #0x40841c8c
40840230 1f3c0072 tst      w0, #0xffff
40840234 80020054 b.eq     #0x40840284
40840238 151f1833 bfi      w21, w24, #8, #8
4084023c ea1740f9 ldr      x10, [sp, #0x28]
40840240 d31e1833 bfi      w19, w22, #8, #8
40840244 341f78b3 bfi      x20, x25, #8, #8
40840248 571f78b3 bfi      x23, x26, #8, #8
4084024c b33e1033 bfi      w19, w21, #0x10, #0x10
40840250 e9031f2a mov      w9, wzr
40840254 973e70b3 bfi      x23, x20, #0x10, #0x10
40840258 88038452 mov      w8, #0x201c
4084025c 777e60b3 bfi      x23, x19, #0x20, #0x20
40840260 2b3d0012 and      w11, w9, #0xffff
40840264 4b596bf8 ldr      x11, [x10, w11, uxtw #3]
40840268 7f0117eb cmp      x11, x23
4084026c 00010054 b.eq     #0x4084028c
40840270 29050011 add      w9, w9, #1
40840274 2b3d0012 and      w11, w9, #0xffff
40840278 7f21206b cmp      w11, w0, uxth
4084027c 23ffff54 b.lo     #0x40840260
40840280 45000014 b        #0x40840394
40840284 88038452 mov      w8, #0x201c
40840288 43000014 b        #0x40840394
4084028c 003888d2 mov      x0, #0x41c0
40840290 e081a8f2 movk     x0, #0x440f, lsl #16
40840294 0000c0f2 movk     x0, #0, lsl #32
40840298 0000e0f2 movk     x0, #0, lsl #48
4084029c e10b0032 mov      w1, #7
408402a0 e2fe60d3 lsr      x2, x23, #0x20
408402a4 6746ff97 bl       #0x40811c40
408402a8 f303002a mov      w19, w0
408402ac 003f88d2 mov      x0, #0x41f8
408402b0 e081a8f2 movk     x0, #0x440f, lsl #16
408402b4 0000c0f2 movk     x0, #0, lsl #32
408402b8 0000e0f2 movk     x0, #0, lsl #48
408402bc e10b0032 mov      w1, #7
408402c0 e25e1053 ubfx     w2, w23, #0x10, #8
408402c4 5f46ff97 bl       #0x40811c40
408402c8 f403002a mov      w20, w0
408402cc e8167892 and      x8, x23, #0x3f00
408402d0 1f0104f1 cmp      x8, #0x100
408402d4 41010054 b.ne     #0x408402fc
408402d8 004688d2 mov      x0, #0x4230
408402dc e081a8f2 movk     x0, #0x440f, lsl #16
408402e0 0000c0f2 movk     x0, #0, lsl #32
408402e4 e21e0012 and      w2, w23, #0xff
408402e8 0000e0f2 movk     x0, #0, lsl #48
408402ec e1070032 mov      w1, #3
408402f0 5446ff97 bl       #0x40811c40
408402f4 f503002a mov      w21, w0
408402f8 02000014 b        #0x40840300
408402fc f5031f2a mov      w21, wzr
40840300 99590094 bl       #0x40856964
40840304 f603002a mov      w22, w0
40840308 72590094 bl       #0x408568d0
4084030c f6830229 stp      w22, w0, [sp, #0x14]
40840310 16228252 mov      w22, #0x1110
40840314 16c0a072 movk     w22, #0x600, lsl #16
40840318 f3530129 stp      w19, w20, [sp, #8]
4084031c e0530091 add      x0, sp, #0x14
40840320 ff1300b9 str      wzr, [sp, #0x10]
40840324 e1230091 add      x1, sp, #8
40840328 e2031f32 mov      w2, #2
4084032c f61f00b9 str      w22, [sp, #0x1c]
40840330 2e5a0094 bl       #0x40856be8
40840334 c0da0311 add      w0, w22, #0xf6
40840338 6d580094 bl       #0x408564ec
4084033c 1f040071 cmp      w0, #1
40840340 a1000054 b.ne     #0x40840354
40840344 80408252 mov      w0, #0x1204
40840348 00e0a072 movk     w0, #0x700, lsl #16
4084034c e103152a mov      w1, w21
40840350 1f5a0094 bl       #0x40856bcc
40840354 134f84d2 mov      x19, #0x2278
40840358 3353a0f2 movk     x19, #0x299, lsl #16
4084035c 5301c0f2 movk     x19, #0xa, lsl #32
40840360 1300e0f2 movk     x19, #0, lsl #48
40840364 680240f9 ldr      x8, [x19]
40840368 1f0117eb cmp      x8, x23
4084036c 61000054 b.ne     #0x40840378
40840370 28008452 mov      w8, #0x2001
40840374 08000014 b        #0x40840394
40840378 0801174a eor      w8, w8, w23
4084037c 1f1d70f2 tst      x8, #0xff0000
40840380 60000054 b.eq     #0x4084038c
40840384 00359a52 mov      w0, #0xd1a8
40840388 1e51ff97 bl       #0x40814800
4084038c 28008452 mov      w8, #0x2001
40840390 770200f9 str      x23, [x19]
40840394 f37b46a9 ldp      x19, x30, [sp, #0x60]
40840398 f55345a9 ldp      x21, x20, [sp, #0x50]
4084039c f75b44a9 ldp      x23, x22, [sp, #0x40]
408403a0 f96343a9 ldp      x25, x24, [sp, #0x30]
408403a4 fa1340f9 ldr      x26, [sp, #0x20]
408403a8 e003082a mov      w0, w8
408403ac ffc30191 add      sp, sp, #0x70
408403b0 c0035fd6 ret

; sdk_allowed_list: [0x40841c8c, 0x40841d44)
; sha256 e1ab6c171ca80b4a33a36ee3159dd0eec729c10bdcd0cd1672c15f37eca40977
40841c8c f37bbfa9 stp      x19, x30, [sp, #-0x10]!
40841c90 f30300aa mov      x19, x0
40841c94 530500b4 cbz      x19, #0x40841d3c
40841c98 c0408252 mov      w0, #0x1206
40841c9c 00c0a072 movk     w0, #0x600, lsl #16
40841ca0 13520094 bl       #0x408564ec
40841ca4 09040051 sub      w9, w0, #1
40841ca8 3f150071 cmp      w9, #5
40841cac 48020054 b.hi     #0x40841cf4
40841cb0 0a2a88d2 mov      x10, #0x4150
40841cb4 ea81a8f2 movk     x10, #0x440f, lsl #16
40841cb8 0a00c0f2 movk     x10, #0, lsl #32
40841cbc 0a00e0f2 movk     x10, #0, lsl #48
40841cc0 085084d2 mov      x8, #0x2280
40841cc4 2853a0f2 movk     x8, #0x299, lsl #16
40841cc8 497969f8 ldr      x9, [x10, x9, lsl #3]
40841ccc 4801c0f2 movk     x8, #0xa, lsl #32
40841cd0 0800e0f2 movk     x8, #0, lsl #48
40841cd4 20018052 mov      w0, #9
40841cd8 20011fd6 br       x9
40841cdc 086a84d2 mov      x8, #0x2350
40841ce0 2853a0f2 movk     x8, #0x299, lsl #16
40841ce4 4801c0f2 movk     x8, #0xa, lsl #32
40841ce8 0800e0f2 movk     x8, #0, lsl #48
40841cec e0031d32 mov      w0, #8
40841cf0 12000014 b        #0x40841d38
40841cf4 085984d2 mov      x8, #0x22c8
40841cf8 2853a0f2 movk     x8, #0x299, lsl #16
40841cfc 4801c0f2 movk     x8, #0xa, lsl #32
40841d00 0800e0f2 movk     x8, #0, lsl #48
40841d04 20028052 mov      w0, #0x11
40841d08 0c000014 b        #0x40841d38
40841d0c 088584d2 mov      x8, #0x2428
40841d10 2853a0f2 movk     x8, #0x299, lsl #16
40841d14 4801c0f2 movk     x8, #0xa, lsl #32
40841d18 0800e0f2 movk     x8, #0, lsl #48
40841d1c 40018052 mov      w0, #0xa
40841d20 06000014 b        #0x40841d38
40841d24 087284d2 mov      x8, #0x2390
40841d28 2853a0f2 movk     x8, #0x299, lsl #16
40841d2c 4801c0f2 movk     x8, #0xa, lsl #32
40841d30 0800e0f2 movk     x8, #0, lsl #48
40841d34 60028052 mov      w0, #0x13
40841d38 680200f9 str      x8, [x19]
40841d3c f37bc1a8 ldp      x19, x30, [sp], #0x10
40841d40 c0035fd6 ret

; sdk_enum_lookup: [0x40811c40, 0x40811c70)
; sha256 97acec5e915954124c616ce7c0ef1feb60f7e976dcb071082230ae8ec4106c30
40811c40 f37bbfa9 stp      x19, x30, [sp, #-0x10]!
40811c44 03008012 mov      w3, #-1
40811c48 f30300aa mov      x19, x0
40811c4c 4819ed97 bl       #0x4035816c
40811c50 1f040031 cmn      w0, #1
40811c54 80000054 b.eq     #0x40811c64
40811c58 684e208b add      x8, x19, w0, uxtw #3
40811c5c 000540b9 ldr      w0, [x8, #4]
40811c60 02000014 b        #0x40811c68
40811c64 e07b0032 mov      w0, #0x7fffffff
40811c68 f37bc1a8 ldp      x19, x30, [sp], #0x10
40811c6c c0035fd6 ret

; rate_setting_id: [0x408568d0, 0x4085692c)
; sha256 ade02638cb999d282a4c661e877612d68cf662ba9d1ce44016c70045e6877014
408568d0 fe0f1ff8 str      x30, [sp, #-0x10]!
408568d4 01de8dd2 mov      x1, #0x6ef0
408568d8 e181a8f2 movk     x1, #0x440f, lsl #16
408568dc c0408252 mov      w0, #0x1206
408568e0 0100c0f2 movk     x1, #0, lsl #32
408568e4 00c0a072 movk     w0, #0x600, lsl #16
408568e8 0100e0f2 movk     x1, #0, lsl #48
408568ec 826a8052 mov      w2, #0x354
408568f0 e5f01e94 bl       #0x41012c84
408568f4 08040051 sub      w8, w0, #1
408568f8 1f150071 cmp      w8, #5
408568fc 08010054 b.hi     #0x4085691c
40856900 098e8dd2 mov      x9, #0x6c70
40856904 e981a8f2 movk     x9, #0x440f, lsl #16
40856908 0900c0f2 movk     x9, #0, lsl #32
4085690c 0900e0f2 movk     x9, #0, lsl #48
40856910 20d968b8 ldr      w0, [x9, w8, sxtw #2]
40856914 fe0741f8 ldr      x30, [sp], #0x10
40856918 c0035fd6 ret
4085691c 60408252 mov      w0, #0x1203
40856920 00e0a072 movk     w0, #0x700, lsl #16
40856924 fe0741f8 ldr      x30, [sp], #0x10
40856928 c0035fd6 ret

; size_setting_id: [0x40856964, 0x408569c0)
; sha256 ab05368ae38933db5bd5002d238ee05e62a93fb221552bedcc919262e028761e
40856964 fe0f1ff8 str      x30, [sp, #-0x10]!
40856968 01de8dd2 mov      x1, #0x6ef0
4085696c e181a8f2 movk     x1, #0x440f, lsl #16
40856970 c0408252 mov      w0, #0x1206
40856974 0100c0f2 movk     x1, #0, lsl #32
40856978 00c0a072 movk     w0, #0x600, lsl #16
4085697c 0100e0f2 movk     x1, #0, lsl #48
40856980 826a8052 mov      w2, #0x354
40856984 c0f01e94 bl       #0x41012c84
40856988 08040051 sub      w8, w0, #1
4085698c 1f150071 cmp      w8, #5
40856990 08010054 b.hi     #0x408569b0
40856994 09928dd2 mov      x9, #0x6c90
40856998 e981a8f2 movk     x9, #0x440f, lsl #16
4085699c 0900c0f2 movk     x9, #0, lsl #32
408569a0 0900e0f2 movk     x9, #0, lsl #48
408569a4 20d968b8 ldr      w0, [x9, w8, sxtw #2]
408569a8 fe0741f8 ldr      x30, [sp], #0x10
408569ac c0035fd6 ret
408569b0 40408252 mov      w0, #0x1202
408569b4 00e0a072 movk     w0, #0x700, lsl #16
408569b8 fe0741f8 ldr      x30, [sp], #0x10
408569bc c0035fd6 ret

; movie_width_height: [0x406d2ba4, 0x406d2ca4)
; sha256 a31c47c7aae16716cedb41e00813acd7e55f88709842d726c4e8d11cc38dfa50
406d2ba4 08804339 ldrb     w8, [x0, #0xe0]
406d2ba8 08010034 cbz      w8, #0x406d2bc8
406d2bac 08e440b9 ldr      w8, [x0, #0xe4]
406d2bb0 1f050071 cmp      w8, #1
406d2bb4 01020054 b.ne     #0x406d2bf4
406d2bb8 e80f1932 mov      w8, #0x780
406d2bbc e0030032 mov      w0, #1
406d2bc0 28480179 strh     w8, [x1, #0xa4]
406d2bc4 c0035fd6 ret
406d2bc8 080c40b9 ldr      w8, [x0, #0xc]
406d2bcc 1f190071 cmp      w8, #6
406d2bd0 28010054 b.hi     #0x406d2bf4
406d2bd4 095c8fd2 mov      x9, #0x7ae0
406d2bd8 8981a8f2 movk     x9, #0x440c, lsl #16
406d2bdc 0900c0f2 movk     x9, #0, lsl #32
406d2be0 0900e0f2 movk     x9, #0, lsl #48
406d2be4 287968f8 ldr      x8, [x9, x8, lsl #3]
406d2be8 00011fd6 br       x8
406d2bec 08a08052 mov      w8, #0x500
406d2bf0 f3ffff17 b        #0x406d2bbc
406d2bf4 e0031f2a mov      w0, wzr
406d2bf8 c0035fd6 ret
406d2bfc e80f1832 mov      w8, #0xf00
406d2c00 efffff17 b        #0x406d2bbc
406d2c04 e80f1732 mov      w8, #0x1e00
406d2c08 edffff17 b        #0x406d2bbc
406d2c0c 08048252 mov      w8, #0x1020
406d2c10 ebffff17 b        #0x406d2bbc
406d2c14 08a28252 mov      w8, #0x1510
406d2c18 e9ffff17 b        #0x406d2bbc
406d2c1c 08088452 mov      w8, #0x2040
406d2c20 e7ffff17 b        #0x406d2bbc
406d2c24 08804339 ldrb     w8, [x0, #0xe0]
406d2c28 08010034 cbz      w8, #0x406d2c48
406d2c2c 08e440b9 ldr      w8, [x0, #0xe4]
406d2c30 1f050071 cmp      w8, #1
406d2c34 01020054 b.ne     #0x406d2c74
406d2c38 08878052 mov      w8, #0x438
406d2c3c e0030032 mov      w0, #1
406d2c40 284c0179 strh     w8, [x1, #0xa6]
406d2c44 c0035fd6 ret
406d2c48 080c40b9 ldr      w8, [x0, #0xc]
406d2c4c 1f190071 cmp      w8, #6
406d2c50 28010054 b.hi     #0x406d2c74
406d2c54 09638fd2 mov      x9, #0x7b18
406d2c58 8981a8f2 movk     x9, #0x440c, lsl #16
406d2c5c 0900c0f2 movk     x9, #0, lsl #32
406d2c60 0900e0f2 movk     x9, #0, lsl #48
406d2c64 287968f8 ldr      x8, [x9, x8, lsl #3]
406d2c68 00011fd6 br       x8
406d2c6c 085a8052 mov      w8, #0x2d0
406d2c70 f3ffff17 b        #0x406d2c3c
406d2c74 e0031f2a mov      w0, wzr
406d2c78 c0035fd6 ret
406d2c7c 080e8152 mov      w8, #0x870
406d2c80 efffff17 b        #0x406d2c3c
406d2c84 081c8252 mov      w8, #0x10e0
406d2c88 edffff17 b        #0x406d2c3c
406d2c8c 48228152 mov      w8, #0x912
406d2c90 ebffff17 b        #0x406d2c3c
406d2c94 087b8152 mov      w8, #0xbd8
406d2c98 e9ffff17 b        #0x406d2c3c
406d2c9c 88448252 mov      w8, #0x1224
406d2ca0 e7ffff17 b        #0x406d2c3c

; effective_video_settings: [0x40ed0310, 0x40ed0bd4)
; sha256 8e4d56e563992275e884ffa179eb9ee43758c4b9851b7c6d2659a51cdd7a46ba
40ed0310 ff4304d1 sub      sp, sp, #0x110
40ed0314 fc6f0ba9 stp      x28, x27, [sp, #0xb0]
40ed0318 fa670ca9 stp      x26, x25, [sp, #0xc0]
40ed031c f85f0da9 stp      x24, x23, [sp, #0xd0]
40ed0320 f6570ea9 stp      x22, x21, [sp, #0xe0]
40ed0324 f44f0fa9 stp      x20, x19, [sp, #0xf0]
40ed0328 fd7b10a9 stp      x29, x30, [sp, #0x100]
40ed032c 1c208052 mov      w28, #0x100
40ed0330 1c00a872 movk     w28, #0x4000, lsl #16
40ed0334 f603002a mov      w22, w0
40ed0338 e0031c2a mov      w0, w28
40ed033c 254d0194 bl       #0x40f237d0
40ed0340 c8408252 mov      w8, #0x1206
40ed0344 f703002a mov      w23, w0
40ed0348 08c0a072 movk     w8, #0x600, lsl #16
40ed034c e0030032 mov      w0, #1
40ed0350 e1b30291 add      x1, sp, #0xac
40ed0354 e2a30291 add      x2, sp, #0xa8
40ed0358 ff231529 stp      wzr, w8, [sp, #0xa8]
40ed035c bf4c0194 bl       #0x40f23658
40ed0360 60000036 tbz      w0, #0, #0x40ed036c
40ed0364 f4ab40b9 ldr      w20, [sp, #0xa8]
40ed0368 03000014 b        #0x40ed0374
40ed036c f4030132 mov      w20, #-0x80000000
40ed0370 f4ab00b9 str      w20, [sp, #0xa8]
40ed0374 b3a78052 mov      w19, #0x53d
40ed0378 13c0a072 movk     w19, #0x600, lsl #16
40ed037c e0030032 mov      w0, #1
40ed0380 e1b30291 add      x1, sp, #0xac
40ed0384 e2a30291 add      x2, sp, #0xa8
40ed0388 ff4f1529 stp      wzr, w19, [sp, #0xa8]
40ed038c b34c0194 bl       #0x40f23658
40ed0390 60000036 tbz      w0, #0, #0x40ed039c
40ed0394 f5ab40b9 ldr      w21, [sp, #0xa8]
40ed0398 03000014 b        #0x40ed03a4
40ed039c f5030132 mov      w21, #-0x80000000
40ed03a0 f5ab00b9 str      w21, [sp, #0xa8]
40ed03a4 68720011 add      w8, w19, #0x1c
40ed03a8 e0030032 mov      w0, #1
40ed03ac e1b30291 add      x1, sp, #0xac
40ed03b0 e2a30291 add      x2, sp, #0xa8
40ed03b4 ff231529 stp      wzr, w8, [sp, #0xa8]
40ed03b8 a84c0194 bl       #0x40f23658
40ed03bc 60000036 tbz      w0, #0, #0x40ed03c8
40ed03c0 f8ab40b9 ldr      w24, [sp, #0xa8]
40ed03c4 03000014 b        #0x40ed03d0
40ed03c8 f8030132 mov      w24, #-0x80000000
40ed03cc f8ab00b9 str      w24, [sp, #0xa8]
40ed03d0 dbd58052 mov      w27, #0x6ae
40ed03d4 1b80a072 movk     w27, #0x400, lsl #16
40ed03d8 e0030032 mov      w0, #1
40ed03dc e1b30291 add      x1, sp, #0xac
40ed03e0 e2a30291 add      x2, sp, #0xa8
40ed03e4 ff6f1529 stp      wzr, w27, [sp, #0xa8]
40ed03e8 9c4c0194 bl       #0x40f23658
40ed03ec 60000036 tbz      w0, #0, #0x40ed03f8
40ed03f0 f9ab40b9 ldr      w25, [sp, #0xa8]
40ed03f4 03000014 b        #0x40ed0400
40ed03f8 f9030132 mov      w25, #-0x80000000
40ed03fc f9ab00b9 str      w25, [sp, #0xa8]
40ed0400 687e0011 add      w8, w19, #0x1f
40ed0404 e0030032 mov      w0, #1
40ed0408 e1b30291 add      x1, sp, #0xac
40ed040c e2a30291 add      x2, sp, #0xa8
40ed0410 ff231529 stp      wzr, w8, [sp, #0xa8]
40ed0414 914c0194 bl       #0x40f23658
40ed0418 60000036 tbz      w0, #0, #0x40ed0424
40ed041c faab40b9 ldr      w26, [sp, #0xa8]
40ed0420 03000014 b        #0x40ed042c
40ed0424 fa030132 mov      w26, #-0x80000000
40ed0428 faab00b9 str      w26, [sp, #0xa8]
40ed042c 68070011 add      w8, w27, #1
40ed0430 e0030032 mov      w0, #1
40ed0434 e1b30291 add      x1, sp, #0xac
40ed0438 e2a30291 add      x2, sp, #0xa8
40ed043c ff231529 stp      wzr, w8, [sp, #0xa8]
40ed0440 f702162a orr      w23, w23, w22
40ed0444 854c0194 bl       #0x40f23658
40ed0448 60000036 tbz      w0, #0, #0x40ed0454
40ed044c f6ab40b9 ldr      w22, [sp, #0xa8]
40ed0450 03000014 b        #0x40ed045c
40ed0454 f6030132 mov      w22, #-0x80000000
40ed0458 f6ab00b9 str      w22, [sp, #0xa8]
40ed045c bbd48052 mov      w27, #0x6a5
40ed0460 1be0a072 movk     w27, #0x700, lsl #16
40ed0464 e0030032 mov      w0, #1
40ed0468 e1b30291 add      x1, sp, #0xac
40ed046c e2a30291 add      x2, sp, #0xa8
40ed0470 ff6f1529 stp      wzr, w27, [sp, #0xa8]
40ed0474 794c0194 bl       #0x40f23658
40ed0478 60000036 tbz      w0, #0, #0x40ed0484
40ed047c e7ab40b9 ldr      w7, [sp, #0xa8]
40ed0480 03000014 b        #0x40ed048c
40ed0484 e7030132 mov      w7, #-0x80000000
40ed0488 e7ab00b9 str      w7, [sp, #0xa8]
40ed048c e003142a mov      w0, w20
40ed0490 e103172a mov      w1, w23
40ed0494 e203152a mov      w2, w21
40ed0498 e303182a mov      w3, w24
40ed049c e403192a mov      w4, w25
40ed04a0 e5031a2a mov      w5, w26
40ed04a4 e603162a mov      w6, w22
40ed04a8 f6100094 bl       #0x40ed4880
40ed04ac e0a700b9 str      w0, [sp, #0xa4]
40ed04b0 804f0011 add      w0, w28, #0x13
40ed04b4 c74c0194 bl       #0x40f237d0
40ed04b8 f403002a mov      w20, w0
40ed04bc 80d30011 add      w0, w28, #0x34
40ed04c0 c44c0194 bl       #0x40f237d0
40ed04c4 e103002a mov      w1, w0
40ed04c8 e003142a mov      w0, w20
40ed04cc 6e220094 bl       #0x40ed8e84
40ed04d0 e09f00b9 str      w0, [sp, #0x9c]
40ed04d4 689f2e11 add      w8, w27, #0xba7
40ed04d8 e0030032 mov      w0, #1
40ed04dc e1b30291 add      x1, sp, #0xac
40ed04e0 e2a30291 add      x2, sp, #0xa8
40ed04e4 ff231529 stp      wzr, w8, [sp, #0xa8]
40ed04e8 5c4c0194 bl       #0x40f23658
40ed04ec 60000036 tbz      w0, #0, #0x40ed04f8
40ed04f0 e8ab40b9 ldr      w8, [sp, #0xa8]
40ed04f4 04000014 b        #0x40ed0504
40ed04f8 e9030132 mov      w9, #-0x80000000
40ed04fc e8030132 mov      w8, #-0x80000000
40ed0500 e9ab00b9 str      w9, [sp, #0xa8]
40ed0504 e89b00b9 str      w8, [sp, #0x98]
40ed0508 68a72e11 add      w8, w27, #0xba9
40ed050c e0030032 mov      w0, #1
40ed0510 e1b30291 add      x1, sp, #0xac
40ed0514 e2a30291 add      x2, sp, #0xa8
40ed0518 ff231529 stp      wzr, w8, [sp, #0xa8]
40ed051c 4f4c0194 bl       #0x40f23658
40ed0520 60000036 tbz      w0, #0, #0x40ed052c
40ed0524 e8ab40b9 ldr      w8, [sp, #0xa8]
40ed0528 04000014 b        #0x40ed0538
40ed052c e9030132 mov      w9, #-0x80000000
40ed0530 e8030132 mov      w8, #-0x80000000
40ed0534 e9ab00b9 str      w9, [sp, #0xa8]
40ed0538 e89700b9 str      w8, [sp, #0x94]
40ed053c 68af2e11 add      w8, w27, #0xbab
40ed0540 e0030032 mov      w0, #1
40ed0544 e1b30291 add      x1, sp, #0xac
40ed0548 e2a30291 add      x2, sp, #0xa8
40ed054c ff231529 stp      wzr, w8, [sp, #0xa8]
40ed0550 424c0194 bl       #0x40f23658
40ed0554 60000036 tbz      w0, #0, #0x40ed0560
40ed0558 e8ab40b9 ldr      w8, [sp, #0xa8]
40ed055c 04000014 b        #0x40ed056c
40ed0560 e9030132 mov      w9, #-0x80000000
40ed0564 e8030132 mov      w8, #-0x80000000
40ed0568 e9ab00b9 str      w9, [sp, #0xa8]
40ed056c e89300b9 str      w8, [sp, #0x90]
40ed0570 687b2d11 add      w8, w27, #0xb5e
40ed0574 e0030032 mov      w0, #1
40ed0578 e1b30291 add      x1, sp, #0xac
40ed057c e2a30291 add      x2, sp, #0xa8
40ed0580 ff231529 stp      wzr, w8, [sp, #0xa8]
40ed0584 354c0194 bl       #0x40f23658
40ed0588 60000036 tbz      w0, #0, #0x40ed0594
40ed058c e8ab40b9 ldr      w8, [sp, #0xa8]
40ed0590 04000014 b        #0x40ed05a0
40ed0594 e9030132 mov      w9, #-0x80000000
40ed0598 e8030132 mov      w8, #-0x80000000
40ed059c e9ab00b9 str      w9, [sp, #0xa8]
40ed05a0 e88f00b9 str      w8, [sp, #0x8c]
40ed05a4 544b8252 mov      w20, #0x125a
40ed05a8 14a0a072 movk     w20, #0x500, lsl #16
40ed05ac 880e0011 add      w8, w20, #3
40ed05b0 e0030032 mov      w0, #1
40ed05b4 e1b30291 add      x1, sp, #0xac
40ed05b8 e2a30291 add      x2, sp, #0xa8
40ed05bc ff231529 stp      wzr, w8, [sp, #0xa8]
40ed05c0 264c0194 bl       #0x40f23658
40ed05c4 60000036 tbz      w0, #0, #0x40ed05d0
40ed05c8 e8ab40b9 ldr      w8, [sp, #0xa8]
40ed05cc 04000014 b        #0x40ed05dc
40ed05d0 e9030132 mov      w9, #-0x80000000
40ed05d4 e8030132 mov      w8, #-0x80000000
40ed05d8 e9ab00b9 str      w9, [sp, #0xa8]
40ed05dc e88b00b9 str      w8, [sp, #0x88]
40ed05e0 880a0011 add      w8, w20, #2
40ed05e4 e0030032 mov      w0, #1
40ed05e8 e1b30291 add      x1, sp, #0xac
40ed05ec e2a30291 add      x2, sp, #0xa8
40ed05f0 ff231529 stp      wzr, w8, [sp, #0xa8]
40ed05f4 194c0194 bl       #0x40f23658
40ed05f8 60000036 tbz      w0, #0, #0x40ed0604
40ed05fc e8ab40b9 ldr      w8, [sp, #0xa8]
40ed0600 04000014 b        #0x40ed0610
40ed0604 e9030132 mov      w9, #-0x80000000
40ed0608 e8030132 mov      w8, #-0x80000000
40ed060c e9ab00b9 str      w9, [sp, #0xa8]
40ed0610 e88700b9 str      w8, [sp, #0x84]
40ed0614 88a18552 mov      w8, #0x2d0c
40ed0618 0880a072 movk     w8, #0x400, lsl #16
40ed061c e0030032 mov      w0, #1
40ed0620 e1b30291 add      x1, sp, #0xac
40ed0624 e2a30291 add      x2, sp, #0xa8
40ed0628 ff231529 stp      wzr, w8, [sp, #0xa8]
40ed062c 0b4c0194 bl       #0x40f23658
40ed0630 60000036 tbz      w0, #0, #0x40ed063c
40ed0634 e8ab40b9 ldr      w8, [sp, #0xa8]
40ed0638 04000014 b        #0x40ed0648
40ed063c e9030132 mov      w9, #-0x80000000
40ed0640 e8030132 mov      w8, #-0x80000000
40ed0644 e9ab00b9 str      w9, [sp, #0xa8]
40ed0648 e88300b9 str      w8, [sp, #0x80]
40ed064c 88a18552 mov      w8, #0x2d0c
40ed0650 0880a072 movk     w8, #0x400, lsl #16
40ed0654 081d0011 add      w8, w8, #7
40ed0658 e0030032 mov      w0, #1
40ed065c e1b30291 add      x1, sp, #0xac
40ed0660 e2a30291 add      x2, sp, #0xa8
40ed0664 ff231529 stp      wzr, w8, [sp, #0xa8]
40ed0668 fc4b0194 bl       #0x40f23658
40ed066c 60000036 tbz      w0, #0, #0x40ed0678
40ed0670 e8ab40b9 ldr      w8, [sp, #0xa8]
40ed0674 04000014 b        #0x40ed0684
40ed0678 e9030132 mov      w9, #-0x80000000
40ed067c e8030132 mov      w8, #-0x80000000
40ed0680 e9ab00b9 str      w9, [sp, #0xa8]
40ed0684 e87f00b9 str      w8, [sp, #0x7c]
40ed0688 68f21451 sub      w8, w19, #0x53c
40ed068c e0030032 mov      w0, #1
40ed0690 e1b30291 add      x1, sp, #0xac
40ed0694 e2a30291 add      x2, sp, #0xa8
40ed0698 ff231529 stp      wzr, w8, [sp, #0xa8]
40ed069c ef4b0194 bl       #0x40f23658
40ed06a0 60000036 tbz      w0, #0, #0x40ed06ac
40ed06a4 f5ab40b9 ldr      w21, [sp, #0xa8]
40ed06a8 03000014 b        #0x40ed06b4
40ed06ac f5030132 mov      w21, #-0x80000000
40ed06b0 f5ab00b9 str      w21, [sp, #0xa8]
40ed06b4 e0031c2a mov      w0, w28
40ed06b8 464c0194 bl       #0x40f237d0
40ed06bc e07b00b9 str      w0, [sp, #0x78]
40ed06c0 683e0051 sub      w8, w19, #0xf
40ed06c4 e0030032 mov      w0, #1
40ed06c8 e1b30291 add      x1, sp, #0xac
40ed06cc e2a30291 add      x2, sp, #0xa8
40ed06d0 ff231529 stp      wzr, w8, [sp, #0xa8]
40ed06d4 e14b0194 bl       #0x40f23658
40ed06d8 60000036 tbz      w0, #0, #0x40ed06e4
40ed06dc f8ab40b9 ldr      w24, [sp, #0xa8]
40ed06e0 03000014 b        #0x40ed06ec
40ed06e4 f8030132 mov      w24, #-0x80000000
40ed06e8 f8ab00b9 str      w24, [sp, #0xa8]
40ed06ec 68860011 add      w8, w19, #0x21
40ed06f0 e0030032 mov      w0, #1
40ed06f4 e1b30291 add      x1, sp, #0xac
40ed06f8 e2a30291 add      x2, sp, #0xa8
40ed06fc ff231529 stp      wzr, w8, [sp, #0xa8]
40ed0700 d64b0194 bl       #0x40f23658
40ed0704 60000036 tbz      w0, #0, #0x40ed0710
40ed0708 f9ab40b9 ldr      w25, [sp, #0xa8]
40ed070c 03000014 b        #0x40ed0718
40ed0710 f9030132 mov      w25, #-0x80000000
40ed0714 f9ab00b9 str      w25, [sp, #0xa8]
40ed0718 68ae0011 add      w8, w19, #0x2b
40ed071c e0030032 mov      w0, #1
40ed0720 e1b30291 add      x1, sp, #0xac
40ed0724 e2a30291 add      x2, sp, #0xa8
40ed0728 ff231529 stp      wzr, w8, [sp, #0xa8]
40ed072c cb4b0194 bl       #0x40f23658
40ed0730 60000036 tbz      w0, #0, #0x40ed073c
40ed0734 faab40b9 ldr      w26, [sp, #0xa8]
40ed0738 03000014 b        #0x40ed0744
40ed073c fa030132 mov      w26, #-0x80000000
40ed0740 faab00b9 str      w26, [sp, #0xa8]
40ed0744 e0030032 mov      w0, #1
40ed0748 ff4f1529 stp      wzr, w19, [sp, #0xa8]
40ed074c e1b30291 add      x1, sp, #0xac
40ed0750 e2a30291 add      x2, sp, #0xa8
40ed0754 c14b0194 bl       #0x40f23658
40ed0758 60000036 tbz      w0, #0, #0x40ed0764
40ed075c fbab40b9 ldr      w27, [sp, #0xa8]
40ed0760 03000014 b        #0x40ed076c
40ed0764 fb030132 mov      w27, #-0x80000000
40ed0768 fbab00b9 str      w27, [sp, #0xa8]
40ed076c 68120011 add      w8, w19, #4
40ed0770 e0030032 mov      w0, #1
40ed0774 e1b30291 add      x1, sp, #0xac
40ed0778 e2a30291 add      x2, sp, #0xa8
40ed077c ff231529 stp      wzr, w8, [sp, #0xa8]
40ed0780 b64b0194 bl       #0x40f23658
40ed0784 60000036 tbz      w0, #0, #0x40ed0790
40ed0788 fcab40b9 ldr      w28, [sp, #0xa8]
40ed078c 03000014 b        #0x40ed0798
40ed0790 fc030132 mov      w28, #-0x80000000
40ed0794 fcab00b9 str      w28, [sp, #0xa8]
40ed0798 687a0011 add      w8, w19, #0x1e
40ed079c f7a300b9 str      w23, [sp, #0xa0]
40ed07a0 e0030032 mov      w0, #1
40ed07a4 e1b30291 add      x1, sp, #0xac
40ed07a8 e2a30291 add      x2, sp, #0xa8
40ed07ac ff231529 stp      wzr, w8, [sp, #0xa8]
40ed07b0 aa4b0194 bl       #0x40f23658
40ed07b4 60000036 tbz      w0, #0, #0x40ed07c0
40ed07b8 f7ab40b9 ldr      w23, [sp, #0xa8]
40ed07bc 03000014 b        #0x40ed07c8
40ed07c0 f7030132 mov      w23, #-0x80000000
40ed07c4 f7ab00b9 str      w23, [sp, #0xa8]
40ed07c8 68a60011 add      w8, w19, #0x29
40ed07cc e0030032 mov      w0, #1
40ed07d0 e1b30291 add      x1, sp, #0xac
40ed07d4 e2a30291 add      x2, sp, #0xa8
40ed07d8 ff231529 stp      wzr, w8, [sp, #0xa8]
40ed07dc 9f4b0194 bl       #0x40f23658
40ed07e0 f303142a mov      w19, w20
40ed07e4 60000036 tbz      w0, #0, #0x40ed07f0
40ed07e8 fdab40b9 ldr      w29, [sp, #0xa8]
40ed07ec 03000014 b        #0x40ed07f8
40ed07f0 fd030132 mov      w29, #-0x80000000
40ed07f4 fdab00b9 str      w29, [sp, #0xa8]
40ed07f8 16208052 mov      w22, #0x100
40ed07fc 1600a872 movk     w22, #0x4000, lsl #16
40ed0800 c06e0011 add      w0, w22, #0x1b
40ed0804 f34b0194 bl       #0x40f237d0
40ed0808 1f000071 cmp      w0, #0
40ed080c c0860011 add      w0, w22, #0x21
40ed0810 f4079f1a cset     w20, ne
40ed0814 ef4b0194 bl       #0x40f237d0
40ed0818 e1235329 ldp      w1, w8, [sp, #0x98]
40ed081c e05b00b9 str      w0, [sp, #0x58]
40ed0820 e0a740b9 ldr      w0, [sp, #0xa4]
40ed0824 e86300b9 str      w8, [sp, #0x60]
40ed0828 e87b40b9 ldr      w8, [sp, #0x78]
40ed082c e30b5229 ldp      w3, w2, [sp, #0x90]
40ed0830 e5135129 ldp      w5, w4, [sp, #0x88]
40ed0834 e71b5029 ldp      w7, w6, [sp, #0x80]
40ed0838 f4430139 strb     w20, [sp, #0x50]
40ed083c e81300b9 str      w8, [sp, #0x10]
40ed0840 e87f40b9 ldr      w8, [sp, #0x7c]
40ed0844 fd4b00b9 str      w29, [sp, #0x48]
40ed0848 f74300b9 str      w23, [sp, #0x40]
40ed084c fc3b00b9 str      w28, [sp, #0x38]
40ed0850 fb3300b9 str      w27, [sp, #0x30]
40ed0854 fa2b00b9 str      w26, [sp, #0x28]
40ed0858 f92300b9 str      w25, [sp, #0x20]
40ed085c f81b00b9 str      w24, [sp, #0x18]
40ed0860 f50b00b9 str      w21, [sp, #8]
40ed0864 e80300b9 str      w8, [sp]
40ed0868 8a210094 bl       #0x40ed8e90
40ed086c b4d48052 mov      w20, #0x6a5
40ed0870 e09f00b9 str      w0, [sp, #0x9c]
40ed0874 14e0a072 movk     w20, #0x700, lsl #16
40ed0878 889a2e11 add      w8, w20, #0xba6
40ed087c e0030032 mov      w0, #1
40ed0880 e1b30291 add      x1, sp, #0xac
40ed0884 e2a30291 add      x2, sp, #0xa8
40ed0888 ff231529 stp      wzr, w8, [sp, #0xa8]
40ed088c 734b0194 bl       #0x40f23658
40ed0890 60000036 tbz      w0, #0, #0x40ed089c
40ed0894 e8ab40b9 ldr      w8, [sp, #0xa8]
40ed0898 04000014 b        #0x40ed08a8
40ed089c e9030132 mov      w9, #-0x80000000
40ed08a0 e8030132 mov      w8, #-0x80000000
40ed08a4 e9ab00b9 str      w9, [sp, #0xa8]
40ed08a8 e89b00b9 str      w8, [sp, #0x98]
40ed08ac 88a22e11 add      w8, w20, #0xba8
40ed08b0 e0030032 mov      w0, #1
40ed08b4 e1b30291 add      x1, sp, #0xac
40ed08b8 e2a30291 add      x2, sp, #0xa8
40ed08bc ff231529 stp      wzr, w8, [sp, #0xa8]
40ed08c0 664b0194 bl       #0x40f23658
40ed08c4 60000036 tbz      w0, #0, #0x40ed08d0
40ed08c8 e8ab40b9 ldr      w8, [sp, #0xa8]
40ed08cc 04000014 b        #0x40ed08dc
40ed08d0 e9030132 mov      w9, #-0x80000000
40ed08d4 e8030132 mov      w8, #-0x80000000
40ed08d8 e9ab00b9 str      w9, [sp, #0xa8]
40ed08dc e89700b9 str      w8, [sp, #0x94]
40ed08e0 88aa2e11 add      w8, w20, #0xbaa
40ed08e4 e0030032 mov      w0, #1
40ed08e8 e1b30291 add      x1, sp, #0xac
40ed08ec e2a30291 add      x2, sp, #0xa8
40ed08f0 ff231529 stp      wzr, w8, [sp, #0xa8]
40ed08f4 594b0194 bl       #0x40f23658
40ed08f8 60000036 tbz      w0, #0, #0x40ed0904
40ed08fc e8ab40b9 ldr      w8, [sp, #0xa8]
40ed0900 04000014 b        #0x40ed0910
40ed0904 e9030132 mov      w9, #-0x80000000
40ed0908 e8030132 mov      w8, #-0x80000000
40ed090c e9ab00b9 str      w9, [sp, #0xa8]
40ed0910 e89300b9 str      w8, [sp, #0x90]
40ed0914 88762d11 add      w8, w20, #0xb5d
40ed0918 e0030032 mov      w0, #1
40ed091c e1b30291 add      x1, sp, #0xac
40ed0920 e2a30291 add      x2, sp, #0xa8
40ed0924 ff231529 stp      wzr, w8, [sp, #0xa8]
40ed0928 4c4b0194 bl       #0x40f23658
40ed092c 60000036 tbz      w0, #0, #0x40ed0938
40ed0930 e8ab40b9 ldr      w8, [sp, #0xa8]
40ed0934 04000014 b        #0x40ed0944
40ed0938 e9030132 mov      w9, #-0x80000000
40ed093c e8030132 mov      w8, #-0x80000000
40ed0940 e9ab00b9 str      w9, [sp, #0xa8]
40ed0944 e88f00b9 str      w8, [sp, #0x8c]
40ed0948 68060011 add      w8, w19, #1
40ed094c e0030032 mov      w0, #1
40ed0950 e1b30291 add      x1, sp, #0xac
40ed0954 e2a30291 add      x2, sp, #0xa8
40ed0958 ff231529 stp      wzr, w8, [sp, #0xa8]
40ed095c 3f4b0194 bl       #0x40f23658
40ed0960 60000036 tbz      w0, #0, #0x40ed096c
40ed0964 e8ab40b9 ldr      w8, [sp, #0xa8]
40ed0968 04000014 b        #0x40ed0978
40ed096c e9030132 mov      w9, #-0x80000000
40ed0970 e8030132 mov      w8, #-0x80000000
40ed0974 e9ab00b9 str      w9, [sp, #0xa8]
40ed0978 e88b00b9 str      w8, [sp, #0x88]
40ed097c e0030032 mov      w0, #1
40ed0980 ff4f1529 stp      wzr, w19, [sp, #0xa8]
40ed0984 e1b30291 add      x1, sp, #0xac
40ed0988 e2a30291 add      x2, sp, #0xa8
40ed098c 334b0194 bl       #0x40f23658
40ed0990 60000036 tbz      w0, #0, #0x40ed099c
40ed0994 fcab40b9 ldr      w28, [sp, #0xa8]
40ed0998 03000014 b        #0x40ed09a4
40ed099c fc030132 mov      w28, #-0x80000000
40ed09a0 fcab00b9 str      w28, [sp, #0xa8]
40ed09a4 b3a78052 mov      w19, #0x53d
40ed09a8 13c0a072 movk     w19, #0x600, lsl #16
40ed09ac 68420051 sub      w8, w19, #0x10
40ed09b0 e0030032 mov      w0, #1
40ed09b4 e1b30291 add      x1, sp, #0xac
40ed09b8 e2a30291 add      x2, sp, #0xa8
40ed09bc ff231529 stp      wzr, w8, [sp, #0xa8]
40ed09c0 264b0194 bl       #0x40f23658
40ed09c4 60000036 tbz      w0, #0, #0x40ed09d0
40ed09c8 f6ab40b9 ldr      w22, [sp, #0xa8]
40ed09cc 03000014 b        #0x40ed09d8
40ed09d0 f6030132 mov      w22, #-0x80000000
40ed09d4 f6ab00b9 str      w22, [sp, #0xa8]
40ed09d8 68820011 add      w8, w19, #0x20
40ed09dc e0030032 mov      w0, #1
40ed09e0 e1b30291 add      x1, sp, #0xac
40ed09e4 e2a30291 add      x2, sp, #0xa8
40ed09e8 ff231529 stp      wzr, w8, [sp, #0xa8]
40ed09ec 1b4b0194 bl       #0x40f23658
40ed09f0 60000036 tbz      w0, #0, #0x40ed09fc
40ed09f4 f7ab40b9 ldr      w23, [sp, #0xa8]
40ed09f8 03000014 b        #0x40ed0a04
40ed09fc f7030132 mov      w23, #-0x80000000
40ed0a00 f7ab00b9 str      w23, [sp, #0xa8]
40ed0a04 68aa0011 add      w8, w19, #0x2a
40ed0a08 e0030032 mov      w0, #1
40ed0a0c e1b30291 add      x1, sp, #0xac
40ed0a10 e2a30291 add      x2, sp, #0xa8
40ed0a14 ff231529 stp      wzr, w8, [sp, #0xa8]
40ed0a18 104b0194 bl       #0x40f23658
40ed0a1c 60000036 tbz      w0, #0, #0x40ed0a28
40ed0a20 fdab40b9 ldr      w29, [sp, #0xa8]
40ed0a24 03000014 b        #0x40ed0a30
40ed0a28 fd030132 mov      w29, #-0x80000000
40ed0a2c fdab00b9 str      w29, [sp, #0xa8]
40ed0a30 e0030032 mov      w0, #1
40ed0a34 ff4f1529 stp      wzr, w19, [sp, #0xa8]
40ed0a38 e1b30291 add      x1, sp, #0xac
40ed0a3c e2a30291 add      x2, sp, #0xa8
40ed0a40 064b0194 bl       #0x40f23658
40ed0a44 60000036 tbz      w0, #0, #0x40ed0a50
40ed0a48 f5ab40b9 ldr      w21, [sp, #0xa8]
40ed0a4c 03000014 b        #0x40ed0a58
40ed0a50 f5030132 mov      w21, #-0x80000000
40ed0a54 f5ab00b9 str      w21, [sp, #0xa8]
40ed0a58 680e0011 add      w8, w19, #3
40ed0a5c e0030032 mov      w0, #1
40ed0a60 e1b30291 add      x1, sp, #0xac
40ed0a64 e2a30291 add      x2, sp, #0xa8
40ed0a68 ff231529 stp      wzr, w8, [sp, #0xa8]
40ed0a6c fb4a0194 bl       #0x40f23658
40ed0a70 60000036 tbz      w0, #0, #0x40ed0a7c
40ed0a74 f8ab40b9 ldr      w24, [sp, #0xa8]
40ed0a78 03000014 b        #0x40ed0a84
40ed0a7c f8030132 mov      w24, #-0x80000000
40ed0a80 f8ab00b9 str      w24, [sp, #0xa8]
40ed0a84 68760011 add      w8, w19, #0x1d
40ed0a88 e0030032 mov      w0, #1
40ed0a8c e1b30291 add      x1, sp, #0xac
40ed0a90 e2a30291 add      x2, sp, #0xa8
40ed0a94 ff231529 stp      wzr, w8, [sp, #0xa8]
40ed0a98 f04a0194 bl       #0x40f23658
40ed0a9c 60000036 tbz      w0, #0, #0x40ed0aa8
40ed0aa0 f9ab40b9 ldr      w25, [sp, #0xa8]
40ed0aa4 03000014 b        #0x40ed0ab0
40ed0aa8 f9030132 mov      w25, #-0x80000000
40ed0aac f9ab00b9 str      w25, [sp, #0xa8]
40ed0ab0 68a20011 add      w8, w19, #0x28
40ed0ab4 e0030032 mov      w0, #1
40ed0ab8 e1b30291 add      x1, sp, #0xac
40ed0abc e2a30291 add      x2, sp, #0xa8
40ed0ac0 ff231529 stp      wzr, w8, [sp, #0xa8]
40ed0ac4 e54a0194 bl       #0x40f23658
40ed0ac8 60000036 tbz      w0, #0, #0x40ed0ad4
40ed0acc faab40b9 ldr      w26, [sp, #0xa8]
40ed0ad0 03000014 b        #0x40ed0adc
40ed0ad4 fa030132 mov      w26, #-0x80000000
40ed0ad8 faab00b9 str      w26, [sp, #0xa8]
40ed0adc 08208052 mov      w8, #0x100
40ed0ae0 0800a872 movk     w8, #0x4000, lsl #16
40ed0ae4 f303082a mov      w19, w8
40ed0ae8 606e0011 add      w0, w19, #0x1b
40ed0aec 394b0194 bl       #0x40f237d0
40ed0af0 f403002a mov      w20, w0
40ed0af4 607a0011 add      w0, w19, #0x1e
40ed0af8 364b0194 bl       #0x40f237d0
40ed0afc 88a18552 mov      w8, #0x2d0c
40ed0b00 f303002a mov      w19, w0
40ed0b04 0880a072 movk     w8, #0x400, lsl #16
40ed0b08 e0030032 mov      w0, #1
40ed0b0c e1b30291 add      x1, sp, #0xac
40ed0b10 e2a30291 add      x2, sp, #0xa8
40ed0b14 ff231529 stp      wzr, w8, [sp, #0xa8]
40ed0b18 d04a0194 bl       #0x40f23658
40ed0b1c 60000036 tbz      w0, #0, #0x40ed0b28
40ed0b20 fbab40b9 ldr      w27, [sp, #0xa8]
40ed0b24 03000014 b        #0x40ed0b30
40ed0b28 fb030132 mov      w27, #-0x80000000
40ed0b2c fbab00b9 str      w27, [sp, #0xa8]
40ed0b30 88a18552 mov      w8, #0x2d0c
40ed0b34 0880a072 movk     w8, #0x400, lsl #16
40ed0b38 081d0011 add      w8, w8, #7
40ed0b3c e0030032 mov      w0, #1
40ed0b40 e1b30291 add      x1, sp, #0xac
40ed0b44 e2a30291 add      x2, sp, #0xa8
40ed0b48 ff231529 stp      wzr, w8, [sp, #0xa8]
40ed0b4c c34a0194 bl       #0x40f23658
40ed0b50 60000036 tbz      w0, #0, #0x40ed0b5c
40ed0b54 e8ab40b9 ldr      w8, [sp, #0xa8]
40ed0b58 03000014 b        #0x40ed0b64
40ed0b5c e8030132 mov      w8, #-0x80000000
40ed0b60 e8ab00b9 str      w8, [sp, #0xa8]
40ed0b64 9f020071 cmp      w20, #0
40ed0b68 e85300b9 str      w8, [sp, #0x50]
40ed0b6c e12b5329 ldp      w1, w10, [sp, #0x98]
40ed0b70 e7035429 ldp      w7, w0, [sp, #0xa0]
40ed0b74 e30b5229 ldp      w3, w2, [sp, #0x90]
40ed0b78 e5135129 ldp      w5, w4, [sp, #0x88]
40ed0b7c e9079f1a cset     w9, ne
40ed0b80 e6031c2a mov      w6, w28
40ed0b84 ea5b00b9 str      w10, [sp, #0x58]
40ed0b88 fb4b00b9 str      w27, [sp, #0x48]
40ed0b8c f34300b9 str      w19, [sp, #0x40]
40ed0b90 e9e30039 strb     w9, [sp, #0x38]
40ed0b94 fa3300b9 str      w26, [sp, #0x30]
40ed0b98 f92b00b9 str      w25, [sp, #0x28]
40ed0b9c f82300b9 str      w24, [sp, #0x20]
40ed0ba0 f51b00b9 str      w21, [sp, #0x18]
40ed0ba4 fd1300b9 str      w29, [sp, #0x10]
40ed0ba8 f70b00b9 str      w23, [sp, #8]
40ed0bac f60300b9 str      w22, [sp]
40ed0bb0 f1200094 bl       #0x40ed8f74
40ed0bb4 fd7b50a9 ldp      x29, x30, [sp, #0x100]
40ed0bb8 f44f4fa9 ldp      x20, x19, [sp, #0xf0]
40ed0bbc f6574ea9 ldp      x22, x21, [sp, #0xe0]
40ed0bc0 f85f4da9 ldp      x24, x23, [sp, #0xd0]
40ed0bc4 fa674ca9 ldp      x26, x25, [sp, #0xc0]
40ed0bc8 fc6f4ba9 ldp      x28, x27, [sp, #0xb0]
40ed0bcc ff430491 add      sp, sp, #0x110
40ed0bd0 c0035fd6 ret

; effective_size_selection: [0x40ed8f74, 0x40ed90d0)
; sha256 11d37066473c693faa24e82db65e0acf487f2a2abebc931a9948498d70a3222e
40ed8f74 e85340b9 ldr      w8, [sp, #0x50]
40ed8f78 eae34039 ldrb     w10, [sp, #0x38]
40ed8f7c e94b40b9 ldr      w9, [sp, #0x48]
40ed8f80 6a030036 tbz      w10, #0, #0x40ed8fec
40ed8f84 e14340b9 ldr      w1, [sp, #0x40]
40ed8f88 29011f32 orr      w9, w9, #2
40ed8f8c 3f0d0071 cmp      w9, #3
40ed8f90 e9179f1a cset     w9, eq
40ed8f94 1f010071 cmp      w8, #0
40ed8f98 e8179f1a cset     w8, eq
40ed8f9c 2801080a and      w8, w9, w8
40ed8fa0 1f050071 cmp      w8, #1
40ed8fa4 81010054 b.ne     #0x40ed8fd4
40ed8fa8 e95b40b9 ldr      w9, [sp, #0x58]
40ed8fac 1f180071 cmp      w0, #6
40ed8fb0 a0040054 b.eq     #0x40ed9044
40ed8fb4 1f140071 cmp      w0, #5
40ed8fb8 e1000054 b.ne     #0x40ed8fd4
40ed8fbc 28010032 orr      w8, w9, #1
40ed8fc0 a9008052 mov      w9, #5
40ed8fc4 1f0d0071 cmp      w8, #3
40ed8fc8 e8031f32 mov      w8, #2
40ed8fcc 0101891a csel     w1, w8, w9, eq
40ed8fd0 21000014 b        #0x40ed9054
40ed8fd4 3f0c0071 cmp      w1, #3
40ed8fd8 e1030054 b.ne     #0x40ed9054
40ed8fdc 1f010071 cmp      w8, #0
40ed8fe0 e8031f32 mov      w8, #2
40ed8fe4 0015881a cinc     w0, w8, eq
40ed8fe8 c0035fd6 ret
40ed8fec 87013836 tbz      w7, #7, #0x40ed901c
40ed8ff0 ea1b40b9 ldr      w10, [sp, #0x18]
40ed8ff4 5f050071 cmp      w10, #1
40ed8ff8 21010054 b.ne     #0x40ed901c
40ed8ffc 1f0c0071 cmp      w0, #3
40ed9000 80040054 b.eq     #0x40ed9090
40ed9004 1f080071 cmp      w0, #2
40ed9008 80040054 b.eq     #0x40ed9098
40ed900c 1f040071 cmp      w0, #1
40ed9010 c1030054 b.ne     #0x40ed9088
40ed9014 e12340b9 ldr      w1, [sp, #0x20]
40ed9018 dcffff17 b        #0x40ed8f88
40ed901c ff041b72 tst      w7, #0x60
40ed9020 e0010054 b.eq     #0x40ed905c
40ed9024 1f0c0071 cmp      w0, #3
40ed9028 c0030054 b.eq     #0x40ed90a0
40ed902c 1f080071 cmp      w0, #2
40ed9030 c0030054 b.eq     #0x40ed90a8
40ed9034 1f040071 cmp      w0, #1
40ed9038 81020054 b.ne     #0x40ed9088
40ed903c e10340b9 ldr      w1, [sp]
40ed9040 d2ffff17 b        #0x40ed8f88
40ed9044 3f090071 cmp      w9, #2
40ed9048 a8008052 mov      w8, #5
40ed904c e9031f32 mov      w9, #2
40ed9050 2131881a csel     w1, w9, w8, lo
40ed9054 e003012a mov      w0, w1
40ed9058 c0035fd6 ret
40ed905c 0a040051 sub      w10, w0, #1
40ed9060 5f150071 cmp      w10, #5
40ed9064 28010054 b.hi     #0x40ed9088
40ed9068 0b2a8cd2 mov      x11, #0x6150
40ed906c 4b54a0f2 movk     x11, #0x2a2, lsl #16
40ed9070 4b01c0f2 movk     x11, #0xa, lsl #32
40ed9074 0b00e0f2 movk     x11, #0, lsl #48
40ed9078 6a796af8 ldr      x10, [x11, x10, lsl #3]
40ed907c 40011fd6 br       x10
40ed9080 e103042a mov      w1, w4
40ed9084 c1ffff17 b        #0x40ed8f88
40ed9088 e1030032 mov      w1, #1
40ed908c bfffff17 b        #0x40ed8f88
40ed9090 e13340b9 ldr      w1, [sp, #0x30]
40ed9094 bdffff17 b        #0x40ed8f88
40ed9098 e12b40b9 ldr      w1, [sp, #0x28]
40ed909c bbffff17 b        #0x40ed8f88
40ed90a0 e11340b9 ldr      w1, [sp, #0x10]
40ed90a4 b9ffff17 b        #0x40ed8f88
40ed90a8 e10b40b9 ldr      w1, [sp, #8]
40ed90ac b7ffff17 b        #0x40ed8f88
40ed90b0 e103022a mov      w1, w2
40ed90b4 b5ffff17 b        #0x40ed8f88
40ed90b8 e103032a mov      w1, w3
40ed90bc b3ffff17 b        #0x40ed8f88
40ed90c0 e103052a mov      w1, w5
40ed90c4 b1ffff17 b        #0x40ed8f88
40ed90c8 e103062a mov      w1, w6
40ed90cc afffff17 b        #0x40ed8f88

; geometry_builder: [0x41065194, 0x4106669c)
; sha256 6ffc7e4ff59205e44e3335b28af603d52ea19e4195a4e0e5d8fcd0e17e9712da
41065194 ffc302d1 sub      sp, sp, #0xb0
41065198 fc6f05a9 stp      x28, x27, [sp, #0x50]
4106519c fa6706a9 stp      x26, x25, [sp, #0x60]
410651a0 f85f07a9 stp      x24, x23, [sp, #0x70]
410651a4 f65708a9 stp      x22, x21, [sp, #0x80]
410651a8 f44f09a9 stp      x20, x19, [sp, #0x90]
410651ac fd7b0aa9 stp      x29, x30, [sp, #0xa0]
410651b0 ff4b00b9 str      wzr, [sp, #0x48]
410651b4 f30301aa mov      x19, x1
410651b8 ffff03a9 stp      xzr, xzr, [sp, #0x38]
410651bc 0d0040b9 ldr      w13, [x0]
410651c0 080c40b9 ldr      w8, [x0, #0xc]
410651c4 ff3300b9 str      wzr, [sp, #0x30]
410651c8 ff2b00b9 str      wzr, [sp, #0x28]
410651cc bf590071 cmp      w13, #0x16
410651d0 68050034 cbz      w8, #0x4106527c
410651d4 88520054 b.hi     #0x41065c24
410651d8 17c98ed2 mov      x23, #0x7648
410651dc ff7f0429 stp      wzr, wzr, [sp, #0x20]
410651e0 3755a0f2 movk     x23, #0x2a9, lsl #16
410651e4 ff7f0329 stp      wzr, wzr, [sp, #0x18]
410651e8 5701c0f2 movk     x23, #0xa, lsl #32
410651ec ff7f0129 stp      wzr, wzr, [sp, #8]
410651f0 f6030d2a mov      w22, w13
410651f4 1700e0f2 movk     x23, #0, lsl #48
410651f8 e8031d32 mov      w8, #8
410651fc 04b28252 mov      w4, #0x1590
41065200 eb7a76f8 ldr      x11, [x23, x22, lsl #3]
41065204 010b8452 mov      w1, #0x2058
41065208 e81300b9 str      w8, [sp, #0x10]
4106520c e8071e32 mov      w8, #0xc
41065210 1bb08252 mov      w27, #0x1580
41065214 07088452 mov      w7, #0x2040
41065218 ef031f2a mov      w15, wzr
4106521c e81700b9 str      w8, [sp, #0x14]
41065220 f1031f2a mov      w17, wzr
41065224 f0031f2a mov      w16, wzr
41065228 ea031f2a mov      w10, wzr
4106522c ec031f2a mov      w12, wzr
41065230 e3031f2a mov      w3, wzr
41065234 e5031f2a mov      w5, wzr
41065238 ee031f2a mov      w14, wzr
4106523c f2031f2a mov      w18, wzr
41065240 e2031f2a mov      w2, wzr
41065244 fa031f2a mov      w26, wzr
41065248 f8031f2a mov      w24, wzr
4106524c f4031f2a mov      w20, wzr
41065250 f5031f2a mov      w21, wzr
41065254 f9031f2a mov      w25, wzr
41065258 e803012a mov      w8, w1
4106525c e903042a mov      w9, w4
41065260 fc03072a mov      w28, w7
41065264 e6031b2a mov      w6, w27
41065268 fe03072a mov      w30, w7
4106526c fd031b2a mov      w29, w27
41065270 f703012a mov      w23, w1
41065274 f603042a mov      w22, w4
41065278 60011fd6 br       x11
4106527c 484d0054 b.hi     #0x41065c24
41065280 09e08ed2 mov      x9, #0x7700
41065284 2955a0f2 movk     x9, #0x2a9, lsl #16
41065288 4901c0f2 movk     x9, #0xa, lsl #32
4106528c e8030d2a mov      w8, w13
41065290 0900e0f2 movk     x9, #0, lsl #48
41065294 287968f8 ldr      x8, [x9, x8, lsl #3]
41065298 00011fd6 br       x8
4106529c 080440b9 ldr      w8, [x0, #4]
410652a0 1f1d0071 cmp      w8, #7
410652a4 00540054 b.eq     #0x41065d24
410652a8 1f150071 cmp      w8, #5
410652ac 20570054 b.eq     #0x41065d90
410652b0 1f110071 cmp      w8, #4
410652b4 81470054 b.ne     #0x41065ba4
410652b8 ff7f0429 stp      wzr, wzr, [sp, #0x20]
410652bc 09048252 mov      w9, #0x1020
410652c0 08404039 ldrb     w8, [x0, #0x10]
410652c4 12448052 mov      w18, #0x220
410652c8 42268052 mov      w2, #0x132
410652cc ffff0229 stp      wzr, wzr, [sp, #0x14]
410652d0 e91f00b9 str      w9, [sp, #0x1c]
410652d4 51018052 mov      w17, #0xa
410652d8 44228152 mov      w4, #0x912
410652dc ffff0129 stp      wzr, wzr, [sp, #0xc]
410652e0 1f010071 cmp      w8, #0
410652e4 ff0b00b9 str      wzr, [sp, #8]
410652e8 c8bb8152 mov      w8, #0xdde
410652ec 2101881a csel     w1, w9, w8, eq
410652f0 48eb8052 mov      w8, #0x75a
410652f4 89ca8052 mov      w9, #0x654
410652f8 2901881a csel     w9, w9, w8, eq
410652fc 084f8052 mov      w8, #0x278
41065300 4a02881a csel     w10, w18, w8, eq
41065304 482c8052 mov      w8, #0x162
41065308 4c00881a csel     w12, w2, w8, eq
4106530c 08688152 mov      w8, #0xb40
41065310 ee031f2a mov      w14, wzr
41065314 f9031f2a mov      w25, wzr
41065318 18258152 mov      w24, #0x928
4106531c 9a058252 mov      w26, #0x102c
41065320 ef071f32 mov      w15, #6
41065324 1b878052 mov      w27, #0x438
41065328 e70f1932 mov      w7, #0x780
4106532c f003042a mov      w16, w4
41065330 e3071f32 mov      w3, #6
41065334 e503112a mov      w5, w17
41065338 fc03082a mov      w28, w8
4106533c e603092a mov      w6, w9
41065340 65040014 b        #0x410664d4
41065344 080440b9 ldr      w8, [x0, #4]
41065348 1f1d0071 cmp      w8, #7
4106534c 80560054 b.eq     #0x41065e1c
41065350 1f150071 cmp      w8, #5
41065354 005a0054 b.eq     #0x41065e94
41065358 1f110071 cmp      w8, #4
4106535c 41420054 b.ne     #0x41065ba4
41065360 08404039 ldrb     w8, [x0, #0x10]
41065364 bf250071 cmp      w13, #9
41065368 a0000054 b.eq     #0x4106537c
4106536c 090840b9 ldr      w9, [x0, #8]
41065370 29110051 sub      w9, w9, #4
41065374 3f090071 cmp      w9, #2
41065378 a9190054 b.ls     #0x410656ac
4106537c 1f010071 cmp      w8, #0
41065380 ff7f0429 stp      wzr, wzr, [sp, #0x20]
41065384 c8bb8152 mov      w8, #0xdde
41065388 ffff0229 stp      wzr, wzr, [sp, #0x14]
4106538c 09048252 mov      w9, #0x1020
41065390 ffff0129 stp      wzr, wzr, [sp, #0xc]
41065394 2101881a csel     w1, w9, w8, eq
41065398 ff0b00b9 str      wzr, [sp, #8]
4106539c 084f8052 mov      w8, #0x278
410653a0 12448052 mov      w18, #0x220
410653a4 e91f00b9 str      w9, [sp, #0x1c]
410653a8 4a02881a csel     w10, w18, w8, eq
410653ac 482c8052 mov      w8, #0x162
410653b0 42268052 mov      w2, #0x132
410653b4 51018052 mov      w17, #0xa
410653b8 44228152 mov      w4, #0x912
410653bc ee031f2a mov      w14, wzr
410653c0 f9031f2a mov      w25, wzr
410653c4 4c00881a csel     w12, w2, w8, eq
410653c8 18258152 mov      w24, #0x928
410653cc 9a058252 mov      w26, #0x102c
410653d0 ef071f32 mov      w15, #6
410653d4 1b0e8152 mov      w27, #0x870
410653d8 e70f1832 mov      w7, #0xf00
410653dc e803012a mov      w8, w1
410653e0 e903042a mov      w9, w4
410653e4 f003042a mov      w16, w4
410653e8 e3071f32 mov      w3, #6
410653ec e503112a mov      w5, w17
410653f0 fc03012a mov      w28, w1
410653f4 e603042a mov      w6, w4
410653f8 d0000014 b        #0x41065738
410653fc 0d0440b9 ldr      w13, [x0, #4]
41065400 e7031f2a mov      w7, wzr
41065404 bf210071 cmp      w13, #8
41065408 286e0054 b.hi     #0x410661cc
4106540c 0b008fd2 mov      x11, #0x7800
41065410 2b55a0f2 movk     x11, #0x2a9, lsl #16
41065414 4b01c0f2 movk     x11, #0xa, lsl #32
41065418 0b00e0f2 movk     x11, #0, lsl #48
4106541c e803072a mov      w8, w7
41065420 ea03072a mov      w10, w7
41065424 6b796df8 ldr      x11, [x11, x13, lsl #3]
41065428 ee03072a mov      w14, w7
4106542c e003072a mov      w0, w7
41065430 e8230429 stp      w8, w8, [sp, #0x20]
41065434 fb03072a mov      w27, w7
41065438 e103072a mov      w1, w7
4106543c ee2b0329 stp      w14, w10, [sp, #0x18]
41065440 e403072a mov      w4, w7
41065444 e0030229 stp      w0, w0, [sp, #0x10]
41065448 e903072a mov      w9, w7
4106544c e0030129 stp      w0, w0, [sp, #8]
41065450 ef03072a mov      w15, w7
41065454 f103072a mov      w17, w7
41065458 f003072a mov      w16, w7
4106545c ec03072a mov      w12, w7
41065460 e303072a mov      w3, w7
41065464 e503072a mov      w5, w7
41065468 fc03072a mov      w28, w7
4106546c e603072a mov      w6, w7
41065470 fe03072a mov      w30, w7
41065474 fd03072a mov      w29, w7
41065478 f203072a mov      w18, w7
4106547c e203072a mov      w2, w7
41065480 fa03072a mov      w26, w7
41065484 f803072a mov      w24, w7
41065488 f403072a mov      w20, w7
4106548c f503072a mov      w21, w7
41065490 f903072a mov      w25, w7
41065494 f703072a mov      w23, w7
41065498 f603072a mov      w22, w7
4106549c 60011fd6 br       x11
410654a0 e8031d32 mov      w8, #8
410654a4 ff7f0429 stp      wzr, wzr, [sp, #0x20]
410654a8 04b28252 mov      w4, #0x1590
410654ac ff7f0329 stp      wzr, wzr, [sp, #0x18]
410654b0 010b8452 mov      w1, #0x2058
410654b4 ff7f0129 stp      wzr, wzr, [sp, #8]
410654b8 e81300b9 str      w8, [sp, #0x10]
410654bc e8071e32 mov      w8, #0xc
410654c0 1bb08252 mov      w27, #0x1580
410654c4 07088452 mov      w7, #0x2040
410654c8 ef031f2a mov      w15, wzr
410654cc e81700b9 str      w8, [sp, #0x14]
410654d0 f1031f2a mov      w17, wzr
410654d4 f0031f2a mov      w16, wzr
410654d8 ea031f2a mov      w10, wzr
410654dc ec031f2a mov      w12, wzr
410654e0 e3031f2a mov      w3, wzr
410654e4 e5031f2a mov      w5, wzr
410654e8 ee031f2a mov      w14, wzr
410654ec f2031f2a mov      w18, wzr
410654f0 e2031f2a mov      w2, wzr
410654f4 fa031f2a mov      w26, wzr
410654f8 f8031f2a mov      w24, wzr
410654fc f4031f2a mov      w20, wzr
41065500 f5031f2a mov      w21, wzr
41065504 f9031f2a mov      w25, wzr
41065508 e803012a mov      w8, w1
4106550c e903042a mov      w9, w4
41065510 fc03072a mov      w28, w7
41065514 e6031b2a mov      w6, w27
41065518 fe03072a mov      w30, w7
4106551c fd031b2a mov      w29, w27
41065520 d1030014 b        #0x41066464
41065524 0d0440b9 ldr      w13, [x0, #4]
41065528 e7031f2a mov      w7, wzr
4106552c bf210071 cmp      w13, #8
41065530 e8640054 b.hi     #0x410661cc
41065534 0bf78ed2 mov      x11, #0x77b8
41065538 2b55a0f2 movk     x11, #0x2a9, lsl #16
4106553c 4b01c0f2 movk     x11, #0xa, lsl #32
41065540 0b00e0f2 movk     x11, #0, lsl #48
41065544 e803072a mov      w8, w7
41065548 ea03072a mov      w10, w7
4106554c 6b796df8 ldr      x11, [x11, x13, lsl #3]
41065550 ee03072a mov      w14, w7
41065554 e003072a mov      w0, w7
41065558 e8230429 stp      w8, w8, [sp, #0x20]
4106555c fb03072a mov      w27, w7
41065560 e103072a mov      w1, w7
41065564 ee2b0329 stp      w14, w10, [sp, #0x18]
41065568 e403072a mov      w4, w7
4106556c e0030229 stp      w0, w0, [sp, #0x10]
41065570 e903072a mov      w9, w7
41065574 e0030129 stp      w0, w0, [sp, #8]
41065578 ef03072a mov      w15, w7
4106557c f103072a mov      w17, w7
41065580 f003072a mov      w16, w7
41065584 ec03072a mov      w12, w7
41065588 e303072a mov      w3, w7
4106558c e503072a mov      w5, w7
41065590 fc03072a mov      w28, w7
41065594 e603072a mov      w6, w7
41065598 fe03072a mov      w30, w7
4106559c fd03072a mov      w29, w7
410655a0 f203072a mov      w18, w7
410655a4 e203072a mov      w2, w7
410655a8 fa03072a mov      w26, w7
410655ac f803072a mov      w24, w7
410655b0 f403072a mov      w20, w7
410655b4 f503072a mov      w21, w7
410655b8 f903072a mov      w25, w7
410655bc f703072a mov      w23, w7
410655c0 f603072a mov      w22, w7
410655c4 60011fd6 br       x11
410655c8 01048252 mov      w1, #0x1020
410655cc ff7f0429 stp      wzr, wzr, [sp, #0x20]
410655d0 eb03012a mov      w11, w1
410655d4 ffff0229 stp      wzr, wzr, [sp, #0x14]
410655d8 51018052 mov      w17, #0xa
410655dc ffff0129 stp      wzr, wzr, [sp, #0xc]
410655e0 44228152 mov      w4, #0x912
410655e4 ff0b00b9 str      wzr, [sp, #8]
410655e8 ee031f2a mov      w14, wzr
410655ec eb1f00b9 str      w11, [sp, #0x1c]
410655f0 f9031f2a mov      w25, wzr
410655f4 18258152 mov      w24, #0x928
410655f8 9a058252 mov      w26, #0x102c
410655fc 4c268052 mov      w12, #0x132
41065600 0a448052 mov      w10, #0x220
41065604 ef071f32 mov      w15, #6
41065608 89ca8052 mov      w9, #0x654
4106560c 08688152 mov      w8, #0xb40
41065610 1b878052 mov      w27, #0x438
41065614 e70f1932 mov      w7, #0x780
41065618 f003042a mov      w16, w4
4106561c e3071f32 mov      w3, #6
41065620 e503112a mov      w5, w17
41065624 d7010014 b        #0x41065d80
41065628 01088452 mov      w1, #0x2040
4106562c ff7f0429 stp      wzr, wzr, [sp, #0x20]
41065630 eb03012a mov      w11, w1
41065634 ffff0229 stp      wzr, wzr, [sp, #0x14]
41065638 d1028052 mov      w17, #0x16
4106563c ffff0129 stp      wzr, wzr, [sp, #0xc]
41065640 84448252 mov      w4, #0x1224
41065644 ff0b00b9 str      wzr, [sp, #8]
41065648 1b1c8252 mov      w27, #0x10e0
4106564c eb1f00b9 str      w11, [sp, #0x1c]
41065650 ee031f2a mov      w14, wzr
41065654 f9031f2a mov      w25, wzr
41065658 184a8252 mov      w24, #0x1250
4106565c 1a0b8452 mov      w26, #0x2058
41065660 0c878052 mov      w12, #0x438
41065664 ea0f1932 mov      w10, #0x780
41065668 ef071e32 mov      w15, #0xc
4106566c e70f1732 mov      w7, #0x1e00
41065670 e803012a mov      w8, w1
41065674 e903042a mov      w9, w4
41065678 f003042a mov      w16, w4
4106567c e3071e32 mov      w3, #0xc
41065680 e503112a mov      w5, w17
41065684 fc03012a mov      w28, w1
41065688 e603042a mov      w6, w4
4106568c fe0f1732 mov      w30, #0x1e00
41065690 fd031b2a mov      w29, w27
41065694 f20f1932 mov      w18, #0x780
41065698 fd010014 b        #0x41065e8c
4106569c 080440b9 ldr      w8, [x0, #4]
410656a0 1f110071 cmp      w8, #4
410656a4 01280054 b.ne     #0x41065ba4
410656a8 08404039 ldrb     w8, [x0, #0x10]
410656ac ff2700b9 str      wzr, [sp, #0x24]
410656b0 09088452 mov      w9, #0x2040
410656b4 ffff0229 stp      wzr, wzr, [sp, #0x14]
410656b8 1f010071 cmp      w8, #0
410656bc ffff0129 stp      wzr, wzr, [sp, #0xc]
410656c0 88778352 mov      w8, #0x1bbc
410656c4 ff0b00b9 str      wzr, [sp, #8]
410656c8 e9ff0329 stp      w9, wzr, [sp, #0x1c]
410656cc 2101881a csel     w1, w9, w8, eq
410656d0 08448252 mov      w8, #0x1220
410656d4 09d08252 mov      w9, #0x1680
410656d8 2801881a csel     w8, w9, w8, eq
410656dc 497b8152 mov      w9, #0xbda
410656e0 0a958152 mov      w10, #0xca8
410656e4 4901891a csel     w9, w10, w9, eq
410656e8 0a4f8052 mov      w10, #0x278
410656ec 12448052 mov      w18, #0x220
410656f0 4b2c8052 mov      w11, #0x162
410656f4 42268052 mov      w2, #0x132
410656f8 d1028052 mov      w17, #0x16
410656fc 84448252 mov      w4, #0x1224
41065700 ee031f2a mov      w14, wzr
41065704 f9031f2a mov      w25, wzr
41065708 4a028a1a csel     w10, w18, w10, eq
4106570c 4c008b1a csel     w12, w2, w11, eq
41065710 184a8252 mov      w24, #0x1250
41065714 1a0b8452 mov      w26, #0x2058
41065718 ef071e32 mov      w15, #0xc
4106571c 1b0e8152 mov      w27, #0x870
41065720 e70f1832 mov      w7, #0xf00
41065724 f003042a mov      w16, w4
41065728 e3071e32 mov      w3, #0xc
4106572c e503112a mov      w5, w17
41065730 fc03082a mov      w28, w8
41065734 e603092a mov      w6, w9
41065738 fe0f1832 mov      w30, #0xf00
4106573c 67030014 b        #0x410664d8
41065740 f0031f2a mov      w16, wzr
41065744 ff7f0429 stp      wzr, wzr, [sp, #0x20]
41065748 ea031f2a mov      w10, wzr
4106574c ff7f0329 stp      wzr, wzr, [sp, #0x18]
41065750 ec031f2a mov      w12, wzr
41065754 ff7f0229 stp      wzr, wzr, [sp, #0x10]
41065758 e3031f2a mov      w3, wzr
4106575c ff7f0129 stp      wzr, wzr, [sp, #8]
41065760 e5031f2a mov      w5, wzr
41065764 ee031f2a mov      w14, wzr
41065768 f2031f2a mov      w18, wzr
4106576c e2031f2a mov      w2, wzr
41065770 f9031f2a mov      w25, wzr
41065774 18258152 mov      w24, #0x928
41065778 9a058252 mov      w26, #0x102c
4106577c 51018052 mov      w17, #0xa
41065780 ef071f32 mov      w15, #6
41065784 44228152 mov      w4, #0x912
41065788 01048252 mov      w1, #0x1020
4106578c 4c030014 b        #0x410664bc
41065790 080440b9 ldr      w8, [x0, #4]
41065794 08110051 sub      w8, w8, #4
41065798 1f110071 cmp      w8, #4
4106579c 42200054 b.hs     #0x41065ba4
410657a0 e803082a mov      w8, w8
410657a4 ff7f0429 stp      wzr, wzr, [sp, #0x20]
410657a8 0bed7cd3 lsl      x11, x8, #4
410657ac ff7f0329 stp      wzr, wzr, [sp, #0x18]
410657b0 e80f09b2 mov      x8, #0x780000007800000
410657b4 ff7f0229 stp      wzr, wzr, [sp, #0x10]
410657b8 08f080f2 movk     x8, #0x780
410657bc ff7f0129 stp      wzr, wzr, [sp, #8]
410657c0 0725cb9a lsr      x7, x8, x11
410657c4 088780d2 mov      x8, #0x438
410657c8 0887a0f2 movk     x8, #0x438, lsl #16
410657cc 0887e0f2 movk     x8, #0x438, lsl #48
410657d0 1b25cb9a lsr      x27, x8, x11
410657d4 080482d2 mov      x8, #0x1020
410657d8 08a2a2f2 movk     x8, #0x1510, lsl #16
410657dc 08e0e1f2 movk     x8, #0xf00, lsl #48
410657e0 0125cb9a lsr      x1, x8, x11
410657e4 482281d2 mov      x8, #0x912
410657e8 087ba1f2 movk     x8, #0xbd8, lsl #16
410657ec 080ee1f2 movk     x8, #0x870, lsl #48
410657f0 0425cb9a lsr      x4, x8, x11
410657f4 c80080d2 mov      x8, #6
410657f8 0820a0f2 movk     x8, #0x100, lsl #16
410657fc 0821e0f2 movk     x8, #0x108, lsl #48
41065800 0f25cb9a lsr      x15, x8, x11
41065804 880582d2 mov      x8, #0x102c
41065808 08e2a2f2 movk     x8, #0x1710, lsl #16
4106580c 0822e2f2 movk     x8, #0x1110, lsl #48
41065810 4d0180d2 mov      x13, #0xa
41065814 1a25cb9a lsr      x26, x8, x11
41065818 082581d2 mov      x8, #0x928
4106581c 8d02a0f2 movk     x13, #0x14, lsl #16
41065820 0880a1f2 movk     x8, #0xc00, lsl #16
41065824 0d01e0f2 movk     x13, #8, lsl #48
41065828 0810e1f2 movk     x8, #0x880, lsl #48
4106582c f0031f2a mov      w16, wzr
41065830 ea031f2a mov      w10, wzr
41065834 ec031f2a mov      w12, wzr
41065838 e3031f2a mov      w3, wzr
4106583c e5031f2a mov      w5, wzr
41065840 ee031f2a mov      w14, wzr
41065844 f2031f2a mov      w18, wzr
41065848 e2031f2a mov      w2, wzr
4106584c f9031f2a mov      w25, wzr
41065850 1825cb9a lsr      x24, x8, x11
41065854 e803072a mov      w8, w7
41065858 e9031b2a mov      w9, w27
4106585c fc03072a mov      w28, w7
41065860 e6031b2a mov      w6, w27
41065864 fe03072a mov      w30, w7
41065868 fd031b2a mov      w29, w27
4106586c f4031a2a mov      w20, w26
41065870 f503182a mov      w21, w24
41065874 f7031a2a mov      w23, w26
41065878 f603182a mov      w22, w24
4106587c b125cb9a lsr      x17, x13, x11
41065880 1b030014 b        #0x410664ec
41065884 ff7f0429 stp      wzr, wzr, [sp, #0x20]
41065888 f0031f2a mov      w16, wzr
4106588c ff7f0329 stp      wzr, wzr, [sp, #0x18]
41065890 ea031f2a mov      w10, wzr
41065894 ec031f2a mov      w12, wzr
41065898 ff7f0229 stp      wzr, wzr, [sp, #0x10]
4106589c e3031f2a mov      w3, wzr
410658a0 ff7f0129 stp      wzr, wzr, [sp, #8]
410658a4 e5031f2a mov      w5, wzr
410658a8 ee031f2a mov      w14, wzr
410658ac f2031f2a mov      w18, wzr
410658b0 e2031f2a mov      w2, wzr
410658b4 f9031f2a mov      w25, wzr
410658b8 184a8252 mov      w24, #0x1250
410658bc 1a0b8452 mov      w26, #0x2058
410658c0 d1028052 mov      w17, #0x16
410658c4 ef071e32 mov      w15, #0xc
410658c8 84448252 mov      w4, #0x1224
410658cc 01088452 mov      w1, #0x2040
410658d0 fb020014 b        #0x410664bc
410658d4 080440b9 ldr      w8, [x0, #4]
410658d8 1f1d0071 cmp      w8, #7
410658dc a05c0054 b.eq     #0x41066470
410658e0 1f150071 cmp      w8, #5
410658e4 c0690054 b.eq     #0x4106661c
410658e8 1f110071 cmp      w8, #4
410658ec c1150054 b.ne     #0x41065ba4
410658f0 ff7f0429 stp      wzr, wzr, [sp, #0x20]
410658f4 94058252 mov      w20, #0x102c
410658f8 080840b9 ldr      w8, [x0, #8]
410658fc 15258152 mov      w21, #0x928
41065900 1b878052 mov      w27, #0x438
41065904 ff7f0329 stp      wzr, wzr, [sp, #0x18]
41065908 f0031f2a mov      w16, wzr
4106590c ff7f0229 stp      wzr, wzr, [sp, #0x10]
41065910 ea031f2a mov      w10, wzr
41065914 ff7f0129 stp      wzr, wzr, [sp, #8]
41065918 08110051 sub      w8, w8, #4
4106591c 1f0d0071 cmp      w8, #3
41065920 080b8452 mov      w8, #0x2058
41065924 1a31941a csel     w26, w8, w20, lo
41065928 084a8252 mov      w8, #0x1250
4106592c ec031f2a mov      w12, wzr
41065930 e3031f2a mov      w3, wzr
41065934 e5031f2a mov      w5, wzr
41065938 ee031f2a mov      w14, wzr
4106593c f2031f2a mov      w18, wzr
41065940 e2031f2a mov      w2, wzr
41065944 f9031f2a mov      w25, wzr
41065948 1831951a csel     w24, w8, w21, lo
4106594c 51018052 mov      w17, #0xa
41065950 ef071f32 mov      w15, #6
41065954 44228152 mov      w4, #0x912
41065958 01048252 mov      w1, #0x1020
4106595c e70f1932 mov      w7, #0x780
41065960 e80f1932 mov      w8, #0x780
41065964 e9031b2a mov      w9, w27
41065968 fc0f1932 mov      w28, #0x780
4106596c e6031b2a mov      w6, w27
41065970 fe0f1932 mov      w30, #0x780
41065974 29000014 b        #0x41065a18
41065978 ff7f0429 stp      wzr, wzr, [sp, #0x20]
4106597c f0031f2a mov      w16, wzr
41065980 080440b9 ldr      w8, [x0, #4]
41065984 ea031f2a mov      w10, wzr
41065988 ff7f0329 stp      wzr, wzr, [sp, #0x18]
4106598c ec031f2a mov      w12, wzr
41065990 e3031f2a mov      w3, wzr
41065994 ff7f0229 stp      wzr, wzr, [sp, #0x10]
41065998 e5031f2a mov      w5, wzr
4106599c ff7f0129 stp      wzr, wzr, [sp, #8]
410659a0 1f110071 cmp      w8, #4
410659a4 e80f1932 mov      w8, #0x780
410659a8 07019f1a csel     w7, w8, wzr, eq
410659ac 08878052 mov      w8, #0x438
410659b0 1b019f1a csel     w27, w8, wzr, eq
410659b4 08048252 mov      w8, #0x1020
410659b8 01019f1a csel     w1, w8, wzr, eq
410659bc 48228152 mov      w8, #0x912
410659c0 04019f1a csel     w4, w8, wzr, eq
410659c4 e8071f32 mov      w8, #6
410659c8 0f019f1a csel     w15, w8, wzr, eq
410659cc 48018052 mov      w8, #0xa
410659d0 11019f1a csel     w17, w8, wzr, eq
410659d4 080b8452 mov      w8, #0x2058
410659d8 1a019f1a csel     w26, w8, wzr, eq
410659dc 084a8252 mov      w8, #0x1250
410659e0 18019f1a csel     w24, w8, wzr, eq
410659e4 88058252 mov      w8, #0x102c
410659e8 14019f1a csel     w20, w8, wzr, eq
410659ec 08258152 mov      w8, #0x928
410659f0 ee031f2a mov      w14, wzr
410659f4 f2031f2a mov      w18, wzr
410659f8 e2031f2a mov      w2, wzr
410659fc f9031f2a mov      w25, wzr
41065a00 15019f1a csel     w21, w8, wzr, eq
41065a04 e803072a mov      w8, w7
41065a08 e9031b2a mov      w9, w27
41065a0c fc03072a mov      w28, w7
41065a10 e6031b2a mov      w6, w27
41065a14 fe03072a mov      w30, w7
41065a18 fd031b2a mov      w29, w27
41065a1c b2020014 b        #0x410664e4
41065a20 080440b9 ldr      w8, [x0, #4]
41065a24 1f050071 cmp      w8, #1
41065a28 e0270054 b.eq     #0x41065f24
41065a2c c80b0035 cbnz     w8, #0x41065ba4
41065a30 f0031f2a mov      w16, wzr
41065a34 ff7f0429 stp      wzr, wzr, [sp, #0x20]
41065a38 ea031f2a mov      w10, wzr
41065a3c ff7f0329 stp      wzr, wzr, [sp, #0x18]
41065a40 ec031f2a mov      w12, wzr
41065a44 ff7f0229 stp      wzr, wzr, [sp, #0x10]
41065a48 e3031f2a mov      w3, wzr
41065a4c ff7f0129 stp      wzr, wzr, [sp, #8]
41065a50 e5031f2a mov      w5, wzr
41065a54 ee031f2a mov      w14, wzr
41065a58 f2031f2a mov      w18, wzr
41065a5c e2031f2a mov      w2, wzr
41065a60 f9031f2a mov      w25, wzr
41065a64 18b28252 mov      w24, #0x1590
41065a68 1a0b8452 mov      w26, #0x2058
41065a6c f1031d32 mov      w17, #8
41065a70 ef071e32 mov      w15, #0xc
41065a74 096c8052 mov      w9, #0x360
41065a78 08a28052 mov      w8, #0x510
41065a7c 04b08252 mov      w4, #0x1580
41065a80 01088452 mov      w1, #0x2040
41065a84 73010014 b        #0x41066050
41065a88 88438052 mov      w8, #0x21c
41065a8c ff7f0429 stp      wzr, wzr, [sp, #0x20]
41065a90 18c38152 mov      w24, #0xe18
41065a94 ff7f0329 stp      wzr, wzr, [sp, #0x18]
41065a98 1aa48252 mov      w26, #0x1520
41065a9c ff7f0229 stp      wzr, wzr, [sp, #0x10]
41065aa0 e80b00b9 str      w8, [sp, #8]
41065aa4 88b38052 mov      w8, #0x59c
41065aa8 096c8052 mov      w9, #0x360
41065aac 9b6a8052 mov      w27, #0x354
41065ab0 e80f00b9 str      w8, [sp, #0xc]
41065ab4 08a28052 mov      w8, #0x510
41065ab8 07a08052 mov      w7, #0x500
41065abc f0031f2a mov      w16, wzr
41065ac0 ea031f2a mov      w10, wzr
41065ac4 ec031f2a mov      w12, wzr
41065ac8 e3031f2a mov      w3, wzr
41065acc e5031f2a mov      w5, wzr
41065ad0 ee031f2a mov      w14, wzr
41065ad4 f2031f2a mov      w18, wzr
41065ad8 e2031f2a mov      w2, wzr
41065adc f9031f2a mov      w25, wzr
41065ae0 164a8252 mov      w22, #0x1250
41065ae4 170b8452 mov      w23, #0x2058
41065ae8 ef031d32 mov      w15, #8
41065aec 04c18152 mov      w4, #0xe08
41065af0 01a28252 mov      w1, #0x1510
41065af4 f1031d32 mov      w17, #8
41065af8 fc03082a mov      w28, w8
41065afc e603092a mov      w6, w9
41065b00 fe03072a mov      w30, w7
41065b04 fd031b2a mov      w29, w27
41065b08 f4031a2a mov      w20, w26
41065b0c f503182a mov      w21, w24
41065b10 77020014 b        #0x410664ec
41065b14 080440b9 ldr      w8, [x0, #4]
41065b18 1f050071 cmp      w8, #1
41065b1c 00230054 b.eq     #0x41065f7c
41065b20 28040035 cbnz     w8, #0x41065ba4
41065b24 98588152 mov      w24, #0xac4
41065b28 ff7f0429 stp      wzr, wzr, [sp, #0x20]
41065b2c 9a058252 mov      w26, #0x102c
41065b30 ff7f0329 stp      wzr, wzr, [sp, #0x18]
41065b34 096c8052 mov      w9, #0x360
41065b38 ff7f0229 stp      wzr, wzr, [sp, #0x10]
41065b3c 08a28052 mov      w8, #0x510
41065b40 ff7f0129 stp      wzr, wzr, [sp, #8]
41065b44 9b6a8052 mov      w27, #0x354
41065b48 07a08052 mov      w7, #0x500
41065b4c f0031f2a mov      w16, wzr
41065b50 ea031f2a mov      w10, wzr
41065b54 ec031f2a mov      w12, wzr
41065b58 e3031f2a mov      w3, wzr
41065b5c e5031f2a mov      w5, wzr
41065b60 ee031f2a mov      w14, wzr
41065b64 f2031f2a mov      w18, wzr
41065b68 e2031f2a mov      w2, wzr
41065b6c 16598152 mov      w22, #0xac8
41065b70 f1031f32 mov      w17, #2
41065b74 ef071f32 mov      w15, #6
41065b78 04588152 mov      w4, #0xac0
41065b7c 01048252 mov      w1, #0x1020
41065b80 fc03082a mov      w28, w8
41065b84 e603092a mov      w6, w9
41065b88 fe03072a mov      w30, w7
41065b8c fd031b2a mov      w29, w27
41065b90 f4031a2a mov      w20, w26
41065b94 f503182a mov      w21, w24
41065b98 f9031f32 mov      w25, #2
41065b9c f7031a2a mov      w23, w26
41065ba0 53020014 b        #0x410664ec
41065ba4 e7031f2a mov      w7, wzr
41065ba8 ff7f0429 stp      wzr, wzr, [sp, #0x20]
41065bac fb031f2a mov      w27, wzr
41065bb0 ff7f0329 stp      wzr, wzr, [sp, #0x18]
41065bb4 e1031f2a mov      w1, wzr
41065bb8 ff7f0229 stp      wzr, wzr, [sp, #0x10]
41065bbc e4031f2a mov      w4, wzr
41065bc0 ff7f0129 stp      wzr, wzr, [sp, #8]
41065bc4 e8031f2a mov      w8, wzr
41065bc8 e9031f2a mov      w9, wzr
41065bcc ef031f2a mov      w15, wzr
41065bd0 f1031f2a mov      w17, wzr
41065bd4 f0031f2a mov      w16, wzr
41065bd8 ea031f2a mov      w10, wzr
41065bdc ec031f2a mov      w12, wzr
41065be0 e3031f2a mov      w3, wzr
41065be4 e5031f2a mov      w5, wzr
41065be8 fc031f2a mov      w28, wzr
41065bec e6031f2a mov      w6, wzr
41065bf0 fe031f2a mov      w30, wzr
41065bf4 fd031f2a mov      w29, wzr
41065bf8 ee031f2a mov      w14, wzr
41065bfc f2031f2a mov      w18, wzr
41065c00 e2031f2a mov      w2, wzr
41065c04 fa031f2a mov      w26, wzr
41065c08 f8031f2a mov      w24, wzr
41065c0c f4031f2a mov      w20, wzr
41065c10 f5031f2a mov      w21, wzr
41065c14 f9031f2a mov      w25, wzr
41065c18 f7031f2a mov      w23, wzr
41065c1c f6031f2a mov      w22, wzr
41065c20 33020014 b        #0x410664ec
41065c24 0d0440b9 ldr      w13, [x0, #4]
41065c28 e7031f2a mov      w7, wzr
41065c2c bf210071 cmp      w13, #8
41065c30 e82c0054 b.hi     #0x410661cc
41065c34 0b098fd2 mov      x11, #0x7848
41065c38 2b55a0f2 movk     x11, #0x2a9, lsl #16
41065c3c 4b01c0f2 movk     x11, #0xa, lsl #32
41065c40 0b00e0f2 movk     x11, #0, lsl #48
41065c44 e803072a mov      w8, w7
41065c48 ea03072a mov      w10, w7
41065c4c 6b796df8 ldr      x11, [x11, x13, lsl #3]
41065c50 ee03072a mov      w14, w7
41065c54 e003072a mov      w0, w7
41065c58 e8230429 stp      w8, w8, [sp, #0x20]
41065c5c fb03072a mov      w27, w7
41065c60 e103072a mov      w1, w7
41065c64 ee2b0329 stp      w14, w10, [sp, #0x18]
41065c68 e403072a mov      w4, w7
41065c6c e0030229 stp      w0, w0, [sp, #0x10]
41065c70 e903072a mov      w9, w7
41065c74 e0030129 stp      w0, w0, [sp, #8]
41065c78 ef03072a mov      w15, w7
41065c7c f103072a mov      w17, w7
41065c80 f003072a mov      w16, w7
41065c84 ec03072a mov      w12, w7
41065c88 e303072a mov      w3, w7
41065c8c e503072a mov      w5, w7
41065c90 fc03072a mov      w28, w7
41065c94 e603072a mov      w6, w7
41065c98 fe03072a mov      w30, w7
41065c9c fd03072a mov      w29, w7
41065ca0 f203072a mov      w18, w7
41065ca4 e203072a mov      w2, w7
41065ca8 fa03072a mov      w26, w7
41065cac f803072a mov      w24, w7
41065cb0 f403072a mov      w20, w7
41065cb4 f503072a mov      w21, w7
41065cb8 f903072a mov      w25, w7
41065cbc f703072a mov      w23, w7
41065cc0 f603072a mov      w22, w7
41065cc4 60011fd6 br       x11
41065cc8 e8031d32 mov      w8, #8
41065ccc ff7f0429 stp      wzr, wzr, [sp, #0x20]
41065cd0 f0031f2a mov      w16, wzr
41065cd4 ff7f0229 stp      wzr, wzr, [sp, #0x10]
41065cd8 ea031f2a mov      w10, wzr
41065cdc ff7f0129 stp      wzr, wzr, [sp, #8]
41065ce0 ec031f2a mov      w12, wzr
41065ce4 e87f0329 stp      w8, wzr, [sp, #0x18]
41065ce8 e3031f2a mov      w3, wzr
41065cec e5031f2a mov      w5, wzr
41065cf0 f2031f2a mov      w18, wzr
41065cf4 e2031f2a mov      w2, wzr
41065cf8 f9031f2a mov      w25, wzr
41065cfc 98e58052 mov      w24, #0x72c
41065d00 9a588152 mov      w26, #0xac4
41065d04 ee071f32 mov      w14, #6
41065d08 f1031f32 mov      w17, #2
41065d0c ef031e32 mov      w15, #4
41065d10 096c8052 mov      w9, #0x360
41065d14 08a28052 mov      w8, #0x510
41065d18 04e58052 mov      w4, #0x728
41065d1c 81578152 mov      w1, #0xabc
41065d20 cc000014 b        #0x41066050
41065d24 0f218052 mov      w15, #0x108
41065d28 ff7f0429 stp      wzr, wzr, [sp, #0x20]
41065d2c 040e8152 mov      w4, #0x870
41065d30 ffff0229 stp      wzr, wzr, [sp, #0x14]
41065d34 ee031f2a mov      w14, wzr
41065d38 ffff0129 stp      wzr, wzr, [sp, #0xc]
41065d3c f9031f2a mov      w25, wzr
41065d40 ff0b00b9 str      wzr, [sp, #8]
41065d44 18108152 mov      w24, #0x880
41065d48 1a228252 mov      w26, #0x1110
41065d4c 4c268052 mov      w12, #0x132
41065d50 0a448052 mov      w10, #0x220
41065d54 f1031d32 mov      w17, #8
41065d58 89ca8052 mov      w9, #0x654
41065d5c 08688152 mov      w8, #0xb40
41065d60 e10f1832 mov      w1, #0xf00
41065d64 1b878052 mov      w27, #0x438
41065d68 e70f1932 mov      w7, #0x780
41065d6c eb0f1832 mov      w11, #0xf00
41065d70 f003042a mov      w16, w4
41065d74 e3030f2a mov      w3, w15
41065d78 e5031d32 mov      w5, #8
41065d7c eb1f00b9 str      w11, [sp, #0x1c]
41065d80 fc03082a mov      w28, w8
41065d84 e603092a mov      w6, w9
41065d88 fe0f1932 mov      w30, #0x780
41065d8c 3e000014 b        #0x41065e84
41065d90 ff7f0429 stp      wzr, wzr, [sp, #0x20]
41065d94 09a28252 mov      w9, #0x1510
41065d98 08404039 ldrb     w8, [x0, #0x10]
41065d9c 12448052 mov      w18, #0x220
41065da0 42268052 mov      w2, #0x132
41065da4 ffff0229 stp      wzr, wzr, [sp, #0x14]
41065da8 e91f00b9 str      w9, [sp, #0x1c]
41065dac 91028052 mov      w17, #0x14
41065db0 047b8152 mov      w4, #0xbd8
41065db4 ffff0129 stp      wzr, wzr, [sp, #0xc]
41065db8 1f010071 cmp      w8, #0
41065dbc ff0b00b9 str      wzr, [sp, #8]
41065dc0 88438252 mov      w8, #0x121c
41065dc4 2101881a csel     w1, w9, w8, eq
41065dc8 48eb8052 mov      w8, #0x75a
41065dcc 49ca8052 mov      w9, #0x652
41065dd0 2901881a csel     w9, w9, w8, eq
41065dd4 084f8052 mov      w8, #0x278
41065dd8 4a02881a csel     w10, w18, w8, eq
41065ddc 482c8052 mov      w8, #0x162
41065de0 4c00881a csel     w12, w2, w8, eq
41065de4 08688152 mov      w8, #0xb40
41065de8 ee031f2a mov      w14, wzr
41065dec f9031f2a mov      w25, wzr
41065df0 f8071632 mov      w24, #0xc00
41065df4 1ae28252 mov      w26, #0x1710
41065df8 ef031832 mov      w15, #0x100
41065dfc 1b878052 mov      w27, #0x438
41065e00 e70f1932 mov      w7, #0x780
41065e04 f003042a mov      w16, w4
41065e08 e3031832 mov      w3, #0x100
41065e0c e503112a mov      w5, w17
41065e10 fc03082a mov      w28, w8
41065e14 e603092a mov      w6, w9
41065e18 1a020014 b        #0x41066680
41065e1c eb0f1832 mov      w11, #0xf00
41065e20 ff7f0429 stp      wzr, wzr, [sp, #0x20]
41065e24 0f218052 mov      w15, #0x108
41065e28 ffff0229 stp      wzr, wzr, [sp, #0x14]
41065e2c 1b0e8152 mov      w27, #0x870
41065e30 ffff0129 stp      wzr, wzr, [sp, #0xc]
41065e34 ee031f2a mov      w14, wzr
41065e38 ff0b00b9 str      wzr, [sp, #8]
41065e3c f9031f2a mov      w25, wzr
41065e40 eb1f00b9 str      w11, [sp, #0x1c]
41065e44 18108152 mov      w24, #0x880
41065e48 1a228252 mov      w26, #0x1110
41065e4c 4c268052 mov      w12, #0x132
41065e50 0a448052 mov      w10, #0x220
41065e54 f1031d32 mov      w17, #8
41065e58 e70f1832 mov      w7, #0xf00
41065e5c e10f1832 mov      w1, #0xf00
41065e60 e4031b2a mov      w4, w27
41065e64 e80f1832 mov      w8, #0xf00
41065e68 e9031b2a mov      w9, w27
41065e6c f0031b2a mov      w16, w27
41065e70 e3030f2a mov      w3, w15
41065e74 e5031d32 mov      w5, #8
41065e78 fc0f1832 mov      w28, #0xf00
41065e7c e6031b2a mov      w6, w27
41065e80 fe0f1832 mov      w30, #0xf00
41065e84 fd031b2a mov      w29, w27
41065e88 f2030a2a mov      w18, w10
41065e8c e2030c2a mov      w2, w12
41065e90 93010014 b        #0x410664dc
41065e94 ff7f0429 stp      wzr, wzr, [sp, #0x20]
41065e98 09a28252 mov      w9, #0x1510
41065e9c 08404039 ldrb     w8, [x0, #0x10]
41065ea0 047b8152 mov      w4, #0xbd8
41065ea4 0a4f8052 mov      w10, #0x278
41065ea8 ffff0229 stp      wzr, wzr, [sp, #0x14]
41065eac e91f00b9 str      w9, [sp, #0x1c]
41065eb0 12448052 mov      w18, #0x220
41065eb4 4b2c8052 mov      w11, #0x162
41065eb8 ffff0129 stp      wzr, wzr, [sp, #0xc]
41065ebc 1f010071 cmp      w8, #0
41065ec0 ff0b00b9 str      wzr, [sp, #8]
41065ec4 88438252 mov      w8, #0x121c
41065ec8 2101881a csel     w1, w9, w8, eq
41065ecc 09448252 mov      w9, #0x1220
41065ed0 2801881a csel     w8, w9, w8, eq
41065ed4 09468152 mov      w9, #0xa30
41065ed8 2901841a csel     w9, w9, w4, eq
41065edc 42268052 mov      w2, #0x132
41065ee0 91028052 mov      w17, #0x14
41065ee4 ee031f2a mov      w14, wzr
41065ee8 f9031f2a mov      w25, wzr
41065eec 4a028a1a csel     w10, w18, w10, eq
41065ef0 4c008b1a csel     w12, w2, w11, eq
41065ef4 f8071632 mov      w24, #0xc00
41065ef8 1ae28252 mov      w26, #0x1710
41065efc ef031832 mov      w15, #0x100
41065f00 1b0e8152 mov      w27, #0x870
41065f04 e70f1832 mov      w7, #0xf00
41065f08 f003042a mov      w16, w4
41065f0c e3031832 mov      w3, #0x100
41065f10 e503112a mov      w5, w17
41065f14 fc03082a mov      w28, w8
41065f18 e603092a mov      w6, w9
41065f1c fe0f1832 mov      w30, #0xf00
41065f20 d9010014 b        #0x41066684
41065f24 ff7f0429 stp      wzr, wzr, [sp, #0x20]
41065f28 f0031f2a mov      w16, wzr
41065f2c ff7f0329 stp      wzr, wzr, [sp, #0x18]
41065f30 ea031f2a mov      w10, wzr
41065f34 ec031f2a mov      w12, wzr
41065f38 ff7f0229 stp      wzr, wzr, [sp, #0x10]
41065f3c e3031f2a mov      w3, wzr
41065f40 ff7f0129 stp      wzr, wzr, [sp, #8]
41065f44 e5031f2a mov      w5, wzr
41065f48 ee031f2a mov      w14, wzr
41065f4c f2031f2a mov      w18, wzr
41065f50 e2031f2a mov      w2, wzr
41065f54 f9031f2a mov      w25, wzr
41065f58 18b28252 mov      w24, #0x1590
41065f5c 1a0b8452 mov      w26, #0x2058
41065f60 91788052 mov      w17, #0x3c4
41065f64 8fb48052 mov      w15, #0x5a4
41065f68 096c8052 mov      w9, #0x360
41065f6c 08a28052 mov      w8, #0x510
41065f70 04c18152 mov      w4, #0xe08
41065f74 01a28252 mov      w1, #0x1510
41065f78 36000014 b        #0x41066050
41065f7c 98588152 mov      w24, #0xac4
41065f80 ff7f0429 stp      wzr, wzr, [sp, #0x20]
41065f84 9a058252 mov      w26, #0x102c
41065f88 ff7f0329 stp      wzr, wzr, [sp, #0x18]
41065f8c 096c8052 mov      w9, #0x360
41065f90 ff7f0229 stp      wzr, wzr, [sp, #0x10]
41065f94 08a28052 mov      w8, #0x510
41065f98 ff7f0129 stp      wzr, wzr, [sp, #8]
41065f9c 9b6a8052 mov      w27, #0x354
41065fa0 07a08052 mov      w7, #0x500
41065fa4 f0031f2a mov      w16, wzr
41065fa8 ea031f2a mov      w10, wzr
41065fac ec031f2a mov      w12, wzr
41065fb0 e3031f2a mov      w3, wzr
41065fb4 e5031f2a mov      w5, wzr
41065fb8 ee031f2a mov      w14, wzr
41065fbc f2031f2a mov      w18, wzr
41065fc0 e2031f2a mov      w2, wzr
41065fc4 16598152 mov      w22, #0xac8
41065fc8 f9031f32 mov      w25, #2
41065fcc f10f1b32 mov      w17, #0x1e0
41065fd0 4f5a8052 mov      w15, #0x2d2
41065fd4 84e08052 mov      w4, #0x704
41065fd8 01518152 mov      w1, #0xa88
41065fdc fc03082a mov      w28, w8
41065fe0 e603092a mov      w6, w9
41065fe4 fe03072a mov      w30, w7
41065fe8 fd031b2a mov      w29, w27
41065fec f4031a2a mov      w20, w26
41065ff0 f503182a mov      w21, w24
41065ff4 eafeff17 b        #0x41065b9c
41065ff8 e8031d32 mov      w8, #8
41065ffc ff7f0429 stp      wzr, wzr, [sp, #0x20]
41066000 f0031f2a mov      w16, wzr
41066004 ff7f0229 stp      wzr, wzr, [sp, #0x10]
41066008 ea031f2a mov      w10, wzr
4106600c ff7f0129 stp      wzr, wzr, [sp, #8]
41066010 ec031f2a mov      w12, wzr
41066014 e87f0329 stp      w8, wzr, [sp, #0x18]
41066018 e3031f2a mov      w3, wzr
4106601c e5031f2a mov      w5, wzr
41066020 f2031f2a mov      w18, wzr
41066024 e2031f2a mov      w2, wzr
41066028 f9031f2a mov      w25, wzr
4106602c 98e58052 mov      w24, #0x72c
41066030 9a588152 mov      w26, #0xac4
41066034 ee071f32 mov      w14, #6
41066038 11288052 mov      w17, #0x140
4106603c ef0f1b32 mov      w15, #0x1e0
41066040 096c8052 mov      w9, #0x360
41066044 08a28052 mov      w8, #0x510
41066048 84958052 mov      w4, #0x4ac
4106604c 81e08052 mov      w1, #0x704
41066050 9b6a8052 mov      w27, #0x354
41066054 07a08052 mov      w7, #0x500
41066058 fc03082a mov      w28, w8
4106605c e603092a mov      w6, w9
41066060 fe03072a mov      w30, w7
41066064 1d010014 b        #0x410664d8
41066068 88088052 mov      w8, #0x44
4106606c ff7f0429 stp      wzr, wzr, [sp, #0x20]
41066070 07a08052 mov      w7, #0x500
41066074 ff7f0129 stp      wzr, wzr, [sp, #8]
41066078 1b5a8052 mov      w27, #0x2d0
4106607c e87f0229 stp      w8, wzr, [sp, #0x10]
41066080 e8031d32 mov      w8, #8
41066084 f0031f2a mov      w16, wzr
41066088 ea031f2a mov      w10, wzr
4106608c e87f0329 stp      w8, wzr, [sp, #0x18]
41066090 08a28052 mov      w8, #0x510
41066094 ec031f2a mov      w12, wzr
41066098 e3031f2a mov      w3, wzr
4106609c e5031f2a mov      w5, wzr
410660a0 f2031f2a mov      w18, wzr
410660a4 e2031f2a mov      w2, wzr
410660a8 f9031f2a mov      w25, wzr
410660ac 98e58052 mov      w24, #0x72c
410660b0 9a588152 mov      w26, #0xac4
410660b4 065b8052 mov      w6, #0x2d8
410660b8 f1031f32 mov      w17, #2
410660bc ef031e32 mov      w15, #4
410660c0 096c8052 mov      w9, #0x360
410660c4 04e58052 mov      w4, #0x728
410660c8 81578152 mov      w1, #0xabc
410660cc fc03082a mov      w28, w8
410660d0 fe03072a mov      w30, w7
410660d4 fd031b2a mov      w29, w27
410660d8 ee031e32 mov      w14, #4
410660dc 00010014 b        #0x410664dc
410660e0 88088052 mov      w8, #0x44
410660e4 ff7f0429 stp      wzr, wzr, [sp, #0x20]
410660e8 f0031f2a mov      w16, wzr
410660ec ff7f0129 stp      wzr, wzr, [sp, #8]
410660f0 ea031f2a mov      w10, wzr
410660f4 e87f0229 stp      w8, wzr, [sp, #0x10]
410660f8 e8031d32 mov      w8, #8
410660fc ec031f2a mov      w12, wzr
41066100 e3031f2a mov      w3, wzr
41066104 e87f0329 stp      w8, wzr, [sp, #0x18]
41066108 08a28052 mov      w8, #0x510
4106610c e5031f2a mov      w5, wzr
41066110 f2031f2a mov      w18, wzr
41066114 e2031f2a mov      w2, wzr
41066118 f9031f2a mov      w25, wzr
4106611c 98e58052 mov      w24, #0x72c
41066120 9a588152 mov      w26, #0xac4
41066124 ee031e32 mov      w14, #4
41066128 065b8052 mov      w6, #0x2d8
4106612c 11288052 mov      w17, #0x140
41066130 ef0f1b32 mov      w15, #0x1e0
41066134 096c8052 mov      w9, #0x360
41066138 84958052 mov      w4, #0x4ac
4106613c 81e08052 mov      w1, #0x704
41066140 07a08052 mov      w7, #0x500
41066144 1b5a8052 mov      w27, #0x2d0
41066148 fc03082a mov      w28, w8
4106614c c5ffff17 b        #0x41066060
41066150 081b8052 mov      w8, #0xd8
41066154 ff7f0429 stp      wzr, wzr, [sp, #0x20]
41066158 096c8052 mov      w9, #0x360
4106615c ffff0129 stp      wzr, wzr, [sp, #0xc]
41066160 876a8052 mov      w7, #0x354
41066164 ff0b00b9 str      wzr, [sp, #8]
41066168 e81700b9 str      w8, [sp, #0x14]
4106616c e8071f32 mov      w8, #6
41066170 f0031f2a mov      w16, wzr
41066174 ea031f2a mov      w10, wzr
41066178 ec031f2a mov      w12, wzr
4106617c e87f0329 stp      w8, wzr, [sp, #0x18]
41066180 e3031f2a mov      w3, wzr
41066184 e5031f2a mov      w5, wzr
41066188 f2031f2a mov      w18, wzr
4106618c e2031f2a mov      w2, wzr
41066190 f9031f2a mov      w25, wzr
41066194 98e58052 mov      w24, #0x72c
41066198 9a588152 mov      w26, #0xac4
4106619c f1031f32 mov      w17, #2
410661a0 ef031e32 mov      w15, #4
410661a4 08a28052 mov      w8, #0x510
410661a8 04e58052 mov      w4, #0x728
410661ac 81578152 mov      w1, #0xabc
410661b0 fb03072a mov      w27, w7
410661b4 fc03092a mov      w28, w9
410661b8 e603092a mov      w6, w9
410661bc fe03072a mov      w30, w7
410661c0 fd03072a mov      w29, w7
410661c4 ee071f32 mov      w14, #6
410661c8 c5000014 b        #0x410664dc
410661cc e803072a mov      w8, w7
410661d0 ea03072a mov      w10, w7
410661d4 eb03072a mov      w11, w7
410661d8 fb03072a mov      w27, w7
410661dc e8230429 stp      w8, w8, [sp, #0x20]
410661e0 e103072a mov      w1, w7
410661e4 e403072a mov      w4, w7
410661e8 eb2b0329 stp      w11, w10, [sp, #0x18]
410661ec e903072a mov      w9, w7
410661f0 eb2f0229 stp      w11, w11, [sp, #0x10]
410661f4 ef03072a mov      w15, w7
410661f8 eb2f0129 stp      w11, w11, [sp, #8]
410661fc f103072a mov      w17, w7
41066200 f003072a mov      w16, w7
41066204 ec03072a mov      w12, w7
41066208 e303072a mov      w3, w7
4106620c e503072a mov      w5, w7
41066210 fc03072a mov      w28, w7
41066214 e603072a mov      w6, w7
41066218 fe03072a mov      w30, w7
4106621c fd03072a mov      w29, w7
41066220 ee03072a mov      w14, w7
41066224 f203072a mov      w18, w7
41066228 e203072a mov      w2, w7
4106622c fa03072a mov      w26, w7
41066230 f803072a mov      w24, w7
41066234 f403072a mov      w20, w7
41066238 f503072a mov      w21, w7
4106623c f903072a mov      w25, w7
41066240 f703072a mov      w23, w7
41066244 f603072a mov      w22, w7
41066248 a9000014 b        #0x410664ec
4106624c e8031d32 mov      w8, #8
41066250 ff7f0329 stp      wzr, wzr, [sp, #0x18]
41066254 ef031f2a mov      w15, wzr
41066258 ff7f0129 stp      wzr, wzr, [sp, #8]
4106625c f1031f2a mov      w17, wzr
41066260 e81300b9 str      w8, [sp, #0x10]
41066264 e8071e32 mov      w8, #0xc
41066268 f0031f2a mov      w16, wzr
4106626c ea031f2a mov      w10, wzr
41066270 e81700b9 str      w8, [sp, #0x14]
41066274 88778052 mov      w8, #0x3bc
41066278 ec031f2a mov      w12, wzr
4106627c e3031f2a mov      w3, wzr
41066280 e5031f2a mov      w5, wzr
41066284 e82300b9 str      w8, [sp, #0x20]
41066288 ee031f2a mov      w14, wzr
4106628c f2031f2a mov      w18, wzr
41066290 e2031f2a mov      w2, wzr
41066294 fa031f2a mov      w26, wzr
41066298 f8031f2a mov      w24, wzr
4106629c f4031f2a mov      w20, wzr
410662a0 f5031f2a mov      w21, wzr
410662a4 f9031f2a mov      w25, wzr
410662a8 06b08252 mov      w6, #0x1580
410662ac 1c088452 mov      w28, #0x2040
410662b0 04b28252 mov      w4, #0x1590
410662b4 010b8452 mov      w1, #0x2058
410662b8 08b38052 mov      w8, #0x598
410662bc 1bc18152 mov      w27, #0xe08
410662c0 e82700b9 str      w8, [sp, #0x24]
410662c4 41000014 b        #0x410663c8
410662c8 e8031d32 mov      w8, #8
410662cc ff2700b9 str      wzr, [sp, #0x24]
410662d0 04b28252 mov      w4, #0x1590
410662d4 ff7f0329 stp      wzr, wzr, [sp, #0x18]
410662d8 010b8452 mov      w1, #0x2058
410662dc ff7f0129 stp      wzr, wzr, [sp, #8]
410662e0 e81300b9 str      w8, [sp, #0x10]
410662e4 e8071e32 mov      w8, #0xc
410662e8 07088452 mov      w7, #0x2040
410662ec ef031f2a mov      w15, wzr
410662f0 e81700b9 str      w8, [sp, #0x14]
410662f4 08368052 mov      w8, #0x1b0
410662f8 f1031f2a mov      w17, wzr
410662fc f0031f2a mov      w16, wzr
41066300 ea031f2a mov      w10, wzr
41066304 e82300b9 str      w8, [sp, #0x20]
41066308 ec031f2a mov      w12, wzr
4106630c e3031f2a mov      w3, wzr
41066310 e5031f2a mov      w5, wzr
41066314 ee031f2a mov      w14, wzr
41066318 f2031f2a mov      w18, wzr
4106631c e2031f2a mov      w2, wzr
41066320 fa031f2a mov      w26, wzr
41066324 f8031f2a mov      w24, wzr
41066328 f4031f2a mov      w20, wzr
4106632c f5031f2a mov      w21, wzr
41066330 f9031f2a mov      w25, wzr
41066334 06b08252 mov      w6, #0x1580
41066338 1b448252 mov      w27, #0x1220
4106633c e803012a mov      w8, w1
41066340 e903042a mov      w9, w4
41066344 fc03072a mov      w28, w7
41066348 fe03072a mov      w30, w7
4106634c 23000014 b        #0x410663d8
41066350 e8031d32 mov      w8, #8
41066354 ff7f0329 stp      wzr, wzr, [sp, #0x18]
41066358 ef031f2a mov      w15, wzr
4106635c ff7f0129 stp      wzr, wzr, [sp, #8]
41066360 f1031f2a mov      w17, wzr
41066364 e81300b9 str      w8, [sp, #0x10]
41066368 e8071e32 mov      w8, #0xc
4106636c f0031f2a mov      w16, wzr
41066370 ea031f2a mov      w10, wzr
41066374 e81700b9 str      w8, [sp, #0x14]
41066378 889a8052 mov      w8, #0x4d4
4106637c ec031f2a mov      w12, wzr
41066380 e3031f2a mov      w3, wzr
41066384 e82300b9 str      w8, [sp, #0x20]
41066388 08b38052 mov      w8, #0x598
4106638c e5031f2a mov      w5, wzr
41066390 ee031f2a mov      w14, wzr
41066394 f2031f2a mov      w18, wzr
41066398 e82700b9 str      w8, [sp, #0x24]
4106639c e2031f2a mov      w2, wzr
410663a0 fa031f2a mov      w26, wzr
410663a4 f8031f2a mov      w24, wzr
410663a8 f4031f2a mov      w20, wzr
410663ac f5031f2a mov      w21, wzr
410663b0 f9031f2a mov      w25, wzr
410663b4 06b08252 mov      w6, #0x1580
410663b8 1c088452 mov      w28, #0x2040
410663bc 04b28252 mov      w4, #0x1590
410663c0 010b8452 mov      w1, #0x2058
410663c4 1b7b8152 mov      w27, #0xbd8
410663c8 07a28252 mov      w7, #0x1510
410663cc e803012a mov      w8, w1
410663d0 e903042a mov      w9, w4
410663d4 fe031c2a mov      w30, w28
410663d8 fd03062a mov      w29, w6
410663dc 22000014 b        #0x41066464
410663e0 e8031d32 mov      w8, #8
410663e4 ffff0329 stp      wzr, wzr, [sp, #0x1c]
410663e8 1c088452 mov      w28, #0x2040
410663ec ff7f0129 stp      wzr, wzr, [sp, #8]
410663f0 04b28252 mov      w4, #0x1590
410663f4 e81300b9 str      w8, [sp, #0x10]
410663f8 e8071e32 mov      w8, #0xc
410663fc 07b08252 mov      w7, #0x1580
41066400 010b8452 mov      w1, #0x2058
41066404 e8ff0229 stp      w8, wzr, [sp, #0x14]
41066408 08ac8052 mov      w8, #0x560
4106640c ef031f2a mov      w15, wzr
41066410 f1031f2a mov      w17, wzr
41066414 f0031f2a mov      w16, wzr
41066418 e82700b9 str      w8, [sp, #0x24]
4106641c ea031f2a mov      w10, wzr
41066420 ec031f2a mov      w12, wzr
41066424 e3031f2a mov      w3, wzr
41066428 e5031f2a mov      w5, wzr
4106642c ee031f2a mov      w14, wzr
41066430 f2031f2a mov      w18, wzr
41066434 e2031f2a mov      w2, wzr
41066438 fa031f2a mov      w26, wzr
4106643c f8031f2a mov      w24, wzr
41066440 f4031f2a mov      w20, wzr
41066444 f5031f2a mov      w21, wzr
41066448 f9031f2a mov      w25, wzr
4106644c fb03072a mov      w27, w7
41066450 e803012a mov      w8, w1
41066454 e903042a mov      w9, w4
41066458 e603072a mov      w6, w7
4106645c fe031c2a mov      w30, w28
41066460 fd03072a mov      w29, w7
41066464 f703012a mov      w23, w1
41066468 f603042a mov      w22, w4
4106646c 20000014 b        #0x410664ec
41066470 ff7f0429 stp      wzr, wzr, [sp, #0x20]
41066474 f0031f2a mov      w16, wzr
41066478 ff7f0329 stp      wzr, wzr, [sp, #0x18]
4106647c ea031f2a mov      w10, wzr
41066480 ec031f2a mov      w12, wzr
41066484 ff7f0229 stp      wzr, wzr, [sp, #0x10]
41066488 e3031f2a mov      w3, wzr
4106648c ff7f0129 stp      wzr, wzr, [sp, #8]
41066490 e5031f2a mov      w5, wzr
41066494 ee031f2a mov      w14, wzr
41066498 f2031f2a mov      w18, wzr
4106649c e2031f2a mov      w2, wzr
410664a0 f9031f2a mov      w25, wzr
410664a4 18108152 mov      w24, #0x880
410664a8 1a228252 mov      w26, #0x1110
410664ac f1031d32 mov      w17, #8
410664b0 0f218052 mov      w15, #0x108
410664b4 040e8152 mov      w4, #0x870
410664b8 e10f1832 mov      w1, #0xf00
410664bc 1b878052 mov      w27, #0x438
410664c0 e70f1932 mov      w7, #0x780
410664c4 e80f1932 mov      w8, #0x780
410664c8 e9031b2a mov      w9, w27
410664cc fc0f1932 mov      w28, #0x780
410664d0 e6031b2a mov      w6, w27
410664d4 fe0f1932 mov      w30, #0x780
410664d8 fd031b2a mov      w29, w27
410664dc f4031a2a mov      w20, w26
410664e0 f503182a mov      w21, w24
410664e4 f7031a2a mov      w23, w26
410664e8 f603182a mov      w22, w24
410664ec eb2740b9 ldr      w11, [sp, #0x24]
410664f0 60e20091 add      x0, x19, #0x38
410664f4 68220079 strh     w8, [x19, #0x10]
410664f8 e81f40b9 ldr      w8, [sp, #0x1c]
410664fc 611a0079 strh     w1, [x19, #0xc]
41066500 e1030191 add      x1, sp, #0x40
41066504 6b120079 strh     w11, [x19, #8]
41066508 eb2340b9 ldr      w11, [sp, #0x20]
4106650c 68320079 strh     w8, [x19, #0x18]
41066510 e81b40b9 ldr      w8, [sp, #0x18]
41066514 626e0079 strh     w2, [x19, #0x36]
41066518 e2071e32 mov      w2, #0xc
4106651c 67020079 strh     w7, [x19]
41066520 7b060079 strh     w27, [x19, #2]
41066524 7f0e0079 strh     wzr, [x19, #6]
41066528 7f0a0079 strh     wzr, [x19, #4]
4106652c 6b160079 strh     w11, [x19, #0xa]
41066530 641e0079 strh     w4, [x19, #0xe]
41066534 69260079 strh     w9, [x19, #0x12]
41066538 6f2a0079 strh     w15, [x19, #0x14]
4106653c 712e0079 strh     w17, [x19, #0x16]
41066540 70360079 strh     w16, [x19, #0x1a]
41066544 6a3a0079 strh     w10, [x19, #0x1c]
41066548 6c3e0079 strh     w12, [x19, #0x1e]
4106654c 63420079 strh     w3, [x19, #0x20]
41066550 65460079 strh     w5, [x19, #0x22]
41066554 7c4a0079 strh     w28, [x19, #0x24]
41066558 664e0079 strh     w6, [x19, #0x26]
4106655c 7e520079 strh     w30, [x19, #0x28]
41066560 7d560079 strh     w29, [x19, #0x2a]
41066564 685a0079 strh     w8, [x19, #0x2c]
41066568 6e5e0079 strh     w14, [x19, #0x2e]
4106656c 6a620079 strh     w10, [x19, #0x30]
41066570 6c660079 strh     w12, [x19, #0x32]
41066574 726a0079 strh     w18, [x19, #0x34]
41066578 e2500894 bl       #0x4127a900
4106657c e81740b9 ldr      w8, [sp, #0x14]
41066580 69520191 add      x9, x19, #0x54
41066584 eb0b40b9 ldr      w11, [sp, #8]
41066588 688a0079 strh     w8, [x19, #0x44]
4106658c eaa34129 ldp      w10, w8, [sp, #0xc]
41066590 7a920079 strh     w26, [x19, #0x48]
41066594 688e0079 strh     w8, [x19, #0x46]
41066598 e81f40f9 ldr      x8, [sp, #0x38]
4106659c 78960079 strh     w24, [x19, #0x4a]
410665a0 749a0079 strh     w20, [x19, #0x4c]
410665a4 759e0079 strh     w21, [x19, #0x4e]
410665a8 28450078 strh     w8, [x9], #4
410665ac 6aa20079 strh     w10, [x19, #0x50]
410665b0 0afd70d3 lsr      x10, x8, #0x30
410665b4 6ba60079 strh     w11, [x19, #0x52]
410665b8 0bfd60d3 lsr      x11, x8, #0x20
410665bc 2a050079 strh     w10, [x9, #2]
410665c0 08fd50d3 lsr      x8, x8, #0x10
410665c4 2b010079 strh     w11, [x9]
410665c8 e93340b9 ldr      w9, [sp, #0x30]
410665cc 68ae0079 strh     w8, [x19, #0x56]
410665d0 7fba0079 strh     wzr, [x19, #0x5c]
410665d4 79be0079 strh     w25, [x19, #0x5e]
410665d8 ea2b40b9 ldr      w10, [sp, #0x28]
410665dc 287d1053 lsr      w8, w9, #0x10
410665e0 69c20079 strh     w9, [x19, #0x60]
410665e4 68c60079 strh     w8, [x19, #0x62]
410665e8 77ca0079 strh     w23, [x19, #0x64]
410665ec 487d1053 lsr      w8, w10, #0x10
410665f0 76ce0079 strh     w22, [x19, #0x66]
410665f4 6ad20079 strh     w10, [x19, #0x68]
410665f8 68d60079 strh     w8, [x19, #0x6a]
410665fc fd7b4aa9 ldp      x29, x30, [sp, #0xa0]
41066600 f44f49a9 ldp      x20, x19, [sp, #0x90]
41066604 f65748a9 ldp      x22, x21, [sp, #0x80]
41066608 f85f47a9 ldp      x24, x23, [sp, #0x70]
4106660c fa6746a9 ldp      x26, x25, [sp, #0x60]
41066610 fc6f45a9 ldp      x28, x27, [sp, #0x50]
41066614 ffc30291 add      sp, sp, #0xb0
41066618 c0035fd6 ret
4106661c 1b878052 mov      w27, #0x438
41066620 ff7f0429 stp      wzr, wzr, [sp, #0x20]
41066624 f0031f2a mov      w16, wzr
41066628 ff7f0329 stp      wzr, wzr, [sp, #0x18]
4106662c ea031f2a mov      w10, wzr
41066630 ff7f0229 stp      wzr, wzr, [sp, #0x10]
41066634 ec031f2a mov      w12, wzr
41066638 ff7f0129 stp      wzr, wzr, [sp, #8]
4106663c e3031f2a mov      w3, wzr
41066640 e5031f2a mov      w5, wzr
41066644 ee031f2a mov      w14, wzr
41066648 f2031f2a mov      w18, wzr
4106664c e2031f2a mov      w2, wzr
41066650 f9031f2a mov      w25, wzr
41066654 f8071632 mov      w24, #0xc00
41066658 1ae28252 mov      w26, #0x1710
4106665c 91028052 mov      w17, #0x14
41066660 ef031832 mov      w15, #0x100
41066664 047b8152 mov      w4, #0xbd8
41066668 01a28252 mov      w1, #0x1510
4106666c e70f1932 mov      w7, #0x780
41066670 e80f1932 mov      w8, #0x780
41066674 e9031b2a mov      w9, w27
41066678 fc0f1932 mov      w28, #0x780
4106667c e6031b2a mov      w6, w27
41066680 fe0f1932 mov      w30, #0x780
41066684 fd031b2a mov      w29, w27
41066688 f4031a2a mov      w20, w26
4106668c f5071632 mov      w21, #0xc00
41066690 f7031a2a mov      w23, w26
41066694 f6071632 mov      w22, #0xc00
41066698 95ffff17 b        #0x410664ec

; geometry_caller_excerpt: [0x41057f64, 0x41058030)
; sha256 2a97230ab14cffaddc4cf7aad340472b4028a5cebb1e19d701cd6d11fe92e31d
41057f64 ff8303d1 sub      sp, sp, #0xe0
41057f68 f65b00f9 str      x22, [sp, #0xb0]
41057f6c f5530ca9 stp      x21, x20, [sp, #0xc0]
41057f70 f37b0da9 stp      x19, x30, [sp, #0xd0]
41057f74 f30302aa mov      x19, x2
41057f78 f40301aa mov      x20, x1
41057f7c f60300aa mov      x22, x0
41057f80 820d8052 mov      w2, #0x6c
41057f84 e0030191 add      x0, sp, #0x40
41057f88 e1031f2a mov      w1, wzr
41057f8c f50303aa mov      x21, x3
41057f90 ec8a0894 bl       #0x4127ab40
41057f94 a82a4029 ldp      w8, w10, [x21]
41057f98 a90a40b9 ldr      w9, [x21, #8]
41057f9c e0a30091 add      x0, sp, #0x28
41057fa0 e1030191 add      x1, sp, #0x40
41057fa4 ffe30039 strb     wzr, [sp, #0x38]
41057fa8 1f4d0071 cmp      w8, #0x13
41057fac e82b0529 stp      w8, w10, [sp, #0x28]
41057fb0 e8179f1a cset     w8, eq
41057fb4 e9230629 stp      w9, w8, [sp, #0x30]
41057fb8 77340094 bl       #0x41065194
41057fbc a8aa4129 ldp      w8, w10, [x21, #0xc]
41057fc0 a91640b9 ldr      w9, [x21, #0x14]
41057fc4 e0430091 add      x0, sp, #0x10
41057fc8 e1030191 add      x1, sp, #0x40
41057fcc ff830039 strb     wzr, [sp, #0x20]
41057fd0 1f4d0071 cmp      w8, #0x13
41057fd4 e82b0229 stp      w8, w10, [sp, #0x10]
41057fd8 e8179f1a cset     w8, eq
41057fdc e9230329 stp      w9, w8, [sp, #0x18]
41057fe0 6d340094 bl       #0x41065194
41057fe4 e84b4179 ldrh     w8, [sp, #0xa4]
41057fe8 e94f4179 ldrh     w9, [sp, #0xa6]
41057fec 68020079 strh     w8, [x19]
41057ff0 69060079 strh     w9, [x19, #2]
41057ff4 a0064029 ldp      w0, w1, [x21]
41057ff8 a20a40b9 ldr      w2, [x21, #8]
41057ffc ff0300f9 str      xzr, [sp]
41058000 e9330094 bl       #0x41064fa4
41058004 e103002a mov      w1, w0
41058008 e2030091 mov      x2, sp
4105800c e00316aa mov      x0, x22
41058010 24340094 bl       #0x410650a0
41058014 a8a64129 ldp      w8, w9, [x21, #0xc]
41058018 ea0340f9 ldr      x10, [sp]
4105801c e0e30291 add      x0, sp, #0xb8
41058020 ab1640b9 ldr      w11, [x21, #0x14]
41058024 e3030091 mov      x3, sp
41058028 e10314aa mov      x1, x20
4105802c e20313aa mov      x2, x19
