
; registry_partition_selector [0x40f23438, 0x40f234a0); SHA-256 59e5c3b01c4948d6a452dd0dc2a652b571068e6fd291cdebfd835b37414d08f1
40f23438 e803002a mov      w8, w0
40f2343c e0031f2a mov      w0, wzr
40f23440 a10200b4 cbz      x1, #0x40f23494
40f23444 820200b4 cbz      x2, #0x40f23494
40f23448 1f050071 cmp      w8, #1
40f2344c 40010054 b.eq     #0x40f23474
40f23450 48020035 cbnz     w8, #0x40f23498
40f23454 08ff91d2 mov      x8, #0x8ff8
40f23458 4854a0f2 movk     x8, #0x2a2, lsl #16
40f2345c 4801c0f2 movk     x8, #0xa, lsl #32
40f23460 099e8452 mov      w9, #0x24f0
40f23464 0800e0f2 movk     x8, #0, lsl #48
40f23468 0801098b add      x8, x8, x9
40f2346c 69128052 mov      w9, #0x93
40f23470 06000014 b        #0x40f23488
40f23474 08ff91d2 mov      x8, #0x8ff8
40f23478 4854a0f2 movk     x8, #0x2a2, lsl #16
40f2347c 4801c0f2 movk     x8, #0xa, lsl #32
40f23480 0800e0f2 movk     x8, #0, lsl #48
40f23484 a9188052 mov      w9, #0xc5
40f23488 e0030032 mov      w0, #1
40f2348c 280000f9 str      x8, [x1]
40f23490 490000b9 str      w9, [x2]
40f23494 c0035fd6 ret
40f23498 e0031f2a mov      w0, wzr
40f2349c c0035fd6 ret

; registry_lookup [0x40f2350c, 0x40f2355c); SHA-256 009bb99517da336efe613140534f4f2aaf97fb56e3d289bc04f67b44ebe699c6
40f2350c 0880a852 mov      w8, #0x44000000
40f23510 1f00086a tst      w0, w8
40f23514 a0010054 b.eq     #0x40f23548
40f23518 08ff91d2 mov      x8, #0x8ff8
40f2351c 4854a0f2 movk     x8, #0x2a2, lsl #16
40f23520 4801c0f2 movk     x8, #0xa, lsl #32
40f23524 e9031faa mov      x9, xzr
40f23528 0800e0f2 movk     x8, #0, lsl #48
40f2352c 0a0140b9 ldr      w10, [x8]
40f23530 5f01006b cmp      w10, w0
40f23534 e0000054 b.eq     #0x40f23550
40f23538 29050091 add      x9, x9, #1
40f2353c 08c10091 add      x8, x8, #0x30
40f23540 3f710af1 cmp      x9, #0x29c
40f23544 49ffff54 b.ls     #0x40f2352c
40f23548 e0031f2a mov      w0, wzr
40f2354c c0035fd6 ret
40f23550 e0030032 mov      w0, #1
40f23554 280000f9 str      x8, [x1]
40f23558 c0035fd6 ret

; snapshot_initialization_wrapper [0x40ed3b14, 0x40ed3b48); SHA-256 1692547849872abbb9e11fd7971ae72a9ba514c34aadc023a752811ea069a5c6
40ed3b14 00ae90d2 mov      x0, #0x8570
40ed3b18 812b92d2 mov      x1, #0x915c
40ed3b1c 025c92d2 mov      x2, #0x92e0
40ed3b20 2077a0f2 movk     x0, #0x3b9, lsl #16
40ed3b24 2177a0f2 movk     x1, #0x3b9, lsl #16
40ed3b28 2277a0f2 movk     x2, #0x3b9, lsl #16
40ed3b2c 4001c0f2 movk     x0, #0xa, lsl #32
40ed3b30 4101c0f2 movk     x1, #0xa, lsl #32
40ed3b34 4201c0f2 movk     x2, #0xa, lsl #32
40ed3b38 0000e0f2 movk     x0, #0, lsl #48
40ed3b3c 0100e0f2 movk     x1, #0, lsl #48
40ed3b40 0200e0f2 movk     x2, #0, lsl #48
40ed3b44 c5940114 b        #0x40f38e58

; snapshot_initialization_excerpt [0x40f38e58, 0x40f38ed0); SHA-256 1fdf6301e25d2678158f6492821673a90a5ae9edfa3c32b56cce78bfbd250700
40f38e58 fc63bca9 stp      x28, x24, [sp, #-0x40]!
40f38e5c f75b01a9 stp      x23, x22, [sp, #0x10]
40f38e60 f55302a9 stp      x21, x20, [sp, #0x20]
40f38e64 f37b03a9 stp      x19, x30, [sp, #0x30]
40f38e68 ffc308d1 sub      sp, sp, #0x230
40f38e6c 88c494d2 mov      x8, #0xa624
40f38e70 13d682d2 mov      x19, #0x16b0
40f38e74 4852a0f2 movk     x8, #0x292, lsl #16
40f38e78 d354a0f2 movk     x19, #0x2a6, lsl #16
40f38e7c 4801c0f2 movk     x8, #0xa, lsl #32
40f38e80 5301c0f2 movk     x19, #0xa, lsl #32
40f38e84 0800e0f2 movk     x8, #0, lsl #48
40f38e88 1300e0f2 movk     x19, #0, lsl #48
40f38e8c f40302aa mov      x20, x2
40f38e90 f50301aa mov      x21, x1
40f38e94 625f8052 mov      w2, #0x2fb
40f38e98 64888052 mov      w4, #0x443
40f38e9c e10300aa mov      x1, x0
40f38ea0 e00308aa mov      x0, x8
40f38ea4 e30313aa mov      x3, x19
40f38ea8 92670394 bl       #0x41012cf0
40f38eac 014296d2 mov      x1, #0xb210
40f38eb0 4152a0f2 movk     x1, #0x292, lsl #16
40f38eb4 4101c0f2 movk     x1, #0xa, lsl #32
40f38eb8 1f040031 cmn      w0, #1
40f38ebc 200c8052 mov      w0, #0x61
40f38ec0 0100e0f2 movk     x1, #0, lsl #48
40f38ec4 e20315aa mov      x2, x21
40f38ec8 f6079f1a cset     w22, ne
40f38ecc 0fa9ff97 bl       #0x40f23308

; effective_size_update_callback [0x40ee0070, 0x40ee02bc); SHA-256 c6bd5877ab5a445baecd6d92cac1c027e1be9b6b274401866f0847c57de31439
40ee0070 ff8302d1 sub      sp, sp, #0xa0
40ee0074 f83300f9 str      x24, [sp, #0x60]
40ee0078 f75b07a9 stp      x23, x22, [sp, #0x70]
40ee007c f55308a9 stp      x21, x20, [sp, #0x80]
40ee0080 f37b09a9 stp      x19, x30, [sp, #0x90]
40ee0084 08ae90d2 mov      x8, #0x8570
40ee0088 2877a0f2 movk     x8, #0x3b9, lsl #16
40ee008c 4801c0f2 movk     x8, #0xa, lsl #32
40ee0090 8a2b92d2 mov      x10, #0x915c
40ee0094 0800e0f2 movk     x8, #0, lsl #48
40ee0098 2a77a0f2 movk     x10, #0x3b9, lsl #16
40ee009c 4a01c0f2 movk     x10, #0xa, lsl #32
40ee00a0 0a00e0f2 movk     x10, #0, lsl #48
40ee00a4 099540b9 ldr      w9, [x8, #0x94]
40ee00a8 140140b9 ldr      w20, [x8]
40ee00ac cd238452 mov      w13, #0x211e
40ee00b0 048542b9 ldr      w4, [x8, #0x284]
40ee00b4 f30301aa mov      x19, x1
40ee00b8 471140b9 ldr      w7, [x10, #0x10]
40ee00bc 0d80a072 movk     w13, #0x400, lsl #16
40ee00c0 3f050071 cmp      w9, #1
40ee00c4 158d43b9 ldr      w21, [x8, #0x38c]
40ee00c8 563540b9 ldr      w22, [x10, #0x34]
40ee00cc ec179f1a cset     w12, eq
40ee00d0 179143b9 ldr      w23, [x8, #0x390]
40ee00d4 0ba940b9 ldr      w11, [x8, #0xa8]
40ee00d8 8c1d470a and      w12, w12, w7, lsr #7
40ee00dc 9f050071 cmp      w12, #1
40ee00e0 ed130d29 stp      w13, w4, [sp, #0x68]
40ee00e4 e1000054 b.ne     #0x40ee0100
40ee00e8 0dd10291 add      x13, x8, #0xb4
40ee00ec 0e610291 add      x14, x8, #0x98
40ee00f0 7f050071 cmp      w11, #1
40ee00f4 ab018e9a csel     x11, x13, x14, eq
40ee00f8 600140b9 ldr      w0, [x11]
40ee00fc 09000014 b        #0x40ee0120
40ee0100 ff041b72 tst      w7, #0x60
40ee0104 c0000054 b.eq     #0x40ee011c
40ee0108 0d9d40b9 ldr      w13, [x8, #0x9c]
40ee010c 7f050071 cmp      w11, #1
40ee0110 0eb940b9 ldr      w14, [x8, #0xb8]
40ee0114 c0018d1a csel     w0, w14, w13, eq
40ee0118 02000014 b        #0x40ee0120
40ee011c 009140b9 ldr      w0, [x8, #0x90]
40ee0120 4b0940b9 ldr      w11, [x10, #8]
40ee0124 ab060034 cbz      w11, #0x40ee01f8
40ee0128 4c9d40b9 ldr      w12, [x10, #0x9c]
40ee012c 017942b9 ldr      w1, [x8, #0x278]
40ee0130 7f010071 cmp      w11, #0
40ee0134 027d42b9 ldr      w2, [x8, #0x27c]
40ee0138 eb079f1a cset     w11, ne
40ee013c 038142b9 ldr      w3, [x8, #0x280]
40ee0140 058942b9 ldr      w5, [x8, #0x288]
40ee0144 068d42b9 ldr      w6, [x8, #0x28c]
40ee0148 0d9142b9 ldr      w13, [x8, #0x290]
40ee014c 0e9542b9 ldr      w14, [x8, #0x294]
40ee0150 0f9942b9 ldr      w15, [x8, #0x298]
40ee0154 109d42b9 ldr      w16, [x8, #0x29c]
40ee0158 11a142b9 ldr      w17, [x8, #0x2a0]
40ee015c 12a542b9 ldr      w18, [x8, #0x2a4]
40ee0160 4a6540b9 ldr      w10, [x10, #0x64]
40ee0164 182140b9 ldr      w24, [x8, #0x20]
40ee0168 088540b9 ldr      w8, [x8, #0x84]
40ee016c ec5b00b9 str      w12, [sp, #0x58]
40ee0170 ea4300b9 str      w10, [sp, #0x40]
40ee0174 f84b00b9 str      w24, [sp, #0x48]
40ee0178 e85300b9 str      w8, [sp, #0x50]
40ee017c ebe30039 strb     w11, [sp, #0x38]
40ee0180 f23300b9 str      w18, [sp, #0x30]
40ee0184 f12b00b9 str      w17, [sp, #0x28]
40ee0188 f02300b9 str      w16, [sp, #0x20]
40ee018c e91b00b9 str      w9, [sp, #0x18]
40ee0190 ef1300b9 str      w15, [sp, #0x10]
40ee0194 ee0b00b9 str      w14, [sp, #8]
40ee0198 ed0300b9 str      w13, [sp]
40ee019c 76e3ff97 bl       #0x40ed8f74
40ee01a0 df020071 cmp      w22, #0
40ee01a4 0800971a csel     w8, w0, w23, eq
40ee01a8 f6030032 mov      w22, #1
40ee01ac 9f060071 cmp      w20, #1
40ee01b0 e86f00b9 str      w8, [sp, #0x6c]
40ee01b4 61000054 b.ne     #0x40ee01c0
40ee01b8 bf02086b cmp      w21, w8
40ee01bc 00010054 b.eq     #0x40ee01dc
40ee01c0 e0030032 mov      w0, #1
40ee01c4 e1a30191 add      x1, sp, #0x68
40ee01c8 e2b30191 add      x2, sp, #0x6c
40ee01cc e30313aa mov      x3, x19
40ee01d0 15cfff97 bl       #0x40ed3e24
40ee01d4 76420539 strb     w22, [x19, #0x150]
40ee01d8 f603002a mov      w22, w0
40ee01dc c0020012 and      w0, w22, #1
40ee01e0 f83340f9 ldr      x24, [sp, #0x60]
40ee01e4 f37b49a9 ldp      x19, x30, [sp, #0x90]
40ee01e8 f55348a9 ldp      x21, x20, [sp, #0x80]
40ee01ec f75b47a9 ldp      x23, x22, [sp, #0x70]
40ee01f0 ff830291 add      sp, sp, #0xa0
40ee01f4 c0035fd6 ret
40ee01f8 2c010034 cbz      w12, #0x40ee021c
40ee01fc 1f0c0071 cmp      w0, #3
40ee0200 e0030054 b.eq     #0x40ee027c
40ee0204 1f080071 cmp      w0, #2
40ee0208 e0030054 b.eq     #0x40ee0284
40ee020c 1f040071 cmp      w0, #1
40ee0210 21030054 b.ne     #0x40ee0274
40ee0214 0c6d42b9 ldr      w12, [x8, #0x26c]
40ee0218 c5ffff17 b        #0x40ee012c
40ee021c ff041b72 tst      w7, #0x60
40ee0220 20010054 b.eq     #0x40ee0244
40ee0224 1f0c0071 cmp      w0, #3
40ee0228 20030054 b.eq     #0x40ee028c
40ee022c 1f080071 cmp      w0, #2
40ee0230 20030054 b.eq     #0x40ee0294
40ee0234 1f040071 cmp      w0, #1
40ee0238 e1010054 b.ne     #0x40ee0274
40ee023c 0c6142b9 ldr      w12, [x8, #0x260]
40ee0240 bbffff17 b        #0x40ee012c
40ee0244 0c040051 sub      w12, w0, #1
40ee0248 9f150071 cmp      w12, #5
40ee024c 48010054 b.hi     #0x40ee0274
40ee0250 0d808cd2 mov      x13, #0x6400
40ee0254 4d54a0f2 movk     x13, #0x2a2, lsl #16
40ee0258 4d01c0f2 movk     x13, #0xa, lsl #32
40ee025c 0d00e0f2 movk     x13, #0, lsl #48
40ee0260 ad796cf8 ldr      x13, [x13, x12, lsl #3]
40ee0264 0c4942b9 ldr      w12, [x8, #0x248]
40ee0268 a0011fd6 br       x13
40ee026c 0c5542b9 ldr      w12, [x8, #0x254]
40ee0270 afffff17 b        #0x40ee012c
40ee0274 ec031f32 mov      w12, #2
40ee0278 adffff17 b        #0x40ee012c
40ee027c 0c7542b9 ldr      w12, [x8, #0x274]
40ee0280 abffff17 b        #0x40ee012c
40ee0284 0c7142b9 ldr      w12, [x8, #0x270]
40ee0288 a9ffff17 b        #0x40ee012c
40ee028c 0c6942b9 ldr      w12, [x8, #0x268]
40ee0290 a7ffff17 b        #0x40ee012c
40ee0294 0c6542b9 ldr      w12, [x8, #0x264]
40ee0298 a5ffff17 b        #0x40ee012c
40ee029c 0c4d42b9 ldr      w12, [x8, #0x24c]
40ee02a0 a3ffff17 b        #0x40ee012c
40ee02a4 0c5142b9 ldr      w12, [x8, #0x250]
40ee02a8 a1ffff17 b        #0x40ee012c
40ee02ac 0c5942b9 ldr      w12, [x8, #0x258]
40ee02b0 9fffff17 b        #0x40ee012c
40ee02b4 0c5d42b9 ldr      w12, [x8, #0x25c]
40ee02b8 9dffff17 b        #0x40ee012c

; effective_size_selection [0x40ed8f74, 0x40ed90d0); SHA-256 11d37066473c693faa24e82db65e0acf487f2a2abebc931a9948498d70a3222e
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

; append_updates [0x40ed3e24, 0x40ed3ed0); SHA-256 e0c853fd5753bc5a97071caeca1041a5f6f680700e22b4d1824f4e0ef71c3581
40ed3e24 69304029 ldp      w9, w12, [x3]
40ed3e28 8801000b add      w8, w12, w0
40ed3e2c 3f01086b cmp      w9, w8
40ed3e30 62000054 b.hs     #0x40ed3e3c
40ed3e34 e0031f2a mov      w0, wzr
40ed3e38 c0035fd6 ret
40ed3e3c 40040034 cbz      w0, #0x40ed3ec4
40ed3e40 6ab440a9 ldp      x10, x13, [x3, #8]
40ed3e44 6bbc40f9 ldr      x11, [x3, #0x178]
40ed3e48 e8031faa mov      x8, xzr
40ed3e4c e903002a mov      w9, w0
40ed3e50 4a090c8b add      x10, x10, x12, lsl #2
40ed3e54 ac090c8b add      x12, x13, x12, lsl #2
40ed3e58 ed030032 mov      w13, #1
40ed3e5c 2e7868b8 ldr      w14, [x1, x8, lsl #2]
40ed3e60 4e7928b8 str      w14, [x10, x8, lsl #2]
40ed3e64 4e7868b8 ldr      w14, [x2, x8, lsl #2]
40ed3e68 8e7928b8 str      w14, [x12, x8, lsl #2]
40ed3e6c 6e0140b9 ldr      w14, [x11]
40ed3e70 0e020034 cbz      w14, #0x40ed3eb0
40ed3e74 700540f9 ldr      x16, [x11, #8]
40ed3e78 ef031f2a mov      w15, wzr
40ed3e7c 517968b8 ldr      w17, [x10, x8, lsl #2]
40ed3e80 12120091 add      x18, x16, #4
40ed3e84 e4030f2a mov      w4, w15
40ed3e88 84f07dd3 lsl      x4, x4, #3
40ed3e8c 046a64b8 ldr      w4, [x16, x4]
40ed3e90 9f00116b cmp      w4, w17
40ed3e94 c0000054 b.eq     #0x40ed3eac
40ed3e98 ef050011 add      w15, w15, #1
40ed3e9c 52220091 add      x18, x18, #8
40ed3ea0 ff010e6b cmp      w15, w14
40ed3ea4 03ffff54 b.lo     #0x40ed3e84
40ed3ea8 02000014 b        #0x40ed3eb0
40ed3eac 4d020039 strb     w13, [x18]
40ed3eb0 08050091 add      x8, x8, #1
40ed3eb4 1f0109eb cmp      x8, x9
40ed3eb8 21fdff54 b.ne     #0x40ed3e5c
40ed3ebc 680440b9 ldr      w8, [x3, #4]
40ed3ec0 0801000b add      w8, w8, w0
40ed3ec4 e0030032 mov      w0, #1
40ed3ec8 680400b9 str      w8, [x3, #4]
40ed3ecc c0035fd6 ret

; dataid_reader [0x4101553c, 0x41015618); SHA-256 8aff30e437255a3ed73cc8fdfebf964fda03aa9d48345788579883bb17b5f50a
4101553c e803002a mov      w8, w0
41015540 3f0000b9 str      wzr, [x1]
41015544 e0031f2a mov      w0, wzr
41015548 093d0853 ubfx     w9, w8, #8, #8
4101554c 3fed0171 cmp      w9, #0x7b
41015550 28060054 b.hi     #0x41015614
41015554 eb071c32 mov      w11, #0x30
41015558 0a9988d2 mov      x10, #0x44c8
4101555c 4a80a8f2 movk     x10, #0x4402, lsl #16
41015560 2b7dab9b umull    x11, w9, w11
41015564 0a00c0f2 movk     x10, #0, lsl #32
41015568 0a00e0f2 movk     x10, #0, lsl #48
4101556c 4b696bb8 ldr      w11, [x10, x11]
41015570 cb030034 cbz      w11, #0x410155e8
41015574 eb071c32 mov      w11, #0x30
41015578 081d0012 and      w8, w8, #0xff
4101557c 2b290b9b madd     x11, x9, x11, x10
41015580 6b354079 ldrh     w11, [x11, #0x1a]
41015584 1f010b6b cmp      w8, w11
41015588 02030054 b.hs     #0x410155e8
4101558c eb071c32 mov      w11, #0x30
41015590 e0031f2a mov      w0, wzr
41015594 29290b9b madd     x9, x9, x11, x10
41015598 0bb894d2 mov      x11, #0xa5c0
4101559c 0b80a8f2 movk     x11, #0x4400, lsl #16
410155a0 ea071d32 mov      w10, #0x18
410155a4 0b00c0f2 movk     x11, #0, lsl #32
410155a8 29314079 ldrh     w9, [x9, #0x18]
410155ac 0b00e0f2 movk     x11, #0, lsl #48
410155b0 0801098b add      x8, x8, x9
410155b4 082d0a9b madd     x8, x8, x10, x11
410155b8 090140b9 ldr      w9, [x8]
410155bc 3f250071 cmp      w9, #9
410155c0 a8020054 b.hi     #0x41015614
410155c4 0aca8fd2 mov      x10, #0x7e50
410155c8 080540f9 ldr      x8, [x8, #8]
410155cc 2a55a0f2 movk     x10, #0x2a9, lsl #16
410155d0 4a01c0f2 movk     x10, #0xa, lsl #32
410155d4 0a00e0f2 movk     x10, #0, lsl #48
410155d8 497969f8 ldr      x9, [x10, x9, lsl #3]
410155dc 20011fd6 br       x9
410155e0 080140b9 ldr      w8, [x8]
410155e4 0a000014 b        #0x4101560c
410155e8 e0031f2a mov      w0, wzr
410155ec c0035fd6 ret
410155f0 08014039 ldrb     w8, [x8]
410155f4 06000014 b        #0x4101560c
410155f8 08014079 ldrh     w8, [x8]
410155fc 04000014 b        #0x4101560c
41015600 0801c039 ldrsb    w8, [x8]
41015604 02000014 b        #0x4101560c
41015608 0801c079 ldrsh    w8, [x8]
4101560c e0030032 mov      w0, #1
41015610 280000b9 str      w8, [x1]
41015614 c0035fd6 ret

; snapshot_size_update_arm [0x40f3ebdc, 0x40f3ec08); SHA-256 e507957e14ac6a274a9a90f2baa65395b6d0b2f7f9ffa0264bf4ac5f40496e2b
40f3ebdc 01d682d2 mov      x1, #0x16b0
40f3ebe0 e84a8252 mov      w8, #0x1257
40f3ebe4 c154a0f2 movk     x1, #0x2a6, lsl #16
40f3ebe8 0880a072 movk     w8, #0x400, lsl #16
40f3ebec 4101c0f2 movk     x1, #0xa, lsl #32
40f3ebf0 001d3b11 add      w0, w8, #0xec7
40f3ebf4 0100e0f2 movk     x1, #0, lsl #48
40f3ebf8 a2128152 mov      w2, #0x895
40f3ebfc 22500394 bl       #0x41012c84
40f3ec00 608e03b9 str      w0, [x19, #0x38c]
40f3ec04 f7110014 b        #0x40f433e0

; snapshot_fps_update_arm [0x40f3f3e0, 0x40f3f404); SHA-256 002c73c6b2e99cc9156313e2f85d3f6e841ae01f124816b62f67eff151dce55d
40f3f3e0 01d682d2 mov      x1, #0x16b0
40f3f3e4 c154a0f2 movk     x1, #0x2a6, lsl #16
40f3f3e8 4101c0f2 movk     x1, #0xa, lsl #32
40f3f3ec 202e8452 mov      w0, #0x2171
40f3f3f0 0100e0f2 movk     x1, #0, lsl #48
40f3f3f4 82148152 mov      w2, #0x8a4
40f3f3f8 234e0394 bl       #0x41012c84
40f3f3fc 60a203b9 str      w0, [x19, #0x3a0]
40f3f400 f80f0014 b        #0x40f433e0

; image_info_context_adapter_excerpt [0x4105c138, 0x4105c19c); SHA-256 b8bd3afa2dba04e063972a16736f6ad950f09e3b41a5dec9a140cfdc9b4fc6f9
4105c138 b5520f91 add      x21, x21, #0x3d4
4105c13c 11000014 b        #0x4105c180
4105c140 e8031f2a mov      w8, wzr
4105c144 a98a43b9 ldr      w9, [x21, #0x388]
4105c148 aa0240f9 ldr      x10, [x21]
4105c14c e8270129 stp      w8, w9, [sp, #8]
4105c150 a8d643b9 ldr      w8, [x21, #0x3d4]
4105c154 49fd60d3 lsr      x9, x10, #0x20
4105c158 eaa70229 stp      w10, w9, [sp, #0x14]
4105c15c e81f00b9 str      w8, [sp, #0x1c]
4105c160 a88e43b9 ldr      w8, [x21, #0x38c]
4105c164 a9a243b9 ldr      w9, [x21, #0x3a0]
4105c168 aa324039 ldrb     w10, [x21, #0xc]
4105c16c ab7a43b9 ldr      w11, [x21, #0x378]
4105c170 b5520f91 add      x21, x21, #0x3d4
4105c174 e8270429 stp      w8, w9, [sp, #0x20]
4105c178 eaa30039 strb     w10, [sp, #0x28]
4105c17c eb2f00b9 str      w11, [sp, #0x2c]
4105c180 e0030091 mov      x0, sp
4105c184 e1730191 add      x1, sp, #0x5c
4105c188 482a0094 bl       #0x41066aa8
4105c18c e9bb4079 ldrh     w9, [sp, #0x5c]
4105c190 e8bf4079 ldrh     w8, [sp, #0x5e]
4105c194 69160079 strh     w9, [x19, #0xa]
4105c198 681a0079 strh     w8, [x19, #0xc]
