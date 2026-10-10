
; descriptor_lookup_and_dispatch [0x407fe064, 0x407fe0f8); SHA-256 b0ff70de61ae879b24e1b3746de0670f3d9830860bd5fda174fe6034845d8219
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

; outer_wrappers_and_parameter_checks [0x407fe12c, 0x407fe228); SHA-256 59a8762960608113102fcbd02f71f0d5c6a46e672c223ec37e95d6b6f4a90b8c
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
0407fe170 fe0f1ff8 str      x30, [sp, #-0x10]!
0407fe174 a1008052 mov      w1, #5
0407fe178 7033ed97 bl       #0x4034af38
0407fe17c c8008452 mov      w8, #0x2006
0407fe180 1f000072 tst      w0, #1
0407fe184 29008452 mov      w9, #0x2001
0407fe188 2011881a csel     w0, w9, w8, ne
0407fe18c fe0741f8 ldr      x30, [sp], #0x10
0407fe190 c0035fd6 ret
0407fe194 f40f1ef8 str      x20, [sp, #-0x20]!
0407fe198 f37b01a9 stp      x19, x30, [sp, #0x10]
0407fe19c f303012a mov      w19, w1
0407fe1a0 a1008052 mov      w1, #5
0407fe1a4 f40300aa mov      x20, x0
0407fe1a8 6433ed97 bl       #0x4034af38
0407fe1ac 00010036 tbz      w0, #0, #0x407fe1cc
0407fe1b0 880e40b9 ldr      w8, [x20, #0xc]
0407fe1b4 08010035 cbnz     w8, #0x407fe1d4
0407fe1b8 881240b9 ldr      w8, [x20, #0x10]
0407fe1bc 1f01136b cmp      w8, w19
0407fe1c0 a1000054 b.ne     #0x407fe1d4
0407fe1c4 20008452 mov      w0, #0x2001
0407fe1c8 04000014 b        #0x407fe1d8
0407fe1cc c0008452 mov      w0, #0x2006
0407fe1d0 02000014 b        #0x407fe1d8
0407fe1d4 a0038452 mov      w0, #0x201d
0407fe1d8 f37b41a9 ldp      x19, x30, [sp, #0x10]
0407fe1dc f40742f8 ldr      x20, [sp], #0x20
0407fe1e0 c0035fd6 ret
0407fe1e4 f553bea9 stp      x21, x20, [sp, #-0x20]!
0407fe1e8 f37b01a9 stp      x19, x30, [sp, #0x10]
0407fe1ec f40300aa mov      x20, x0
0407fe1f0 f30302aa mov      x19, x2
0407fe1f4 f50301aa mov      x21, x1
0407fe1f8 800e40b9 ldr      w0, [x20, #0xc]
0407fe1fc 0b000094 bl       #0x407fe228
0407fe200 e00000b4 cbz      x0, #0x407fe21c
0407fe204 e30313aa mov      x3, x19
0407fe208 f37b41a9 ldp      x19, x30, [sp, #0x10]
0407fe20c e10314aa mov      x1, x20
0407fe210 e20315aa mov      x2, x21
0407fe214 f553c2a8 ldp      x21, x20, [sp], #0x20
0407fe218 a3ffff17 b        #0x407fe0a4
0407fe21c f37b41a9 ldp      x19, x30, [sp, #0x10]
0407fe220 f553c2a8 ldp      x21, x20, [sp], #0x20
0407fe224 c0035fd6 ret

; admission_and_handler_dispatch [0x407fe228, 0x407fe36c); SHA-256 1d59bd5ffabc16843ade03e4809ade88c8ae54ae58b9a18e5b191b40808cfab8
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

; registration_open_close [0x407fe4f0, 0x407fe85c); SHA-256 d1177c95679bd5736ad7a206c60b41d1233c6d793d624b9c26261cf040d18df7
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
0407fe53c ff8301d1 sub      sp, sp, #0x60
0407fe540 f81300f9 str      x24, [sp, #0x20]
0407fe544 f75b03a9 stp      x23, x22, [sp, #0x30]
0407fe548 f55304a9 stp      x21, x20, [sp, #0x40]
0407fe54c f37b05a9 stp      x19, x30, [sp, #0x50]
0407fe550 f30301aa mov      x19, x1
0407fe554 ff1b00b9 str      wzr, [sp, #0x18]
0407fe558 e00313aa mov      x0, x19
0407fe55c ffff00a9 stp      xzr, xzr, [sp, #8]
0407fe560 04ffff97 bl       #0x407fe170
0407fe564 083c0012 and      w8, w0, #0xffff
0407fe568 34008452 mov      w20, #0x2001
0407fe56c 1f01146b cmp      w8, w20
0407fe570 21070054 b.ne     #0x407fe654
0407fe574 16f993d2 mov      x22, #0x9fc8
0407fe578 b68fa0f2 movk     x22, #0x47d, lsl #16
0407fe57c 5601c0f2 movk     x22, #0xa, lsl #32
0407fe580 1600e0f2 movk     x22, #0, lsl #48
0407fe584 c8024039 ldrb     w8, [x22]
0407fe588 1f050071 cmp      w8, #1
0407fe58c 61000054 b.ne     #0x407fe598
0407fe590 c8038452 mov      w8, #0x201e
0407fe594 30000014 b        #0x407fe654
0407fe598 37f993d2 mov      x23, #0x9fc9
0407fe59c b78fa0f2 movk     x23, #0x47d, lsl #16
0407fe5a0 5701c0f2 movk     x23, #0xa, lsl #32
0407fe5a4 1700e0f2 movk     x23, #0, lsl #48
0407fe5a8 e8024039 ldrb     w8, [x23]
0407fe5ac a8020037 tbnz     w8, #0, #0x407fe600
0407fe5b0 e0031f2a mov      w0, wzr
0407fe5b4 679dff97 bl       #0x407e5b50
0407fe5b8 679dff97 bl       #0x407e5b54
0407fe5bc 40068052 mov      w0, #0x32
0407fe5c0 25bc1494 bl       #0x40d2d654
0407fe5c4 029f1e94 bl       #0x40fa61cc
0407fe5c8 1f080071 cmp      w0, #2
0407fe5cc 61010054 b.ne     #0x407fe5f8
0407fe5d0 f8031f2a mov      w24, wzr
0407fe5d4 55018052 mov      w21, #0xa
0407fe5d8 1f250094 bl       #0x40807a54
0407fe5dc e0000037 tbnz     w0, #0, #0x407fe5f8
0407fe5e0 e003152a mov      w0, w21
0407fe5e4 18070011 add      w24, w24, #1
0407fe5e8 1bbc1494 bl       #0x40d2d654
0407fe5ec 1f230371 cmp      w24, #0xc8
0407fe5f0 43ffff54 b.lo     #0x407fe5d8
0407fe5f4 17000014 b        #0x407fe650
0407fe5f8 e8030032 mov      w8, #1
0407fe5fc e8020039 strb     w8, [x23]
0407fe600 e0031f2a mov      w0, wzr
0407fe604 5a230094 bl       #0x4080736c
0407fe608 083c0012 and      w8, w0, #0xffff
0407fe60c 1f01146b cmp      w8, w20
0407fe610 21020054 b.ne     #0x407fe654
0407fe614 36140094 bl       #0x408036ec
0407fe618 84350094 bl       #0x4080bc28
0407fe61c e0031f2a mov      w0, wzr
0407fe620 1c000094 bl       #0x407fe690
0407fe624 60010036 tbz      w0, #0, #0x407fe650
0407fe628 f5030032 mov      w21, #1
0407fe62c f40b00b9 str      w20, [sp, #8]
0407fe630 a2008052 mov      w2, #5
0407fe634 e3230091 add      x3, sp, #8
0407fe638 e00313aa mov      x0, x19
0407fe63c d5020039 strb     w21, [x22]
0407fe640 e103142a mov      w1, w20
0407fe644 e4031f2a mov      w4, wzr
0407fe648 a382ff97 bl       #0x407df0d4
0407fe64c 0a000014 b        #0x407fe674
0407fe650 28009452 mov      w8, #0xa001
0407fe654 21008452 mov      w1, #0x2001
0407fe658 e80b00b9 str      w8, [sp, #8]
0407fe65c a2008052 mov      w2, #5
0407fe660 e3230091 add      x3, sp, #8
0407fe664 e00313aa mov      x0, x19
0407fe668 e4031f2a mov      w4, wzr
0407fe66c 9a82ff97 bl       #0x407df0d4
0407fe670 f5031f2a mov      w21, wzr
0407fe674 e003152a mov      w0, w21
0407fe678 f81340f9 ldr      x24, [sp, #0x20]
0407fe67c f37b45a9 ldp      x19, x30, [sp, #0x50]
0407fe680 f55344a9 ldp      x21, x20, [sp, #0x40]
0407fe684 f75b43a9 ldp      x23, x22, [sp, #0x30]
0407fe688 ff830191 add      sp, sp, #0x60
0407fe68c c0035fd6 ret
0407fe690 f40f1ef8 str      x20, [sp, #-0x20]!
0407fe694 f37b01a9 stp      x19, x30, [sp, #0x10]
0407fe698 f303002a mov      w19, w0
0407fe69c e0030132 mov      w0, #-0x80000000
0407fe6a0 68008052 mov      w8, #3
0407fe6a4 7f020071 cmp      w19, #0
0407fe6a8 2860a072 movk     w8, #0x301, lsl #16
0407fe6ac 1405881a cinc     w20, w8, ne
0407fe6b0 167fff97 bl       #0x407de308
0407fe6b4 01e19dd2 mov      x1, #0xef08
0407fe6b8 e10fa8f2 movk     x1, #0x407f, lsl #16
0407fe6bc 0100c0f2 movk     x1, #0, lsl #32
0407fe6c0 0100e0f2 movk     x1, #0, lsl #48
0407fe6c4 e003132a mov      w0, w19
0407fe6c8 bb022694 bl       #0x4117f1b4
0407fe6cc c0000036 tbz      w0, #0, #0x407fe6e4
0407fe6d0 02fa8052 mov      w2, #0x7d0
0407fe6d4 e0030132 mov      w0, #-0x80000000
0407fe6d8 e1330091 add      x1, sp, #0xc
0407fe6dc 597fff97 bl       #0x407de440
0407fe6e0 60000034 cbz      w0, #0x407fe6ec
0407fe6e4 e0031f2a mov      w0, wzr
0407fe6e8 10000014 b        #0x407fe728
0407fe6ec 88f993d2 mov      x8, #0x9fcc
0407fe6f0 09fa93d2 mov      x9, #0x9fd0
0407fe6f4 a88fa0f2 movk     x8, #0x47d, lsl #16
0407fe6f8 a98fa0f2 movk     x9, #0x47d, lsl #16
0407fe6fc 4801c0f2 movk     x8, #0xa, lsl #32
0407fe700 0800e0f2 movk     x8, #0, lsl #48
0407fe704 4901c0f2 movk     x9, #0xa, lsl #32
0407fe708 0900e0f2 movk     x9, #0, lsl #48
0407fe70c 080140b9 ldr      w8, [x8]
0407fe710 290140b9 ldr      w9, [x9]
0407fe714 9f02086b cmp      w20, w8
0407fe718 e8179f1a cset     w8, eq
0407fe71c 3f010071 cmp      w9, #0
0407fe720 e9079f1a cset     w9, ne
0407fe724 0001090a and      w0, w8, w9
0407fe728 f37b41a9 ldp      x19, x30, [sp, #0x10]
0407fe72c f40742f8 ldr      x20, [sp], #0x20
0407fe730 c0035fd6 ret
0407fe734 ffc300d1 sub      sp, sp, #0x30
0407fe738 f37b02a9 stp      x19, x30, [sp, #0x20]
0407fe73c e0031f2a mov      w0, wzr
0407fe740 ff7f0329 stp      wzr, wzr, [sp, #0x18]
0407fe744 f30301aa mov      x19, x1
0407fe748 ff7f0229 stp      wzr, wzr, [sp, #0x10]
0407fe74c 0c000094 bl       #0x407fe77c
0407fe750 21008452 mov      w1, #0x2001
0407fe754 a2008052 mov      w2, #5
0407fe758 e3330091 add      x3, sp, #0xc
0407fe75c e00313aa mov      x0, x19
0407fe760 e10f00b9 str      w1, [sp, #0xc]
0407fe764 e4031f2a mov      w4, wzr
0407fe768 5b82ff97 bl       #0x407df0d4
0407fe76c f37b42a9 ldp      x19, x30, [sp, #0x20]
0407fe770 e0030032 mov      w0, #1
0407fe774 ffc30091 add      sp, sp, #0x30
0407fe778 c0035fd6 ret
0407fe77c f37bbfa9 stp      x19, x30, [sp, #-0x10]!
0407fe780 f303002a mov      w19, w0
0407fe784 2a350094 bl       #0x4080bc2c
0407fe788 42290094 bl       #0x40808c90
0407fe78c e0031f2a mov      w0, wzr
0407fe790 33340094 bl       #0x4080b85c
0407fe794 e01f0032 mov      w0, #0xff
0407fe798 d4360094 bl       #0x4080c2e8
0407fe79c e0031faa mov      x0, xzr
0407fe7a0 e1031faa mov      x1, xzr
0407fe7a4 dd360094 bl       #0x4080c318
0407fe7a8 dd360094 bl       #0x4080c31c
0407fe7ac 23310094 bl       #0x4080ac38
0407fe7b0 64190094 bl       #0x40804d40
0407fe7b4 612f0094 bl       #0x4080a538
0407fe7b8 d3000036 tbz      w19, #0, #0x407fe7d0
0407fe7bc 28f993d2 mov      x8, #0x9fc9
0407fe7c0 a88fa0f2 movk     x8, #0x47d, lsl #16
0407fe7c4 4801c0f2 movk     x8, #0xa, lsl #32
0407fe7c8 0800e0f2 movk     x8, #0, lsl #48
0407fe7cc 1f010039 strb     wzr, [x8]
0407fe7d0 13f993d2 mov      x19, #0x9fc8
0407fe7d4 b38fa0f2 movk     x19, #0x47d, lsl #16
0407fe7d8 5301c0f2 movk     x19, #0xa, lsl #32
0407fe7dc 1300e0f2 movk     x19, #0, lsl #48
0407fe7e0 68024039 ldrb     w8, [x19]
0407fe7e4 1f050071 cmp      w8, #1
0407fe7e8 81020054 b.ne     #0x407fe838
0407fe7ec c0248052 mov      w0, #0x126
0407fe7f0 f9ca1594 bl       #0x40d713d4
0407fe7f4 20010035 cbnz     w0, #0x407fe818
0407fe7f8 48f993d2 mov      x8, #0x9fca
0407fe7fc a88fa0f2 movk     x8, #0x47d, lsl #16
0407fe800 4801c0f2 movk     x8, #0xa, lsl #32
0407fe804 0800e0f2 movk     x8, #0, lsl #48
0407fe808 08014039 ldrb     w8, [x8]
0407fe80c 68000037 tbnz     w8, #0, #0x407fe818
0407fe810 e0030032 mov      w0, #1
0407fe814 d6220094 bl       #0x4080736c
0407fe818 71330094 bl       #0x4080b5dc
0407fe81c e0030032 mov      w0, #1
0407fe820 9cffff97 bl       #0x407fe690
0407fe824 981e0094 bl       #0x40806284
0407fe828 f41d0094 bl       #0x40805ff8
0407fe82c 561f0094 bl       #0x40806584
0407fe830 e0031f2a mov      w0, wzr
0407fe834 8b020094 bl       #0x407ff260
0407fe838 48f993d2 mov      x8, #0x9fca
0407fe83c 7f020039 strb     wzr, [x19]
0407fe840 a88fa0f2 movk     x8, #0x47d, lsl #16
0407fe844 4801c0f2 movk     x8, #0xa, lsl #32
0407fe848 0800e0f2 movk     x8, #0, lsl #48
0407fe84c e0030032 mov      w0, #1
0407fe850 1f010039 strb     wzr, [x8]
0407fe854 f37bc1a8 ldp      x19, x30, [sp], #0x10
0407fe858 c0035fd6 ret

; parameter_count_check [0x4034af38, 0x4034af88); SHA-256 5001cc8bbf34f507d6a339b3dccf67d5915fce5bdeca14a86fe0254088fee5c2
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
