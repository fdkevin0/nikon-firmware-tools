Addresses are virtual; offsets are relative to each extracted section.
Candidate names describe hypotheses, not recovered debug symbols.

main_entry: file offset 0x0, base 0x10020000
10020000  202f00ea    b         #0x1002bc88

main_reset: file offset 0xbc88, base 0x10020000
1002bc88  0000a0e3    mov       r0, #0
1002bc8c  0010a0e3    mov       r1, #0
1002bc90  0020a0e3    mov       r2, #0
1002bc94  0030a0e3    mov       r3, #0
1002bc98  0040a0e3    mov       r4, #0
1002bc9c  0050a0e3    mov       r5, #0
1002bca0  0060a0e3    mov       r6, #0
1002bca4  0070a0e3    mov       r7, #0
1002bca8  0080a0e3    mov       r8, #0
1002bcac  0090a0e3    mov       sb, #0
1002bcb0  00a0a0e3    mov       sl, #0
1002bcb4  00b0a0e3    mov       fp, #0
1002bcb8  00c0a0e3    mov       ip, #0
1002bcbc  04d39fe5    ldr       sp, [pc, #0x304]
1002bcc0  00e0a0e3    mov       lr, #0
1002bcc4  100f11ee    mrc       p15, #0, r0, c1, c0, #0
1002bcc8  0100c0e3    bic       r0, r0, #1
1002bccc  0400c0e3    bic       r0, r0, #4
1002bcd0  010ac0e3    bic       r0, r0, #0x1000
1002bcd4  100f01ee    mcr       p15, #0, r0, c1, c0, #0
1002bcd8  6ff07ff5    isb       sy
1002bcdc  300f11ee    mrc       p15, #0, r0, c1, c0, #1
1002bce0  400080e3    orr       r0, r0, #0x40
1002bce4  060ac0e3    bic       r0, r0, #0x6000
1002bce8  300f01ee    mcr       p15, #0, r0, c1, c0, #1
1002bcec  6ff07ff5    isb       sy
1002bcf0  d4029fe5    ldr       r0, [pc, #0x2d4]
1002bcf4  100f02ee    mcr       p15, #0, r0, c2, c0, #0
1002bcf8  d0029fe5    ldr       r0, [pc, #0x2d0]
1002bcfc  100f03ee    mcr       p15, #0, r0, c3, c0, #0
1002bd00  100f11ee    mrc       p15, #0, r0, c1, c0, #0
1002bd04  010080e3    orr       r0, r0, #1
1002bd08  0200c0e3    bic       r0, r0, #2
1002bd0c  040080e3    orr       r0, r0, #4
1002bd10  010a80e3    orr       r0, r0, #0x1000
1002bd14  100f01ee    mcr       p15, #0, r0, c1, c0, #0
1002bd18  4ff07ff5    dsb       sy
1002bd1c  6ff07ff5    isb       sy
1002bd20  ac029fe5    ldr       r0, [pc, #0x2ac]
1002bd24  100f0cee    mcr       p15, #0, r0, c12, c0, #0
1002bd28  6ff07ff5    isb       sy
1002bd2c  b00f10ee    mrc       p15, #0, r0, c0, c0, #5
1002bd30  0f0000e2    and       r0, r0, #0xf
1002bd34  db010ef1    cpsid     aif, #0x1b
1002bd38  98d29fe5    ldr       sp, [pc, #0x298]
1002bd3c  00174de0    sub       r1, sp, r0, lsl #14
1002bd40  01d0a0e1    mov       sp, r1
1002bd44  d7010ef1    cpsid     aif, #0x17
1002bd48  8cd29fe5    ldr       sp, [pc, #0x28c]
1002bd4c  00174de0    sub       r1, sp, r0, lsl #14
1002bd50  01d0a0e1    mov       sp, r1
1002bd54  d1010ef1    cpsid     aif, #0x11
1002bd58  80d29fe5    ldr       sp, [pc, #0x280]
1002bd5c  00174de0    sub       r1, sp, r0, lsl #14
1002bd60  01d0a0e1    mov       sp, r1
1002bd64  d2010ef1    cpsid     aif, #0x12
1002bd68  74d29fe5    ldr       sp, [pc, #0x274]
1002bd6c  00174de0    sub       r1, sp, r0, lsl #14
1002bd70  01d0a0e1    mov       sp, r1
1002bd74  df010ef1    cpsid     aif, #0x1f
1002bd78  68d29fe5    ldr       sp, [pc, #0x268]
1002bd7c  00174de0    sub       r1, sp, r0, lsl #14
1002bd80  01d0a0e1    mov       sp, r1
1002bd84  d3000ef1    cpsid     if, #0x13
1002bd88  5cd29fe5    ldr       sp, [pc, #0x25c]
1002bd8c  00174de0    sub       r1, sp, r0, lsl #14
1002bd90  01d0a0e1    mov       sp, r1
1002bd94  000050e3    cmp       r0, #0
1002bd98  7f00001a    bne       #0x1002bf9c
1002bd9c  4c029fe5    ldr       r0, [pc, #0x24c]
1002bda0  2110a0e3    mov       r1, #0x21
1002bda4  001080e5    str       r1, [r0]
1002bda8  44129fe5    ldr       r1, [pc, #0x244]
1002bdac  201080e5    str       r1, [r0, #0x20]
1002bdb0  0d40a0e1    mov       r4, sp
1002bdb4  3cd29fe5    ldr       sp, [pc, #0x23c]
1002bdb8  3ed1ffeb    bl        #0x100202b8
1002bdbc  4f0600eb    bl        #0x1002d700
1002bdc0  73d1ffeb    bl        #0x10020394
1002bdc4  000050e3    cmp       r0, #0
1002bdc8  0000a013    movne     r0, #0
1002bdcc  38d1ff1b    blne      #0x100202b4
1002bdd0  24029fe5    ldr       r0, [pc, #0x224]
1002bdd4  0111a0e3    mov       r1, #0x40000000
1002bdd8  001080e5    str       r1, [r0]
1002bddc  0211a0e3    mov       r1, #0x80000000
1002bde0  041080e5    str       r1, [r0, #4]
1002bde4  0111a0e3    mov       r1, #0x40000000
1002bde8  081080e5    str       r1, [r0, #8]
1002bdec  0311a0e3    mov       r1, #0xc0000000
1002bdf0  0c1080e5    str       r1, [r0, #0xc]
1002bdf4  0211a0e3    mov       r1, #0x80000000
1002bdf8  101080e5    str       r1, [r0, #0x10]
1002bdfc  0010a0e3    mov       r1, #0
1002be00  141080e5    str       r1, [r0, #0x14]
1002be04  0318a0e3    mov       r1, #0x30000
1002be08  181080e5    str       r1, [r0, #0x18]
1002be0c  0211a0e3    mov       r1, #0x80000000
1002be10  1c1080e5    str       r1, [r0, #0x1c]
1002be14  e4019fe5    ldr       r0, [pc, #0x1e4]
1002be18  0111a0e3    mov       r1, #0x40000000
1002be1c  001080e5    str       r1, [r0]
1002be20  0211a0e3    mov       r1, #0x80000000
1002be24  041080e5    str       r1, [r0, #4]
1002be28  0111a0e3    mov       r1, #0x40000000
1002be2c  081080e5    str       r1, [r0, #8]
1002be30  0311a0e3    mov       r1, #0xc0000000
1002be34  0c1080e5    str       r1, [r0, #0xc]
1002be38  c4019fe5    ldr       r0, [pc, #0x1c4]
1002be3c  0110a0e3    mov       r1, #1
1002be40  001080e5    str       r1, [r0]
1002be44  bc019fe5    ldr       r0, [pc, #0x1bc]
1002be48  0110a0e3    mov       r1, #1
1002be4c  001080e5    str       r1, [r0]
1002be50  2a0100eb    bl        #0x1002c300
1002be54  b0019fe5    ldr       r0, [pc, #0x1b0]
1002be58  000090e5    ldr       r0, [r0]
1002be5c  000050e3    cmp       r0, #0
1002be60  30ff2f11    blxne     r0
1002be64  04d0a0e1    mov       sp, r4
1002be68  a0019fe5    ldr       r0, [pc, #0x1a0]
1002be6c  a0119fe5    ldr       r1, [pc, #0x1a0]
1002be70  ef0000eb    bl        #0x1002c234
1002be74  9c019fe5    ldr       r0, [pc, #0x19c]
1002be78  9c119fe5    ldr       r1, [pc, #0x19c]
1002be7c  9c219fe5    ldr       r2, [pc, #0x19c]
1002be80  032082e2    add       r2, r2, #3
1002be84  0320c2e3    bic       r2, r2, #3
1002be88  180052e3    cmp       r2, #0x18
1002be8c  0500009a    bls       #0x1002bea8
1002be90  f801d0e8    ldm       r0, {r3, r4, r5, r6, r7, r8} ^
1002be94  180080e2    add       r0, r0, #0x18
1002be98  f801c1e8    stm       r1, {r3, r4, r5, r6, r7, r8} ^
1002be9c  181081e2    add       r1, r1, #0x18
1002bea0  182042e2    sub       r2, r2, #0x18
1002bea4  f7ffffea    b         #0x1002be88
1002bea8  040052e3    cmp       r2, #4
1002beac  030000ba    blt       #0x1002bec0
1002beb0  044090e4    ldr       r4, [r0], #4
1002beb4  044081e4    str       r4, [r1], #4
1002beb8  042042e2    sub       r2, r2, #4
1002bebc  f9ffffea    b         #0x1002bea8
1002bec0  000052e3    cmp       r2, #0
1002bec4  02409016    ldrne     r4, [r0], r2
1002bec8  02408116    strne     r4, [r1], r2
1002becc  0100a0e1    mov       r0, r1
1002bed0  4c019fe5    ldr       r0, [pc, #0x14c]
1002bed4  4c119fe5    ldr       r1, [pc, #0x14c]
1002bed8  4c219fe5    ldr       r2, [pc, #0x14c]
1002bedc  032082e2    add       r2, r2, #3
1002bee0  0320c2e3    bic       r2, r2, #3
1002bee4  180052e3    cmp       r2, #0x18
1002bee8  0500009a    bls       #0x1002bf04
1002beec  f801d0e8    ldm       r0, {r3, r4, r5, r6, r7, r8} ^
1002bef0  180080e2    add       r0, r0, #0x18
1002bef4  f801c1e8    stm       r1, {r3, r4, r5, r6, r7, r8} ^
1002bef8  181081e2    add       r1, r1, #0x18
1002befc  182042e2    sub       r2, r2, #0x18
1002bf00  f7ffffea    b         #0x1002bee4
1002bf04  040052e3    cmp       r2, #4
1002bf08  030000ba    blt       #0x1002bf1c
1002bf0c  044090e4    ldr       r4, [r0], #4
1002bf10  044081e4    str       r4, [r1], #4
1002bf14  042042e2    sub       r2, r2, #4
1002bf18  f9ffffea    b         #0x1002bf04
1002bf1c  000052e3    cmp       r2, #0
1002bf20  02409016    ldrne     r4, [r0], r2
1002bf24  02408116    strne     r4, [r1], r2
1002bf28  0100a0e1    mov       r0, r1
1002bf2c  fc009fe5    ldr       r0, [pc, #0xfc]
1002bf30  fc109fe5    ldr       r1, [pc, #0xfc]
1002bf34  fc209fe5    ldr       r2, [pc, #0xfc]
1002bf38  032082e2    add       r2, r2, #3
1002bf3c  0320c2e3    bic       r2, r2, #3
1002bf40  180052e3    cmp       r2, #0x18
1002bf44  0500009a    bls       #0x1002bf60
1002bf48  f801d0e8    ldm       r0, {r3, r4, r5, r6, r7, r8} ^
1002bf4c  180080e2    add       r0, r0, #0x18
1002bf50  f801c1e8    stm       r1, {r3, r4, r5, r6, r7, r8} ^
1002bf54  181081e2    add       r1, r1, #0x18
1002bf58  182042e2    sub       r2, r2, #0x18
1002bf5c  f7ffffea    b         #0x1002bf40
1002bf60  040052e3    cmp       r2, #4
1002bf64  030000ba    blt       #0x1002bf78
1002bf68  044090e4    ldr       r4, [r0], #4
1002bf6c  044081e4    str       r4, [r1], #4
1002bf70  042042e2    sub       r2, r2, #4
1002bf74  f9ffffea    b         #0x1002bf60
1002bf78  000052e3    cmp       r2, #0
1002bf7c  02409016    ldrne     r4, [r0], r2
1002bf80  02408116    strne     r4, [r1], r2
1002bf84  0100a0e1    mov       r0, r1
1002bf88  c40000eb    bl        #0x1002c2a0
1002bf8c  000050e3    cmp       r0, #0
1002bf90  0000a013    movne     r0, #0
1002bf94  c6d0ff1b    blne      #0x100202b4
1002bf98  4a3b08ea    b         #0x1023acc8
1002bf9c  98009fe5    ldr       r0, [pc, #0x98]
1002bfa0  98209fe5    ldr       r2, [pc, #0x98]
1002bfa4  02f020e3    wfe
1002bfa8  5ff07ff5    dmb       sy
1002bfac  001090e5    ldr       r1, [r0]
1002bfb0  020051e1    cmp       r1, r2
1002bfb4  faffff1a    bne       #0x1002bfa4
1002bfb8  0010a0e3    mov       r1, #0
1002bfbc  001080e5    str       r1, [r0]
1002bfc0  5ff07ff5    dmb       sy
1002bfc4  38d0ffea    b         #0x100200ac

main_vectors: file offset 0x14140, base 0x10020000
10034140  18f09fe5    ldr       pc, [pc, #0x18]
10034144  da0300ea    b         #0x100350b4
10034148  14f09fe5    ldr       pc, [pc, #0x14]
1003414c  fe0300ea    b         #0x1003514c
10034150  ea0300ea    b         #0x10035100
10034154  feffffea    b         #0x10034154
10034158  08f09fe5    ldr       pc, [pc, #8]
1003415c  feffffea    b         #0x1003415c

firmware_check_candidate: file offset 0x1a3bba, base 0x10020000
101c3bba  f0b5        push      {r4, r5, r6, r7, lr}
101c3bbc  464c        ldr       r4, [pc, #0x118]
101c3bbe  0025        movs      r5, #0
101c3bc0  9db0        sub       sp, #0x74
101c3bc2  a768        ldr       r7, [r4, #8]
101c3bc4  c7b3        cbz       r7, #0x101c3c38
101c3bc6  2068        ldr       r0, [r4]
101c3bc8  b0b3        cbz       r0, #0x101c3c38
101c3bca  6069        ldr       r0, [r4, #0x14]
101c3bcc  04f11803    add.w     r3, r4, #0x18
101c3bd0  c043        mvns      r0, r0
101c3bd2  0821        movs      r1, #8
101c3bd4  02ba        rev       r2, r0
101c3bd6  a3f10c00    sub.w     r0, r3, #0xc
101c3bda  6261        str       r2, [r4, #0x14]
101c3bdc  0646        mov       r6, r0
101c3bde  b847        blx       r7
101c3be0  d4e90001    ldrd      r0, r1, [r4]
101c3be4  0822        movs      r2, #8
101c3be6  0844        add       r0, r1
101c3be8  3146        mov       r1, r6
101c3bea  adf7cae9    blx       #0x10170f80
101c3bee  6068        ldr       r0, [r4, #4]
101c3bf0  3aa1        adr       r1, #0xe8
101c3bf2  40f29a12    movw      r2, #0x19a
101c3bf6  0830        adds      r0, #8
101c3bf8  6060        str       r0, [r4, #4]
101c3bfa  0120        movs      r0, #1
101c3bfc  15f0acff    bl        #0x101d9b58
101c3c00  3b49        ldr       r1, [pc, #0xec]
101c3c02  0df1040c    add.w     ip, sp, #4
101c3c06  3b4a        ldr       r2, [pc, #0xec]
101c3c08  0020        movs      r0, #0
101c3c0a  3b4f        ldr       r7, [pc, #0xec]
101c3c0c  cb43        mvns      r3, r1
101c3c0e  d643        mvns      r6, r2
101c3c10  8ce8cf00    stm.w     ip, {r0, r1, r2, r3, r6, r7}
101c3c14  0090        str       r0, [sp]
101c3c16  6846        mov       r0, sp
101c3c18  d4e90012    ldrd      r1, r2, [r4]
101c3c1c  fff77bff    bl        #0x101c3b16
101c3c20  17a8        add       r0, sp, #0x5c
101c3c22  6946        mov       r1, sp
101c3c24  00f00bf8    bl        #0x101c3c3e
101c3c28  1422        movs      r2, #0x14
101c3c2a  17a9        add       r1, sp, #0x5c
101c3c2c  04f12000    add.w     r0, r4, #0x20
101c3c30  30f0b4fa    bl        #0x101f419c
101c3c34  00b9        cbnz      r0, #0x101c3c38
101c3c36  0125        movs      r5, #1
101c3c38  1db0        add       sp, #0x74
101c3c3a  2846        mov       r0, r5
101c3c3c  f0bd        pop       {r4, r5, r6, r7, pc}

sha1_finalize_candidate: file offset 0x1a3c3e, base 0x10020000
101c3c3e  7cb5        push      {r2, r3, r4, r5, r6, lr}
101c3c40  0500        movs      r5, r0
101c3c42  0c46        mov       r4, r1
101c3c44  01d0        beq       #0x101c3c4a
101c3c46  0120        movs      r0, #1
101c3c48  00e0        b         #0x101c3c4c
101c3c4a  0020        movs      r0, #0
101c3c4c  40f2c912    movw      r2, #0x1c9
101c3c50  22a1        adr       r1, #0x88
101c3c52  15f081ff    bl        #0x101d9b58
101c3c56  0cb1        cbz       r4, #0x101c3c5c
101c3c58  0120        movs      r0, #1
101c3c5a  00e0        b         #0x101c3c5e
101c3c5c  0020        movs      r0, #0
101c3c5e  40f2ca12    movw      r2, #0x1ca
101c3c62  1ea1        adr       r1, #0x78
101c3c64  15f078ff    bl        #0x101d9b58
101c3c68  0022        movs      r2, #0
101c3c6a  6946        mov       r1, sp
101c3c6c  01e0        b         #0x101c3c72
101c3c6e  042a        cmp       r2, #4
101c3c70  01d2        bhs       #0x101c3c76
101c3c72  0120        movs      r0, #1
101c3c74  00e0        b         #0x101c3c78
101c3c76  0020        movs      r0, #0
101c3c78  02f00303    and       r3, r2, #3
101c3c7c  c3f10303    rsb.w     r3, r3, #3
101c3c80  54f82000    ldr.w     r0, [r4, r0, lsl #2]
101c3c84  db00        lsls      r3, r3, #3
101c3c86  d840        lsrs      r0, r3
101c3c88  8854        strb      r0, [r1, r2]
101c3c8a  521c        adds      r2, r2, #1
101c3c8c  082a        cmp       r2, #8
101c3c8e  eed3        blo       #0x101c3c6e
101c3c90  0122        movs      r2, #1
101c3c92  1aa1        adr       r1, #0x68
101c3c94  01e0        b         #0x101c3c9a
101c3c96  0122        movs      r2, #1
101c3c98  14a1        adr       r1, #0x50
101c3c9a  2046        mov       r0, r4
101c3c9c  fff73bff    bl        #0x101c3b16
101c3ca0  2088        ldrh      r0, [r4]
101c3ca2  c0f3c500    ubfx      r0, r0, #3, #6
101c3ca6  3828        cmp       r0, #0x38
101c3ca8  f5d1        bne       #0x101c3c96
101c3caa  0822        movs      r2, #8
101c3cac  6946        mov       r1, sp
101c3cae  2046        mov       r0, r4
101c3cb0  fff731ff    bl        #0x101c3b16
101c3cb4  002d        cmp       r5, #0
101c3cb6  0ed0        beq       #0x101c3cd6
101c3cb8  0022        movs      r2, #0
101c3cba  22f00300    bic       r0, r2, #3
101c3cbe  2044        add       r0, r4
101c3cc0  02f00301    and       r1, r2, #3
101c3cc4  c1f10301    rsb.w     r1, r1, #3
101c3cc8  8068        ldr       r0, [r0, #8]
101c3cca  c900        lsls      r1, r1, #3
101c3ccc  c840        lsrs      r0, r1
101c3cce  a854        strb      r0, [r5, r2]
101c3cd0  521c        adds      r2, r2, #1
101c3cd2  142a        cmp       r2, #0x14
101c3cd4  f1d3        blo       #0x101c3cba
101c3cd6  7cbd        pop       {r2, r3, r4, r5, r6, pc}

file_handling_candidate_near_hdmi_raw: file offset 0x50f156, base 0x10020000
1052f156  2de9f047    push.w    {r4, r5, r6, r7, r8, sb, sl, lr}
1052f15a  96b0        sub       sp, #0x58
1052f15c  8946        mov       sb, r1
1052f15e  1421        movs      r1, #0x14
1052f160  10a8        add       r0, sp, #0x40
1052f162  41f4e3fe    bl        #0x10170f2c
1052f166  d2f6edff    bl        #0x10402144
1052f16a  8246        mov       sl, r0
1052f16c  d2f6f4ff    bl        #0x10402158
1052f170  0024        movs      r4, #0
1052f172  6b48        ldr       r0, [pc, #0x1ac]
1052f174  02a9        add       r1, sp, #8
1052f176  0194        str       r4, [sp, #4]
1052f178  0294        str       r4, [sp, #8]
1052f17a  0394        str       r4, [sp, #0xc]
1052f17c  0494        str       r4, [sp, #0x10]
1052f17e  0594        str       r4, [sp, #0x14]
1052f180  fff7e1ff    bl        #0x1052f146
1052f184  02a8        add       r0, sp, #8
1052f186  abf597fc    bl        #0x102daab8
1052f18a  42f20107    movw      r7, #0x2001
1052f18e  d8b1        cbz       r0, #0x1052f1c8
1052f190  02a9        add       r1, sp, #8
1052f192  06a8        add       r0, sp, #0x18
1052f194  abf571fb    bl        #0x102da87a
1052f198  0022        movs      r2, #0
1052f19a  06a8        add       r0, sp, #0x18
1052f19c  1146        mov       r1, r2
1052f19e  abf56efb    bl        #0x102da87e
1052f1a2  604d        ldr       r5, [pc, #0x180]
1052f1a4  42f21306    movw      r6, #0x2013
1052f1a8  a842        cmp       r0, r5
1052f1aa  0bd1        bne       #0x1052f1c4
1052f1ac  3022        movs      r2, #0x30
1052f1ae  5146        mov       r1, sl
1052f1b0  01ab        add       r3, sp, #4
1052f1b2  06a8        add       r0, sp, #0x18
1052f1b4  abf51cfc    bl        #0x102da9f0
1052f1b8  8046        mov       r8, r0
1052f1ba  06a8        add       r0, sp, #0x18
1052f1bc  abf5a5fb    bl        #0x102da90a
1052f1c0  a845        cmp       r8, r5
1052f1c2  04d0        beq       #0x1052f1ce
1052f1c4  1096        str       r6, [sp, #0x40]
1052f1c6  12e0        b         #0x1052f1ee
1052f1c8  42f20f00    movw      r0, #0x200f
1052f1cc  0ee0        b         #0x1052f1ec
1052f1ce  0199        ldr       r1, [sp, #4]
1052f1d0  5046        mov       r0, sl
1052f1d2  0af5bdf8    bl        #0x10239350
1052f1d6  18b1        cbz       r0, #0x1052f1e0
1052f1d8  0120        movs      r0, #1
1052f1da  16b0        add       sp, #0x58
1052f1dc  bde8f087    pop.w     {r4, r5, r6, r7, r8, sb, sl, pc}
1052f1e0  0220        movs      r0, #2
1052f1e2  401c        adds      r0, r0, #1
1052f1e4  0628        cmp       r0, #6
1052f1e6  fcdb        blt       #0x1052f1e2
1052f1e8  4af20100    movw      r0, #0xa001
1052f1ec  1090        str       r0, [sp, #0x40]
1052f1ee  0522        movs      r2, #5
1052f1f0  3946        mov       r1, r7
1052f1f2  10ab        add       r3, sp, #0x40
1052f1f4  4846        mov       r0, sb
1052f1f6  0094        str       r4, [sp]
1052f1f8  d3f661f8    bl        #0x104022be
1052f1fc  0020        movs      r0, #0
1052f1fe  ece7        b         #0x1052f1da

ex_reset: file offset 0x1c4, base 0x08000000
080001c4  00f020f8    bl        #0x8000208
080001c8  dff82c80    ldr.w     r8, [pc, #0x2c]
080001cc  dff82c90    ldr.w     sb, [pc, #0x2c]
080001d0  dff82ca0    ldr.w     sl, [pc, #0x2c]
080001d4  aaeb090a    sub.w     sl, sl, sb
080001d8  58f8040b    ldr       r0, [r8], #4
080001dc  49f8040b    str       r0, [sb], #4
080001e0  baf1040a    subs.w    sl, sl, #4
080001e4  f8d1        bne       #0x80001d8
080001e6  dff81c80    ldr.w     r8, [pc, #0x1c]
080001ea  dff81090    ldr.w     sb, [pc, #0x10]
080001ee  c8f80090    str.w     sb, [r8]
080001f2  20f0c7b8    b.w       #0x8020384
