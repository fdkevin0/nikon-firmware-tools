Analytical names; virtual addresses = EG offset + 0x40160000.
Synthetic execution does not emulate the OS, DMA or DSP.

host_load_resource: [0x40c91f3c, 0x40c92194)
40c91f3c  f37bbfa9  stp       x19, x30, [sp, #-0x10]!
40c91f40  f303002a  mov       w19, w0
40c91f44  61110035  cbnz      w1, #0x40c92170
40c91f48  7f160071  cmp       w19, #5
40c91f4c  e8110054  b.hi      #0x40c92188
40c91f50  094d99d2  mov       x9, #0xca68
40c91f54  e92ca8f2  movk      x9, #0x4167, lsl #16
40c91f58  0900c0f2  movk      x9, #0, lsl #32
40c91f5c  e803132a  mov       w8, w19
40c91f60  0900e0f2  movk      x9, #0, lsl #48
40c91f64  287968f8  ldr       x8, [x9, x8, lsl #3]
40c91f68  00011fd6  br        x8
40c91f6c  087c80d2  mov       x8, #0x3e0
40c91f70  085da0f2  movk      x8, #0x2e8, lsl #16
40c91f74  4801c0f2  movk      x8, #0xa, lsl #32
40c91f78  0800e0f2  movk      x8, #0, lsl #48
40c91f7c  005499d2  mov       x0, #0xcaa0
40c91f80  e02ca8f2  movk      x0, #0x4167, lsl #16
40c91f84  010140f9  ldr       x1, [x8]
40c91f88  0000c0f2  movk      x0, #0, lsl #32
40c91f8c  0000e0f2  movk      x0, #0, lsl #48
40c91f90  22404091  add       x2, x1, #0x10, lsl #12
40c91f94  18000014  b         #0x40c91ff4
40c91f98  087c80d2  mov       x8, #0x3e0
40c91f9c  085da0f2  movk      x8, #0x2e8, lsl #16
40c91fa0  4801c0f2  movk      x8, #0xa, lsl #32
40c91fa4  0800e0f2  movk      x8, #0, lsl #48
40c91fa8  007a8bd2  mov       x0, #0x5bd0
40c91fac  402ea8f2  movk      x0, #0x4172, lsl #16
40c91fb0  080140f9  ldr       x8, [x8]
40c91fb4  0000c0f2  movk      x0, #0, lsl #32
40c91fb8  0000e0f2  movk      x0, #0, lsl #48
40c91fbc  01414991  add       x1, x8, #0x250, lsl #12
40c91fc0  02814991  add       x2, x8, #0x260, lsl #12
40c91fc4  0c000014  b         #0x40c91ff4
40c91fc8  087c80d2  mov       x8, #0x3e0
40c91fcc  085da0f2  movk      x8, #0x2e8, lsl #16
40c91fd0  4801c0f2  movk      x8, #0xa, lsl #32
40c91fd4  0800e0f2  movk      x8, #0, lsl #48
40c91fd8  00248ad2  mov       x0, #0x5120
40c91fdc  202fa8f2  movk      x0, #0x4179, lsl #16
40c91fe0  080140f9  ldr       x8, [x8]
40c91fe4  0000c0f2  movk      x0, #0, lsl #32
40c91fe8  0000e0f2  movk      x0, #0, lsl #48
40c91fec  01815291  add       x1, x8, #0x4a0, lsl #12
40c91ff0  02c15291  add       x2, x8, #0x4b0, lsl #12
40c91ff4  68000094  bl        #0x40c92194
40c91ff8  5e000014  b         #0x40c92170
40c91ffc  087c80d2  mov       x8, #0x3e0
40c92000  085da0f2  movk      x8, #0x2e8, lsl #16
40c92004  4801c0f2  movk      x8, #0xa, lsl #32
40c92008  0800e0f2  movk      x8, #0, lsl #48
40c9200c  090080d2  mov       x9, #0
40c92010  0930a0f2  movk      x9, #0x180, lsl #16
40c92014  080140f9  ldr       x8, [x8]
40c92018  4901c0f2  movk      x9, #0xa, lsl #32
40c9201c  0900e0f2  movk      x9, #0, lsl #48
40c92020  00c16b91  add       x0, x8, #0xaf0, lsl #12
40c92024  1f0009eb  cmp       x0, x9
40c92028  43090054  b.lo      #0x40c92150
40c9202c  020080d2  mov       x2, #0
40c92030  0200a0f2  movk      x2, #0, lsl #16
40c92034  080080d2  mov       x8, #0
40c92038  0200c0f2  movk      x2, #0, lsl #32
40c9203c  0850a0f2  movk      x8, #0x280, lsl #16
40c92040  0200e0f2  movk      x2, #0, lsl #48
40c92044  4801c0f2  movk      x8, #0xa, lsl #32
40c92048  0940228b  add       x9, x0, w2, uxtw
40c9204c  0800e0f2  movk      x8, #0, lsl #48
40c92050  3f0108eb  cmp       x9, x8
40c92054  e2070054  b.hs      #0x40c92150
40c92058  01c681d2  mov       x1, #0xe30
40c9205c  213aa8f2  movk      x1, #0x41d1, lsl #16
40c92060  0100c0f2  movk      x1, #0, lsl #32
40c92064  0100e0f2  movk      x1, #0, lsl #48
40c92068  38000014  b         #0x40c92148
40c9206c  087c80d2  mov       x8, #0x3e0
40c92070  085da0f2  movk      x8, #0x2e8, lsl #16
40c92074  4801c0f2  movk      x8, #0xa, lsl #32
40c92078  0800e0f2  movk      x8, #0, lsl #48
40c9207c  090080d2  mov       x9, #0
40c92080  0930a0f2  movk      x9, #0x180, lsl #16
40c92084  080140f9  ldr       x8, [x8]
40c92088  4901c0f2  movk      x9, #0xa, lsl #32
40c9208c  0900e0f2  movk      x9, #0, lsl #48
40c92090  00c17191  add       x0, x8, #0xc70, lsl #12
40c92094  1f0009eb  cmp       x0, x9
40c92098  c3050054  b.lo      #0x40c92150
40c9209c  02369dd2  mov       x2, #0xe9b0
40c920a0  e201a0f2  movk      x2, #0xf, lsl #16
40c920a4  080080d2  mov       x8, #0
40c920a8  0200c0f2  movk      x2, #0, lsl #32
40c920ac  0850a0f2  movk      x8, #0x280, lsl #16
40c920b0  0200e0f2  movk      x2, #0, lsl #48
40c920b4  4801c0f2  movk      x8, #0xa, lsl #32
40c920b8  0940228b  add       x9, x0, w2, uxtw
40c920bc  0800e0f2  movk      x8, #0, lsl #48
40c920c0  3f0108eb  cmp       x9, x8
40c920c4  62040054  b.hs      #0x40c92150
40c920c8  01c681d2  mov       x1, #0xe30
40c920cc  213aa8f2  movk      x1, #0x41d1, lsl #16
40c920d0  0100c0f2  movk      x1, #0, lsl #32
40c920d4  0100e0f2  movk      x1, #0, lsl #48
40c920d8  1c000014  b         #0x40c92148
40c920dc  087c80d2  mov       x8, #0x3e0
40c920e0  085da0f2  movk      x8, #0x2e8, lsl #16
40c920e4  4801c0f2  movk      x8, #0xa, lsl #32
40c920e8  0800e0f2  movk      x8, #0, lsl #48
40c920ec  090080d2  mov       x9, #0
40c920f0  0930a0f2  movk      x9, #0x180, lsl #16
40c920f4  080140f9  ldr       x8, [x8]
40c920f8  4901c0f2  movk      x9, #0xa, lsl #32
40c920fc  0900e0f2  movk      x9, #0, lsl #48
40c92100  00c17791  add       x0, x8, #0xdf0, lsl #12
40c92104  1f0009eb  cmp       x0, x9
40c92108  43020054  b.lo      #0x40c92150
40c9210c  02ee90d2  mov       x2, #0x8770
40c92110  0202a0f2  movk      x2, #0x10, lsl #16
40c92114  080080d2  mov       x8, #0
40c92118  0200c0f2  movk      x2, #0, lsl #32
40c9211c  0850a0f2  movk      x8, #0x280, lsl #16
40c92120  0200e0f2  movk      x2, #0, lsl #48
40c92124  4801c0f2  movk      x8, #0xa, lsl #32
40c92128  0940228b  add       x9, x0, w2, uxtw
40c9212c  0800e0f2  movk      x8, #0, lsl #48
40c92130  3f0108eb  cmp       x9, x8
40c92134  e2000054  b.hs      #0x40c92150
40c92138  01fc9ed2  mov       x1, #0xf7e0
40c9213c  013ca8f2  movk      x1, #0x41e0, lsl #16
40c92140  0100c0f2  movk      x1, #0, lsl #32
40c92144  0100e0f2  movk      x1, #0, lsl #48
40c92148  2d5d0094  bl        #0x40ca95fc
40c9214c  09000014  b         #0x40c92170
40c92150  c87d80d2  mov       x8, #0x3ee
40c92154  085da0f2  movk      x8, #0x2e8, lsl #16
40c92158  4801c0f2  movk      x8, #0xa, lsl #32
40c9215c  0800e0f2  movk      x8, #0, lsl #48
40c92160  09014039  ldrb      w9, [x8]
40c92164  69000037  tbnz      w9, #0, #0x40c92170
40c92168  e9030032  mov       w9, #1
40c9216c  09010039  strb      w9, [x8]
40c92170  087d80d2  mov       x8, #0x3e8
40c92174  085da0f2  movk      x8, #0x2e8, lsl #16
40c92178  4801c0f2  movk      x8, #0xa, lsl #32
40c9217c  0800e0f2  movk      x8, #0, lsl #48
40c92180  e9030032  mov       w9, #1
40c92184  09493338  strb      w9, [x8, w19, uxtw]
40c92188  e0031f2a  mov       w0, wzr
40c9218c  f37bc1a8  ldp       x19, x30, [sp], #0x10
40c92190  c0035fd6  ret

host_get_network: [0x40c9233c, 0x40c92434)
40c9233c  1f5c0071  cmp       w0, #0x17
40c92340  c0020054  b.eq      #0x40c92398
40c92344  1f800071  cmp       w0, #0x20
40c92348  a0040054  b.eq      #0x40c923dc
40c9234c  1f7c0071  cmp       w0, #0x1f
40c92350  81060054  b.ne      #0x40c92420
40c92354  087d80d2  mov       x8, #0x3e8
40c92358  085da0f2  movk      x8, #0x2e8, lsl #16
40c9235c  4801c0f2  movk      x8, #0xa, lsl #32
40c92360  0800e0f2  movk      x8, #0, lsl #48
40c92364  08154039  ldrb      w8, [x8, #5]
40c92368  c8050034  cbz       w8, #0x40c92420
40c9236c  087c80d2  mov       x8, #0x3e0
40c92370  085da0f2  movk      x8, #0x2e8, lsl #16
40c92374  4801c0f2  movk      x8, #0xa, lsl #32
40c92378  0800e0f2  movk      x8, #0, lsl #48
40c9237c  090140f9  ldr       x9, [x8]
40c92380  08ee90d2  mov       x8, #0x8770
40c92384  0802a0f2  movk      x8, #0x10, lsl #16
40c92388  0800c0f2  movk      x8, #0, lsl #32
40c9238c  0800e0f2  movk      x8, #0, lsl #48
40c92390  29c17791  add       x9, x9, #0xdf0, lsl #12
40c92394  25000014  b         #0x40c92428
40c92398  087d80d2  mov       x8, #0x3e8
40c9239c  085da0f2  movk      x8, #0x2e8, lsl #16
40c923a0  4801c0f2  movk      x8, #0xa, lsl #32
40c923a4  0800e0f2  movk      x8, #0, lsl #48
40c923a8  080d4039  ldrb      w8, [x8, #3]
40c923ac  a8030034  cbz       w8, #0x40c92420
40c923b0  087c80d2  mov       x8, #0x3e0
40c923b4  085da0f2  movk      x8, #0x2e8, lsl #16
40c923b8  4801c0f2  movk      x8, #0xa, lsl #32
40c923bc  0800e0f2  movk      x8, #0, lsl #48
40c923c0  090140f9  ldr       x9, [x8]
40c923c4  080080d2  mov       x8, #0
40c923c8  0800a0f2  movk      x8, #0, lsl #16
40c923cc  0800c0f2  movk      x8, #0, lsl #32
40c923d0  0800e0f2  movk      x8, #0, lsl #48
40c923d4  29c16b91  add       x9, x9, #0xaf0, lsl #12
40c923d8  14000014  b         #0x40c92428
40c923dc  087d80d2  mov       x8, #0x3e8
40c923e0  085da0f2  movk      x8, #0x2e8, lsl #16
40c923e4  4801c0f2  movk      x8, #0xa, lsl #32
40c923e8  0800e0f2  movk      x8, #0, lsl #48
40c923ec  08114039  ldrb      w8, [x8, #4]
40c923f0  88010034  cbz       w8, #0x40c92420
40c923f4  087c80d2  mov       x8, #0x3e0
40c923f8  085da0f2  movk      x8, #0x2e8, lsl #16
40c923fc  4801c0f2  movk      x8, #0xa, lsl #32
40c92400  0800e0f2  movk      x8, #0, lsl #48
40c92404  090140f9  ldr       x9, [x8]
40c92408  08369dd2  mov       x8, #0xe9b0
40c9240c  e801a0f2  movk      x8, #0xf, lsl #16
40c92410  0800c0f2  movk      x8, #0, lsl #32
40c92414  0800e0f2  movk      x8, #0, lsl #48
40c92418  29c17191  add       x9, x9, #0xc70, lsl #12
40c9241c  03000014  b         #0x40c92428
40c92420  e9031faa  mov       x9, xzr
40c92424  e8031f2a  mov       w8, wzr
40c92428  290000f9  str       x9, [x1]
40c9242c  480000b9  str       w8, [x2]
40c92430  c0035fd6  ret

host_initialize_cdnn: [0x40fe85e4, 0x40fe86f8)
40fe85e4  ff0301d1  sub       sp, sp, #0x40
40fe85e8  f75b01a9  stp       x23, x22, [sp, #0x10]
40fe85ec  f55302a9  stp       x21, x20, [sp, #0x20]
40fe85f0  f37b03a9  stp       x19, x30, [sp, #0x30]
40fe85f4  17bd83d2  mov       x23, #0x1de8
40fe85f8  b777a0f2  movk      x23, #0x3bd, lsl #16
40fe85fc  5701c0f2  movk      x23, #0xa, lsl #32
40fe8600  1700e0f2  movk      x23, #0, lsl #48
40fe8604  f30300aa  mov       x19, x0
40fe8608  f40240f9  ldr       x20, [x23]
40fe860c  e00314aa  mov       x0, x20
40fe8610  5c780694  bl        #0x41186780
40fe8614  f50300aa  mov       x21, x0
40fe8618  02098052  mov       w2, #0x48
40fe861c  e00314aa  mov       x0, x20
40fe8620  e1031f2a  mov       w1, wzr
40fe8624  47490a94  bl        #0x4127ab40
40fe8628  e0130032  mov       w0, #0x1f
40fe862c  ff0700f9  str       xzr, [sp, #8]
40fe8630  e1230091  add       x1, sp, #8
40fe8634  ff0700b9  str       wzr, [sp, #4]
40fe8638  e2130091  add       x2, sp, #4
40fe863c  40a7f297  bl        #0x40c9233c
40fe8640  e80740f9  ldr       x8, [sp, #8]
40fe8644  e0031b32  mov       w0, #0x20
40fe8648  e90740b9  ldr       w9, [sp, #4]
40fe864c  e1230091  add       x1, sp, #8
40fe8650  e2130091  add       x2, sp, #4
40fe8654  88a601a9  stp       x8, x9, [x20, #0x18]
40fe8658  39a7f297  bl        #0x40c9233c
40fe865c  e80740f9  ldr       x8, [sp, #8]
40fe8660  e0031f2a  mov       w0, wzr
40fe8664  e90740b9  ldr       w9, [sp, #4]
40fe8668  88a600a9  stp       x8, x9, [x20, #8]
40fe866c  c80300b4  cbz       x8, #0x40fe86e4
40fe8670  880e40f9  ldr       x8, [x20, #0x18]
40fe8674  880300b4  cbz       x8, #0x40fe86e4
40fe8678  08008152  mov       w8, #0x800
40fe867c  2800a072  movk      w8, #1, lsl #16
40fe8680  0cdf90d2  mov       x12, #0x86f8
40fe8684  cc1fa8f2  movk      x12, #0x40fe, lsl #16
40fe8688  0aa08952  mov       w10, #0x4d00
40fe868c  880200b9  str       w8, [x20]
40fe8690  0c00c0f2  movk      x12, #0, lsl #32
40fe8694  a9020291  add       x9, x21, #0x80
40fe8698  0a07a072  movk      w10, #0x38, lsl #16
40fe869c  eb031f32  mov       w11, #2
40fe86a0  0c00e0f2  movk      x12, #0, lsl #48
40fe86a4  a8038052  mov       w8, #0x1d
40fe86a8  89aa03a9  stp       x9, x10, [x20, #0x38]
40fe86ac  01098052  mov       w1, #0x48
40fe86b0  ebb203b9  str       w11, [x23, #0x3b0]
40fe86b4  e00314aa  mov       x0, x20
40fe86b8  ecee01f9  str       x12, [x23, #0x3d8]
40fe86bc  e8ba03b9  str       w8, [x23, #0x3b8]
40fe86c0  f6c20e91  add       x22, x23, #0x3b0
40fe86c4  ffd203b9  str       wzr, [x23, #0x3d0]
40fe86c8  f5e201f9  str       x21, [x23, #0x3c0]
40fe86cc  ffe601f9  str       xzr, [x23, #0x3c8]
40fe86d0  7a0cf597  bl        #0x40d2b8b8
40fe86d4  e00316aa  mov       x0, x22
40fe86d8  f3f601f9  str       x19, [x23, #0x3e8]
40fe86dc  b3a0f297  bl        #0x40c909a8
40fe86e0  e0030032  mov       w0, #1
40fe86e4  f37b43a9  ldp       x19, x30, [sp, #0x30]
40fe86e8  f55342a9  ldp       x21, x20, [sp, #0x20]
40fe86ec  f75b41a9  ldp       x23, x22, [sp, #0x10]
40fe86f0  ff030191  add       sp, sp, #0x40
40fe86f4  c0035fd6  ret

initialize_resource_arena_pointer: [0x40c91f08, 0x40c91f30)
40c91f08  087c80d2  mov       x8, #0x3e0
40c91f0c  090080d2  mov       x9, #0
40c91f10  085da0f2  movk      x8, #0x2e8, lsl #16
40c91f14  0930a0f2  movk      x9, #0x180, lsl #16
40c91f18  4801c0f2  movk      x8, #0xa, lsl #32
40c91f1c  4901c0f2  movk      x9, #0xa, lsl #32
40c91f20  0800e0f2  movk      x8, #0, lsl #48
40c91f24  0900e0f2  movk      x9, #0, lsl #48
40c91f28  090100f9  str       x9, [x8]
40c91f2c  c0035fd6  ret

load_elf_program_headers: [0x40c92194, 0x40c92334)
40c92194  fc0f1af8  str       x28, [sp, #-0x60]!
40c92198  fb6b01a9  stp       x27, x26, [sp, #0x10]
40c9219c  f96302a9  stp       x25, x24, [sp, #0x20]
40c921a0  f75b03a9  stp       x23, x22, [sp, #0x30]
40c921a4  f55304a9  stp       x21, x20, [sp, #0x40]
40c921a8  f37b05a9  stp       x19, x30, [sp, #0x50]
40c921ac  f30302aa  mov       x19, x2
40c921b0  f40301aa  mov       x20, x1
40c921b4  f50300aa  mov       x21, x0
40c921b8  0fffff97  bl        #0x40c91df4
40c921bc  a8064039  ldrb      w8, [x21, #1]
40c921c0  1f150171  cmp       w8, #0x45
40c921c4  a10a0054  b.ne      #0x40c92318
40c921c8  a80a4039  ldrb      w8, [x21, #2]
40c921cc  1f310171  cmp       w8, #0x4c
40c921d0  410a0054  b.ne      #0x40c92318
40c921d4  a80e4039  ldrb      w8, [x21, #3]
40c921d8  1f190171  cmp       w8, #0x46
40c921dc  e1090054  b.ne      #0x40c92318
40c921e0  a81e40b9  ldr       w8, [x21, #0x1c]
40c921e4  a8090034  cbz       w8, #0x40c92318
40c921e8  a95a4079  ldrh      w9, [x21, #0x2c]
40c921ec  69090034  cbz       w9, #0x40c92318
40c921f0  180080d2  mov       x24, #0
40c921f4  d97d80d2  mov       x25, #0x3ee
40c921f8  1a0080d2  mov       x26, #0
40c921fc  1830a0f2  movk      x24, #0x180, lsl #16
40c92200  195da0f2  movk      x25, #0x2e8, lsl #16
40c92204  1a50a0f2  movk      x26, #0x280, lsl #16
40c92208  5801c0f2  movk      x24, #0xa, lsl #32
40c9220c  5901c0f2  movk      x25, #0xa, lsl #32
40c92210  5a01c0f2  movk      x26, #0xa, lsl #32
40c92214  f6031faa  mov       x22, xzr
40c92218  f7030032  mov       w23, #1
40c9221c  1800e0f2  movk      x24, #0, lsl #48
40c92220  1900e0f2  movk      x25, #0, lsl #48
40c92224  1a00e0f2  movk      x26, #0, lsl #48
40c92228  fb030032  mov       w27, #1
40c9222c  04000014  b         #0x40c9223c
40c92230  a81e40b9  ldr       w8, [x21, #0x1c]
40c92234  d6820091  add       x22, x22, #0x20
40c92238  7b070091  add       x27, x27, #1
40c9223c  a842288b  add       x8, x21, w8, uxtw
40c92240  096976b8  ldr       w9, [x8, x22]
40c92244  ff0700f9  str       xzr, [sp, #8]
40c92248  3f050071  cmp       w9, #1
40c9224c  01060054  b.ne      #0x40c9230c
40c92250  1c01168b  add       x28, x8, x22
40c92254  810b40b9  ldr       w1, [x28, #8]
40c92258  287c5ed3  ubfx      x8, x1, #0x1e, #2
40c9225c  a8000035  cbnz      w8, #0x40c92270
40c92260  88634039  ldrb      w8, [x28, #0x18]
40c92264  e8000037  tbnz      w8, #0, #0x40c92280
40c92268  2800138b  add       x8, x1, x19
40c9226c  06000014  b         #0x40c92284
40c92270  e0071b32  mov       w0, #0x60
40c92274  e2230091  add       x2, sp, #8
40c92278  1e920094  bl        #0x40cb6af0
40c9227c  03000014  b         #0x40c92288
40c92280  2800148b  add       x8, x1, x20
40c92284  e80700f9  str       x8, [sp, #8]
40c92288  821340b9  ldr       w2, [x28, #0x10]
40c9228c  e2010034  cbz       w2, #0x40c922c8
40c92290  e00740f9  ldr       x0, [sp, #8]
40c92294  1f0018eb  cmp       x0, x24
40c92298  23010054  b.lo      #0x40c922bc
40c9229c  0800028b  add       x8, x0, x2
40c922a0  1f011aeb  cmp       x8, x26
40c922a4  c2000054  b.hs      #0x40c922bc
40c922a8  880740b9  ldr       w8, [x28, #4]
40c922ac  0101158b  add       x1, x8, x21
40c922b0  d35c0094  bl        #0x40ca95fc
40c922b4  821340b9  ldr       w2, [x28, #0x10]
40c922b8  04000014  b         #0x40c922c8
40c922bc  28034039  ldrb      w8, [x25]
40c922c0  48000037  tbnz      w8, #0, #0x40c922c8
40c922c4  37030039  strb      w23, [x25]
40c922c8  881740b9  ldr       w8, [x28, #0x14]
40c922cc  0801026b  subs      w8, w8, w2
40c922d0  e0010054  b.eq      #0x40c9230c
40c922d4  e90740f9  ldr       x9, [sp, #8]
40c922d8  2041228b  add       x0, x9, w2, uxtw
40c922dc  1f0018eb  cmp       x0, x24
40c922e0  03010054  b.lo      #0x40c92300
40c922e4  0940288b  add       x9, x0, w8, uxtw
40c922e8  3f011aeb  cmp       x9, x26
40c922ec  a2000054  b.hs      #0x40c92300
40c922f0  e1031f2a  mov       w1, wzr
40c922f4  e203082a  mov       w2, w8
40c922f8  465f0094  bl        #0x40caa010
40c922fc  04000014  b         #0x40c9230c
40c92300  28034039  ldrb      w8, [x25]
40c92304  48000037  tbnz      w8, #0, #0x40c9230c
40c92308  37030039  strb      w23, [x25]
40c9230c  a85a4079  ldrh      w8, [x21, #0x2c]
40c92310  7f0308eb  cmp       x27, x8
40c92314  e3f8ff54  b.lo      #0x40c92230
40c92318  f37b45a9  ldp       x19, x30, [sp, #0x50]
40c9231c  f55344a9  ldp       x21, x20, [sp, #0x40]
40c92320  f75b43a9  ldp       x23, x22, [sp, #0x30]
40c92324  f96342a9  ldp       x25, x24, [sp, #0x20]
40c92328  fb6b41a9  ldp       x27, x26, [sp, #0x10]
40c9232c  fc0746f8  ldr       x28, [sp], #0x60
40c92330  c0035fd6  ret

queue_dsp_request: [0x40c909a8, 0x40c90aec)
40c909a8  f37bbfa9  stp       x19, x30, [sp, #-0x10]!
40c909ac  f30300aa  mov       x19, x0
40c909b0  09da9cd2  mov       x9, #0xe6d0
40c909b4  e95ca0f2  movk      x9, #0x2e7, lsl #16
40c909b8  6b0240b9  ldr       w11, [x19]
40c909bc  08338152  mov       w8, #0x998
40c909c0  6a2240b9  ldr       w10, [x19, #0x20]
40c909c4  4901c0f2  movk      x9, #0xa, lsl #32
40c909c8  0900e0f2  movk      x9, #0, lsl #48
40c909cc  e20313aa  mov       x2, x19
40c909d0  6025089b  madd      x0, x11, x8, x9
40c909d4  e8071932  mov       w8, #0x180
40c909d8  5f0100f1  cmp       x10, #0
40c909dc  4801089b  madd      x8, x10, x8, x0
40c909e0  e9031832  mov       w9, #0x100
40c909e4  eb031932  mov       w11, #0x80
40c909e8  6301891a  csel      w3, w11, w9, eq
40c909ec  01011491  add       x1, x8, #0x500
40c909f0  0c000094  bl        #0x40c90a20
40c909f4  60000036  tbz       w0, #0, #0x40c90a00
40c909f8  f37bc1a8  ldp       x19, x30, [sp], #0x10
40c909fc  c0035fd6  ret
40c90a00  e8030432  mov       w8, #0x10000000
40c90a04  621640f9  ldr       x2, [x19, #0x28]
40c90a08  60008052  mov       w0, #3
40c90a0c  0043a872  movk      w0, #0x4218, lsl #16
40c90a10  e10313aa  mov       x1, x19
40c90a14  683200b9  str       w8, [x19, #0x30]
40c90a18  f37bc1a8  ldp       x19, x30, [sp], #0x10
40c90a1c  40001fd6  br        x2
40c90a20  f60f1df8  str       x22, [sp, #-0x30]!
40c90a24  f55301a9  stp       x21, x20, [sp, #0x10]
40c90a28  f37b02a9  stp       x19, x30, [sp, #0x20]
40c90a2c  f60301aa  mov       x22, x1
40c90a30  f50300aa  mov       x21, x0
40c90a34  e00316aa  mov       x0, x22
40c90a38  f303032a  mov       w19, w3
40c90a3c  f40302aa  mov       x20, x2
40c90a40  8ea8ff97  bl        #0x40c7ac78
40c90a44  e80300aa  mov       x8, x0
40c90a48  480100b4  cbz       x8, #0x40c90a70
40c90a4c  e00316aa  mov       x0, x22
40c90a50  140d00f9  str       x20, [x8, #0x18]
40c90a54  e10308aa  mov       x1, x8
40c90a58  dda8ff97  bl        #0x40c7adcc
40c90a5c  e00315aa  mov       x0, x21
40c90a60  e103132a  mov       w1, w19
40c90a64  39befd97  bl        #0x40c00348
40c90a68  e0030032  mov       w0, #1
40c90a6c  1c000014  b         #0x40c90adc
40c90a70  880240b9  ldr       w8, [x20]
40c90a74  7f020171  cmp       w19, #0x40
40c90a78  61010054  b.ne      #0x40c90aa4
40c90a7c  c97380d2  mov       x9, #0x39e
40c90a80  095da0f2  movk      x9, #0x2e8, lsl #16
40c90a84  4901c0f2  movk      x9, #0xa, lsl #32
40c90a88  0900e0f2  movk      x9, #0, lsl #48
40c90a8c  2a696838  ldrb      w10, [x9, x8]
40c90a90  ca010035  cbnz      w10, #0x40c90ac8
40c90a94  ea030032  mov       w10, #1
40c90a98  e0031f2a  mov       w0, wzr
40c90a9c  2a692838  strb      w10, [x9, x8]
40c90aa0  0f000014  b         #0x40c90adc
40c90aa4  097380d2  mov       x9, #0x398
40c90aa8  8a2240b9  ldr       w10, [x20, #0x20]
40c90aac  095da0f2  movk      x9, #0x2e8, lsl #16
40c90ab0  4901c0f2  movk      x9, #0xa, lsl #32
40c90ab4  0900e0f2  movk      x9, #0, lsl #48
40c90ab8  2805088b  add       x8, x9, x8, lsl #1
40c90abc  08010a8b  add       x8, x8, x10
40c90ac0  09014039  ldrb      w9, [x8]
40c90ac4  69000034  cbz       w9, #0x40c90ad0
40c90ac8  e0031f2a  mov       w0, wzr
40c90acc  04000014  b         #0x40c90adc
40c90ad0  e9030032  mov       w9, #1
40c90ad4  e0031f2a  mov       w0, wzr
40c90ad8  09010039  strb      w9, [x8]
40c90adc  f37b42a9  ldp       x19, x30, [sp, #0x20]
40c90ae0  f55341a9  ldp       x21, x20, [sp, #0x10]
40c90ae4  f60743f8  ldr       x22, [sp], #0x30
40c90ae8  c0035fd6  ret

animal_submission_dsp_branch_excerpt: [0x40fe73c8, 0x40fe7510)
40fe73c8  ff4301d1  sub       sp, sp, #0x50
40fe73cc  f96301a9  stp       x25, x24, [sp, #0x10]
40fe73d0  f75b02a9  stp       x23, x22, [sp, #0x20]
40fe73d4  f55303a9  stp       x21, x20, [sp, #0x30]
40fe73d8  f37b04a9  stp       x19, x30, [sp, #0x40]
40fe73dc  18bd83d2  mov       x24, #0x1de8
40fe73e0  b877a0f2  movk      x24, #0x3bd, lsl #16
40fe73e4  5801c0f2  movk      x24, #0xa, lsl #32
40fe73e8  f30301aa  mov       x19, x1
40fe73ec  1800e0f2  movk      x24, #0, lsl #48
40fe73f0  f40300aa  mov       x20, x0
40fe73f4  5f040071  cmp       w2, #1
40fe73f8  02f303b9  str       w2, [x24, #0x3f0]
40fe73fc  a1080054  b.ne      #0x40fe7510
40fe7400  190340f9  ldr       x25, [x24]
40fe7404  08b08952  mov       w8, #0x4d80
40fe7408  0807a072  movk      w8, #0x38, lsl #16
40fe740c  3603088b  add       x22, x25, x8
40fe7410  e00316aa  mov       x0, x22
40fe7414  db7c0694  bl        #0x41186780
40fe7418  08b88952  mov       w8, #0x4dc0
40fe741c  0807a072  movk      w8, #0x38, lsl #16
40fe7420  3703088b  add       x23, x25, x8
40fe7424  f50300aa  mov       x21, x0
40fe7428  89b18952  mov       w9, #0x4d8c
40fe742c  0ab98952  mov       w10, #0x4dc8
40fe7430  ff0200f9  str       xzr, [x23]
40fe7434  0bbb8952  mov       w11, #0x4dd8
40fe7438  8e0e40f9  ldr       x14, [x20, #0x18]
40fe743c  0907a072  movk      w9, #0x38, lsl #16
40fe7440  e8070032  mov       w8, #3
40fe7444  0a07a072  movk      w10, #0x38, lsl #16
40fe7448  0b07a072  movk      w11, #0x38, lsl #16
40fe744c  ac020291  add       x12, x21, #0x80
40fe7450  286b2978  strh      w8, [x25, x9]
40fe7454  ad020691  add       x13, x21, #0x180
40fe7458  09b18952  mov       w9, #0x4d88
40fe745c  2c6b2af8  str       x12, [x25, x10]
40fe7460  0907a072  movk      w9, #0x38, lsl #16
40fe7464  2d6b2bf8  str       x13, [x25, x11]
40fe7468  4bb18952  mov       w11, #0x4d8a
40fe746c  c86d4079  ldrh      w8, [x14, #0x36]
40fe7470  0b07a072  movk      w11, #0x38, lsl #16
40fe7474  ca714079  ldrh      w10, [x14, #0x38]
40fe7478  cdb18952  mov       w13, #0x4d8e
40fe747c  cc514079  ldrh      w12, [x14, #0x28]
40fe7480  0d07a072  movk      w13, #0x38, lsl #16
40fe7484  ce2940f9  ldr       x14, [x14, #0x50]
40fe7488  e1031c32  mov       w1, #0x10
40fe748c  286b2978  strh      w8, [x25, x9]
40fe7490  08ba8952  mov       w8, #0x4dd0
40fe7494  2a6b2b78  strh      w10, [x25, x11]
40fe7498  0abc8952  mov       w10, #0x4de0
40fe749c  0807a072  movk      w8, #0x38, lsl #16
40fe74a0  2c6b2d78  strh      w12, [x25, x13]
40fe74a4  e9031832  mov       w9, #0x100
40fe74a8  ce0200f9  str       x14, [x22]
40fe74ac  0a07a072  movk      w10, #0x38, lsl #16
40fe74b0  e00316aa  mov       x0, x22
40fe74b4  296b28f8  str       x9, [x25, x8]
40fe74b8  296b2af8  str       x9, [x25, x10]
40fe74bc  ff10f597  bl        #0x40d2b8b8
40fe74c0  01058052  mov       w1, #0x28
40fe74c4  e00317aa  mov       x0, x23
40fe74c8  4011f597  bl        #0x40d2b9c8
40fe74cc  09df90d2  mov       x9, #0x86f8
40fe74d0  1f1b04b9  str       wzr, [x24, #0x418]
40fe74d4  c91fa8f2  movk      x9, #0x40fe, lsl #16
40fe74d8  150702f9  str       x21, [x24, #0x408]
40fe74dc  0900c0f2  movk      x9, #0, lsl #32
40fe74e0  13db02f9  str       x19, [x24, #0x5b0]
40fe74e4  e8031f32  mov       w8, #2
40fe74e8  ea130032  mov       w10, #0x1f
40fe74ec  ab020191  add       x11, x21, #0x40
40fe74f0  0900e0f2  movk      x9, #0, lsl #48
40fe74f4  08fb03b9  str       w8, [x24, #0x3f8]
40fe74f8  00e30f91  add       x0, x24, #0x3f8
40fe74fc  0a0304b9  str       w10, [x24, #0x400]
40fe7500  0b0b02f9  str       x11, [x24, #0x410]
40fe7504  091302f9  str       x9, [x24, #0x420]
40fe7508  28a5f297  bl        #0x40c909a8
40fe750c  60000014  b         #0x40fe768c

vehicle_submission_dsp_branch_excerpt: [0x40fe7b84, 0x40fe7cc4)
40fe7b84  ff4301d1  sub       sp, sp, #0x50
40fe7b88  f96301a9  stp       x25, x24, [sp, #0x10]
40fe7b8c  f75b02a9  stp       x23, x22, [sp, #0x20]
40fe7b90  f55303a9  stp       x21, x20, [sp, #0x30]
40fe7b94  f37b04a9  stp       x19, x30, [sp, #0x40]
40fe7b98  18bd83d2  mov       x24, #0x1de8
40fe7b9c  b877a0f2  movk      x24, #0x3bd, lsl #16
40fe7ba0  5801c0f2  movk      x24, #0xa, lsl #32
40fe7ba4  f30301aa  mov       x19, x1
40fe7ba8  1800e0f2  movk      x24, #0, lsl #48
40fe7bac  f50300aa  mov       x21, x0
40fe7bb0  5f040071  cmp       w2, #1
40fe7bb4  02bb05b9  str       w2, [x24, #0x5b8]
40fe7bb8  61080054  b.ne      #0x40fe7cc4
40fe7bbc  190340f9  ldr       x25, [x24]
40fe7bc0  36174e91  add       x22, x25, #0x385, lsl #12
40fe7bc4  e00316aa  mov       x0, x22
40fe7bc8  ee7a0694  bl        #0x41186780
40fe7bcc  08088a52  mov       w8, #0x5040
40fe7bd0  0807a072  movk      w8, #0x38, lsl #16
40fe7bd4  3703088b  add       x23, x25, x8
40fe7bd8  f40300aa  mov       x20, x0
40fe7bdc  89018a52  mov       w9, #0x500c
40fe7be0  0a098a52  mov       w10, #0x5048
40fe7be4  ff0200f9  str       xzr, [x23]
40fe7be8  0b0b8a52  mov       w11, #0x5058
40fe7bec  ae0e40f9  ldr       x14, [x21, #0x18]
40fe7bf0  0907a072  movk      w9, #0x38, lsl #16
40fe7bf4  e8070032  mov       w8, #3
40fe7bf8  0a07a072  movk      w10, #0x38, lsl #16
40fe7bfc  0b07a072  movk      w11, #0x38, lsl #16
40fe7c00  8c020291  add       x12, x20, #0x80
40fe7c04  286b2978  strh      w8, [x25, x9]
40fe7c08  8d020691  add       x13, x20, #0x180
40fe7c0c  09018a52  mov       w9, #0x5008
40fe7c10  2c6b2af8  str       x12, [x25, x10]
40fe7c14  0907a072  movk      w9, #0x38, lsl #16
40fe7c18  2d6b2bf8  str       x13, [x25, x11]
40fe7c1c  4b018a52  mov       w11, #0x500a
40fe7c20  c86d4079  ldrh      w8, [x14, #0x36]
40fe7c24  0b07a072  movk      w11, #0x38, lsl #16
40fe7c28  ca714079  ldrh      w10, [x14, #0x38]
40fe7c2c  cd018a52  mov       w13, #0x500e
40fe7c30  cc514079  ldrh      w12, [x14, #0x28]
40fe7c34  0d07a072  movk      w13, #0x38, lsl #16
40fe7c38  ce2940f9  ldr       x14, [x14, #0x50]
40fe7c3c  e1031c32  mov       w1, #0x10
40fe7c40  286b2978  strh      w8, [x25, x9]
40fe7c44  080a8a52  mov       w8, #0x5050
40fe7c48  2a6b2b78  strh      w10, [x25, x11]
40fe7c4c  0a0c8a52  mov       w10, #0x5060
40fe7c50  0807a072  movk      w8, #0x38, lsl #16
40fe7c54  2c6b2d78  strh      w12, [x25, x13]
40fe7c58  e9031832  mov       w9, #0x100
40fe7c5c  ce0200f9  str       x14, [x22]
40fe7c60  0a07a072  movk      w10, #0x38, lsl #16
40fe7c64  e00316aa  mov       x0, x22
40fe7c68  296b28f8  str       x9, [x25, x8]
40fe7c6c  296b2af8  str       x9, [x25, x10]
40fe7c70  120ff597  bl        #0x40d2b8b8
40fe7c74  01058052  mov       w1, #0x28
40fe7c78  e00317aa  mov       x0, x23
40fe7c7c  530ff597  bl        #0x40d2b9c8
40fe7c80  09df90d2  mov       x9, #0x86f8
40fe7c84  1fe305b9  str       wzr, [x24, #0x5e0]
40fe7c88  c91fa8f2  movk      x9, #0x40fe, lsl #16
40fe7c8c  14eb02f9  str       x20, [x24, #0x5d0]
40fe7c90  0900c0f2  movk      x9, #0, lsl #32
40fe7c94  13bb03f9  str       x19, [x24, #0x770]
40fe7c98  e8031f32  mov       w8, #2
40fe7c9c  ea031b32  mov       w10, #0x20
40fe7ca0  8b020191  add       x11, x20, #0x40
40fe7ca4  0900e0f2  movk      x9, #0, lsl #48
40fe7ca8  08c305b9  str       w8, [x24, #0x5c0]
40fe7cac  00031791  add       x0, x24, #0x5c0
40fe7cb0  0acb05b9  str       w10, [x24, #0x5c8]
40fe7cb4  0bef02f9  str       x11, [x24, #0x5d8]
40fe7cb8  09f702f9  str       x9, [x24, #0x5e8]
40fe7cbc  3ba3f297  bl        #0x40c909a8
40fe7cc0  63000014  b         #0x40fe7e4c

cdnn_completion_callback: [0x40fe86f8, 0x40fe879c)
40fe86f8  68008052  mov       w8, #3
40fe86fc  0843a872  movk      w8, #0x4218, lsl #16
40fe8700  1f00086b  cmp       w0, w8
40fe8704  41020054  b.ne      #0x40fe874c
40fe8708  280840b9  ldr       w8, [x1, #8]
40fe870c  1f810071  cmp       w8, #0x20
40fe8710  00020054  b.eq      #0x40fe8750
40fe8714  1f7d0071  cmp       w8, #0x1f
40fe8718  e0020054  b.eq      #0x40fe8774
40fe871c  1f750071  cmp       w8, #0x1d
40fe8720  61010054  b.ne      #0x40fe874c
40fe8724  08bd83d2  mov       x8, #0x1de8
40fe8728  213040b9  ldr       w1, [x1, #0x30]
40fe872c  a877a0f2  movk      x8, #0x3bd, lsl #16
40fe8730  4801c0f2  movk      x8, #0xa, lsl #32
40fe8734  0800e0f2  movk      x8, #0, lsl #48
40fe8738  29008252  mov       w9, #0x1001
40fe873c  c982a072  movk      w9, #0x416, lsl #16
40fe8740  02f541f9  ldr       x2, [x8, #0x3e8]
40fe8744  203d0011  add       w0, w9, #0xf
40fe8748  40001fd6  br        x2
40fe874c  c0035fd6  ret
40fe8750  08bd83d2  mov       x8, #0x1de8
40fe8754  210c40f9  ldr       x1, [x1, #0x18]
40fe8758  a877a0f2  movk      x8, #0x3bd, lsl #16
40fe875c  4801c0f2  movk      x8, #0xa, lsl #32
40fe8760  0800e0f2  movk      x8, #0, lsl #48
40fe8764  20008252  mov       w0, #0x1001
40fe8768  c082a072  movk      w0, #0x416, lsl #16
40fe876c  02b943f9  ldr       x2, [x8, #0x770]
40fe8770  40001fd6  br        x2
40fe8774  08bd83d2  mov       x8, #0x1de8
40fe8778  210c40f9  ldr       x1, [x1, #0x18]
40fe877c  a877a0f2  movk      x8, #0x3bd, lsl #16
40fe8780  4801c0f2  movk      x8, #0xa, lsl #32
40fe8784  0800e0f2  movk      x8, #0, lsl #48
40fe8788  29008252  mov       w9, #0x1001
40fe878c  c982a072  movk      w9, #0x416, lsl #16
40fe8790  02d942f9  ldr       x2, [x8, #0x5b0]
40fe8794  20050011  add       w0, w9, #1
40fe8798  40001fd6  br        x2

address_alias_conversion: [0x41186780, 0x411867b4)
41186780  080080d2  mov       x8, #0
41186784  090080d2  mov       x9, #0
41186788  0800a8f2  movk      x8, #0x4000, lsl #16
4118678c  0900a8f2  movk      x9, #0x4000, lsl #16
41186790  8801c0f2  movk      x8, #0xc, lsl #32
41186794  0901c0f2  movk      x9, #8, lsl #32
41186798  0800e0f2  movk      x8, #0, lsl #48
4118679c  0900e0f2  movk      x9, #0, lsl #48
411867a0  290108cb  sub       x9, x9, x8
411867a4  0900098b  add       x9, x0, x9
411867a8  1f0008eb  cmp       x0, x8
411867ac  2081809a  csel      x0, x9, x0, hi
411867b0  c0035fd6  ret
