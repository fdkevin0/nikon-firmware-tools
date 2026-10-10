
; private_descriptor_lookup [0x407fe064, 0x407fe0f8); SHA-256 b0ff70de61ae879b24e1b3746de0670f3d9830860bd5fda174fe6034845d8219
0407fe064 00b298d2 mov      x0, #0xc590
0407fe068 c081a8f2 movk     x0, #0x440e, lsl #16
0407fe06c 0000c0f2 movk     x0, #0, lsl #32
0407fe070 0000e0f2 movk     x0, #0, lsl #48
0407fe074 c0035fd6 ret
0407fe078 08004079 ldrh     w8, [x0]
0407fe07c c8000034 cbz      w8, #0x407fe094
0407fe080 083d0012 and      w8, w8, #0xffff
0407fe084 1f21216b cmp      w8, w1, uxth
0407fe088 80000054 b.eq     #0x407fe098
0407fe08c 080c4378 ldrh     w8, [x0, #0x30]!
0407fe090 88ffff35 cbnz     w8, #0x407fe080
0407fe094 e0031faa mov      x0, xzr
0407fe098 c0035fd6 ret
0407fe09c 00084039 ldrb     w0, [x0, #2]
0407fe0a0 c0035fd6 ret
0407fe0a4 040840f9 ldr      x4, [x0, #0x10]
0407fe0a8 640000b4 cbz      x4, #0x407fe0b4
0407fe0ac 000440f9 ldr      x0, [x0, #8]
0407fe0b0 80001fd6 br       x4
0407fe0b4 e0031f2a mov      w0, wzr
0407fe0b8 c0035fd6 ret
0407fe0bc 080c40f9 ldr      x8, [x0, #0x18]
0407fe0c0 c80000b4 cbz      x8, #0x407fe0d8
0407fe0c4 fe0f1ff8 str      x30, [sp, #-0x10]!
0407fe0c8 000440f9 ldr      x0, [x0, #8]
0407fe0cc 00013fd6 blr      x8
0407fe0d0 fe0741f8 ldr      x30, [sp], #0x10
0407fe0d4 60000036 tbz      w0, #0, #0x407fe0e0
0407fe0d8 e0030032 mov      w0, #1
0407fe0dc c0035fd6 ret
0407fe0e0 e0031f2a mov      w0, wzr
0407fe0e4 c0035fd6 ret
0407fe0e8 080440f9 ldr      x8, [x0, #8]
0407fe0ec 021040f9 ldr      x2, [x0, #0x20]
0407fe0f0 e00308aa mov      x0, x8
0407fe0f4 40001fd6 br       x2

; outer_operation_wrappers [0x407fe12c, 0x407fe170); SHA-256 bae0cbd6fd576931d27f4f91a1332d134f22c9a50f38a856dca8023a25f1b897
0407fe12c c0035fd6 ret
0407fe130 e00301aa mov      x0, x1
0407fe134 52000014 b        #0x407fe27c
0407fe138 e00301aa mov      x0, x1
0407fe13c 85000014 b        #0x407fe350
0407fe140 e00301aa mov      x0, x1
0407fe144 e10302aa mov      x1, x2
0407fe148 e20303aa mov      x2, x3
0407fe14c 26000014 b        #0x407fe1e4
0407fe150 e00301aa mov      x0, x1
0407fe154 4a000014 b        #0x407fe27c
0407fe158 e00301aa mov      x0, x1
0407fe15c 7d000014 b        #0x407fe350
0407fe160 e00301aa mov      x0, x1
0407fe164 46000014 b        #0x407fe27c
0407fe168 e00301aa mov      x0, x1
0407fe16c 79000014 b        #0x407fe350

; cached_lookup_and_admission [0x407fe228, 0x407fe36c); SHA-256 1d59bd5ffabc16843ade03e4809ade88c8ae54ae58b9a18e5b191b40808cfab8
0407fe228 f40f1ef8 str      x20, [sp, #-0x20]!
0407fe22c f37b01a9 stp      x19, x30, [sp, #0x10]
0407fe230 14f693d2 mov      x20, #0x9fb0
0407fe234 b48fa0f2 movk     x20, #0x47d, lsl #16
0407fe238 5401c0f2 movk     x20, #0xa, lsl #32
0407fe23c 1400e0f2 movk     x20, #0, lsl #48
0407fe240 f303002a mov      w19, w0
0407fe244 880240f9 ldr      x8, [x20]
0407fe248 880000b4 cbz      x8, #0x407fe258
0407fe24c 09014079 ldrh     w9, [x8]
0407fe250 3f21336b cmp      w9, w19, uxth
0407fe254 c0000054 b.eq     #0x407fe26c
0407fe258 83ffff97 bl       #0x407fe064
0407fe25c e103132a mov      w1, w19
0407fe260 86ffff97 bl       #0x407fe078
0407fe264 e80300aa mov      x8, x0
0407fe268 880200f9 str      x8, [x20]
0407fe26c f37b41a9 ldp      x19, x30, [sp, #0x10]
0407fe270 e00308aa mov      x0, x8
0407fe274 f40742f8 ldr      x20, [sp], #0x20
0407fe278 c0035fd6 ret
0407fe27c ff4301d1 sub      sp, sp, #0x50
0407fe280 f61300f9 str      x22, [sp, #0x20]
0407fe284 f55303a9 stp      x21, x20, [sp, #0x30]
0407fe288 f37b04a9 stp      x19, x30, [sp, #0x40]
0407fe28c f30300aa mov      x19, x0
0407fe290 a1008052 mov      w1, #5
0407fe294 741a4079 ldrh     w20, [x19, #0xc]
0407fe298 760e4079 ldrh     w22, [x19, #6]
0407fe29c ff1b00b9 str      wzr, [sp, #0x18]
0407fe2a0 ffff00a9 stp      xzr, xzr, [sp, #8]
0407fe2a4 2533ed97 bl       #0x4034af38
0407fe2a8 40020036 tbz      w0, #0, #0x407fe2f0
0407fe2ac e003142a mov      w0, w20
0407fe2b0 deffff97 bl       #0x407fe228
0407fe2b4 f50300aa mov      x21, x0
0407fe2b8 150200b4 cbz      x21, #0x407fe2f8
0407fe2bc 08f593d2 mov      x8, #0x9fa8
0407fe2c0 a88fa0f2 movk     x8, #0x47d, lsl #16
0407fe2c4 4801c0f2 movk     x8, #0xa, lsl #32
0407fe2c8 0800e0f2 movk     x8, #0, lsl #48
0407fe2cc 080140f9 ldr      x8, [x8]
0407fe2d0 880100b4 cbz      x8, #0x407fe300
0407fe2d4 00013fd6 blr      x8
0407fe2d8 40030037 tbnz     w0, #0, #0x407fe340
0407fe2dc 28009e52 mov      w8, #0xf001
0407fe2e0 9f02086b cmp      w20, w8
0407fe2e4 e0020054 b.eq     #0x407fe340
0407fe2e8 81009452 mov      w1, #0xa004
0407fe2ec 06000014 b        #0x407fe304
0407fe2f0 c1008452 mov      w1, #0x2006
0407fe2f4 04000014 b        #0x407fe304
0407fe2f8 a1038452 mov      w1, #0x201d
0407fe2fc 02000014 b        #0x407fe304
0407fe300 21008452 mov      w1, #0x2001
0407fe304 e89f9252 mov      w8, #0x94ff
0407fe308 df02086b cmp      w22, w8
0407fe30c e8179f1a cset     w8, eq
0407fe310 a2008052 mov      w2, #5
0407fe314 e3230091 add      x3, sp, #8
0407fe318 e00313aa mov      x0, x19
0407fe31c 04791f53 lsl      w4, w8, #1
0407fe320 6d83ff97 bl       #0x407df0d4
0407fe324 e0031f2a mov      w0, wzr
0407fe328 f37b44a9 ldp      x19, x30, [sp, #0x40]
0407fe32c f55343a9 ldp      x21, x20, [sp, #0x30]
0407fe330 f61340f9 ldr      x22, [sp, #0x20]
0407fe334 00000012 and      w0, w0, #1
0407fe338 ff430191 add      sp, sp, #0x50
0407fe33c c0035fd6 ret
0407fe340 e00315aa mov      x0, x21
0407fe344 e10313aa mov      x1, x19
0407fe348 5dffff97 bl       #0x407fe0bc
0407fe34c f7ffff17 b        #0x407fe328
0407fe350 f37bbfa9 stp      x19, x30, [sp, #-0x10]!
0407fe354 f30300aa mov      x19, x0
0407fe358 600e40b9 ldr      w0, [x19, #0xc]
0407fe35c b3ffff97 bl       #0x407fe228
0407fe360 e10313aa mov      x1, x19
0407fe364 f37bc1a8 ldp      x19, x30, [sp], #0x10
0407fe368 60ffff17 b        #0x407fe0e8

; session_callback_registration [0x407fe4f0, 0x407fe53c); SHA-256 5270861bcb1c8961a6d22cf0ef22e6e2780de2db84c5ef1df41430912969999d
0407fe4f0 08f893d2 mov      x8, #0x9fc0
0407fe4f4 a88fa0f2 movk     x8, #0x47d, lsl #16
0407fe4f8 4801c0f2 movk     x8, #0xa, lsl #32
0407fe4fc 0800e0f2 movk     x8, #0, lsl #48
0407fe500 090140f9 ldr      x9, [x8]
0407fe504 490000b4 cbz      x9, #0x407fe50c
0407fe508 c0035fd6 ret
0407fe50c 80a49cd2 mov      x0, #0xe524
0407fe510 e00fa8f2 movk     x0, #0x407f, lsl #16
0407fe514 0000c0f2 movk     x0, #0, lsl #32
0407fe518 0000e0f2 movk     x0, #0, lsl #48
0407fe51c 000100f9 str      x0, [x8]
0407fe520 93ffff17 b        #0x407fe36c
0407fe524 08f993d2 mov      x8, #0x9fc8
0407fe528 a88fa0f2 movk     x8, #0x47d, lsl #16
0407fe52c 4801c0f2 movk     x8, #0xa, lsl #32
0407fe530 0800e0f2 movk     x8, #0, lsl #48
0407fe534 00014039 ldrb     w0, [x8]
0407fe538 c0035fd6 ret

; request_parameter_count_check [0x4034af38, 0x4034af88); SHA-256 5001cc8bbf34f507d6a339b3dccf67d5915fce5bdeca14a86fe0254088fee5c2
04034af38 080040b9 ldr      w8, [x0]
04034af3c 89fe9fd2 mov      x9, #0xfff4
04034af40 e9ffbff2 movk     x9, #0xffff, lsl #16
04034af44 6900c0f2 movk     x9, #3, lsl #32
04034af48 0801098b add      x8, x8, x9
04034af4c 08fd42d3 lsr      x8, x8, #2
04034af50 1f01016b cmp      w8, w1
04034af54 29010054 b.ls     #0x4034af78
04034af58 0948218b add      x9, x0, w1, uxtw #2
04034af5c 290d40b9 ldr      w9, [x9, #0xc]
04034af60 09010035 cbnz     w9, #0x4034af80
04034af64 21040011 add      w1, w1, #1
04034af68 3f00086b cmp      w1, w8
04034af6c 63ffff54 b.lo     #0x4034af58
04034af70 e0030032 mov      w0, #1
04034af74 c0035fd6 ret
04034af78 e0379f1a cset     w0, hs
04034af7c c0035fd6 ret
04034af80 e0031f2a mov      w0, wzr
04034af84 c0035fd6 ret

; resource_read_preflight [0x407ffc6c, 0x407ffd54); SHA-256 29355c5c68d54b13361ad8868f2136e3f05c805a19fde3614c33a0f599de43f3
0407ffc6c ff8301d1 sub      sp, sp, #0x60
0407ffc70 f55304a9 stp      x21, x20, [sp, #0x40]
0407ffc74 f37b05a9 stp      x19, x30, [sp, #0x50]
0407ffc78 f30301aa mov      x19, x1
0407ffc7c ff3b00b9 str      wzr, [sp, #0x38]
0407ffc80 ffff02a9 stp      xzr, xzr, [sp, #0x28]
0407ffc84 75a24229 ldp      w21, w8, [x19, #0x14]
0407ffc88 741240b9 ldr      w20, [x19, #0x10]
0407ffc8c ffff01a9 stp      xzr, xzr, [sp, #0x18]
0407ffc90 1f1d0071 cmp      w8, #7
0407ffc94 ffff00a9 stp      xzr, xzr, [sp, #8]
0407ffc98 c8030054 b.hi     #0x407ffd10
0407ffc9c 09089dd2 mov      x9, #0xe840
0407ffca0 c981a8f2 movk     x9, #0x440e, lsl #16
0407ffca4 0900c0f2 movk     x9, #0, lsl #32
0407ffca8 0900e0f2 movk     x9, #0, lsl #48
0407ffcac 287968f8 ldr      x8, [x9, x8, lsl #3]
0407ffcb0 00011fd6 br       x8
0407ffcb4 800b8052 mov      w0, #0x5c
0407ffcb8 0e000014 b        #0x407ffcf0
0407ffcbc 400a8052 mov      w0, #0x52
0407ffcc0 0c000014 b        #0x407ffcf0
0407ffcc4 a0098052 mov      w0, #0x4d
0407ffcc8 0a000014 b        #0x407ffcf0
0407ffccc 600b8052 mov      w0, #0x5b
0407ffcd0 08000014 b        #0x407ffcf0
0407ffcd4 60018052 mov      w0, #0xb
0407ffcd8 06000014 b        #0x407ffcf0
0407ffcdc e0071e32 mov      w0, #0xc
0407ffce0 04000014 b        #0x407ffcf0
0407ffce4 40098052 mov      w0, #0x4a
0407ffce8 02000014 b        #0x407ffcf0
0407ffcec 400b8052 mov      w0, #0x5a
0407ffcf0 e1230091 add      x1, sp, #8
0407ffcf4 dbad1594 bl       #0x40d6b460
0407ffcf8 00010036 tbz      w0, #0, #0x407ffd18
0407ffcfc b5000034 cbz      w21, #0x407ffd10
0407ffd00 e81f40b9 ldr      w8, [sp, #0x1c]
0407ffd04 a902140b add      w9, w21, w20
0407ffd08 1f01096b cmp      w8, w9
0407ffd0c 02020054 b.hs     #0x407ffd4c
0407ffd10 a8038452 mov      w8, #0x201d
0407ffd14 02000014 b        #0x407ffd1c
0407ffd18 28009452 mov      w8, #0xa001
0407ffd1c 21008452 mov      w1, #0x2001
0407ffd20 e82b00b9 str      w8, [sp, #0x28]
0407ffd24 a2008052 mov      w2, #5
0407ffd28 e3a30091 add      x3, sp, #0x28
0407ffd2c e4031f32 mov      w4, #2
0407ffd30 e00313aa mov      x0, x19
0407ffd34 e87cff97 bl       #0x407df0d4
0407ffd38 e0031f2a mov      w0, wzr
0407ffd3c f37b45a9 ldp      x19, x30, [sp, #0x50]
0407ffd40 f55344a9 ldp      x21, x20, [sp, #0x40]
0407ffd44 ff830191 add      sp, sp, #0x60
0407ffd48 c0035fd6 ret
0407ffd4c e0030032 mov      w0, #1
0407ffd50 fbffff17 b        #0x407ffd3c

; resource_read_handler [0x407ffd54, 0x407ffe74); SHA-256 fedd6af22fc68dade42d13d3ae4e2b86bbdbc8b72146ff232654296c3028d336
0407ffd54 ff8301d1 sub      sp, sp, #0x60
0407ffd58 f55304a9 stp      x21, x20, [sp, #0x40]
0407ffd5c f37b05a9 stp      x19, x30, [sp, #0x50]
0407ffd60 f30301aa mov      x19, x1
0407ffd64 ff3b00b9 str      wzr, [sp, #0x38]
0407ffd68 ffff02a9 stp      xzr, xzr, [sp, #0x28]
0407ffd6c 74a24229 ldp      w20, w8, [x19, #0x14]
0407ffd70 751240b9 ldr      w21, [x19, #0x10]
0407ffd74 ffff01a9 stp      xzr, xzr, [sp, #0x18]
0407ffd78 1f1d0071 cmp      w8, #7
0407ffd7c ffff00a9 stp      xzr, xzr, [sp, #8]
0407ffd80 28030054 b.hi     #0x407ffde4
0407ffd84 09109dd2 mov      x9, #0xe880
0407ffd88 c981a8f2 movk     x9, #0x440e, lsl #16
0407ffd8c 0900c0f2 movk     x9, #0, lsl #32
0407ffd90 0900e0f2 movk     x9, #0, lsl #48
0407ffd94 287968f8 ldr      x8, [x9, x8, lsl #3]
0407ffd98 00011fd6 br       x8
0407ffd9c 800b8052 mov      w0, #0x5c
0407ffda0 0e000014 b        #0x407ffdd8
0407ffda4 400a8052 mov      w0, #0x52
0407ffda8 0c000014 b        #0x407ffdd8
0407ffdac a0098052 mov      w0, #0x4d
0407ffdb0 0a000014 b        #0x407ffdd8
0407ffdb4 600b8052 mov      w0, #0x5b
0407ffdb8 08000014 b        #0x407ffdd8
0407ffdbc 60018052 mov      w0, #0xb
0407ffdc0 06000014 b        #0x407ffdd8
0407ffdc4 e0071e32 mov      w0, #0xc
0407ffdc8 04000014 b        #0x407ffdd8
0407ffdcc 40098052 mov      w0, #0x4a
0407ffdd0 02000014 b        #0x407ffdd8
0407ffdd4 400b8052 mov      w0, #0x5a
0407ffdd8 e1230091 add      x1, sp, #8
0407ffddc a1ad1594 bl       #0x40d6b460
0407ffde0 20020036 tbz      w0, #0, #0x407ffe24
0407ffde4 e80740f9 ldr      x8, [sp, #8]
0407ffde8 03718252 mov      w3, #0x1388
0407ffdec e00313aa mov      x0, x19
0407ffdf0 e203142a mov      w2, w20
0407ffdf4 0101158b add      x1, x8, x21
0407ffdf8 337dff97 bl       #0x407df2c4
0407ffdfc 20020036 tbz      w0, #0, #0x407ffe40
0407ffe00 21008452 mov      w1, #0x2001
0407ffe04 a2008052 mov      w2, #5
0407ffe08 e3a30091 add      x3, sp, #0x28
0407ffe0c e00313aa mov      x0, x19
0407ffe10 e12b00b9 str      w1, [sp, #0x28]
0407ffe14 e4031f2a mov      w4, wzr
0407ffe18 af7cff97 bl       #0x407df0d4
0407ffe1c e0030032 mov      w0, #1
0407ffe20 11000014 b        #0x407ffe64
0407ffe24 28009452 mov      w8, #0xa001
0407ffe28 21008452 mov      w1, #0x2001
0407ffe2c a2008052 mov      w2, #5
0407ffe30 e82b00b9 str      w8, [sp, #0x28]
0407ffe34 e3a30091 add      x3, sp, #0x28
0407ffe38 e4031f32 mov      w4, #2
0407ffe3c 07000014 b        #0x407ffe58
0407ffe40 e8008452 mov      w8, #0x2007
0407ffe44 21008452 mov      w1, #0x2001
0407ffe48 a2008052 mov      w2, #5
0407ffe4c e3a30091 add      x3, sp, #0x28
0407ffe50 e82b00b9 str      w8, [sp, #0x28]
0407ffe54 e4030032 mov      w4, #1
0407ffe58 e00313aa mov      x0, x19
0407ffe5c 9e7cff97 bl       #0x407df0d4
0407ffe60 e0031f2a mov      w0, wzr
0407ffe64 f37b45a9 ldp      x19, x30, [sp, #0x50]
0407ffe68 f55344a9 ldp      x21, x20, [sp, #0x40]
0407ffe6c ff830191 add      sp, sp, #0x60
0407ffe70 c0035fd6 ret

; address_read_preflight [0x408008a4, 0x40800a08); SHA-256 4eaedbabaf3944d4415e2fcd2decc10ab6b366ec25554a6224201018d6e7501a
0408008a4 ffc300d1 sub      sp, sp, #0x30
0408008a8 f37b02a9 stp      x19, x30, [sp, #0x20]
0408008ac f30301aa mov      x19, x1
0408008b0 ff1b00b9 str      wzr, [sp, #0x18]
0408008b4 681a40b9 ldr      w8, [x19, #0x18]
0408008b8 ffff00a9 stp      xzr, xzr, [sp, #8]
0408008bc 09050051 sub      w9, w8, #1
0408008c0 3f011071 cmp      w9, #0x400
0408008c4 22010054 b.hs     #0x408008e8
0408008c8 60264229 ldp      w0, w9, [x19, #0x10]
0408008cc 207d60b3 bfi      x0, x9, #0x20, #0x20
0408008d0 0801008b add      x8, x8, x0
0408008d4 010500d1 sub      x1, x8, #1
0408008d8 10000094 bl       #0x40800918
0408008dc 60000036 tbz      w0, #0, #0x408008e8
0408008e0 e0030032 mov      w0, #1
0408008e4 0a000014 b        #0x4080090c
0408008e8 a8038452 mov      w8, #0x201d
0408008ec 21008452 mov      w1, #0x2001
0408008f0 a2008052 mov      w2, #5
0408008f4 e3230091 add      x3, sp, #8
0408008f8 e80b00b9 str      w8, [sp, #8]
0408008fc e4031f32 mov      w4, #2
040800900 e00313aa mov      x0, x19
040800904 f479ff97 bl       #0x407df0d4
040800908 e0031f2a mov      w0, wzr
04080090c f37b42a9 ldp      x19, x30, [sp, #0x20]
040800910 ffc30091 add      sp, sp, #0x30
040800914 c0035fd6 ret
040800918 ff0301d1 sub      sp, sp, #0x40
04080091c f41300f9 str      x20, [sp, #0x20]
040800920 f37b03a9 stp      x19, x30, [sp, #0x30]
040800924 08008ad2 mov      x8, #0x5000
040800928 6855a0f2 movk     x8, #0x2ab, lsl #16
04080092c f30301aa mov      x19, x1
040800930 f40300aa mov      x20, x0
040800934 4801c0f2 movk     x8, #0xa, lsl #32
040800938 0800e0f2 movk     x8, #0, lsl #48
04080093c 9f0208eb cmp      x20, x8
040800940 e8000054 b.hi     #0x4080095c
040800944 080084d2 mov      x8, #0x2000
040800948 6855a0f2 movk     x8, #0x2ab, lsl #16
04080094c 4801c0f2 movk     x8, #0xa, lsl #32
040800950 0800e0f2 movk     x8, #0, lsl #48
040800954 7f0208eb cmp      x19, x8
040800958 02030054 b.hs     #0x408009b8
04080095c 080096d2 mov      x8, #0xb000
040800960 4818a2f2 movk     x8, #0x10c2, lsl #16
040800964 4801c0f2 movk     x8, #0xa, lsl #32
040800968 0800e0f2 movk     x8, #0, lsl #48
04080096c 9f0208eb cmp      x20, x8
040800970 e8000054 b.hi     #0x4080098c
040800974 080080d2 mov      x8, #0
040800978 08f0a1f2 movk     x8, #0xf80, lsl #16
04080097c 4801c0f2 movk     x8, #0xa, lsl #32
040800980 0800e0f2 movk     x8, #0, lsl #48
040800984 7f0208eb cmp      x19, x8
040800988 82010054 b.hs     #0x408009b8
04080098c 88fe5bd3 lsr      x8, x20, #0x1b
040800990 1f2100f1 cmp      x8, #8
040800994 68000054 b.hi     #0x408009a0
040800998 68fe5ed3 lsr      x8, x19, #0x1e
04080099c e80000b5 cbnz     x8, #0x408009b8
0408009a0 c836b712 mov      w8, #0x4649ffff
0408009a4 9f0208eb cmp      x20, x8
0408009a8 28010054 b.hi     #0x408009cc
0408009ac 68fe53d3 lsr      x8, x19, #0x13
0408009b0 1f2123f1 cmp      x8, #0x8c8
0408009b4 c9000054 b.ls     #0x408009cc
0408009b8 e0031f2a mov      w0, wzr
0408009bc f37b43a9 ldp      x19, x30, [sp, #0x30]
0408009c0 f41340f9 ldr      x20, [sp, #0x20]
0408009c4 ff030191 add      sp, sp, #0x40
0408009c8 c0035fd6 ret
0408009cc e0031d32 mov      w0, #8
0408009d0 e1030091 mov      x1, sp
0408009d4 a3aa1594 bl       #0x40d6b460
0408009d8 40010036 tbz      w0, #0, #0x40800a00
0408009dc e80340b9 ldr      w8, [sp]
0408009e0 ea1740b9 ldr      w10, [sp, #0x14]
0408009e4 090500d1 sub      x9, x8, #1
0408009e8 28010a8b add      x8, x9, x10
0408009ec 1f0114eb cmp      x8, x20
0408009f0 83000054 b.lo     #0x40800a00
0408009f4 3f0113eb cmp      x9, x19
0408009f8 42000054 b.hs     #0x40800a00
0408009fc e8fdffb5 cbnz     x8, #0x408009b8
040800a00 e0030032 mov      w0, #1
040800a04 eeffff17 b        #0x408009bc

; address_read_handler_excerpt [0x40800a08, 0x40800af0); SHA-256 8902b74453b3af1f090e8cfedda3148086ea65b29cd50aa0041de202edf26049
040800a08 fc5bbda9 stp      x28, x22, [sp, #-0x30]!
040800a0c f55301a9 stp      x21, x20, [sp, #0x10]
040800a10 f37b02a9 stp      x19, x30, [sp, #0x20]
040800a14 ff0740d1 sub      sp, sp, #1, lsl #12
040800a18 ff8300d1 sub      sp, sp, #0x20
040800a1c f30301aa mov      x19, x1
040800a20 e0230091 add      x0, sp, #8
040800a24 e2031432 mov      w2, #0x1000
040800a28 755a4229 ldp      w21, w22, [x19, #0x10]
040800a2c 741a40b9 ldr      w20, [x19, #0x18]
040800a30 e1031f2a mov      w1, wzr
040800a34 ff1b10b9 str      wzr, [sp, #0x1018]
040800a38 ff0b08f9 str      xzr, [sp, #0x1010]
040800a3c ff0708f9 str      xzr, [sp, #0x1008]
040800a40 40e82994 bl       #0x4127ab40
040800a44 d57e60b3 bfi      x21, x22, #0x20, #0x20
040800a48 e00315aa mov      x0, x21
040800a4c 5a172694 bl       #0x411867b4
040800a50 c0000036 tbz      w0, #0, #0x40800a68
040800a54 e00313aa mov      x0, x19
040800a58 e10315aa mov      x1, x21
040800a5c e203142a mov      w2, w20
040800a60 24000094 bl       #0x40800af0
040800a64 0a000014 b        #0x40800a8c
040800a68 e0230091 add      x0, sp, #8
040800a6c e10315aa mov      x1, x21
040800a70 e20314aa mov      x2, x20
040800a74 a3e72994 bl       #0x4127a900
040800a78 03718252 mov      w3, #0x1388
040800a7c e1230091 add      x1, sp, #8
040800a80 e00313aa mov      x0, x19
040800a84 e203142a mov      w2, w20
040800a88 0f7aff97 bl       #0x407df2c4
040800a8c e3074091 add      x3, sp, #1, lsl #12
040800a90 63200091 add      x3, x3, #8
040800a94 20010036 tbz      w0, #0, #0x40800ab8
040800a98 21008452 mov      w1, #0x2001
040800a9c a2008052 mov      w2, #5
040800aa0 e00313aa mov      x0, x19
040800aa4 e4031f2a mov      w4, wzr
040800aa8 e10b10b9 str      w1, [sp, #0x1008]
040800aac 8a79ff97 bl       #0x407df0d4
040800ab0 e0030032 mov      w0, #1
040800ab4 09000014 b        #0x40800ad8
040800ab8 e8008452 mov      w8, #0x2007
040800abc 21008452 mov      w1, #0x2001
040800ac0 a2008052 mov      w2, #5
040800ac4 e4030032 mov      w4, #1
040800ac8 e80b10b9 str      w8, [sp, #0x1008]
040800acc e00313aa mov      x0, x19
040800ad0 8179ff97 bl       #0x407df0d4
040800ad4 e0031f2a mov      w0, wzr
040800ad8 ff074091 add      sp, sp, #1, lsl #12
040800adc ff830091 add      sp, sp, #0x20
040800ae0 f37b42a9 ldp      x19, x30, [sp, #0x20]
040800ae4 f55341a9 ldp      x21, x20, [sp, #0x10]
040800ae8 fc5bc3a8 ldp      x28, x22, [sp], #0x30
040800aec c0035fd6 ret

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
