
; resource_ram_assignment_excerpt [0x40d70dbc, 0x40d70f88); SHA-256 266fa094c1096ca338aefa07530743a7f4c36241bdaa11d62c5d462751f52644
40d70dbc f60f1df8 str      x22, [sp, #-0x30]!
40d70dc0 f55301a9 stp      x21, x20, [sp, #0x10]
40d70dc4 f37b02a9 stp      x19, x30, [sp, #0x20]
40d70dc8 134183d2 mov      x19, #0x1a08
40d70dcc 08188fd2 mov      x8, #0x78c0
40d70dd0 b368a0f2 movk     x19, #0x345, lsl #16
40d70dd4 a8aba2f2 movk     x8, #0x155d, lsl #16
40d70dd8 5301c0f2 movk     x19, #0xa, lsl #32
40d70ddc 4801c0f2 movk     x8, #0xa, lsl #32
40d70de0 1300e0f2 movk     x19, #0, lsl #48
40d70de4 0800e0f2 movk     x8, #0, lsl #48
40d70de8 680200f9 str      x8, [x19]
40d70dec b1010094 bl       #0x40d714b0
40d70df0 142999d2 mov      x20, #0xc948
40d70df4 3452a0f2 movk     x20, #0x291, lsl #16
40d70df8 5401c0f2 movk     x20, #0xa, lsl #32
40d70dfc 1400e0f2 movk     x20, #0, lsl #48
40d70e00 80ca00f9 str      x0, [x20, #0x190]
40d70e04 ca010094 bl       #0x40d7152c
40d70e08 090090d2 mov      x9, #0x8000
40d70e0c 680240f9 ldr      x8, [x19]
40d70e10 e9a5a3f2 movk     x9, #0x1d2f, lsl #16
40d70e14 8ba648f9 ldr      x11, [x20, #0x1148]
40d70e18 0a0090d2 mov      x10, #0x8000
40d70e1c 8c5a51b9 ldr      w12, [x20, #0x1158]
40d70e20 4901c0f2 movk     x9, #0xa, lsl #32
40d70e24 8d7648f9 ldr      x13, [x20, #0x10e8]
40d70e28 0900e0f2 movk     x9, #0, lsl #48
40d70e2c 8efa50b9 ldr      w14, [x20, #0x10f8]
40d70e30 aaaaa3f2 movk     x10, #0x1d55, lsl #16
40d70e34 8fb647f9 ldr      x15, [x20, #0xf68]
40d70e38 4a01c0f2 movk     x10, #0xa, lsl #32
40d70e3c 90b641f9 ldr      x16, [x20, #0x368]
40d70e40 0a00e0f2 movk     x10, #0, lsl #48
40d70e44 891201f9 str      x9, [x20, #0x220]
40d70e48 09010b8b add      x9, x8, x11
40d70e4c 809a01b9 str      w0, [x20, #0x198]
40d70e50 0b010c8b add      x11, x8, x12
40d70e54 6b010d8b add      x11, x11, x13
40d70e58 8d7a4fb9 ldr      w13, [x20, #0xf78]
40d70e5c 8a2a01f9 str      x10, [x20, #0x250]
40d70e60 ca010c8b add      x10, x14, x12
40d70e64 0c010a8b add      x12, x8, x10
40d70e68 8e3e47f9 ldr      x14, [x20, #0xe78]
40d70e6c 8c010f8b add      x12, x12, x15
40d70e70 8f8a4eb9 ldr      w15, [x20, #0xe88]
40d70e74 4a010d8b add      x10, x10, x13
40d70e78 89aa08f9 str      x9, [x20, #0x1150]
40d70e7c 0d010a8b add      x13, x8, x10
40d70e80 899208f9 str      x9, [x20, #0x1120]
40d70e84 ad010e8b add      x13, x13, x14
40d70e88 8ece41f9 ldr      x14, [x20, #0x398]
40d70e8c 4a010f8b add      x10, x10, x15
40d70e90 8b7a08f9 str      x11, [x20, #0x10f0]
40d70e94 09010a8b add      x9, x8, x10
40d70e98 8cba07f9 str      x12, [x20, #0xf70]
40d70e9c 2c01108b add      x12, x9, x16
40d70ea0 8b7a43b9 ldr      w11, [x20, #0x378]
40d70ea4 ce010c8b add      x14, x14, x12
40d70ea8 8d4207f9 str      x13, [x20, #0xe80]
40d70eac e9031faa mov      x9, xzr
40d70eb0 8cba01f9 str      x12, [x20, #0x370]
40d70eb4 8ed201f9 str      x14, [x20, #0x3a0]
40d70eb8 8c02098b add      x12, x20, x9
40d70ebc 8dba41f9 ldr      x13, [x20, #0x370]
40d70ec0 29c10091 add      x9, x9, #0x30
40d70ec4 3f011ef1 cmp      x9, #0x780
40d70ec8 8ee541f9 ldr      x14, [x12, #0x3c8]
40d70ecc cd010d8b add      x13, x14, x13
40d70ed0 8de901f9 str      x13, [x12, #0x3d0]
40d70ed4 21ffff54 b.ne     #0x40d70eb8
40d70ed8 8ca645f9 ldr      x12, [x20, #0xb48]
40d70edc 4a010b8b add      x10, x10, x11
40d70ee0 8dbe45f9 ldr      x13, [x20, #0xb78]
40d70ee4 0b010a8b add      x11, x8, x10
40d70ee8 e9031faa mov      x9, xzr
40d70eec 6c010c8b add      x12, x11, x12
40d70ef0 8b5a4bb9 ldr      w11, [x20, #0xb58]
40d70ef4 ad010c8b add      x13, x13, x12
40d70ef8 8caa05f9 str      x12, [x20, #0xb50]
40d70efc 8dc205f9 str      x13, [x20, #0xb80]
40d70f00 8c02098b add      x12, x20, x9
40d70f04 8daa45f9 ldr      x13, [x20, #0xb50]
40d70f08 29c10091 add      x9, x9, #0x30
40d70f0c 3f0109f1 cmp      x9, #0x240
40d70f10 8ed545f9 ldr      x14, [x12, #0xba8]
40d70f14 cd010d8b add      x13, x14, x13
40d70f18 8dd905f9 str      x13, [x12, #0xbb0]
40d70f1c 21ffff54 b.ne     #0x40d70f00
40d70f20 8cfa41b9 ldr      w12, [x20, #0x1f8]
40d70f24 4a010b8b add      x10, x10, x11
40d70f28 89f640f9 ldr      x9, [x20, #0x1e8]
40d70f2c 0d010a8b add      x13, x8, x10
40d70f30 8bca41b9 ldr      w11, [x20, #0x1c8]
40d70f34 c03b8052 mov      w0, #0x1de
40d70f38 8ede40f9 ldr      x14, [x20, #0x1b8]
40d70f3c 4a010c8b add      x10, x10, x12
40d70f40 8ffa4db9 ldr      w15, [x20, #0xdf8]
40d70f44 a901098b add      x9, x13, x9
40d70f48 8cf646f9 ldr      x12, [x20, #0xde8]
40d70f4c 0d010a8b add      x13, x8, x10
40d70f50 ff1b0079 strh     wzr, [sp, #0xc]
40d70f54 4a010b8b add      x10, x10, x11
40d70f58 ff130079 strh     wzr, [sp, #8]
40d70f5c ab010e8b add      x11, x13, x14
40d70f60 8e5647f9 ldr      x14, [x20, #0xea8]
40d70f64 0d010a8b add      x13, x8, x10
40d70f68 89fa00f9 str      x9, [x20, #0x1f0]
40d70f6c 4a010f8b add      x10, x10, x15
40d70f70 08010a8b add      x8, x8, x10
40d70f74 8be200f9 str      x11, [x20, #0x1c0]
40d70f78 ac010c8b add      x12, x13, x12
40d70f7c 08010e8b add      x8, x8, x14
40d70f80 8cfa06f9 str      x12, [x20, #0xdf0]
40d70f84 885a07f9 str      x8, [x20, #0xeb0]

; resource_load_entry_excerpt [0x40d6bff4, 0x40d6c164); SHA-256 26e98b3f9c63a3a6f7b00540aa5912ce5d99aa080ac8dda86dcea4b5718fa85f
40d6bff4 fc6fbaa9 stp      x28, x27, [sp, #-0x60]!
40d6bff8 fa6701a9 stp      x26, x25, [sp, #0x10]
40d6bffc f85f02a9 stp      x24, x23, [sp, #0x20]
40d6c000 f65703a9 stp      x22, x21, [sp, #0x30]
40d6c004 f44f04a9 stp      x20, x19, [sp, #0x40]
40d6c008 fd7b05a9 stp      x29, x30, [sp, #0x50]
40d6c00c f503002a mov      w21, w0
40d6c010 bf720171 cmp      w21, #0x5c
40d6c014 49010054 b.ls     #0x40d6c03c
40d6c018 f3031f2a mov      w19, wzr
40d6c01c 60020012 and      w0, w19, #1
40d6c020 fd7b45a9 ldp      x29, x30, [sp, #0x50]
40d6c024 f44f44a9 ldp      x20, x19, [sp, #0x40]
40d6c028 f65743a9 ldp      x22, x21, [sp, #0x30]
40d6c02c f85f42a9 ldp      x24, x23, [sp, #0x20]
40d6c030 fa6741a9 ldp      x26, x25, [sp, #0x10]
40d6c034 fc6fc6a8 ldp      x28, x27, [sp], #0x60
40d6c038 c0035fd6 ret
40d6c03c e003152a mov      w0, w21
40d6c040 a2140094 bl       #0x40d712c8
40d6c044 f30300aa mov      x19, x0
40d6c048 b3feffb4 cbz      x19, #0x40d6c01c
40d6c04c 681a40b9 ldr      w8, [x19, #0x18]
40d6c050 48feff34 cbz      w8, #0x40d6c018
40d6c054 680a40f9 ldr      x8, [x19, #0x10]
40d6c058 08feffb4 cbz      x8, #0x40d6c018
40d6c05c 602640b9 ldr      w0, [x19, #0x24]
40d6c060 93140094 bl       #0x40d712ac
40d6c064 f40300aa mov      x20, x0
40d6c068 94fdffb4 cbz      x20, #0x40d6c018
40d6c06c 880240f9 ldr      x8, [x20]
40d6c070 48fdffb4 cbz      x8, #0x40d6c018
40d6c074 88924039 ldrb     w8, [x20, #0x24]
40d6c078 1f050071 cmp      w8, #1
40d6c07c 40010054 b.eq     #0x40d6c0a4
40d6c080 bf4a0071 cmp      w21, #0x12
40d6c084 00010054 b.eq     #0x40d6c0a4
40d6c088 bff20071 cmp      w21, #0x3c
40d6c08c c0000054 b.eq     #0x40d6c0a4
40d6c090 602640b9 ldr      w0, [x19, #0x24]
40d6c094 a7140094 bl       #0x40d71330
40d6c098 8c140094 bl       #0x40d712c8
40d6c09c f30300aa mov      x19, x0
40d6c0a0 f3fbffb4 cbz      x19, #0x40d6c01c
40d6c0a4 e00313aa mov      x0, x19
40d6c0a8 e10314aa mov      x1, x20
40d6c0ac 9d000094 bl       #0x40d6c320
40d6c0b0 f303002a mov      w19, w0
40d6c0b4 73000037 tbnz     w19, #0, #0x40d6c0c0
40d6c0b8 e003152a mov      w0, w21
40d6c0bc 7a140094 bl       #0x40d712a4
40d6c0c0 185f89d2 mov      x24, #0x4af8
40d6c0c4 5868a0f2 movk     x24, #0x342, lsl #16
40d6c0c8 5801c0f2 movk     x24, #0xa, lsl #32
40d6c0cc 080b8052 mov      w8, #0x58
40d6c0d0 1800e0f2 movk     x24, #0, lsl #48
40d6c0d4 a962a89b umaddl   x9, w21, w8, x24
40d6c0d8 b4088052 mov      w20, #0x45
40d6c0dc 1487a072 movk     w20, #0x438, lsl #16
40d6c0e0 bf320071 cmp      w21, #0xc
40d6c0e4 e80d8052 mov      w8, #0x6f
40d6c0e8 2b5140b9 ldr      w11, [x9, #0x50]
40d6c0ec ec031e32 mov      w12, #4
40d6c0f0 8a120011 add      w10, w20, #4
40d6c0f4 9901881a csel     w25, w12, w8, eq
40d6c0f8 280140f9 ldr      x8, [x9]
40d6c0fc 96028a1a csel     w22, w20, w10, eq
40d6c100 6b01192a orr      w11, w11, w25
40d6c104 2b5100b9 str      w11, [x9, #0x50]
40d6c108 e80200b4 cbz      x8, #0x40d6c164
40d6c10c f703152a mov      w23, w21
40d6c110 090b8052 mov      w9, #0x58
40d6c114 fa62099b madd     x26, x23, x9, x24
40d6c118 494f4578 ldrh     w9, [x26, #0x54]!
40d6c11c 49020034 cbz      w9, #0x40d6c164
40d6c120 e003162a mov      w0, w22
40d6c124 e10317aa mov      x1, x23
40d6c128 00013fd6 blr      x8
40d6c12c 48034079 ldrh     w8, [x26]
40d6c130 1f090071 cmp      w8, #2
40d6c134 83010054 b.lo     #0x40d6c164
40d6c138 080b8052 mov      w8, #0x58
40d6c13c fc030032 mov      w28, #1
40d6c140 fb62089b madd     x27, x23, x8, x24
40d6c144 687b7cf8 ldr      x8, [x27, x28, lsl #3]
40d6c148 e003162a mov      w0, w22
40d6c14c e10317aa mov      x1, x23
40d6c150 00013fd6 blr      x8
40d6c154 48034079 ldrh     w8, [x26]
40d6c158 9c070091 add      x28, x28, #1
40d6c15c 9f0308eb cmp      x28, x8
40d6c160 23ffff54 b.lo     #0x40d6c144

; resource_load_descriptor_adapter [0x40d6c320, 0x40d6c3c0); SHA-256 9a4f378dd37f92225ca0f3400626b00681ff68510b6b5d426dcc24e9bdad3cd2
40d6c320 ffc301d1 sub      sp, sp, #0x70
40d6c324 fe3300f9 str      x30, [sp, #0x60]
40d6c328 280040f9 ldr      x8, [x1]
40d6c32c 080300b4 cbz      x8, #0x40d6c38c
40d6c330 09ac40a9 ldp      x9, x11, [x0, #8]
40d6c334 0a2040b9 ldr      w10, [x0, #0x20]
40d6c338 000c40fd ldr      d0, [x0, #0x18]
40d6c33c e9af00a9 stp      x9, x11, [sp, #8]
40d6c340 ea2300b9 str      w10, [sp, #0x20]
40d6c344 29284229 ldp      w9, w10, [x1, #0x10]
40d6c348 e81700f9 str      x8, [sp, #0x28]
40d6c34c 28604039 ldrb     w8, [x1, #0x18]
40d6c350 e92b0729 stp      w9, w10, [sp, #0x38]
40d6c354 290440f9 ldr      x9, [x1, #8]
40d6c358 e00f00fd str      d0, [sp, #0x18]
40d6c35c e8030139 strb     w8, [sp, #0x40]
40d6c360 e8230091 add      x8, sp, #8
40d6c364 0cf10091 add      x12, x8, #0x3c
40d6c368 28700091 add      x8, x1, #0x1c
40d6c36c e91b00f9 str      x9, [sp, #0x30]
40d6c370 8081000d st1      {v0.s}[0], [x12]
40d6c374 e8af04a9 stp      x8, x11, [sp, #0x48]
40d6c378 ea5b00b9 str      w10, [sp, #0x58]
40d6c37c c90000b4 cbz      x9, #0x40d6c394
40d6c380 e0230091 add      x0, sp, #8
40d6c384 5d100094 bl       #0x40d704f8
40d6c388 0a000014 b        #0x40d6c3b0
40d6c38c e0031f2a mov      w0, wzr
40d6c390 08000014 b        #0x40d6c3b0
40d6c394 080140b9 ldr      w8, [x8]
40d6c398 e0230091 add      x0, sp, #8
40d6c39c 1f050071 cmp      w8, #1
40d6c3a0 61000054 b.ne     #0x40d6c3ac
40d6c3a4 42100094 bl       #0x40d704ac
40d6c3a8 02000014 b        #0x40d6c3b0
40d6c3ac c40f0094 bl       #0x40d702bc
40d6c3b0 fe3340f9 ldr      x30, [sp, #0x60]
40d6c3b4 00000012 and      w0, w0, #1
40d6c3b8 ffc30191 add      sp, sp, #0x70
40d6c3bc c0035fd6 ret

; resource_load_copy [0x40d702bc, 0x40d70370); SHA-256 eaa2265d4a93659e4f38a1d1a54bfbd1c147dca354291e076d477d648a43180e
40d702bc ff8301d1 sub      sp, sp, #0x60
40d702c0 f37b05a9 stp      x19, x30, [sp, #0x50]
40d702c4 f30300aa mov      x19, x0
40d702c8 e2830091 add      x2, sp, #0x20
40d702cc e3330191 add      x3, sp, #0x4c
40d702d0 68a64229 ldp      w8, w9, [x19, #0x14]
40d702d4 6a1640f9 ldr      x10, [x19, #0x28]
40d702d8 e1031f2a mov      w1, wzr
40d702dc 287d60b3 bfi      x8, x9, #0x20, #0x20
40d702e0 ea0700f9 str      x10, [sp, #8]
40d702e4 e81300f9 str      x8, [sp, #0x20]
40d702e8 681240f9 ldr      x8, [x19, #0x20]
40d702ec e80300f9 str      x8, [sp]
40d702f0 e003c03d ldr      q0, [sp]
40d702f4 e007803d str      q0, [sp, #0x10]
40d702f8 e80f40f9 ldr      x8, [sp, #0x18]
40d702fc 693240b9 ldr      w9, [x19, #0x30]
40d70300 e81b00f9 str      x8, [sp, #0x30]
40d70304 e80b40f9 ldr      x8, [sp, #0x10]
40d70308 6a2240f9 ldr      x10, [x19, #0x40]
40d7030c 605240b9 ldr      w0, [x19, #0x50]
40d70310 e93b00b9 str      w9, [sp, #0x38]
40d70314 e81700f9 str      x8, [sp, #0x28]
40d70318 ea2300f9 str      x10, [sp, #0x40]
40d7031c 15000094 bl       #0x40d70370
40d70320 e803002a mov      w8, w0
40d70324 e0031f2a mov      w0, wzr
40d70328 e8010036 tbz      w8, #0, #0x40d70364
40d7032c 68e24039 ldrb     w8, [x19, #0x38]
40d70330 602640f9 ldr      x0, [x19, #0x48]
40d70334 611240f9 ldr      x1, [x19, #0x20]
40d70338 621240b9 ldr      w2, [x19, #0x10]
40d7033c a8000034 cbz      w8, #0x40d70350
40d70340 afe4fc97 bl       #0x40ca95fc
40d70344 1f000071 cmp      w0, #0
40d70348 e0179f1a cset     w0, eq
40d7034c 06000014 b        #0x40d70364
40d70350 683240b9 ldr      w8, [x19, #0x30]
40d70354 1f01026b cmp      w8, w2
40d70358 0231821a csel     w2, w8, w2, lo
40d7035c 69291494 bl       #0x4127a900
40d70360 e0030032 mov      w0, #1
40d70364 f37b45a9 ldp      x19, x30, [sp, #0x50]
40d70368 ff830191 add      sp, sp, #0x60
40d7036c c0035fd6 ret

; resource_footer_validation [0x40d70370, 0x40d704ac); SHA-256 fc6cb3f5fc111a399381f6723f77481baffb426e5d9ed8e7c46a04516847929c
40d70370 f60f1df8 str      x22, [sp, #-0x30]!
40d70374 f55301a9 stp      x21, x20, [sp, #0x10]
40d70378 f37b02a9 stp      x19, x30, [sp, #0x20]
40d7037c f30302aa mov      x19, x2
40d70380 f60303aa mov      x22, x3
40d70384 f403012a mov      w20, w1
40d70388 681240f9 ldr      x8, [x19, #0x20]
40d7038c f503002a mov      w21, w0
40d70390 081d4039 ldrb     w8, [x8, #7]
40d70394 88010034 cbz      w8, #0x40d703c4
40d70398 e003152a mov      w0, w21
40d7039c e103142a mov      w1, w20
40d703a0 e20313aa mov      x2, x19
40d703a4 f8fcff97 bl       #0x40d6f784
40d703a8 a00000b4 cbz      x0, #0x40d703bc
40d703ac 080040b9 ldr      w8, [x0]
40d703b0 1f410031 cmn      w8, #0x10
40d703b4 c80200b9 str      w8, [x22]
40d703b8 a9000054 b.ls     #0x40d703cc
40d703bc f6031f2a mov      w22, wzr
40d703c0 04000014 b        #0x40d703d0
40d703c4 e86f1c32 mov      w8, #-0x10
40d703c8 c80200b9 str      w8, [x22]
40d703cc f6030032 mov      w22, #1
40d703d0 681240f9 ldr      x8, [x19, #0x20]
40d703d4 09194039 ldrb     w9, [x8, #6]
40d703d8 09060034 cbz      w9, #0x40d70498
40d703dc 080140b9 ldr      w8, [x8]
40d703e0 1f090071 cmp      w8, #2
40d703e4 41030054 b.ne     #0x40d7044c
40d703e8 f4000035 cbnz     w20, #0x40d70404
40d703ec 083a83d2 mov      x8, #0x19d0
40d703f0 a868a0f2 movk     x8, #0x345, lsl #16
40d703f4 4801c0f2 movk     x8, #0xa, lsl #32
40d703f8 0800e0f2 movk     x8, #0, lsl #48
40d703fc 080140f9 ldr      x8, [x8]
40d70400 c80400b5 cbnz     x8, #0x40d70498
40d70404 9f060071 cmp      w20, #1
40d70408 e1000054 b.ne     #0x40d70424
40d7040c 083b83d2 mov      x8, #0x19d8
40d70410 a868a0f2 movk     x8, #0x345, lsl #16
40d70414 4801c0f2 movk     x8, #0xa, lsl #32
40d70418 0800e0f2 movk     x8, #0, lsl #48
40d7041c 080140f9 ldr      x8, [x8]
40d70420 c80300b5 cbnz     x8, #0x40d70498
40d70424 684e348b add      x8, x19, w20, uxtw #3
40d70428 621a40b9 ldr      w2, [x19, #0x18]
40d7042c 003c83d2 mov      x0, #0x19e0
40d70430 a068a0f2 movk     x0, #0x345, lsl #16
40d70434 010540f9 ldr      x1, [x8, #8]
40d70438 4001c0f2 movk     x0, #0xa, lsl #32
40d7043c 0000e0f2 movk     x0, #0, lsl #48
40d70440 d9010094 bl       #0x40d70ba4
40d70444 a00200b5 cbnz     x0, #0x40d70498
40d70448 15000014 b        #0x40d7049c
40d7044c e003152a mov      w0, w21
40d70450 e103142a mov      w1, w20
40d70454 e20313aa mov      x2, x19
40d70458 bd010094 bl       #0x40d70b4c
40d7045c e00700f9 str      x0, [sp, #8]
40d70460 e0031f2a mov      w0, wzr
40d70464 eb0740f9 ldr      x11, [sp, #8]
40d70468 69014039 ldrb     w9, [x11]
40d7046c 68054039 ldrb     w8, [x11, #1]
40d70470 6a094039 ldrb     w10, [x11, #2]
40d70474 6b0d4039 ldrb     w11, [x11, #3]
40d70478 7f350171 cmp      w11, #0x4d
40d7047c 01010054 b.ne     #0x40d7049c
40d70480 5f110171 cmp      w10, #0x44
40d70484 c1000054 b.ne     #0x40d7049c
40d70488 3f150171 cmp      w9, #0x45
40d7048c 81000054 b.ne     #0x40d7049c
40d70490 1f390171 cmp      w8, #0x4e
40d70494 41000054 b.ne     #0x40d7049c
40d70498 e003162a mov      w0, w22
40d7049c f37b42a9 ldp      x19, x30, [sp, #0x20]
40d704a0 f55341a9 ldp      x21, x20, [sp, #0x10]
40d704a4 f60743f8 ldr      x22, [sp], #0x30
40d704a8 c0035fd6 ret

; resource_footer_address [0x40d70b4c, 0x40d70ba4); SHA-256 ae713e1cc029aefd9eba541d86fa883f9fae0c3f7804abff8356133d87e0c914
40d70b4c 480040b9 ldr      w8, [x2]
40d70b50 1f090071 cmp      w8, #2
40d70b54 20010054 b.eq     #0x40d70b78
40d70b58 1f050071 cmp      w8, #1
40d70b5c 80010054 b.eq     #0x40d70b8c
40d70b60 e8010035 cbnz     w8, #0x40d70b9c
40d70b64 484c218b add      x8, x2, w1, uxtw #3
40d70b68 491840b9 ldr      w9, [x2, #0x18]
40d70b6c 080540f9 ldr      x8, [x8, #8]
40d70b70 0801098b add      x8, x8, x9
40d70b74 04000014 b        #0x40d70b84
40d70b78 484c218b add      x8, x2, w1, uxtw #3
40d70b7c 080540f9 ldr      x8, [x8, #8]
40d70b80 0841208b add      x8, x8, w0, uxtw
40d70b84 001100d1 sub      x0, x8, #4
40d70b88 c0035fd6 ret
40d70b8c 484c218b add      x8, x2, w1, uxtw #3
40d70b90 080540f9 ldr      x8, [x8, #8]
40d70b94 0041208b add      x0, x8, w0, uxtw
40d70b98 c0035fd6 ret
40d70b9c e0031faa mov      x0, xzr
40d70ba0 c0035fd6 ret

; capture_context_request_caller_excerpt [0x40f81cc4, 0x40f81dbc); SHA-256 e4ffe361433fbf17d22683e00fa7b840926da6dd0848ae77d537df6d64ba6a31
40f81cc4 68034039 ldrb     w8, [x27]
40f81cc8 e00313aa mov      x0, x19
40f81ccc f30b00f9 str      x19, [sp, #0x10]
40f81cd0 f51f00b9 str      w21, [sp, #0x1c]
40f81cd4 f42700b9 str      w20, [sp, #0x24]
40f81cd8 e8830039 strb     w8, [sp, #0x20]
40f81cdc 90070094 bl       #0x40f83b1c
40f81ce0 156788d2 mov      x21, #0x4338
40f81ce4 68d643b9 ldr      w8, [x19, #0x3d4]
40f81ce8 9577a0f2 movk     x21, #0x3bc, lsl #16
40f81cec 690240b9 ldr      w9, [x19]
40f81cf0 5501c0f2 movk     x21, #0xa, lsl #32
40f81cf4 e02b00b9 str      w0, [sp, #0x28]
40f81cf8 1500e0f2 movk     x21, #0, lsl #48
40f81cfc 1f050071 cmp      w8, #1
40f81d00 e8179f1a cset     w8, eq
40f81d04 a20240b9 ldr      w2, [x21]
40f81d08 3f110071 cmp      w9, #4
40f81d0c e9630291 add      x9, sp, #0x98
40f81d10 ea179f1a cset     w10, eq
40f81d14 e8b30039 strb     w8, [sp, #0x2c]
40f81d18 5f100071 cmp      w2, #4
40f81d1c e94b00f9 str      x9, [sp, #0x90]
40f81d20 ea630039 strb     w10, [sp, #0x18]
40f81d24 a2000054 b.hs     #0x40f81d38
40f81d28 e803022a mov      w8, w2
40f81d2c 09000014 b        #0x40f81d50
40f81d30 e8faff35 cbnz     w8, #0x40f81c8c
40f81d34 ddffff17 b        #0x40f81ca8
40f81d38 a1678b52 mov      w1, #0x5b3d
40f81d3c e0030032 mov      w0, #1
40f81d40 e3031f2a mov      w3, wzr
40f81d44 5006ff97 bl       #0x40f43684
40f81d48 a20240b9 ldr      w2, [x21]
40f81d4c e8031f2a mov      w8, wzr
40f81d50 896688d2 mov      x9, #0x4334
40f81d54 e87f00b9 str      w8, [sp, #0x7c]
40f81d58 0b6688d2 mov      x11, #0x4330
40f81d5c e89f41b9 ldr      w8, [sp, #0x19c]
40f81d60 8977a0f2 movk     x9, #0x3bc, lsl #16
40f81d64 f8030239 strb     w24, [sp, #0x80]
40f81d68 8b77a0f2 movk     x11, #0x3bc, lsl #16
40f81d6c 0a7485d2 mov      x10, #0x2ba0
40f81d70 4901c0f2 movk     x9, #0xa, lsl #32
40f81d74 e88f00b9 str      w8, [sp, #0x8c]
40f81d78 4b01c0f2 movk     x11, #0xa, lsl #32
40f81d7c 8a77a0f2 movk     x10, #0x3bc, lsl #16
40f81d80 0900e0f2 movk     x9, #0, lsl #48
40f81d84 0b00e0f2 movk     x11, #0, lsl #48
40f81d88 4a01c0f2 movk     x10, #0xa, lsl #32
40f81d8c 0a00e0f2 movk     x10, #0, lsl #48
40f81d90 220100b9 str      w2, [x9]
40f81d94 620140b9 ldr      w2, [x11]
40f81d98 60028052 mov      w0, #0x13
40f81d9c 21698b52 mov      w1, #0x5b49
40f81da0 490140b9 ldr      w9, [x10]
40f81da4 43300c53 ubfx     w3, w2, #0xc, #1
40f81da8 e98700b9 str      w9, [sp, #0x84]
40f81dac e3230239 strb     w3, [sp, #0x88]
40f81db0 626f0094 bl       #0x40f9db38
40f81db4 e0430091 add      x0, sp, #0x10
40f81db8 7bcc0294 bl       #0x41034fa4

; capture_selector_builder [0x40f889a8, 0x40f88a78); SHA-256 f80e9e9c49d37aa900bd1729bf8e8a66ce5050f11359953d22fc0c1e65de45f6
40f889a8 ff4301d1 sub      sp, sp, #0x50
40f889ac fe2300f9 str      x30, [sp, #0x40]
40f889b0 ff7f01a9 stp      xzr, xzr, [sp, #0x10]
40f889b4 085685d2 mov      x8, #0x2ab0
40f889b8 000040fd ldr      d0, [x0]
40f889bc 8877a0f2 movk     x8, #0x3bc, lsl #16
40f889c0 ff7f02a9 stp      xzr, xzr, [sp, #0x20]
40f889c4 4801c0f2 movk     x8, #0xa, lsl #32
40f889c8 ff3b00b9 str      wzr, [sp, #0x38]
40f889cc 0800e0f2 movk     x8, #0, lsl #48
40f889d0 ff1b00f9 str      xzr, [sp, #0x30]
40f889d4 e1ae95d2 mov      x1, #0xad77
40f889d8 0900669e fmov     x9, d0
40f889dc 0a8843b9 ldr      w10, [x0, #0x388]
40f889e0 080140b9 ldr      w8, [x8]
40f889e4 8153a0f2 movk     x1, #0x29c, lsl #16
40f889e8 4101c0f2 movk     x1, #0xa, lsl #32
40f889ec 0100e0f2 movk     x1, #0, lsl #48
40f889f0 a26d9b52 mov      w2, #0xdb6d
40f889f4 08050051 sub      w8, w8, #1
40f889f8 2bfd60d3 lsr      x11, x9, #0x20
40f889fc 1f0d0071 cmp      w8, #3
40f88a00 e9af0229 stp      w9, w11, [sp, #0x14]
40f88a04 0900261e fmov     w9, s0
40f88a08 0b8c43b9 ldr      w11, [x0, #0x38c]
40f88a0c ec279f1a cset     w12, lo
40f88a10 ea1f00b9 str      w10, [sp, #0x1c]
40f88a14 0aa043b9 ldr      w10, [x0, #0x3a0]
40f88a18 08304039 ldrb     w8, [x0, #0xc]
40f88a1c 3f050071 cmp      w9, #1
40f88a20 ebab0429 stp      w11, w10, [sp, #0x24]
40f88a24 0bd00e91 add      x11, x0, #0x3b4
40f88a28 094840b9 ldr      w9, [x0, #0x48]
40f88a2c 0a400e91 add      x10, x0, #0x390
40f88a30 e8b30039 strb     w8, [sp, #0x2c]
40f88a34 48018b9a csel     x8, x10, x11, eq
40f88a38 0a7843b9 ldr      w10, [x0, #0x378]
40f88a3c 60618452 mov      w0, #0x230b
40f88a40 e93300b9 str      w9, [sp, #0x30]
40f88a44 89791f53 lsl      w9, w12, #1
40f88a48 080140b9 ldr      w8, [x8]
40f88a4c ff0700f9 str      xzr, [sp, #8]
40f88a50 ea3f00b9 str      w10, [sp, #0x3c]
40f88a54 e93700b9 str      w9, [sp, #0x34]
40f88a58 e82300b9 str      w8, [sp, #0x20]
40f88a5c 8a280294 bl       #0x41012c84
40f88a60 e03b00b9 str      w0, [sp, #0x38]
40f88a64 e0230091 add      x0, sp, #8
40f88a68 24770394 bl       #0x410666f8
40f88a6c fe2340f9 ldr      x30, [sp, #0x40]
40f88a70 ff430191 add      sp, sp, #0x50
40f88a74 c0035fd6 ret

; capture_selector_store_excerpt [0x40f88a78, 0x40f88a98); SHA-256 f13f225ce48af5ea7f52c5034a7ae3d677ae477d7757c1e3209e110637dab7c4
40f88a78 f37bbfa9 stp      x19, x30, [sp, #-0x10]!
40f88a7c f30300aa mov      x19, x0
40f88a80 60f244f9 ldr      x0, [x19, #0x9e0]
40f88a84 1f0400b9 str      wzr, [x0, #4]
40f88a88 c8ffff97 bl       #0x40f889a8
40f88a8c 68f244f9 ldr      x8, [x19, #0x9e0]
40f88a90 09fd41b9 ldr      w9, [x8, #0x1fc]
40f88a94 000900b9 str      w0, [x8, #8]

; capture_selector_leaf [0x410666f8, 0x410668e0); SHA-256 b8aac32a6fe23dbb8e86620f52467a1c22518f80b57eddaaca5794559ad89525
410666f8 f37bbfa9 stp      x19, x30, [sp, #-0x10]!
410666fc f30300aa mov      x19, x0
41066700 68024039 ldrb     w8, [x19]
41066704 08010034 cbz      w8, #0x41066724
41066708 600640b9 ldr      w0, [x19, #4]
4106670c 1f080071 cmp      w0, #2
41066710 20010054 b.eq     #0x41066734
41066714 1f040071 cmp      w0, #1
41066718 60090054 b.eq     #0x41066844
4106671c 20090035 cbnz     w0, #0x41066840
41066720 49000014 b        #0x41066844
41066724 681240b9 ldr      w8, [x19, #0x10]
41066728 88010034 cbz      w8, #0x41066758
4106672c e0031f2a mov      w0, wzr
41066730 45000014 b        #0x41066844
41066734 680a80b9 ldrsw    x8, [x19, #8]
41066738 1f110071 cmp      w8, #4
4106673c 22080054 b.hs     #0x41066840
41066740 09c78fd2 mov      x9, #0x7e38
41066744 2955a0f2 movk     x9, #0x2a9, lsl #16
41066748 4901c0f2 movk     x9, #0xa, lsl #32
4106674c 0900e0f2 movk     x9, #0, lsl #48
41066750 207968b8 ldr      w0, [x9, x8, lsl #2]
41066754 3c000014 b        #0x41066844
41066758 680e40b9 ldr      w8, [x19, #0xc]
4106675c 60018052 mov      w0, #0xb
41066760 1f150071 cmp      w8, #5
41066764 08070054 b.hi     #0x41066844
41066768 091a8fd2 mov      x9, #0x78d0
4106676c 2955a0f2 movk     x9, #0x2a9, lsl #16
41066770 4901c0f2 movk     x9, #0xa, lsl #32
41066774 0900e0f2 movk     x9, #0, lsl #48
41066778 287968f8 ldr      x8, [x9, x8, lsl #3]
4106677c 00011fd6 br       x8
41066780 40018052 mov      w0, #0xa
41066784 30000014 b        #0x41066844
41066788 20018052 mov      w0, #9
4106678c 2e000014 b        #0x41066844
41066790 681640b9 ldr      w8, [x19, #0x14]
41066794 09190051 sub      w9, w8, #6
41066798 3f090071 cmp      w9, #2
4106679c 83050054 b.lo     #0x4106684c
410667a0 1f150071 cmp      w8, #5
410667a4 c0050054 b.eq     #0x4106685c
410667a8 1f110071 cmp      w8, #4
410667ac a1040054 b.ne     #0x41066840
410667b0 682240b9 ldr      w8, [x19, #0x20]
410667b4 080d0051 sub      w8, w8, #3
410667b8 1f050071 cmp      w8, #1
410667bc 48050054 b.hi     #0x41066864
410667c0 68924039 ldrb     w8, [x19, #0x24]
410667c4 88060035 cbnz     w8, #0x41066894
410667c8 681e40b9 ldr      w8, [x19, #0x1c]
410667cc 1f190071 cmp      w8, #6
410667d0 40080054 b.eq     #0x410668d8
410667d4 1f110071 cmp      w8, #4
410667d8 e1050054 b.ne     #0x41066894
410667dc 681a40b9 ldr      w8, [x19, #0x18]
410667e0 09110051 sub      w9, w8, #4
410667e4 3f0d0071 cmp      w9, #3
410667e8 83070054 b.lo     #0x410668d8
410667ec 08090051 sub      w8, w8, #2
410667f0 1f050071 cmp      w8, #1
410667f4 08050054 b.hi     #0x41066894
410667f8 683240b9 ldr      w8, [x19, #0x30]
410667fc 1f050071 cmp      w8, #1
41066800 a1040054 b.ne     #0x41066894
41066804 35000014 b        #0x410668d8
41066808 602a40b9 ldr      w0, [x19, #0x28]
4106680c 611640b9 ldr      w1, [x19, #0x14]
41066810 14cdff97 bl       #0x41059c60
41066814 1f140071 cmp      w0, #5
41066818 00060054 b.eq     #0x410668d8
4106681c 1f100071 cmp      w0, #4
41066820 a0010054 b.eq     #0x41066854
41066824 1f0c0071 cmp      w0, #3
41066828 c1000054 b.ne     #0x41066840
4106682c 682e40b9 ldr      w8, [x19, #0x2c]
41066830 1f010071 cmp      w8, #0
41066834 e80b0032 mov      w8, #7
41066838 00019f1a csel     w0, w8, wzr, eq
4106683c 02000014 b        #0x41066844
41066840 60018052 mov      w0, #0xb
41066844 f37bc1a8 ldp      x19, x30, [sp], #0x10
41066848 c0035fd6 ret
4106684c e0071f32 mov      w0, #6
41066850 fdffff17 b        #0x41066844
41066854 e00b0032 mov      w0, #7
41066858 fbffff17 b        #0x41066844
4106685c a0008052 mov      w0, #5
41066860 f9ffff17 b        #0x41066844
41066864 683640b9 ldr      w8, [x19, #0x34]
41066868 691e40b9 ldr      w9, [x19, #0x1c]
4106686c 08010034 cbz      w8, #0x4106688c
41066870 3f050071 cmp      w9, #1
41066874 a0000054 b.eq     #0x41066888
41066878 3f090071 cmp      w9, #2
4106687c 81000054 b.ne     #0x4106688c
41066880 e9070032 mov      w9, #3
41066884 02000014 b        #0x4106688c
41066888 e9031f32 mov      w9, #2
4106688c 6a924039 ldrb     w10, [x19, #0x24]
41066890 6a000034 cbz      w10, #0x4106689c
41066894 e0031d32 mov      w0, #8
41066898 ebffff17 b        #0x41066844
4106689c 3f0d0071 cmp      w9, #3
410668a0 c0010054 b.eq     #0x410668d8
410668a4 3f090071 cmp      w9, #2
410668a8 61ffff54 b.ne     #0x41066894
410668ac 691a40b9 ldr      w9, [x19, #0x18]
410668b0 2a110051 sub      w10, w9, #4
410668b4 5f0d0071 cmp      w10, #3
410668b8 e3000054 b.lo     #0x410668d4
410668bc 29090051 sub      w9, w9, #2
410668c0 3f050071 cmp      w9, #1
410668c4 88feff54 b.hi     #0x41066894
410668c8 693240b9 ldr      w9, [x19, #0x30]
410668cc 3f050071 cmp      w9, #1
410668d0 21feff54 b.ne     #0x41066894
410668d4 08feff35 cbnz     w8, #0x41066894
410668d8 e0031e32 mov      w0, #4
410668dc daffff17 b        #0x41066844

; sensor_request_producer_excerpt [0x41031da0, 0x41031e18); SHA-256 d2b8c5785232f8667530ccd8493767abc8208985ba5af8e521ef4c95585e8d7f
41031da0 ff8301d1 sub      sp, sp, #0x60
41031da4 f75b03a9 stp      x23, x22, [sp, #0x30]
41031da8 f55304a9 stp      x21, x20, [sp, #0x40]
41031dac f37b05a9 stp      x19, x30, [sp, #0x50]
41031db0 f40300aa mov      x20, x0
41031db4 ff2b00b9 str      wzr, [sp, #0x28]
41031db8 f30304aa mov      x19, x4
41031dbc f703032a mov      w23, w3
41031dc0 880a40b9 ldr      w8, [x20, #8]
41031dc4 f503022a mov      w21, w2
41031dc8 f603012a mov      w22, w1
41031dcc ff1300f9 str      xzr, [sp, #0x20]
41031dd0 ff1b00b9 str      wzr, [sp, #0x18]
41031dd4 680200b9 str      w8, [x19]
41031dd8 f00f0094 bl       #0x41035d98
41031ddc 600600b9 str      w0, [x19, #4]
41031de0 e00314aa mov      x0, x20
41031de4 888e43b9 ldr      w8, [x20, #0x38c]
41031de8 680a00b9 str      w8, [x19, #8]
41031dec 31100094 bl       #0x41035eb0
41031df0 600e00b9 str      w0, [x19, #0xc]
41031df4 e00314aa mov      x0, x20
41031df8 1c100094 bl       #0x41035e68
41031dfc 601200b9 str      w0, [x19, #0x10]
41031e00 bf2a0071 cmp      w21, #0xa
41031e04 88c243b9 ldr      w8, [x20, #0x3c0]
41031e08 681600b9 str      w8, [x19, #0x14]
41031e0c 41000054 b.ne     #0x41031e14
41031e10 95b643b9 ldr      w21, [x20, #0x3b4]
41031e14 751a00b9 str      w21, [x19, #0x18]

; sensor_request_producer_call_excerpt [0x41035168, 0x410351fc); SHA-256 4be06c5f9b298717a54a17072231147ee8a0e5eb652f48c4d305b85cbbe8733e
41035168 684240f9 ldr      x8, [x19, #0x80]
4103516c 098d47b8 ldr      w9, [x8, #0x78]!
41035170 0aad7329 ldp      w10, w11, [x8, #-0x64]
41035174 0cb97429 ldp      w12, w14, [x8, #-0x5c]
41035178 0fc15ab8 ldur     w15, [x8, #-0x54]
4103517c ebb30c29 stp      w11, w12, [sp, #0x64]
41035180 0b357229 ldp      w11, w13, [x8, #-0x70]
41035184 0c414129 ldp      w12, w16, [x8, #8]
41035188 ebb70d29 stp      w11, w13, [sp, #0x6c]
4103518c 0d8159b8 ldur     w13, [x8, #-0x68]
41035190 0c7e60b3 bfi      x12, x16, #0x20, #0x20
41035194 eebf0f29 stp      w14, w15, [sp, #0x7c]
41035198 ec0700f9 str      x12, [sp, #8]
4103519c edab0e29 stp      w13, w10, [sp, #0x74]
410351a0 0a0540b9 ldr      w10, [x8, #4]
410351a4 497d60b3 bfi      x9, x10, #0x20, #0x20
410351a8 e90300f9 str      x9, [sp]
410351ac e9830191 add      x9, sp, #0x60
410351b0 e003c03d ldr      q0, [sp]
410351b4 2b910091 add      x11, x9, #0x24
410351b8 24d10091 add      x4, x9, #0x34
410351bc e007803d str      q0, [sp, #0x10]
410351c0 ea0b40f9 ldr      x10, [sp, #0x10]
410351c4 6a8500b8 str      w10, [x11], #8
410351c8 ec0f40f9 ldr      x12, [sp, #0x18]
410351cc 0d514039 ldrb     w13, [x8, #0x14]
410351d0 6e224039 ldrb     w14, [x19, #8]
410351d4 8ffd60d3 lsr      x15, x12, #0x20
410351d8 6c3d0029 stp      w12, w15, [x11]
410351dc 610e40b9 ldr      w1, [x19, #0xc]
410351e0 021140b9 ldr      w2, [x8, #0x10]
410351e4 48fd60d3 lsr      x8, x10, #0x20
410351e8 637e40b9 ldr      w3, [x19, #0x7c]
410351ec edc30239 strb     w13, [sp, #0xb0]
410351f0 e88b00b9 str      w8, [sp, #0x88]
410351f4 ee830139 strb     w14, [sp, #0x60]
410351f8 eaf2ff97 bl       #0x41031da0

; sensor_request_forward_excerpt [0x410352cc, 0x410352d4); SHA-256 8c67ca53a005323b2e11253e55da7d0c1240088797fbbddf1b7af16e5a822ec3
410352cc e0830191 add      x0, sp, #0x60
410352d0 8e63fc97 bl       #0x40f4e108

; sensor_service_wrapper_excerpt [0x40f4e108, 0x40f4e15c); SHA-256 c1ff612a459b54ecbe3c0b61fb6dfb08736069400a937022d5ccc803522ea69e
40f4e108 ff0301d1 sub      sp, sp, #0x40
40f4e10c f55302a9 stp      x21, x20, [sp, #0x20]
40f4e110 f37b03a9 stp      x19, x30, [sp, #0x30]
40f4e114 f30300aa mov      x19, x0
40f4e118 ff7f01a9 stp      xzr, xzr, [sp, #0x10]
40f4e11c e00b1f32 mov      w0, #0xe
40f4e120 ff0700f9 str      xzr, [sp, #8]
40f4e124 0e710094 bl       #0x40f6a55c
40f4e128 74420291 add      x20, x19, #0x90
40f4e12c 61520091 add      x1, x19, #0x14
40f4e130 e2030032 mov      w2, #1
40f4e134 e00314aa mov      x0, x20
40f4e138 35000094 bl       #0x40f4e20c
40f4e13c 603a40b9 ldr      w0, [x19, #0x38]
40f4e140 76720094 bl       #0x40f6ab18
40f4e144 685a40b9 ldr      w8, [x19, #0x58]
40f4e148 e0430091 add      x0, sp, #0x10
40f4e14c e1230091 add      x1, sp, #8
40f4e150 f30b00f9 str      x19, [sp, #0x10]
40f4e154 e81b00b9 str      w8, [sp, #0x18]
40f4e158 a0370094 bl       #0x40f5bfd8

; sensor_service_request_adapter_excerpt [0x40f5c18c, 0x40f5c22c); SHA-256 0bebea36cf82987811bfb66e1b52d65413b1ad7a756508c416136c37d60a9288
40f5c18c 880240f9 ldr      x8, [x20]
40f5c190 0aa54629 ldp      w10, w9, [x8, #0x34]
40f5c194 29050051 sub      w9, w9, #1
40f5c198 eab700b9 str      w10, [sp, #0xb4]
40f5c19c 3f1d0071 cmp      w9, #7
40f5c1a0 e8000054 b.hi     #0x40f5c1bc
40f5c1a4 0a2e94d2 mov      x10, #0xa170
40f5c1a8 aa53a0f2 movk     x10, #0x29d, lsl #16
40f5c1ac 4a01c0f2 movk     x10, #0xa, lsl #32
40f5c1b0 0a00e0f2 movk     x10, #0, lsl #48
40f5c1b4 49d969b8 ldr      w9, [x10, w9, sxtw #2]
40f5c1b8 02000014 b        #0x40f5c1c0
40f5c1bc e9031f2a mov      w9, wzr
40f5c1c0 0a5540b9 ldr      w10, [x8, #0x54]
40f5c1c4 0b4140b9 ldr      w11, [x8, #0x40]
40f5c1c8 0c4d40b9 ldr      w12, [x8, #0x4c]
40f5c1cc 0d414139 ldrb     w13, [x8, #0x50]
40f5c1d0 ea3301b9 str      w10, [sp, #0x130]
40f5c1d4 0ea94829 ldp      w14, w10, [x8, #0x44]
40f5c1d8 0f3d40b9 ldr      w15, [x8, #0x3c]
40f5c1dc e9b300b9 str      w9, [sp, #0xb0]
40f5c1e0 5f050071 cmp      w10, #1
40f5c1e4 eb331729 stp      w11, w12, [sp, #0xb8]
40f5c1e8 ea179f1a cset     w10, eq
40f5c1ec ed030339 strb     w13, [sp, #0xc0]
40f5c1f0 e9050051 sub      w9, w15, #1
40f5c1f4 3f150071 cmp      w9, #5
40f5c1f8 eeab1829 stp      w14, w10, [sp, #0xc4]
40f5c1fc e8000054 b.hi     #0x40f5c218
40f5c200 0ada91d2 mov      x10, #0x8ed0
40f5c204 aa53a0f2 movk     x10, #0x29d, lsl #16
40f5c208 4a01c0f2 movk     x10, #0xa, lsl #32
40f5c20c 0a00e0f2 movk     x10, #0, lsl #48
40f5c210 49d969b8 ldr      w9, [x10, w9, sxtw #2]
40f5c214 02000014 b        #0x40f5c21c
40f5c218 e9031f2a mov      w9, wzr
40f5c21c 8a0a40b9 ldr      w10, [x20, #8]
40f5c220 e0031f32 mov      w0, #2
40f5c224 e1430191 add      x1, sp, #0x50
40f5c228 e9ab1929 stp      w9, w10, [sp, #0xcc]

; backend_mode_store_excerpt [0x41158878, 0x411588fc); SHA-256 107a39aace46ce0598310e042a7a2c897e407c04a7149c9c7a914a9c6eaf80e6
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

; request_kind_and_auxiliary_selectors [0x41035d98, 0x41035ee0); SHA-256 81ff88433eec0af6763eeb8d86cfa7b3e3dc8bc7ac7c80533ce810a8e2525a32
41035d98 080440b9 ldr      w8, [x0, #4]
41035d9c 1f050071 cmp      w8, #1
41035da0 61000054 b.ne     #0x41035dac
41035da4 e8031f32 mov      w8, #2
41035da8 29000014 b        #0x41035e4c
41035dac 08fc41b9 ldr      w8, [x0, #0x1fc]
41035db0 88000034 cbz      w8, #0x41035dc0
41035db4 08a048b9 ldr      w8, [x0, #0x8a0]
41035db8 1f0d0071 cmp      w8, #3
41035dbc 01020054 b.ne     #0x41035dfc
41035dc0 080040b9 ldr      w8, [x0]
41035dc4 1f110071 cmp      w8, #4
41035dc8 e8010054 b.hi     #0x41035e04
41035dcc 096996d2 mov      x9, #0xb348
41035dd0 8953a0f2 movk     x9, #0x29c, lsl #16
41035dd4 4901c0f2 movk     x9, #0xa, lsl #32
41035dd8 0900e0f2 movk     x9, #0, lsl #48
41035ddc 297968f8 ldr      x9, [x9, x8, lsl #3]
41035de0 a8008052 mov      w8, #5
41035de4 20011fd6 br       x9
41035de8 081040b9 ldr      w8, [x0, #0x10]
41035dec 1f050071 cmp      w8, #1
41035df0 41020054 b.ne     #0x41035e38
41035df4 e8031e32 mov      w8, #4
41035df8 15000014 b        #0x41035e4c
41035dfc e8070032 mov      w8, #3
41035e00 13000014 b        #0x41035e4c
41035e04 fe0f1ff8 str      x30, [sp, #-0x10]!
41035e08 40018052 mov      w0, #0xa
41035e0c a1a28b52 mov      w1, #0x5d15
41035e10 e2031f2a mov      w2, wzr
41035e14 e3031f2a mov      w3, wzr
41035e18 1b36fc97 bl       #0x40f43684
41035e1c e8031f2a mov      w8, wzr
41035e20 fe0741f8 ldr      x30, [sp], #0x10
41035e24 0a000014 b        #0x41035e4c
41035e28 e8031d32 mov      w8, #8
41035e2c 08000014 b        #0x41035e4c
41035e30 e8071f32 mov      w8, #6
41035e34 06000014 b        #0x41035e4c
41035e38 08504039 ldrb     w8, [x0, #0x14]
41035e3c 68000035 cbnz     w8, #0x41035e48
41035e40 08544039 ldrb     w8, [x0, #0x15]
41035e44 88000034 cbz      w8, #0x41035e54
41035e48 e8031f2a mov      w8, wzr
41035e4c e003082a mov      w0, w8
41035e50 c0035fd6 ret
41035e54 08c04039 ldrb     w8, [x0, #0x30]
41035e58 1f010071 cmp      w8, #0
41035e5c e80b0032 mov      w8, #7
41035e60 08159f1a csinc    w8, w8, wzr, ne
41035e64 faffff17 b        #0x41035e4c
41035e68 088883b9 ldrsw    x8, [x0, #0x388]
41035e6c 1f250071 cmp      w8, #9
41035e70 e2000054 b.hs     #0x41035e8c
41035e74 09d096d2 mov      x9, #0xb680
41035e78 8953a0f2 movk     x9, #0x29c, lsl #16
41035e7c 4901c0f2 movk     x9, #0xa, lsl #32
41035e80 0900e0f2 movk     x9, #0, lsl #48
41035e84 207968b8 ldr      w0, [x9, x8, lsl #2]
41035e88 c0035fd6 ret
41035e8c fe0f1ff8 str      x30, [sp, #-0x10]!
41035e90 40018052 mov      w0, #0xa
41035e94 a1ab8b52 mov      w1, #0x5d5d
41035e98 e2031f2a mov      w2, wzr
41035e9c e3031f2a mov      w3, wzr
41035ea0 f935fc97 bl       #0x40f43684
41035ea4 e0031f2a mov      w0, wzr
41035ea8 fe0741f8 ldr      x30, [sp], #0x10
41035eac c0035fd6 ret
41035eb0 00d043b9 ldr      w0, [x0, #0x3d0]
41035eb4 1f100071 cmp      w0, #4
41035eb8 23010054 b.lo     #0x41035edc
41035ebc fe0f1ff8 str      x30, [sp, #-0x10]!
41035ec0 40018052 mov      w0, #0xa
41035ec4 01b48b52 mov      w1, #0x5da0
41035ec8 e2031f2a mov      w2, wzr
41035ecc e3031f2a mov      w3, wzr
41035ed0 ed35fc97 bl       #0x40f43684
41035ed4 e0031f2a mov      w0, wzr
41035ed8 fe0741f8 ldr      x30, [sp], #0x10
41035edc c0035fd6 ret

; sdk_effective_mode_getter [0x40841bfc, 0x40841c40); SHA-256 4333c83df865fab88de12dba21b67acd94d2769be616263c5c2964b0b0c0209a
40841bfc f40f1ef8 str      x20, [sp, #-0x20]!
40841c00 f37b01a9 stp      x19, x30, [sp, #0x10]
40841c04 c0238452 mov      w0, #0x211e
40841c08 0080a072 movk     w0, #0x400, lsl #16
40841c0c 38520094 bl       #0x408564ec
40841c10 f303002a mov      w19, w0
40841c14 202e8452 mov      w0, #0x2171
40841c18 35520094 bl       #0x408564ec
40841c1c f403002a mov      w20, w0
40841c20 002e8452 mov      w0, #0x2170
40841c24 32520094 bl       #0x408564ec
40841c28 e203002a mov      w2, w0
40841c2c e003132a mov      w0, w19
40841c30 f37b41a9 ldp      x19, x30, [sp, #0x10]
40841c34 e103142a mov      w1, w20
40841c38 f40742f8 ldr      x20, [sp], #0x20
40841c3c 5a40ff17 b        #0x40811da4

; sdk_mode_builder [0x40811da4, 0x40811e7c); SHA-256 d5e50fb886aa82413332ecfac8406c91fbfd3eec93a42bccbef2749e91912ca2
40811da4 f80f1cf8 str      x24, [sp, #-0x40]!
40811da8 f75b01a9 stp      x23, x22, [sp, #0x10]
40811dac f55302a9 stp      x21, x20, [sp, #0x20]
40811db0 f37b03a9 stp      x19, x30, [sp, #0x30]
40811db4 156c80d2 mov      x21, #0x360
40811db8 f581a8f2 movk     x21, #0x440f, lsl #16
40811dbc 1500c0f2 movk     x21, #0, lsl #32
40811dc0 1500e0f2 movk     x21, #0, lsl #48
40811dc4 f303022a mov      w19, w2
40811dc8 f403012a mov      w20, w1
40811dcc e10b0032 mov      w1, #7
40811dd0 e203002a mov      w2, w0
40811dd4 e00315aa mov      x0, x21
40811dd8 e3031f2a mov      w3, wzr
40811ddc 0619ed97 bl       #0x403581f4
40811de0 167380d2 mov      x22, #0x398
40811de4 f681a8f2 movk     x22, #0x440f, lsl #16
40811de8 1600c0f2 movk     x22, #0, lsl #32
40811dec 1600e0f2 movk     x22, #0, lsl #48
40811df0 e803002a mov      w8, w0
40811df4 e10b0032 mov      w1, #7
40811df8 e203142a mov      w2, w20
40811dfc e00316aa mov      x0, x22
40811e00 e3031f2a mov      w3, wzr
40811e04 17f17dd3 lsl      x23, x8, #3
40811e08 fb18ed97 bl       #0x403581f4
40811e0c 147a80d2 mov      x20, #0x3d0
40811e10 f481a8f2 movk     x20, #0x440f, lsl #16
40811e14 1400c0f2 movk     x20, #0, lsl #32
40811e18 1400e0f2 movk     x20, #0, lsl #48
40811e1c e803002a mov      w8, w0
40811e20 e1070032 mov      w1, #3
40811e24 e203132a mov      w2, w19
40811e28 e00314aa mov      x0, x20
40811e2c e3031f2a mov      w3, wzr
40811e30 18f17dd3 lsl      x24, x8, #3
40811e34 f018ed97 bl       #0x403581f4
40811e38 e903002a mov      w9, w0
40811e3c a86a77b8 ldr      w8, [x21, x23]
40811e40 2af17dd3 lsl      x10, x9, #3
40811e44 cb6a78b8 ldr      w11, [x22, x24]
40811e48 290500d1 sub      x9, x9, #1
40811e4c 8a6a6a38 ldrb     w10, [x20, x10]
40811e50 3f0900f1 cmp      x9, #2
40811e54 e9279f1a cset     w9, lo
40811e58 f37b43a9 ldp      x19, x30, [sp, #0x30]
40811e5c f55342a9 ldp      x21, x20, [sp, #0x20]
40811e60 f75b41a9 ldp      x23, x22, [sp, #0x10]
40811e64 087d60d3 lsl      x8, x8, #0x20
40811e68 681d70b3 bfi      x8, x11, #0x10, #8
40811e6c 00010aaa orr      x0, x8, x10
40811e70 200178b3 bfi      x0, x9, #8, #1
40811e74 f80744f8 ldr      x24, [sp], #0x40
40811e78 c0035fd6 ret

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

; capture_context_initialization_call [0x40f79348, 0x40f793a8); SHA-256 58ce77b219c95b3f3cec8f607899e3fb462022f6be3de733cf970168762ac9d2
40f79348 ff4303d1 sub      sp, sp, #0xd0
40f7934c fc6f07a9 stp      x28, x27, [sp, #0x70]
40f79350 fa6708a9 stp      x26, x25, [sp, #0x80]
40f79354 f85f09a9 stp      x24, x23, [sp, #0x90]
40f79358 f6570aa9 stp      x22, x21, [sp, #0xa0]
40f7935c f44f0ba9 stp      x20, x19, [sp, #0xb0]
40f79360 fd7b0ca9 stp      x29, x30, [sp, #0xc0]
40f79364 88da83d2 mov      x8, #0x1ed4
40f79368 8877a0f2 movk     x8, #0x3bc, lsl #16
40f7936c 4801c0f2 movk     x8, #0xa, lsl #32
40f79370 0800e0f2 movk     x8, #0, lsl #48
40f79374 f30300aa mov      x19, x0
40f79378 f503012a mov      w21, w1
40f7937c 08014039 ldrb     w8, [x8]
40f79380 41000012 and      w1, w2, #1
40f79384 68360039 strb     w8, [x19, #0xd]
40f79388 5139fd97 bl       #0x40ec78cc
40f7938c f403002a mov      w20, w0
40f79390 d4000037 tbnz     w20, #0, #0x40f793a8
40f79394 a1cd8952 mov      w1, #0x4e6d
40f79398 e0030032 mov      w0, #1
40f7939c e2031f2a mov      w2, wzr
40f793a0 e3031f2a mov      w3, wzr
40f793a4 b828ff97 bl       #0x40f43684

; capture_context_builder_read_excerpt [0x40f28488, 0x40f28590); SHA-256 acfbf6e80e15a427d0d18463bf2b7f2b7e23b403da88d38cc93b50b0c7480ad3
40f28488 fc6fbaa9 stp      x28, x27, [sp, #-0x60]!
40f2848c fa6701a9 stp      x26, x25, [sp, #0x10]
40f28490 f85f02a9 stp      x24, x23, [sp, #0x20]
40f28494 f65703a9 stp      x22, x21, [sp, #0x30]
40f28498 f44f04a9 stp      x20, x19, [sp, #0x40]
40f2849c fd7b05a9 stp      x29, x30, [sp, #0x50]
40f284a0 ffc30cd1 sub      sp, sp, #0x330
40f284a4 f30300aa mov      x19, x0
40f284a8 b35c01b4 cbz      x19, #0x40f2b03c
40f284ac 15208052 mov      w21, #0x100
40f284b0 1500a872 movk     w21, #0x4000, lsl #16
40f284b4 01010036 tbz      w1, #0, #0x40f284d4
40f284b8 007a8dd2 mov      x0, #0x6bd0
40f284bc 6077a0f2 movk     x0, #0x3bb, lsl #16
40f284c0 4001c0f2 movk     x0, #0xa, lsl #32
40f284c4 0000e0f2 movk     x0, #0, lsl #48
40f284c8 6b10f897 bl       #0x40d2c674
40f284cc fc03002a mov      w28, w0
40f284d0 5a000014 b        #0x40f28638
40f284d4 140e8ed2 mov      x20, #0x7070
40f284d8 f7d282d2 mov      x23, #0x1697
40f284dc 00e597d2 mov      x0, #0xbf28
40f284e0 7477a0f2 movk     x20, #0x3bb, lsl #16
40f284e4 d754a0f2 movk     x23, #0x2a6, lsl #16
40f284e8 8054a0f2 movk     x0, #0x2a4, lsl #16
40f284ec 5401c0f2 movk     x20, #0xa, lsl #32
40f284f0 5701c0f2 movk     x23, #0xa, lsl #32
40f284f4 4001c0f2 movk     x0, #0xa, lsl #32
40f284f8 1400e0f2 movk     x20, #0, lsl #48
40f284fc 1700e0f2 movk     x23, #0, lsl #48
40f28500 0000e0f2 movk     x0, #0, lsl #48
40f28504 c2218052 mov      w2, #0x10e
40f28508 04598952 mov      w4, #0x4ac8
40f2850c e10314aa mov      x1, x20
40f28510 e30317aa mov      x3, x23
40f28514 f7a90394 bl       #0x41012cf0
40f28518 f603002a mov      w22, w0
40f2851c 00ae94d2 mov      x0, #0xa570
40f28520 81008ed2 mov      x1, #0x7004
40f28524 4052a0f2 movk     x0, #0x292, lsl #16
40f28528 6177a0f2 movk     x1, #0x3bb, lsl #16
40f2852c 4001c0f2 movk     x0, #0xa, lsl #32
40f28530 4101c0f2 movk     x1, #0xa, lsl #32
40f28534 0000e0f2 movk     x0, #0, lsl #48
40f28538 0100e0f2 movk     x1, #0, lsl #48
40f2853c 62038052 mov      w2, #0x1b
40f28540 e4598952 mov      w4, #0x4acf
40f28544 e30317aa mov      x3, x23
40f28548 eaa90394 bl       #0x41012cf0
40f2854c 016c98d2 mov      x1, #0xc360
40f28550 8154a0f2 movk     x1, #0x2a4, lsl #16
40f28554 4101c0f2 movk     x1, #0xa, lsl #32
40f28558 f703002a mov      w23, w0
40f2855c 0100e0f2 movk     x1, #0, lsl #48
40f28560 82058052 mov      w2, #0x2c
40f28564 e0430891 add      x0, sp, #0x210
40f28568 e6480d94 bl       #0x4127a900
40f2856c 60018052 mov      w0, #0xb
40f28570 ffc301b9 str      wzr, [sp, #0x1c0]
40f28574 e1430891 add      x1, sp, #0x210
40f28578 ff7f1ba9 stp      xzr, xzr, [sp, #0x1b0]
40f2857c e2630691 add      x2, sp, #0x198
40f28580 ff7f1aa9 stp      xzr, xzr, [sp, #0x1a0]
40f28584 ffcf00f9 str      xzr, [sp, #0x198]
40f28588 f8630691 add      x24, sp, #0x198
40f2858c 33ecff97 bl       #0x40f23658

; capture_context_cache_transfer_excerpt [0x40f28590, 0x40f28620); SHA-256 7a791b7c10f6836fe3bde2afca6e9ccec7f1b5268c41c5a2f5d59d013339c4f8
40f28590 e8cf40f9 ldr      x8, [sp, #0x198]
40f28594 0a330091 add      x10, x24, #0xc
40f28598 e9a341b9 ldr      w9, [sp, #0x1a0]
40f2859c 007a8dd2 mov      x0, #0x6bd0
40f285a0 ebab41b9 ldr      w11, [sp, #0x1a8]
40f285a4 6077a0f2 movk     x0, #0x3bb, lsl #16
40f285a8 4001c0f2 movk     x0, #0xa, lsl #32
40f285ac 887e01b9 str      w8, [x20, #0x17c]
40f285b0 08fd60d3 lsr      x8, x8, #0x20
40f285b4 894e02b9 str      w9, [x20, #0x24c]
40f285b8 0000e0f2 movk     x0, #0, lsl #48
40f285bc 888201b9 str      w8, [x20, #0x180]
40f285c0 488540b8 ldr      w8, [x10], #8
40f285c4 687d60b3 bfi      x8, x11, #0x20, #0x20
40f285c8 ebdf40f9 ldr      x11, [sp, #0x1b8]
40f285cc e8bb00f9 str      x8, [sp, #0x170]
40f285d0 48254029 ldp      w8, w9, [x10]
40f285d4 eab741b9 ldr      w10, [sp, #0x1b4]
40f285d8 287d60b3 bfi      x8, x9, #0x20, #0x20
40f285dc 89a20591 add      x9, x20, #0x168
40f285e0 e8bf00f9 str      x8, [sp, #0x178]
40f285e4 e05fc03d ldr      q0, [sp, #0x170]
40f285e8 e063803d str      q0, [sp, #0x180]
40f285ec e8c340f9 ldr      x8, [sp, #0x180]
40f285f0 288500b8 str      w8, [x9], #8
40f285f4 ecc740f9 ldr      x12, [sp, #0x188]
40f285f8 08fd60d3 lsr      x8, x8, #0x20
40f285fc 8a4203b9 str      w10, [x20, #0x340]
40f28600 6afd60d3 lsr      x10, x11, #0x20
40f28604 886e01b9 str      w8, [x20, #0x16c]
40f28608 e8c341b9 ldr      w8, [sp, #0x1c0]
40f2860c 8afe03b9 str      w10, [x20, #0x3fc]
40f28610 8afd60d3 lsr      x10, x12, #0x20
40f28614 8bfa03b9 str      w11, [x20, #0x3f8]
40f28618 2c290029 stp      w12, w10, [x9]
40f2861c 880204b9 str      w8, [x20, #0x400]

; capture_context_kind_excerpt [0x40f28638, 0x40f28688); SHA-256 cfe99146480b9d98aaefac52c5090b07402ee511d6e88e68f37bab9822c4f9be
40f28638 1d0e8ed2 mov      x29, #0x7070
40f2863c 7d77a0f2 movk     x29, #0x3bb, lsl #16
40f28640 5d01c0f2 movk     x29, #0xa, lsl #32
40f28644 1d00e0f2 movk     x29, #0, lsl #48
40f28648 a87f41b9 ldr      w8, [x29, #0x17c]
40f2864c 68000034 cbz      w8, #0x40f28658
40f28650 e8030032 mov      w8, #1
40f28654 0b000014 b        #0x40f28680
40f28658 a86b42b9 ldr      w8, [x29, #0x268]
40f2865c 1f050071 cmp      w8, #1
40f28660 e1000054 b.ne     #0x40f2867c
40f28664 a86f42b9 ldr      w8, [x29, #0x26c]
40f28668 080d0051 sub      w8, w8, #3
40f2866c 1f110071 cmp      w8, #4
40f28670 62000054 b.hs     #0x40f2867c
40f28674 e8070032 mov      w8, #3
40f28678 02000014 b        #0x40f28680
40f2867c e8031f2a mov      w8, wzr
40f28680 a0420811 add      w0, w21, #0x210
40f28684 680200b9 str      w8, [x19]

; capture_context_video_fields_excerpt [0x40f2888c, 0x40f288f4); SHA-256 7029f118d2255cee7aee7d7cd24aacd1bacdcff676c01f15067ef307991d1bdb
40f2888c a88341b9 ldr      w8, [x29, #0x180]
40f28890 aaa30591 add      x10, x29, #0x168
40f28894 a96f41b9 ldr      w9, [x29, #0x16c]
40f28898 688a03b9 str      w8, [x19, #0x388]
40f2889c 08090051 sub      w8, w8, #2
40f288a0 1f190071 cmp      w8, #6
40f288a4 4b8540b8 ldr      w11, [x10], #8
40f288a8 2b7d60b3 bfi      x11, x9, #0x20, #0x20
40f288ac ebab00f9 str      x11, [sp, #0x150]
40f288b0 49294029 ldp      w9, w10, [x10]
40f288b4 497d60b3 bfi      x9, x10, #0x20, #0x20
40f288b8 6a320e91 add      x10, x19, #0x38c
40f288bc e9af00f9 str      x9, [sp, #0x158]
40f288c0 e057c03d ldr      q0, [sp, #0x150]
40f288c4 e05b803d str      q0, [sp, #0x160]
40f288c8 e9b340f9 ldr      x9, [sp, #0x160]
40f288cc ab4343b9 ldr      w11, [x29, #0x340]
40f288d0 498500b8 str      w9, [x10], #8
40f288d4 ecb740f9 ldr      x12, [sp, #0x168]
40f288d8 29fd60d3 lsr      x9, x9, #0x20
40f288dc 6b9e03b9 str      w11, [x19, #0x39c]
40f288e0 ab7b41b9 ldr      w11, [x29, #0x178]
40f288e4 699203b9 str      w9, [x19, #0x390]
40f288e8 89fd60d3 lsr      x9, x12, #0x20
40f288ec 4c250029 stp      w12, w9, [x10]
40f288f0 6bda03b9 str      w11, [x19, #0x3d8]

; capture_context_auxiliary_fields_excerpt [0x40f28960, 0x40f28980); SHA-256 40a38f6878d94360d5436e8b643910467060b8dc1b396f6c0d9b7a12f67b0a43
40f28960 a8ff43b9 ldr      w8, [x29, #0x3fc]
40f28964 a9fb43b9 ldr      w9, [x29, #0x3f8]
40f28968 68a603b9 str      w8, [x19, #0x3a4]
40f2896c 69a203b9 str      w9, [x19, #0x3a0]
40f28970 a80344b9 ldr      w8, [x29, #0x400]
40f28974 a97f41b9 ldr      w9, [x29, #0x17c]
40f28978 68aa03b9 str      w8, [x19, #0x3a8]
40f2897c ea1302b9 str      w10, [sp, #0x210]

; effective_format_fields_callback [0x40f1ae50, 0x40f1b168); SHA-256 cbf18430a537cea63cf72194b97685cadcabaf2aec8d6ac480811fbbe0c10e79
40f1ae50 ff8302d1 sub      sp, sp, #0xa0
40f1ae54 fc6f04a9 stp      x28, x27, [sp, #0x40]
40f1ae58 fa6705a9 stp      x26, x25, [sp, #0x50]
40f1ae5c f85f06a9 stp      x24, x23, [sp, #0x60]
40f1ae60 f65707a9 stp      x22, x21, [sp, #0x70]
40f1ae64 f44f08a9 stp      x20, x19, [sp, #0x80]
40f1ae68 fd7b09a9 stp      x29, x30, [sp, #0x90]
40f1ae6c 8b2b92d2 mov      x11, #0x915c
40f1ae70 2b77a0f2 movk     x11, #0x3b9, lsl #16
40f1ae74 4b01c0f2 movk     x11, #0xa, lsl #32
40f1ae78 0b00e0f2 movk     x11, #0, lsl #48
40f1ae7c 4c628452 mov      w12, #0x2312
40f1ae80 2d0d8552 mov      w13, #0x2869
40f1ae84 0aae90d2 mov      x10, #0x8570
40f1ae88 7c1140b9 ldr      w28, [x11, #0x10]
40f1ae8c 4b0d8552 mov      w11, #0x286a
40f1ae90 ed330429 stp      w13, w12, [sp, #0x20]
40f1ae94 6c0d8552 mov      w12, #0x286b
40f1ae98 2a77a0f2 movk     x10, #0x3b9, lsl #16
40f1ae9c 4a01c0f2 movk     x10, #0xa, lsl #32
40f1aea0 0a00e0f2 movk     x10, #0, lsl #48
40f1aea4 ec2f0329 stp      w12, w11, [sp, #0x18]
40f1aea8 0d0e8552 mov      w13, #0x2870
40f1aeac 2b0e8552 mov      w11, #0x2871
40f1aeb0 540140b9 ldr      w20, [x10]
40f1aeb4 f30301aa mov      x19, x1
40f1aeb8 55014bb9 ldr      w21, [x10, #0xb00]
40f1aebc 56054bb9 ldr      w22, [x10, #0xb04]
40f1aec0 57094bb9 ldr      w23, [x10, #0xb08]
40f1aec4 48755229 ldp      w8, w29, [x10, #0x90]
40f1aec8 4f0d4bb9 ldr      w15, [x10, #0xb0c]
40f1aecc 4e114bb9 ldr      w14, [x10, #0xb10]
40f1aed0 49fd4ab9 ldr      w9, [x10, #0xafc]
40f1aed4 eb370229 stp      w11, w13, [sp, #0x10]
40f1aed8 4c9d40b9 ldr      w12, [x10, #0x9c]
40f1aedc 4db940b9 ldr      w13, [x10, #0xb8]
40f1aee0 4ba940b9 ldr      w11, [x10, #0xa8]
40f1aee4 f5230729 stp      w21, w8, [sp, #0x38]
40f1aee8 f75b0629 stp      w23, w22, [sp, #0x30]
40f1aeec ee3f0529 stp      w14, w15, [sp, #0x28]
40f1aef0 3c013836 tbz      w28, #7, #0x40f1af14
40f1aef4 bf070071 cmp      w29, #1
40f1aef8 e1000054 b.ne     #0x40f1af14
40f1aefc 48d10291 add      x8, x10, #0xb4
40f1af00 4a610291 add      x10, x10, #0x98
40f1af04 7f050071 cmp      w11, #1
40f1af08 08018a9a csel     x8, x8, x10, eq
40f1af0c 080140b9 ldr      w8, [x8]
40f1af10 05000014 b        #0x40f1af24
40f1af14 9f071b72 tst      w28, #0x60
40f1af18 60000054 b.eq     #0x40f1af24
40f1af1c 7f050071 cmp      w11, #1
40f1af20 a8018c1a csel     w8, w13, w12, eq
40f1af24 0a050051 sub      w10, w8, #1
40f1af28 e83f00b9 str      w8, [sp, #0x3c]
40f1af2c 5f150071 cmp      w10, #5
40f1af30 ef3b0129 stp      w15, w14, [sp, #8]
40f1af34 f70700b9 str      w23, [sp, #4]
40f1af38 08020054 b.hi     #0x40f1af78
40f1af3c 0bb38fd2 mov      x11, #0x7d98
40f1af40 4b54a0f2 movk     x11, #0x2a2, lsl #16
40f1af44 4b01c0f2 movk     x11, #0xa, lsl #32
40f1af48 0b00e0f2 movk     x11, #0, lsl #48
40f1af4c 6a796af8 ldr      x10, [x11, x10, lsl #3]
40f1af50 40011fd6 br       x10
40f1af54 f80b0032 mov      w24, #7
40f1af58 ff2b00b9 str      wzr, [sp, #0x28]
40f1af5c fb030032 mov      w27, #1
40f1af60 fa031f2a mov      w26, wzr
40f1af64 f7031f2a mov      w23, wzr
40f1af68 f8ff0629 stp      w24, wzr, [sp, #0x34]
40f1af6c fbff0529 stp      w27, wzr, [sp, #0x2c]
40f1af70 f9031f2a mov      w25, wzr
40f1af74 31000014 b        #0x40f1b038
40f1af78 fa030e2a mov      w26, w14
40f1af7c fb030f2a mov      w27, w15
40f1af80 f803162a mov      w24, w22
40f1af84 f903152a mov      w25, w21
40f1af88 2c000014 b        #0x40f1b038
40f1af8c fa030032 mov      w26, #1
40f1af90 ff2f00b9 str      wzr, [sp, #0x2c]
40f1af94 b8008052 mov      w24, #5
40f1af98 fb031f2a mov      w27, wzr
40f1af9c f7031f2a mov      w23, wzr
40f1afa0 fa3b00b9 str      w26, [sp, #0x38]
40f1afa4 f9030032 mov      w25, #1
40f1afa8 ff630629 stp      wzr, w24, [sp, #0x30]
40f1afac 22000014 b        #0x40f1b034
40f1afb0 fb031f2a mov      w27, wzr
40f1afb4 ff2f00b9 str      wzr, [sp, #0x2c]
40f1afb8 fa030032 mov      w26, #1
40f1afbc b8008052 mov      w24, #5
40f1afc0 f7030032 mov      w23, #1
40f1afc4 f9030032 mov      w25, #1
40f1afc8 fa3b00b9 str      w26, [sp, #0x38]
40f1afcc 08000014 b        #0x40f1afec
40f1afd0 f9031f32 mov      w25, #2
40f1afd4 ff2f00b9 str      wzr, [sp, #0x2c]
40f1afd8 fb031f2a mov      w27, wzr
40f1afdc b8008052 mov      w24, #5
40f1afe0 fa030032 mov      w26, #1
40f1afe4 f93b00b9 str      w25, [sp, #0x38]
40f1afe8 f7030032 mov      w23, #1
40f1afec fa630629 stp      w26, w24, [sp, #0x30]
40f1aff0 11000014 b        #0x40f1b034
40f1aff4 f7070032 mov      w23, #3
40f1aff8 ff2f00b9 str      wzr, [sp, #0x2c]
40f1affc fb031f2a mov      w27, wzr
40f1b000 b8008052 mov      w24, #5
40f1b004 fa030032 mov      w26, #1
40f1b008 f73b00b9 str      w23, [sp, #0x38]
40f1b00c f9070032 mov      w25, #3
40f1b010 08000014 b        #0x40f1b030
40f1b014 fb031f2a mov      w27, wzr
40f1b018 ff2f00b9 str      wzr, [sp, #0x2c]
40f1b01c f9031e32 mov      w25, #4
40f1b020 f8071f32 mov      w24, #6
40f1b024 f7070032 mov      w23, #3
40f1b028 fa030032 mov      w26, #1
40f1b02c f93b00b9 str      w25, [sp, #0x38]
40f1b030 f7630629 stp      w23, w24, [sp, #0x30]
40f1b034 fa2b00b9 str      w26, [sp, #0x28]
40f1b038 9f060071 cmp      w20, #1
40f1b03c a1000054 b.ne     #0x40f1b050
40f1b040 3f01086b cmp      w9, w8
40f1b044 61000054 b.ne     #0x40f1b050
40f1b048 e0030032 mov      w0, #1
40f1b04c 06000014 b        #0x40f1b064
40f1b050 e0030032 mov      w0, #1
40f1b054 e1930091 add      x1, sp, #0x24
40f1b058 e2f30091 add      x2, sp, #0x3c
40f1b05c e30313aa mov      x3, x19
40f1b060 71e3fe97 bl       #0x40ed3e24
40f1b064 bf070071 cmp      w29, #1
40f1b068 e8179f1a cset     w8, eq
40f1b06c 7c002837 tbnz     w28, #5, #0x40f1b078
40f1b070 081d5c0a and      w8, w8, w28, lsr #7
40f1b074 88000034 cbz      w8, #0x40f1b084
40f1b078 fa031f2a mov      w26, wzr
40f1b07c ff7f0529 stp      wzr, wzr, [sp, #0x28]
40f1b080 fb031f2a mov      w27, wzr
40f1b084 9f060071 cmp      w20, #1
40f1b088 61000054 b.ne     #0x40f1b094
40f1b08c bf02196b cmp      w21, w25
40f1b090 c0000054 b.eq     #0x40f1b0a8
40f1b094 e0030032 mov      w0, #1
40f1b098 e1830091 add      x1, sp, #0x20
40f1b09c e2e30091 add      x2, sp, #0x38
40f1b0a0 e30313aa mov      x3, x19
40f1b0a4 60e3fe97 bl       #0x40ed3e24
40f1b0a8 9f060071 cmp      w20, #1
40f1b0ac 61000054 b.ne     #0x40f1b0b8
40f1b0b0 df02186b cmp      w22, w24
40f1b0b4 c0000054 b.eq     #0x40f1b0cc
40f1b0b8 e0030032 mov      w0, #1
40f1b0bc e1730091 add      x1, sp, #0x1c
40f1b0c0 e2d30091 add      x2, sp, #0x34
40f1b0c4 e30313aa mov      x3, x19
40f1b0c8 57e3fe97 bl       #0x40ed3e24
40f1b0cc 9f060071 cmp      w20, #1
40f1b0d0 81000054 b.ne     #0x40f1b0e0
40f1b0d4 e80740b9 ldr      w8, [sp, #4]
40f1b0d8 1f01176b cmp      w8, w23
40f1b0dc c0000054 b.eq     #0x40f1b0f4
40f1b0e0 e0030032 mov      w0, #1
40f1b0e4 e1630091 add      x1, sp, #0x18
40f1b0e8 e2c30091 add      x2, sp, #0x30
40f1b0ec e30313aa mov      x3, x19
40f1b0f0 4de3fe97 bl       #0x40ed3e24
40f1b0f4 9f060071 cmp      w20, #1
40f1b0f8 81000054 b.ne     #0x40f1b108
40f1b0fc e80b40b9 ldr      w8, [sp, #8]
40f1b100 1f011b6b cmp      w8, w27
40f1b104 c0000054 b.eq     #0x40f1b11c
40f1b108 e0030032 mov      w0, #1
40f1b10c e1530091 add      x1, sp, #0x14
40f1b110 e2b30091 add      x2, sp, #0x2c
40f1b114 e30313aa mov      x3, x19
40f1b118 43e3fe97 bl       #0x40ed3e24
40f1b11c 9f060071 cmp      w20, #1
40f1b120 81000054 b.ne     #0x40f1b130
40f1b124 e80f40b9 ldr      w8, [sp, #0xc]
40f1b128 1f011a6b cmp      w8, w26
40f1b12c c0000054 b.eq     #0x40f1b144
40f1b130 e0030032 mov      w0, #1
40f1b134 e1430091 add      x1, sp, #0x10
40f1b138 e2a30091 add      x2, sp, #0x28
40f1b13c e30313aa mov      x3, x19
40f1b140 39e3fe97 bl       #0x40ed3e24
40f1b144 fd7b49a9 ldp      x29, x30, [sp, #0x90]
40f1b148 f44f48a9 ldp      x20, x19, [sp, #0x80]
40f1b14c f65747a9 ldp      x22, x21, [sp, #0x70]
40f1b150 f85f46a9 ldp      x24, x23, [sp, #0x60]
40f1b154 fa6745a9 ldp      x26, x25, [sp, #0x50]
40f1b158 fc6f44a9 ldp      x28, x27, [sp, #0x40]
40f1b15c 00000012 and      w0, w0, #1
40f1b160 ff830291 add      sp, sp, #0xa0
40f1b164 c0035fd6 ret

; effective_rate_callback [0x40ee02bc, 0x40ee0560); SHA-256 8284b8eec8c291bcaed48bcb22f2041379fd2758be03680b6747135cde7370da
40ee02bc ff0301d1 sub      sp, sp, #0x40
40ee02c0 f60b00f9 str      x22, [sp, #0x10]
40ee02c4 f55302a9 stp      x21, x20, [sp, #0x20]
40ee02c8 f37b03a9 stp      x19, x30, [sp, #0x30]
40ee02cc 08ae90d2 mov      x8, #0x8570
40ee02d0 ff0b00b9 str      wzr, [sp, #8]
40ee02d4 2877a0f2 movk     x8, #0x3b9, lsl #16
40ee02d8 8a2b92d2 mov      x10, #0x915c
40ee02dc 4801c0f2 movk     x8, #0xa, lsl #32
40ee02e0 0800e0f2 movk     x8, #0, lsl #48
40ee02e4 2a77a0f2 movk     x10, #0x3b9, lsl #16
40ee02e8 4a01c0f2 movk     x10, #0xa, lsl #32
40ee02ec 0a00e0f2 movk     x10, #0, lsl #48
40ee02f0 0c9540b9 ldr      w12, [x8, #0x94]
40ee02f4 0d5542b9 ldr      w13, [x8, #0x254]
40ee02f8 0e248452 mov      w14, #0x2120
40ee02fc 0e80a072 movk     w14, #0x400, lsl #16
40ee0300 140140b9 ldr      w20, [x8]
40ee0304 4b1140b9 ldr      w11, [x10, #0x10]
40ee0308 f30301aa mov      x19, x1
40ee030c 9f050071 cmp      w12, #1
40ee0310 099d43b9 ldr      w9, [x8, #0x39c]
40ee0314 15a143b9 ldr      w21, [x8, #0x3a0]
40ee0318 f0179f1a cset     w16, eq
40ee031c 0ca940b9 ldr      w12, [x8, #0xa8]
40ee0320 2f2e8452 mov      w15, #0x2171
40ee0324 ee370329 stp      w14, w13, [sp, #0x18]
40ee0328 0e1e4b0a and      w14, w16, w11, lsr #7
40ee032c df050071 cmp      w14, #1
40ee0330 ef0f00b9 str      w15, [sp, #0xc]
40ee0334 e1000054 b.ne     #0x40ee0350
40ee0338 0fd10291 add      x15, x8, #0xb4
40ee033c 10610291 add      x16, x8, #0x98
40ee0340 9f050071 cmp      w12, #1
40ee0344 ec01909a csel     x12, x15, x16, eq
40ee0348 8c0140b9 ldr      w12, [x12]
40ee034c 09000014 b        #0x40ee0370
40ee0350 7f051b72 tst      w11, #0x60
40ee0354 c0000054 b.eq     #0x40ee036c
40ee0358 0f9d40b9 ldr      w15, [x8, #0x9c]
40ee035c 9f050071 cmp      w12, #1
40ee0360 10b940b9 ldr      w16, [x8, #0xb8]
40ee0364 0c028f1a csel     w12, w16, w15, eq
40ee0368 02000014 b        #0x40ee0370
40ee036c 0c9140b9 ldr      w12, [x8, #0x90]
40ee0370 4f0940b9 ldr      w15, [x10, #8]
40ee0374 cf070034 cbz      w15, #0x40ee046c
40ee0378 569d40b9 ldr      w22, [x10, #0x9c]
40ee037c f61f00b9 str      w22, [sp, #0x1c]
40ee0380 2b032837 tbnz     w11, #5, #0x40ee03e4
40ee0384 9f050071 cmp      w12, #1
40ee0388 e1020054 b.ne     #0x40ee03e4
40ee038c 0c1d40b9 ldr      w12, [x8, #0x1c]
40ee0390 8d650051 sub      w13, w12, #0x19
40ee0394 bf0d0071 cmp      w13, #3
40ee0398 63020054 b.lo     #0x40ee03e4
40ee039c 8d4d0051 sub      w13, w12, #0x13
40ee03a0 bf150071 cmp      w13, #5
40ee03a4 03020054 b.lo     #0x40ee03e4
40ee03a8 eb013037 tbnz     w11, #6, #0x40ee03e4
40ee03ac 8b011f32 orr      w11, w12, #2
40ee03b0 7f490071 cmp      w11, #0x12
40ee03b4 80010054 b.eq     #0x40ee03e4
40ee03b8 0c4542b9 ldr      w12, [x8, #0x244]
40ee03bc f60b00b9 str      w22, [sp, #8]
40ee03c0 9f050071 cmp      w12, #1
40ee03c4 a1070054 b.ne     #0x40ee04b8
40ee03c8 df160071 cmp      w22, #5
40ee03cc c00a0054 b.eq     #0x40ee0524
40ee03d0 eb03162a mov      w11, w22
40ee03d4 df120071 cmp      w22, #4
40ee03d8 a1000054 b.ne     #0x40ee03ec
40ee03dc eb031f2a mov      w11, wzr
40ee03e0 3d000014 b        #0x40ee04d4
40ee03e4 eb03162a mov      w11, w22
40ee03e8 f60b00b9 str      w22, [sp, #8]
40ee03ec 4a3540b9 ldr      w10, [x10, #0x34]
40ee03f0 aa000034 cbz      w10, #0x40ee0404
40ee03f4 169543b9 ldr      w22, [x8, #0x394]
40ee03f8 eb03162a mov      w11, w22
40ee03fc f61f00b9 str      w22, [sp, #0x1c]
40ee0400 f60b00b9 str      w22, [sp, #8]
40ee0404 9f060071 cmp      w20, #1
40ee0408 a1000054 b.ne     #0x40ee041c
40ee040c 3f010b6b cmp      w9, w11
40ee0410 61000054 b.ne     #0x40ee041c
40ee0414 e0030032 mov      w0, #1
40ee0418 06000014 b        #0x40ee0430
40ee041c e0030032 mov      w0, #1
40ee0420 e1630091 add      x1, sp, #0x18
40ee0424 e2730091 add      x2, sp, #0x1c
40ee0428 e30313aa mov      x3, x19
40ee042c 7eceff97 bl       #0x40ed3e24
40ee0430 9f060071 cmp      w20, #1
40ee0434 61000054 b.ne     #0x40ee0440
40ee0438 bf02166b cmp      w21, w22
40ee043c c0000054 b.eq     #0x40ee0454
40ee0440 e0030032 mov      w0, #1
40ee0444 e1330091 add      x1, sp, #0xc
40ee0448 e2230091 add      x2, sp, #8
40ee044c e30313aa mov      x3, x19
40ee0450 75ceff97 bl       #0x40ed3e24
40ee0454 f37b43a9 ldp      x19, x30, [sp, #0x30]
40ee0458 f55342a9 ldp      x21, x20, [sp, #0x20]
40ee045c f60b40f9 ldr      x22, [sp, #0x10]
40ee0460 00000012 and      w0, w0, #1
40ee0464 ff030191 add      sp, sp, #0x40
40ee0468 c0035fd6 ret
40ee046c 2e010034 cbz      w14, #0x40ee0490
40ee0470 9f0d0071 cmp      w12, #3
40ee0474 00050054 b.eq     #0x40ee0514
40ee0478 9f090071 cmp      w12, #2
40ee047c 00050054 b.eq     #0x40ee051c
40ee0480 9f050071 cmp      w12, #1
40ee0484 41040054 b.ne     #0x40ee050c
40ee0488 166d42b9 ldr      w22, [x8, #0x26c]
40ee048c bcffff17 b        #0x40ee037c
40ee0490 7f051b72 tst      w11, #0x60
40ee0494 40020054 b.eq     #0x40ee04dc
40ee0498 9f0d0071 cmp      w12, #3
40ee049c a0040054 b.eq     #0x40ee0530
40ee04a0 9f090071 cmp      w12, #2
40ee04a4 a0040054 b.eq     #0x40ee0538
40ee04a8 9f050071 cmp      w12, #1
40ee04ac 01030054 b.ne     #0x40ee050c
40ee04b0 166142b9 ldr      w22, [x8, #0x260]
40ee04b4 b2ffff17 b        #0x40ee037c
40ee04b8 eb03162a mov      w11, w22
40ee04bc df1a0071 cmp      w22, #6
40ee04c0 61f9ff54 b.ne     #0x40ee03ec
40ee04c4 9f090071 cmp      w12, #2
40ee04c8 21f9ff54 b.ne     #0x40ee03ec
40ee04cc eb031f2a mov      w11, wzr
40ee04d0 f6071f32 mov      w22, #6
40ee04d4 ff1f00b9 str      wzr, [sp, #0x1c]
40ee04d8 c5ffff17 b        #0x40ee03ec
40ee04dc 8e050051 sub      w14, w12, #1
40ee04e0 df150071 cmp      w14, #5
40ee04e4 48010054 b.hi     #0x40ee050c
40ee04e8 0f868cd2 mov      x15, #0x6430
40ee04ec 164942b9 ldr      w22, [x8, #0x248]
40ee04f0 4f54a0f2 movk     x15, #0x2a2, lsl #16
40ee04f4 4f01c0f2 movk     x15, #0xa, lsl #32
40ee04f8 0f00e0f2 movk     x15, #0, lsl #48
40ee04fc ee796ef8 ldr      x14, [x15, x14, lsl #3]
40ee0500 c0011fd6 br       x14
40ee0504 f6030d2a mov      w22, w13
40ee0508 9dffff17 b        #0x40ee037c
40ee050c f6031f32 mov      w22, #2
40ee0510 9bffff17 b        #0x40ee037c
40ee0514 167542b9 ldr      w22, [x8, #0x274]
40ee0518 99ffff17 b        #0x40ee037c
40ee051c 167142b9 ldr      w22, [x8, #0x270]
40ee0520 97ffff17 b        #0x40ee037c
40ee0524 eb030032 mov      w11, #1
40ee0528 eb1f00b9 str      w11, [sp, #0x1c]
40ee052c b0ffff17 b        #0x40ee03ec
40ee0530 166942b9 ldr      w22, [x8, #0x268]
40ee0534 92ffff17 b        #0x40ee037c
40ee0538 166542b9 ldr      w22, [x8, #0x264]
40ee053c 90ffff17 b        #0x40ee037c
40ee0540 164d42b9 ldr      w22, [x8, #0x24c]
40ee0544 8effff17 b        #0x40ee037c
40ee0548 165142b9 ldr      w22, [x8, #0x250]
40ee054c 8cffff17 b        #0x40ee037c
40ee0550 165942b9 ldr      w22, [x8, #0x258]
40ee0554 8affff17 b        #0x40ee037c
40ee0558 165d42b9 ldr      w22, [x8, #0x25c]
40ee055c 88ffff17 b        #0x40ee037c

; video_area_callback [0x40ee1924, 0x40ee21c8); SHA-256 417cfb7f08eb9e23ab6faef15cc81d35745d782ea3e34bf9fd6ff987bce53882
40ee1924 ff8305d1 sub      sp, sp, #0x160
40ee1928 fc6f10a9 stp      x28, x27, [sp, #0x100]
40ee192c fa6711a9 stp      x26, x25, [sp, #0x110]
40ee1930 f85f12a9 stp      x24, x23, [sp, #0x120]
40ee1934 f65713a9 stp      x22, x21, [sp, #0x130]
40ee1938 f44f14a9 stp      x20, x19, [sp, #0x140]
40ee193c fd7b15a9 stp      x29, x30, [sp, #0x150]
40ee1940 19ae90d2 mov      x25, #0x8570
40ee1944 e13f00f9 str      x1, [sp, #0x78]
40ee1948 3977a0f2 movk     x25, #0x3b9, lsl #16
40ee194c 5901c0f2 movk     x25, #0xa, lsl #32
40ee1950 1900e0f2 movk     x25, #0, lsl #48
40ee1954 972b92d2 mov      x23, #0x915c
40ee1958 3777a0f2 movk     x23, #0x3b9, lsl #16
40ee195c 280340b9 ldr      w8, [x25]
40ee1960 5701c0f2 movk     x23, #0xa, lsl #32
40ee1964 8bb09ad2 mov      x11, #0xd584
40ee1968 2ad343b9 ldr      w10, [x25, #0x3d0]
40ee196c 1700e0f2 movk     x23, #0, lsl #48
40ee1970 299b43b9 ldr      w9, [x25, #0x398]
40ee1974 2b77a0f2 movk     x11, #0x3b9, lsl #16
40ee1978 2cb743b9 ldr      w12, [x25, #0x3b4]
40ee197c 4b01c0f2 movk     x11, #0xa, lsl #32
40ee1980 e8c300b9 str      w8, [sp, #0xc0]
40ee1984 0b00e0f2 movk     x11, #0, lsl #48
40ee1988 e83640b9 ldr      w8, [x23, #0x34]
40ee198c f51240b9 ldr      w21, [x23, #0x10]
40ee1990 348740b9 ldr      w20, [x25, #0x84]
40ee1994 6d0140b9 ldr      w13, [x11]
40ee1998 e8e300b9 str      w8, [sp, #0xe0]
40ee199c 88248452 mov      w8, #0x2124
40ee19a0 362340b9 ldr      w22, [x25, #0x20]
40ee19a4 fc0a40b9 ldr      w28, [x23, #8]
40ee19a8 eaa71029 stp      w10, w9, [sp, #0x84]
40ee19ac e9338452 mov      w9, #0x219f
40ee19b0 e8371f29 stp      w8, w13, [sp, #0xf8]
40ee19b4 08548052 mov      w8, #0x2a0
40ee19b8 bf02086a tst      w21, w8
40ee19bc eb5300f9 str      x11, [sp, #0xa0]
40ee19c0 e9f700b9 str      w9, [sp, #0xf4]
40ee19c4 ec6b00b9 str      w12, [sp, #0x68]
40ee19c8 ed7700b9 str      w13, [sp, #0x74]
40ee19cc 60000054 b.eq     #0x40ee19d8
40ee19d0 f3031f2a mov      w19, wzr
40ee19d4 11000014 b        #0x40ee1a18
40ee19d8 e80e40b9 ldr      w8, [x23, #0xc]
40ee19dc b5010037 tbnz     w21, #0, #0x40ee1a10
40ee19e0 89af9ad2 mov      x9, #0xd57c
40ee19e4 ea0640b9 ldr      w10, [x23, #4]
40ee19e8 2977a0f2 movk     x9, #0x3b9, lsl #16
40ee19ec 2b3340b9 ldr      w11, [x25, #0x30]
40ee19f0 4901c0f2 movk     x9, #0xa, lsl #32
40ee19f4 0900e0f2 movk     x9, #0, lsl #48
40ee19f8 9f030071 cmp      w28, #0
40ee19fc 290140b9 ldr      w9, [x9]
40ee1a00 0811891a csel     w8, w8, w9, ne
40ee1a04 5f010071 cmp      w10, #0
40ee1a08 13018b1a csel     w19, w8, w11, eq
40ee1a0c 03000014 b        #0x40ee1a18
40ee1a10 9f030071 cmp      w28, #0
40ee1a14 13119f1a csel     w19, w8, wzr, ne
40ee1a18 e81640b9 ldr      w8, [x23, #0x14]
40ee1a1c e103162a mov      w1, w22
40ee1a20 201f40b9 ldr      w0, [x25, #0x1c]
40ee1a24 e203152a mov      w2, w21
40ee1a28 24974629 ldp      w4, w5, [x25, #0x34]
40ee1a2c 1f010071 cmp      w8, #0
40ee1a30 e3079f1a cset     w3, ne
40ee1a34 e4a31d29 stp      w4, w8, [sp, #0xec]
40ee1a38 34c9ff97 bl       #0x40ed3f08
40ee1a3c 3d9740b9 ldr      w29, [x25, #0x94]
40ee1a40 fb03002a mov      w27, w0
40ee1a44 2bab40b9 ldr      w11, [x25, #0xa8]
40ee1a48 bf070071 cmp      w29, #1
40ee1a4c e8179f1a cset     w8, eq
40ee1a50 081d550a and      w8, w8, w21, lsr #7
40ee1a54 1f050071 cmp      w8, #1
40ee1a58 e1000054 b.ne     #0x40ee1a74
40ee1a5c 29d30291 add      x9, x25, #0xb4
40ee1a60 2a630291 add      x10, x25, #0x98
40ee1a64 7f050071 cmp      w11, #1
40ee1a68 29018a9a csel     x9, x9, x10, eq
40ee1a6c 3a0140b9 ldr      w26, [x9]
40ee1a70 09000014 b        #0x40ee1a94
40ee1a74 bf061b72 tst      w21, #0x60
40ee1a78 c0000054 b.eq     #0x40ee1a90
40ee1a7c 299f40b9 ldr      w9, [x25, #0x9c]
40ee1a80 7f050071 cmp      w11, #1
40ee1a84 2abb40b9 ldr      w10, [x25, #0xb8]
40ee1a88 5a01891a csel     w26, w10, w9, eq
40ee1a8c 02000014 b        #0x40ee1a94
40ee1a90 3a9340b9 ldr      w26, [x25, #0x90]
40ee1a94 ebb300b9 str      w11, [sp, #0xb0]
40ee1a98 7c260034 cbz      w28, #0x40ee1f64
40ee1a9c f09e40b9 ldr      w16, [x23, #0x9c]
40ee1aa0 217b42b9 ldr      w1, [x25, #0x278]
40ee1aa4 9f030071 cmp      w28, #0
40ee1aa8 227f42b9 ldr      w2, [x25, #0x27c]
40ee1aac ef079f1a cset     w15, ne
40ee1ab0 238342b9 ldr      w3, [x25, #0x280]
40ee1ab4 e0031a2a mov      w0, w26
40ee1ab8 248742b9 ldr      w4, [x25, #0x284]
40ee1abc e703152a mov      w7, w21
40ee1ac0 258b42b9 ldr      w5, [x25, #0x288]
40ee1ac4 268f42b9 ldr      w6, [x25, #0x28c]
40ee1ac8 289342b9 ldr      w8, [x25, #0x290]
40ee1acc 299742b9 ldr      w9, [x25, #0x294]
40ee1ad0 2a9b42b9 ldr      w10, [x25, #0x298]
40ee1ad4 2b9f42b9 ldr      w11, [x25, #0x29c]
40ee1ad8 2ca342b9 ldr      w12, [x25, #0x2a0]
40ee1adc 2da742b9 ldr      w13, [x25, #0x2a4]
40ee1ae0 ee6640b9 ldr      w14, [x23, #0x64]
40ee1ae4 f0bf00b9 str      w16, [sp, #0xbc]
40ee1ae8 f05b00b9 str      w16, [sp, #0x58]
40ee1aec f45300b9 str      w20, [sp, #0x50]
40ee1af0 ee4300b9 str      w14, [sp, #0x40]
40ee1af4 f64b00b9 str      w22, [sp, #0x48]
40ee1af8 efe30039 strb     w15, [sp, #0x38]
40ee1afc ed3300b9 str      w13, [sp, #0x30]
40ee1b00 ec2b00b9 str      w12, [sp, #0x28]
40ee1b04 eb2300b9 str      w11, [sp, #0x20]
40ee1b08 fd1b00b9 str      w29, [sp, #0x18]
40ee1b0c ea1300b9 str      w10, [sp, #0x10]
40ee1b10 e90b00b9 str      w9, [sp, #8]
40ee1b14 e80300b9 str      w8, [sp]
40ee1b18 17ddff97 bl       #0x40ed8f74
40ee1b1c e0bb00b9 str      w0, [sp, #0xb8]
40ee1b20 fad31829 stp      w26, w20, [sp, #0xc4]
40ee1b24 f6e700b9 str      w22, [sp, #0xe4]
40ee1b28 fdf30d29 stp      w29, w28, [sp, #0x6c]
40ee1b2c 15022837 tbnz     w21, #5, #0x40ee1b6c
40ee1b30 68670051 sub      w8, w27, #0x19
40ee1b34 1f0d0071 cmp      w8, #3
40ee1b38 a3010054 b.lo     #0x40ee1b6c
40ee1b3c 684f0051 sub      w8, w27, #0x13
40ee1b40 1f150071 cmp      w8, #5
40ee1b44 43010054 b.lo     #0x40ee1b6c
40ee1b48 35013037 tbnz     w21, #6, #0x40ee1b6c
40ee1b4c 68031f32 orr      w8, w27, #2
40ee1b50 1f490071 cmp      w8, #0x12
40ee1b54 c0000054 b.eq     #0x40ee1b6c
40ee1b58 5f070071 cmp      w26, #1
40ee1b5c 81000054 b.ne     #0x40ee1b6c
40ee1b60 284742b9 ldr      w8, [x25, #0x244]
40ee1b64 e8b700b9 str      w8, [sp, #0xb4]
40ee1b68 02000014 b        #0x40ee1b70
40ee1b6c ffb700b9 str      wzr, [sp, #0xb4]
40ee1b70 e8f340b9 ldr      w8, [sp, #0xf0]
40ee1b74 e0031b2a mov      w0, w27
40ee1b78 342b40b9 ldr      w20, [x25, #0x28]
40ee1b7c fbd300b9 str      w27, [sp, #0xd0]
40ee1b80 1f010071 cmp      w8, #0
40ee1b84 f6079f1a cset     w22, ne
40ee1b88 fa179f1a cset     w26, eq
40ee1b8c 87d0ff97 bl       #0x40ed5da8
40ee1b90 08008c52 mov      w8, #0x6000
40ee1b94 e93240b9 ldr      w9, [x23, #0x30]
40ee1b98 0804a072 movk     w8, #0x20, lsl #16
40ee1b9c eeef40b9 ldr      w14, [sp, #0xec]
40ee1ba0 a802080a and      w8, w21, w8
40ee1ba4 2c4340b9 ldr      w12, [x25, #0x40]
40ee1ba8 0800082a orr      w8, w0, w8
40ee1bac fd3a40b9 ldr      w29, [x23, #0x38]
40ee1bb0 1f010071 cmp      w8, #0
40ee1bb4 21af40b9 ldr      w1, [x25, #0xac]
40ee1bb8 84029f1a csel     w4, w20, wzr, eq
40ee1bbc ee3300b9 str      w14, [sp, #0x30]
40ee1bc0 f403092a mov      w20, w9
40ee1bc4 f6630039 strb     w22, [sp, #0x18]
40ee1bc8 9f020071 cmp      w20, #0
40ee1bcc e8079f1a cset     w8, ne
40ee1bd0 e19300b9 str      w1, [sp, #0x90]
40ee1bd4 df011572 tst      w14, #0x800
40ee1bd8 20ab4d29 ldp      w0, w10, [x25, #0x6c]
40ee1bdc 09011a2a orr      w9, w8, w26
40ee1be0 eb179f1a cset     w11, eq
40ee1be4 e8a30039 strb     w8, [sp, #0x28]
40ee1be8 6901092a orr      w9, w11, w9
40ee1bec 2b6740b9 ldr      w11, [x25, #0x64]
40ee1bf0 3f010071 cmp      w9, #0
40ee1bf4 293f40b9 ldr      w9, [x25, #0x3c]
40ee1bf8 ad021712 and      w13, w21, #0x200
40ee1bfc 45119f1a csel     w5, w10, wzr, ne
40ee1c00 9f010071 cmp      w12, #0
40ee1c04 ec2e40b9 ldr      w12, [x23, #0x2c]
40ee1c08 a409407a ccmp     w13, #0, #4, eq
40ee1c0c ea031f32 mov      w10, #2
40ee1c10 e5eb00b9 str      w5, [sp, #0xe8]
40ee1c14 fa03132a mov      w26, w19
40ee1c18 29018a1a csel     w9, w9, w10, eq
40ee1c1c ecd700b9 str      w12, [sp, #0xd4]
40ee1c20 5f070071 cmp      w26, #1
40ee1c24 ec1300b9 str      w12, [sp, #0x10]
40ee1c28 ea03891a csel     w10, wzr, w9, eq
40ee1c2c 5f010071 cmp      w10, #0
40ee1c30 3ce34e29 ldp      w28, w24, [x25, #0x74]
40ee1c34 69019f1a csel     w9, w11, wzr, eq
40ee1c38 bf030071 cmp      w29, #0
40ee1c3c ea131329 stp      w10, w4, [sp, #0x98]
40ee1c40 e2079f1a cset     w2, ne
40ee1c44 ea3b00b9 str      w10, [sp, #0x38]
40ee1c48 e9cf00b9 str      w9, [sp, #0xcc]
40ee1c4c e303152a mov      w3, w21
40ee1c50 297f40b9 ldr      w9, [x25, #0x7c]
40ee1c54 e7031c2a mov      w7, w28
40ee1c58 f80300b9 str      w24, [sp]
40ee1c5c e9031b29 stp      w9, w0, [sp, #0xd8]
40ee1c60 e92300b9 str      w9, [sp, #0x20]
40ee1c64 b8caff97 bl       #0x40ed4744
40ee1c68 e9e340b9 ldr      w9, [sp, #0xe0]
40ee1c6c a8021112 and      w8, w21, #0x8000
40ee1c70 e09700b9 str      w0, [sp, #0x94]
40ee1c74 2901082a orr      w9, w9, w8
40ee1c78 e8031f2a mov      w8, wzr
40ee1c7c 69180034 cbz      w9, #0x40ee1f88
40ee1c80 f6a75d29 ldp      w22, w9, [sp, #0xec]
40ee1c84 e82300b9 str      w8, [sp, #0x20]
40ee1c88 bf030071 cmp      w29, #0
40ee1c8c e8cb40b9 ldr      w8, [sp, #0xc8]
40ee1c90 e2079f1a cset     w2, ne
40ee1c94 9f020071 cmp      w20, #0
40ee1c98 208340b9 ldr      w0, [x25, #0x80]
40ee1c9c e7079f1a cset     w7, ne
40ee1ca0 21b340b9 ldr      w1, [x25, #0xb0]
40ee1ca4 3f010071 cmp      w9, #0
40ee1ca8 e9eb40b9 ldr      w9, [sp, #0xe8]
40ee1cac f3079f1a cset     w19, ne
40ee1cb0 fbd740b9 ldr      w27, [sp, #0xd4]
40ee1cb4 e60f5b29 ldp      w6, w3, [sp, #0xd8]
40ee1cb8 e80b00b9 str      w8, [sp, #8]
40ee1cbc e503132a mov      w5, w19
40ee1cc0 e8e740b9 ldr      w8, [sp, #0xe4]
40ee1cc4 fd8f00b9 str      w29, [sp, #0x8c]
40ee1cc8 fd03142a mov      w29, w20
40ee1ccc e92b00b9 str      w9, [sp, #0x28]
40ee1cd0 fb1b00b9 str      w27, [sp, #0x18]
40ee1cd4 f61300b9 str      w22, [sp, #0x10]
40ee1cd8 e80300b9 str      w8, [sp]
40ee1cdc 0ccbff97 bl       #0x40ed490c
40ee1ce0 296340b9 ldr      w9, [x25, #0x60]
40ee1ce4 e2031a2a mov      w2, w26
40ee1ce8 e4eb5929 ldp      w4, w26, [sp, #0xcc]
40ee1cec 276b40b9 ldr      w7, [x25, #0x68]
40ee1cf0 e603162a mov      w6, w22
40ee1cf4 f69740b9 ldr      w22, [sp, #0x94]
40ee1cf8 e803002a mov      w8, w0
40ee1cfc e003092a mov      w0, w9
40ee1d00 fb0b00b9 str      w27, [sp, #8]
40ee1d04 e1031a2a mov      w1, w26
40ee1d08 e91f1529 stp      w9, w7, [sp, #0xa8]
40ee1d0c e303152a mov      w3, w21
40ee1d10 e8b300b9 str      w8, [sp, #0xb0]
40ee1d14 e503132a mov      w5, w19
40ee1d18 e81b00b9 str      w8, [sp, #0x18]
40ee1d1c f403022a mov      w20, w2
40ee1d20 f61300b9 str      w22, [sp, #0x10]
40ee1d24 2ccbff97 bl       #0x40ed49d4
40ee1d28 5f830071 cmp      w26, #0x20
40ee1d2c 41010054 b.ne     #0x40ee1d54
40ee1d30 08000032 orr      w8, w0, #1
40ee1d34 1f0d0071 cmp      w8, #3
40ee1d38 e1000054 b.ne     #0x40ee1d54
40ee1d3c e8eb40b9 ldr      w8, [sp, #0xe8]
40ee1d40 1f050071 cmp      w8, #1
40ee1d44 e803142a mov      w8, w20
40ee1d48 c1130054 b.ne     #0x40ee1fc0
40ee1d4c f6031e32 mov      w22, #4
40ee1d50 02000014 b        #0x40ee1d58
40ee1d54 e803142a mov      w8, w20
40ee1d58 f4031d2a mov      w20, w29
40ee1d5c fa031c2a mov      w26, w28
40ee1d60 fc03182a mov      w28, w24
40ee1d64 fde35129 ldp      w29, w24, [sp, #0x8c]
40ee1d68 f3030032 mov      w19, #1
40ee1d6c f5092837 tbnz     w21, #5, #0x40ee1ea8
40ee1d70 d5093037 tbnz     w21, #6, #0x40ee1ea8
40ee1d74 1f050071 cmp      w8, #1
40ee1d78 81090054 b.ne     #0x40ee1ea8
40ee1d7c 08b09ad2 mov      x8, #0xd580
40ee1d80 22b342b9 ldr      w2, [x25, #0x2b0]
40ee1d84 2877a0f2 movk     x8, #0x3b9, lsl #16
40ee1d88 e17740b9 ldr      w1, [sp, #0x74]
40ee1d8c 4801c0f2 movk     x8, #0xa, lsl #32
40ee1d90 f62b00b9 str      w22, [sp, #0x28]
40ee1d94 0800e0f2 movk     x8, #0, lsl #48
40ee1d98 f6e740b9 ldr      w22, [sp, #0xe4]
40ee1d9c e4030032 mov      w4, #1
40ee1da0 e303152a mov      w3, w21
40ee1da4 000140b9 ldr      w0, [x8]
40ee1da8 e9a34d29 ldp      w9, w8, [sp, #0x6c]
40ee1dac f61300b9 str      w22, [sp, #0x10]
40ee1db0 1f010071 cmp      w8, #0
40ee1db4 e93b00b9 str      w9, [sp, #0x38]
40ee1db8 e6224d29 ldp      w6, w8, [x23, #0x68]
40ee1dbc e9cf5829 ldp      w9, w19, [sp, #0xc4]
40ee1dc0 e5079f1a cset     w5, ne
40ee1dc4 e82300b9 str      w8, [sp, #0x20]
40ee1dc8 e89f5629 ldp      w8, w7, [sp, #0xb4]
40ee1dcc e94300b9 str      w9, [sp, #0x40]
40ee1dd0 e9b340b9 ldr      w9, [sp, #0xb0]
40ee1dd4 e80b00b9 str      w8, [sp, #8]
40ee1dd8 e8bf40b9 ldr      w8, [sp, #0xbc]
40ee1ddc f31b00b9 str      w19, [sp, #0x18]
40ee1de0 e93300b9 str      w9, [sp, #0x30]
40ee1de4 e80300b9 str      w8, [sp]
40ee1de8 badcff97 bl       #0x40ed90d0
40ee1dec e8e340b9 ldr      w8, [sp, #0xe0]
40ee1df0 fb03002a mov      w27, w0
40ee1df4 08010034 cbz      w8, #0x40ee1e14
40ee1df8 e98b40b9 ldr      w9, [sp, #0x88]
40ee1dfc c8021f32 orr      w8, w22, #2
40ee1e00 3f110071 cmp      w9, #4
40ee1e04 0009437a ccmp     w8, #3, #0, eq
40ee1e08 a8008052 mov      w8, #5
40ee1e0c 600a407a ccmp     w19, #0, #0, eq
40ee1e10 1b01891a csel     w27, w8, w9, eq
40ee1e14 e8c340b9 ldr      w8, [sp, #0xc0]
40ee1e18 f3030032 mov      w19, #1
40ee1e1c fbff00b9 str      w27, [sp, #0xfc]
40ee1e20 1f050071 cmp      w8, #1
40ee1e24 81000054 b.ne     #0x40ee1e34
40ee1e28 e86b40b9 ldr      w8, [sp, #0x68]
40ee1e2c 1f011b6b cmp      w8, w27
40ee1e30 c0030054 b.eq     #0x40ee1ea8
40ee1e34 f63f40f9 ldr      x22, [sp, #0x78]
40ee1e38 e0030032 mov      w0, #1
40ee1e3c e1e30391 add      x1, sp, #0xf8
40ee1e40 e2f30391 add      x2, sp, #0xfc
40ee1e44 e30316aa mov      x3, x22
40ee1e48 f7c7ff97 bl       #0x40ed3e24
40ee1e4c d3420239 strb     w19, [x22, #0x90]
40ee1e50 d3e20439 strb     w19, [x22, #0x138]
40ee1e54 286b40b9 ldr      w8, [x25, #0x68]
40ee1e58 38af40b9 ldr      w24, [x25, #0xac]
40ee1e5c fd3a40b9 ldr      w29, [x23, #0x38]
40ee1e60 3af34e29 ldp      w26, w28, [x25, #0x74]
40ee1e64 e8af00b9 str      w8, [sp, #0xac]
40ee1e68 286f40b9 ldr      w8, [x25, #0x6c]
40ee1e6c e8df00b9 str      w8, [sp, #0xdc]
40ee1e70 f5224229 ldp      w21, w8, [x23, #0x10]
40ee1e74 e8f300b9 str      w8, [sp, #0xf0]
40ee1e78 287f40b9 ldr      w8, [x25, #0x7c]
40ee1e7c e8db00b9 str      w8, [sp, #0xd8]
40ee1e80 e8d24529 ldp      w8, w20, [x23, #0x2c]
40ee1e84 e8d700b9 str      w8, [sp, #0xd4]
40ee1e88 283740b9 ldr      w8, [x25, #0x34]
40ee1e8c e8ef00b9 str      w8, [sp, #0xec]
40ee1e90 286340b9 ldr      w8, [x25, #0x60]
40ee1e94 d3ca0539 strb     w19, [x22, #0x172]
40ee1e98 f303002a mov      w19, w0
40ee1e9c db9600b9 str      w27, [x22, #0x94]
40ee1ea0 db3e01b9 str      w27, [x22, #0x13c]
40ee1ea4 e8ab00b9 str      w8, [sp, #0xa8]
40ee1ea8 e8f340b9 ldr      w8, [sp, #0xf0]
40ee1eac bf030071 cmp      w29, #0
40ee1eb0 e9135329 ldp      w9, w4, [sp, #0x98]
40ee1eb4 e2079f1a cset     w2, ne
40ee1eb8 e103182a mov      w1, w24
40ee1ebc fbd740b9 ldr      w27, [sp, #0xd4]
40ee1ec0 1f010071 cmp      w8, #0
40ee1ec4 fc0300b9 str      w28, [sp]
40ee1ec8 f6079f1a cset     w22, ne
40ee1ecc e93b00b9 str      w9, [sp, #0x38]
40ee1ed0 9f020071 cmp      w20, #0
40ee1ed4 e5635d29 ldp      w5, w24, [sp, #0xe8]
40ee1ed8 e9035b29 ldp      w9, w0, [sp, #0xd8]
40ee1edc e8079f1a cset     w8, ne
40ee1ee0 e303152a mov      w3, w21
40ee1ee4 f83300b9 str      w24, [sp, #0x30]
40ee1ee8 e7031a2a mov      w7, w26
40ee1eec e92300b9 str      w9, [sp, #0x20]
40ee1ef0 fb1300b9 str      w27, [sp, #0x10]
40ee1ef4 e8a30039 strb     w8, [sp, #0x28]
40ee1ef8 f6630039 strb     w22, [sp, #0x18]
40ee1efc 12caff97 bl       #0x40ed4744
40ee1f00 e4eb5929 ldp      w4, w26, [sp, #0xcc]
40ee1f04 f403002a mov      w20, w0
40ee1f08 e01f5529 ldp      w0, w7, [sp, #0xa8]
40ee1f0c e603182a mov      w6, w24
40ee1f10 f8b340b9 ldr      w24, [sp, #0xb0]
40ee1f14 e2030032 mov      w2, #1
40ee1f18 e1031a2a mov      w1, w26
40ee1f1c f41300b9 str      w20, [sp, #0x10]
40ee1f20 e303152a mov      w3, w21
40ee1f24 fb0b00b9 str      w27, [sp, #8]
40ee1f28 e503162a mov      w5, w22
40ee1f2c f81b00b9 str      w24, [sp, #0x18]
40ee1f30 a9caff97 bl       #0x40ed49d4
40ee1f34 5f830071 cmp      w26, #0x20
40ee1f38 21050054 b.ne     #0x40ee1fdc
40ee1f3c e95340f9 ldr      x9, [sp, #0xa0]
40ee1f40 08000032 orr      w8, w0, #1
40ee1f44 ecc740b9 ldr      w12, [sp, #0xc4]
40ee1f48 1f0d0071 cmp      w8, #3
40ee1f4c 01050054 b.ne     #0x40ee1fec
40ee1f50 f6a35c29 ldp      w22, w8, [sp, #0xe4]
40ee1f54 1f050071 cmp      w8, #1
40ee1f58 e1040054 b.ne     #0x40ee1ff4
40ee1f5c f4031e32 mov      w20, #4
40ee1f60 3a000014 b        #0x40ee2048
40ee1f64 48050034 cbz      w8, #0x40ee200c
40ee1f68 5f0f0071 cmp      w26, #3
40ee1f6c 20100054 b.eq     #0x40ee2170
40ee1f70 5f0b0071 cmp      w26, #2
40ee1f74 20100054 b.eq     #0x40ee2178
40ee1f78 5f070071 cmp      w26, #1
40ee1f7c 610f0054 b.ne     #0x40ee2168
40ee1f80 306f42b9 ldr      w16, [x25, #0x26c]
40ee1f84 c7feff17 b        #0x40ee1aa0
40ee1f88 7a050034 cbz      w26, #0x40ee2034
40ee1f8c e8c740b9 ldr      w8, [sp, #0xc4]
40ee1f90 080d0051 sub      w8, w8, #3
40ee1f94 1f0d0071 cmp      w8, #3
40ee1f98 480f0054 b.hi     #0x40ee2180
40ee1f9c 09a08cd2 mov      x9, #0x6500
40ee1fa0 4954a0f2 movk     x9, #0x2a2, lsl #16
40ee1fa4 4901c0f2 movk     x9, #0xa, lsl #32
40ee1fa8 0900e0f2 movk     x9, #0, lsl #48
40ee1fac 297968f8 ldr      x9, [x9, x8, lsl #3]
40ee1fb0 288b40b9 ldr      w8, [x25, #0x88]
40ee1fb4 20011fd6 br       x9
40ee1fb8 288f40b9 ldr      w8, [x25, #0x8c]
40ee1fbc 31ffff17 b        #0x40ee1c80
40ee1fc0 f4031d2a mov      w20, w29
40ee1fc4 df060071 cmp      w22, #1
40ee1fc8 a0030054 b.eq     #0x40ee203c
40ee1fcc df0e0071 cmp      w22, #3
40ee1fd0 61ecff54 b.ne     #0x40ee1d5c
40ee1fd4 f6031f32 mov      w22, #2
40ee1fd8 61ffff17 b        #0x40ee1d5c
40ee1fdc f6e740b9 ldr      w22, [sp, #0xe4]
40ee1fe0 e95340f9 ldr      x9, [sp, #0xa0]
40ee1fe4 ecc740b9 ldr      w12, [sp, #0xc4]
40ee1fe8 18000014 b        #0x40ee2048
40ee1fec f6e740b9 ldr      w22, [sp, #0xe4]
40ee1ff0 16000014 b        #0x40ee2048
40ee1ff4 9f060071 cmp      w20, #1
40ee1ff8 60020054 b.eq     #0x40ee2044
40ee1ffc 9f0e0071 cmp      w20, #3
40ee2000 41020054 b.ne     #0x40ee2048
40ee2004 f4031f32 mov      w20, #2
40ee2008 10000014 b        #0x40ee2048
40ee200c bf061b72 tst      w21, #0x60
40ee2010 40090054 b.eq     #0x40ee2138
40ee2014 5f0f0071 cmp      w26, #3
40ee2018 000c0054 b.eq     #0x40ee2198
40ee201c 5f0b0071 cmp      w26, #2
40ee2020 000c0054 b.eq     #0x40ee21a0
40ee2024 5f070071 cmp      w26, #1
40ee2028 010a0054 b.ne     #0x40ee2168
40ee202c 306342b9 ldr      w16, [x25, #0x260]
40ee2030 9cfeff17 b        #0x40ee1aa0
40ee2034 e8b340b9 ldr      w8, [sp, #0xb0]
40ee2038 12ffff17 b        #0x40ee1c80
40ee203c f6031f2a mov      w22, wzr
40ee2040 47ffff17 b        #0x40ee1d5c
40ee2044 f4031f2a mov      w20, wzr
40ee2048 08b09ad2 mov      x8, #0xd580
40ee204c 210140b9 ldr      w1, [x9]
40ee2050 2877a0f2 movk     x8, #0x3b9, lsl #16
40ee2054 e90a40b9 ldr      w9, [x23, #8]
40ee2058 4801c0f2 movk     x8, #0xa, lsl #32
40ee205c 22b342b9 ldr      w2, [x25, #0x2b0]
40ee2060 0800e0f2 movk     x8, #0, lsl #48
40ee2064 2a2340b9 ldr      w10, [x25, #0x20]
40ee2068 2b8740b9 ldr      w11, [x25, #0x84]
40ee206c e4030032 mov      w4, #1
40ee2070 3f010071 cmp      w9, #0
40ee2074 299740b9 ldr      w9, [x25, #0x94]
40ee2078 000140b9 ldr      w0, [x8]
40ee207c e5079f1a cset     w5, ne
40ee2080 e6224d29 ldp      w6, w8, [x23, #0x68]
40ee2084 e303152a mov      w3, w21
40ee2088 ec4300b9 str      w12, [sp, #0x40]
40ee208c e93b00b9 str      w9, [sp, #0x38]
40ee2090 e82300b9 str      w8, [sp, #0x20]
40ee2094 e89f5629 ldp      w8, w7, [sp, #0xb4]
40ee2098 f83300b9 str      w24, [sp, #0x30]
40ee209c f42b00b9 str      w20, [sp, #0x28]
40ee20a0 e80b00b9 str      w8, [sp, #8]
40ee20a4 e8bf40b9 ldr      w8, [sp, #0xbc]
40ee20a8 eb1b00b9 str      w11, [sp, #0x18]
40ee20ac ea1300b9 str      w10, [sp, #0x10]
40ee20b0 e80300b9 str      w8, [sp]
40ee20b4 07dcff97 bl       #0x40ed90d0
40ee20b8 e8e340b9 ldr      w8, [sp, #0xe0]
40ee20bc 28010034 cbz      w8, #0x40ee20e0
40ee20c0 e98b40b9 ldr      w9, [sp, #0x88]
40ee20c4 c8021f32 orr      w8, w22, #2
40ee20c8 3f110071 cmp      w9, #4
40ee20cc 0009437a ccmp     w8, #3, #0, eq
40ee20d0 e8cb40b9 ldr      w8, [sp, #0xc8]
40ee20d4 0009407a ccmp     w8, #0, #0, eq
40ee20d8 a8008052 mov      w8, #5
40ee20dc 0001891a csel     w0, w8, w9, eq
40ee20e0 e8c340b9 ldr      w8, [sp, #0xc0]
40ee20e4 e0ff00b9 str      w0, [sp, #0xfc]
40ee20e8 1f050071 cmp      w8, #1
40ee20ec 81000054 b.ne     #0x40ee20fc
40ee20f0 e88740b9 ldr      w8, [sp, #0x84]
40ee20f4 1f01006b cmp      w8, w0
40ee20f8 e0000054 b.eq     #0x40ee2114
40ee20fc e33f40f9 ldr      x3, [sp, #0x78]
40ee2100 e0030032 mov      w0, #1
40ee2104 e1d30391 add      x1, sp, #0xf4
40ee2108 e2f30391 add      x2, sp, #0xfc
40ee210c 46c7ff97 bl       #0x40ed3e24
40ee2110 f303002a mov      w19, w0
40ee2114 60020012 and      w0, w19, #1
40ee2118 fd7b55a9 ldp      x29, x30, [sp, #0x150]
40ee211c f44f54a9 ldp      x20, x19, [sp, #0x140]
40ee2120 f65753a9 ldp      x22, x21, [sp, #0x130]
40ee2124 f85f52a9 ldp      x24, x23, [sp, #0x120]
40ee2128 fa6751a9 ldp      x26, x25, [sp, #0x110]
40ee212c fc6f50a9 ldp      x28, x27, [sp, #0x100]
40ee2130 ff830591 add      sp, sp, #0x160
40ee2134 c0035fd6 ret
40ee2138 48070051 sub      w8, w26, #1
40ee213c 1f150071 cmp      w8, #5
40ee2140 48010054 b.hi     #0x40ee2168
40ee2144 099a8cd2 mov      x9, #0x64d0
40ee2148 304b42b9 ldr      w16, [x25, #0x248]
40ee214c 4954a0f2 movk     x9, #0x2a2, lsl #16
40ee2150 4901c0f2 movk     x9, #0xa, lsl #32
40ee2154 0900e0f2 movk     x9, #0, lsl #48
40ee2158 287968f8 ldr      x8, [x9, x8, lsl #3]
40ee215c 00011fd6 br       x8
40ee2160 305742b9 ldr      w16, [x25, #0x254]
40ee2164 4ffeff17 b        #0x40ee1aa0
40ee2168 f0031f32 mov      w16, #2
40ee216c 4dfeff17 b        #0x40ee1aa0
40ee2170 307742b9 ldr      w16, [x25, #0x274]
40ee2174 4bfeff17 b        #0x40ee1aa0
40ee2178 307342b9 ldr      w16, [x25, #0x270]
40ee217c 49feff17 b        #0x40ee1aa0
40ee2180 e8031f2a mov      w8, wzr
40ee2184 bffeff17 b        #0x40ee1c80
40ee2188 28a340b9 ldr      w8, [x25, #0xa0]
40ee218c bdfeff17 b        #0x40ee1c80
40ee2190 28a740b9 ldr      w8, [x25, #0xa4]
40ee2194 bbfeff17 b        #0x40ee1c80
40ee2198 306b42b9 ldr      w16, [x25, #0x268]
40ee219c 41feff17 b        #0x40ee1aa0
40ee21a0 306742b9 ldr      w16, [x25, #0x264]
40ee21a4 3ffeff17 b        #0x40ee1aa0
40ee21a8 304f42b9 ldr      w16, [x25, #0x24c]
40ee21ac 3dfeff17 b        #0x40ee1aa0
40ee21b0 305342b9 ldr      w16, [x25, #0x250]
40ee21b4 3bfeff17 b        #0x40ee1aa0
40ee21b8 305b42b9 ldr      w16, [x25, #0x258]
40ee21bc 39feff17 b        #0x40ee1aa0
40ee21c0 305f42b9 ldr      w16, [x25, #0x25c]
40ee21c4 37feff17 b        #0x40ee1aa0

; area_selector [0x40ed90d0, 0x40ed9288); SHA-256 7e2faf824f49a388c11915257a8ecccbee0d3cd0c99f4ef3a378d0658ecddb9a
40ed90d0 a8008052 mov      w8, #5
40ed90d4 a3002837 tbnz     w3, #5, #0x40ed90e8
40ed90d8 69001a12 and      w9, w3, #0x40
40ed90dc 2901042a orr      w9, w9, w4
40ed90e0 3f010071 cmp      w9, #0
40ed90e4 08159f1a csinc    w8, w8, wzr, ne
40ed90e8 45080037 tbnz     w5, #0, #0x40ed91f0
40ed90ec 7f041b72 tst      w3, #0x60
40ed90f0 81000054 b.ne     #0x40ed9100
40ed90f4 9f040071 cmp      w4, #1
40ed90f8 2200801a csel     w2, w1, w0, eq
40ed90fc 07000014 b        #0x40ed9118
40ed9100 5f040071 cmp      w2, #1
40ed9104 80000054 b.eq     #0x40ed9114
40ed9108 82000035 cbnz     w2, #0x40ed9118
40ed910c e2031e32 mov      w2, #4
40ed9110 02000014 b        #0x40ed9118
40ed9114 a2008052 mov      w2, #5
40ed9118 e91b40b9 ldr      w9, [sp, #0x18]
40ed911c 9f040071 cmp      w4, #1
40ed9120 ea1340b9 ldr      w10, [sp, #0x10]
40ed9124 21010054 b.ne     #0x40ed9148
40ed9128 ec0340b9 ldr      w12, [sp]
40ed912c eb4340b9 ldr      w11, [sp, #0x40]
40ed9130 9f090071 cmp      w12, #2
40ed9134 63010054 b.lo     #0x40ed9160
40ed9138 ec0b40b9 ldr      w12, [sp, #8]
40ed913c 2c010035 cbnz     w12, #0x40ed9160
40ed9140 ec031f2a mov      w12, wzr
40ed9144 0e000014 b        #0x40ed917c
40ed9148 9f000071 cmp      w4, #0
40ed914c eb179f1a cset     w11, eq
40ed9150 23037836 tbz      w3, #0xf, #0x40ed91b4
40ed9154 04030035 cbnz     w4, #0x40ed91b4
40ed9158 e6031f2a mov      w6, wzr
40ed915c 25000014 b        #0x40ed91f0
40ed9160 1f01026b cmp      w8, w2
40ed9164 a0000054 b.eq     #0x40ed9178
40ed9168 4c011f32 orr      w12, w10, #2
40ed916c 9f0d0071 cmp      w12, #3
40ed9170 81feff54 b.ne     #0x40ed9140
40ed9174 69feff35 cbnz     w9, #0x40ed9140
40ed9178 ec030032 mov      w12, #1
40ed917c 6b150051 sub      w11, w11, #5
40ed9180 7f050071 cmp      w11, #1
40ed9184 08010054 b.hi     #0x40ed91a4
40ed9188 ff080071 cmp      w7, #2
40ed918c e8031e32 mov      w8, #4
40ed9190 e90b0032 mov      w9, #7
40ed9194 2801881a csel     w8, w9, w8, eq
40ed9198 ff140071 cmp      w7, #5
40ed919c e600881a csel     w6, w7, w8, eq
40ed91a0 14000014 b        #0x40ed91f0
40ed91a4 6c000034 cbz      w12, #0x40ed91b0
40ed91a8 e60b0032 mov      w6, #7
40ed91ac 11000014 b        #0x40ed91f0
40ed91b0 eb031f2a mov      w11, wzr
40ed91b4 4a011f32 orr      w10, w10, #2
40ed91b8 5f0d0071 cmp      w10, #3
40ed91bc 81000054 b.ne     #0x40ed91cc
40ed91c0 69000035 cbnz     w9, #0x40ed91cc
40ed91c4 e603082a mov      w6, w8
40ed91c8 0a000014 b        #0x40ed91f0
40ed91cc 83002837 tbnz     w3, #5, #0x40ed91dc
40ed91d0 69010052 eor      w9, w11, #1
40ed91d4 49000037 tbnz     w9, #0, #0x40ed91dc
40ed91d8 03013036 tbz      w3, #6, #0x40ed91f8
40ed91dc ff0c0071 cmp      w7, #3
40ed91e0 c1000054 b.ne     #0x40ed91f8
40ed91e4 1f01026b cmp      w8, w2
40ed91e8 81000054 b.ne     #0x40ed91f8
40ed91ec e6031e32 mov      w6, #4
40ed91f0 e003062a mov      w0, w6
40ed91f4 c0035fd6 ret
40ed91f8 ff0c0071 cmp      w7, #3
40ed91fc e1000054 b.ne     #0x40ed9218
40ed9200 c3003836 tbz      w3, #7, #0x40ed9218
40ed9204 e93b40b9 ldr      w9, [sp, #0x38]
40ed9208 3f050071 cmp      w9, #1
40ed920c 61000054 b.ne     #0x40ed9218
40ed9210 1f01026b cmp      w8, w2
40ed9214 20faff54 b.eq     #0x40ed9158
40ed9218 ea2b40b9 ldr      w10, [sp, #0x28]
40ed921c e93340b9 ldr      w9, [sp, #0x30]
40ed9220 5f050071 cmp      w10, #1
40ed9224 ea179f1a cset     w10, eq
40ed9228 4a010b0a and      w10, w10, w11
40ed922c 3f110071 cmp      w9, #4
40ed9230 41000054 b.ne     #0x40ed9238
40ed9234 2af90737 tbnz     w10, #0, #0x40ed9158
40ed9238 3f150071 cmp      w9, #5
40ed923c eb179f1a cset     w11, eq
40ed9240 6b010a0a and      w11, w11, w10
40ed9244 e603082a mov      w6, w8
40ed9248 4bfd0737 tbnz     w11, #0, #0x40ed91f0
40ed924c 2a010034 cbz      w10, #0x40ed9270
40ed9250 3f190071 cmp      w9, #6
40ed9254 e8079f1a cset     w8, ne
40ed9258 3f0d0071 cmp      w9, #3
40ed925c e9079f1a cset     w9, ne
40ed9260 0801090a and      w8, w8, w9
40ed9264 68000037 tbnz     w8, #0, #0x40ed9270
40ed9268 5f040071 cmp      w2, #1
40ed926c 68f7ff54 b.hi     #0x40ed9158
40ed9270 e82340b9 ldr      w8, [sp, #0x20]
40ed9274 7f001672 tst      w3, #0x400
40ed9278 4800881a csel     w8, w2, w8, eq
40ed927c 1f210071 cmp      w8, #8
40ed9280 e083881a csel     w0, wzr, w8, hi
40ed9284 c0035fd6 ret
