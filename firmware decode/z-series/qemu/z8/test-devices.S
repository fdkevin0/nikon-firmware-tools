/* Synthetic hardware contracts, never injected into official firmware. */
.text
.global _start
_start:
    ldr x23, =0xa00000000
    ldr x0, =0x0d151418
    mov w1, #0x50000
    orr w1, w1, #1
    str w1, [x0]
    mov w1, #0x20000
    orr w1, w1, #2
    str w1, [x0]
    ldr w1, [x0]
    cmp w1, #3
    b.ne fail
    ldr x20, =0x0e001100
#ifdef TEST_INVALID_COUNTER
    mov w1, #1
    str w1, [x20, #0x24]
#endif
    mov w1, #1
    str w1, [x20]
    str wzr, [x20]
    mov w1, #99
    str w1, [x20, #4]
    str w1, [x20, #8]
    mov w1, #2
    str w1, [x20, #0x3c]
    mov w1, #1
    str w1, [x20, #0x38]
    ldr x21, =0x0e000100
    mov w1, #9
    str w1, [x21]
    ldr x22, =0x0e000000
    mov w1, #1
    str w1, [x22, #4]
    mov w1, #0x1fff
    str w1, [x22, #0x100c]
    ldr w2, [x22, #0x100c]
    cmp w1, w2
    b.ne fail
    mov w1, #0x1ffe
    str w1, [x22, #0x100c]
    mov w1, #1
    str w1, [x22, #0x1000]
6:  ldr w1, [x20, #0xc]
    cbz w1, 6b
9:  ldr w1, [x21, #0x10]
    tbz w1, #0, 9b
    tbnz w1, #3, fail
    mov w1, #1
    str w1, [x21, #0x10]
    ldr w1, [x21, #0x10]
    cbnz w1, fail
7:  ldr w1, [x21, #0x10]
    tbz w1, #3, 7b
    tbz w1, #0, fail
    mov w1, #9
    str w1, [x21, #0x10]
    ldr w1, [x21, #0x10]
    cbnz w1, fail
    ldr w1, [x22, #0x1000]
    tbnz w1, #0, fail
    str wzr, [x22, #0x1000]
    ldr w4, [x20, #0xc]
    mov w5, #256
8:  subs w5, w5, #1
    b.ne 8b
    ldr w1, [x20, #0xc]
    cmp w1, w4
    b.ne fail
    ldr x20, =0x0e001b00
    mov w1, #1
    str w1, [x20]
    str wzr, [x20]
    mov w1, #99
    str w1, [x20, #4]
    mov w1, #-1
    str w1, [x20, #8]
    mov w1, #1
    str w1, [x20, #0x10]
    ldr x21, =0x0e000b00
    mov w1, #7
    str w1, [x21]
    mov w1, #0x1bfe
    str w1, [x22, #0x100c]
    mov w1, #0x400
    str w1, [x22, #0x1000]
12: ldr w1, [x20, #0xc]
    cbz w1, 12b
    ldr w1, [x21, #0x10]
    cbnz w1, fail
    str wzr, [x22, #0x1000]
    ldr x20, =0x0e005000
    mov w1, #0x40
    str w1, [x20]
    mov w1, #2
    str w1, [x20]
    mov w1, #4
    str w1, [x20, #0x24]
    ldr w1, [x20, #0x20]
    mov w2, #0x2fb
    cmp w1, w2
    b.ne fail
    mov w1, #0xaa
    str w1, [x20, #0xc]
    mov w1, #0x50
    str w1, [x20, #8]
    ldr w1, [x20, #4]
    tbz w1, #8, fail
10: ldr w1, [x20, #0x10]
    tbz w1, #2, 10b
    tbnz w1, #0, fail
    ldr w1, [x20, #4]
    tbnz w1, #8, fail
    tbnz w1, #5, fail
    mov w1, #4
    str w1, [x20, #0x10]
    ldr w1, [x20, #0x10]
    cbnz w1, fail
    mov w1, #4
    str w1, [x20, #0x28]
    ldr w1, [x20, #0x20]
    mov w2, #0x2ff
    cmp w1, w2
    b.ne fail
    mov w1, #0x40
    str w1, [x20]
#ifdef TEST_INVALID_RX
    ldr w1, [x20, #0xc]
#endif
    ldr x20, =0x0e700000
    str wzr, [x20, #0x60]
    str wzr, [x20, #0xc]
    mov w1, #0x700
    str w1, [x20, #0x10]
    mov w1, #7
    str w1, [x20, #0x20]
#ifdef TEST_INVALID_SPI_DMA
    mov w1, #0x400
    str w1, [x20, #0xc]
#endif
    mov w1, #1
    str w1, [x20, #0x3c]
    str w1, [x20, #0x64]
    mov w1, #0x12
    str w1, [x20]
    mov w1, #0x34
    str w1, [x20]
11: ldr w1, [x20, #0x24]
    tbz w1, #2, 11b
    cmp w1, #7
    b.ne fail
    ldr w1, [x20, #4]
    cmp w1, #255
    b.ne fail
    ldr w1, [x20, #4]
    cmp w1, #255
    b.ne fail
#ifdef TEST_INVALID_SPI_RX
    ldr w1, [x20, #4]
#endif
    mov w1, #7
    str w1, [x20, #0x28]
    ldr w1, [x20, #0x24]
    cbnz w1, fail
    ldr w1, [x20, #0x14]
    cmp w1, #0x24
    b.ne fail
    str wzr, [x20, #0x64]
    ldr x20, =0x155c0000
    mov w1, #1
    str w1, [x20]
    mov w1, #0x20
    str w1, [x20, #0x14]
    mov w1, #4096
    str w1, [x20, #0x1c]
    str w1, [x20, #0x20]
    str w1, [x20, #0x24]
    mov w1, #1
    str w1, [x20, #0x28]
    ldr w1, =0x40162000
    str w1, [x20, #0x30]
    str wzr, [x20, #0x34]
#ifdef TEST_INVALID_DMA
    str w1, [x20, #0x38]
    str wzr, [x20, #0x3c]
#else
    mov w1, #0x10000
    str w1, [x20, #0x38]
    mov w1, #10
    str w1, [x20, #0x3c]
#endif
    bl transfer
    mov w1, #0x21
    str w1, [x20, #0x14]
    mov w1, #-1
    add x0, x23, #0x20, lsl #12
    str w1, [x0]
    str w1, [x0, #4092]
    mov w1, #0x20000
    str w1, [x20, #0x38]
    bl transfer
    add x0, x23, #0x30, lsl #12
    ldr x1, =0xaaaaaaaaaaaaaaaa
    mov w2, #8
13: str x1, [x0], #8
    subs w2, w2, #1
    b.ne 13b
    add x0, x23, #0x40, lsl #12
    ldr w1, =0x01234567
    str w1, [x0]
    ldr w1, =0x89abcdef
    str w1, [x0, #8]
    ldr w1, =0x13579bdf
    str w1, [x0, #16]
    ldr x20, =0x15600000
    mov w1, #1
    str w1, [x20]
    str w1, [x20, #0x40]
    mov w1, #0xb
    str w1, [x20, #4]
    ldr w2, [x20, #4]
    cmp w1, w2
    b.ne fail
    mov w1, #0x20
    str w1, [x20, #0x14]
    mov w1, #8
    str w1, [x20, #0x1c]
    mov w1, #16
    str w1, [x20, #0x20]
    mov w1, #4
    str w1, [x20, #0x24]
    mov w1, #3
    str w1, [x20, #0x28]
    mov w1, #0x40000
    str w1, [x20, #0x30]
    mov w1, #10
    str w1, [x20, #0x34]
    str w1, [x20, #0x3c]
    mov w1, #0x30000
    str w1, [x20, #0x38]
    bl transfer
    add x0, x23, #0x50, lsl #12
    ldr x1, =0xaaaaaaaaaaaaaaaa
    mov w2, #8
14: str x1, [x0], #8
    subs w2, w2, #1
    b.ne 14b
    mov w1, #0x21
    str w1, [x20, #0x14]
    mov w1, #0x12
    str w1, [x20, #0x18]
    mov w1, #0x50000
    str w1, [x20, #0x38]
    bl transfer
    ldr x20, =0x0d158000
    add x0, x20, #0x80
    ldr w1, =0x1c1d1e1f
    ldr w2, =0x04040404
    mov w3, #8
1:  str w1, [x0], #4
    sub w1, w1, w2
    subs w3, w3, #1
    b.ne 1b
    mov w1, #0x80
    str w1, [x20, #0x20]
    mov w1, #0xaa01
    str w1, [x20]
2:  ldr w1, [x20, #0xc]
    tbz w1, #4, 2b
    ldr w1, [x20, #0x18]
    cmp w1, #0x80
    b.ne fail
    mov w1, #0x10
    str w1, [x20, #0x10]
    ldr w1, [x20, #0xc]
    cbnz w1, fail
    mov w1, #0x80
    str w1, [x20, #0x40]
    mov w1, #0xaa02
    str w1, [x20]
3:  ldr w1, [x20, #0xc]
    tbz w1, #5, 3b
    ldr w1, [x20, #0x18]
    cbnz w1, fail
#ifdef TEST_INVALID_GATE
    ldr x0, =0x15083408
    mov w1, #0x4000
    str w1, [x0]
    mov w1, #1
    str w1, [x0, #4]
#endif
    ldr x0, =0x150833e8
#ifdef TEST_INVALID_STAGE
    mov w1, #1
    str w1, [x0]
#endif
    ldr x0, =0x150833c8
    mov w1, #0x12340000
    mov w2, #8
5:  str w1, [x0], #4
    add w1, w1, #1
    subs w2, w2, #1
    b.ne 5b
    mov w1, #1
    str w1, [x0]
    ldr x0, =0x15083408
    mov w1, #0x4000
    str w1, [x0]
    mov w1, #1
    str w1, [x0, #4]
    ldr x0, =0x153c0000
    mov w2, #2
14: ldr w1, [x0, #0x44]
    cbnz w1, fail
    mov w1, #0x70000
    str w1, [x0, #0x44]
    ldr w3, [x0, #0x44]
    cmp w1, w3
    b.ne fail
    mov w1, #1
    str w1, [x0]
    str w1, [x0, #4]
    ldr w3, [x0]
    cmp w1, w3
    b.ne fail
    str wzr, [x0, #0x44]
    add x0, x0, #0x40000
    subs w2, w2, #1
    b.ne 14b
    ldr x0, =0x15340014
    str wzr, [x0]
    ldr x0, =0x15380014
    str wzr, [x0]
    ldr x0, =0x15240044
    mov w1, #2
    str w1, [x0]
    str wzr, [x0, #4]
    ldr x0, =0x15200000
    mov w1, #1
    str w1, [x0]
    str w1, [x0, #4]
    ldr x0, =0x15180014
    str w1, [x0]
    str wzr, [x0]
    ldr x0, =0x151c0014
    str w1, [x0]
    str wzr, [x0]
    ldr x0, =0x15100000
    mov w2, #2
15: str w1, [x0, #0xc]
    str w1, [x0]
    str w1, [x0, #4]
    ldr w3, =0x3807f
    str w3, [x0, #0x14]
    str w3, [x0, #0x18]
    add x0, x0, #0x40000
    subs w2, w2, #1
    b.ne 15b
    ldr x0, =0x15040000
    ldr w1, [x0]
    cbnz w1, fail
    mov w1, #1
    str w1, [x0]
    str wzr, [x0]
    mov w1, #-1
    str w1, [x0, #0x10]
    str w1, [x0, #0x14]
    str w1, [x0, #0x18]
    str w1, [x0, #0x1c]
    mov w1, #1
    str w1, [x0, #0x800]
    ldr w2, [x0, #0x800]
    cmp w1, w2
    b.ne fail
    ldr x0, =0x15000000
    mov w1, #-1
    str w1, [x0]
    ldr x0, =0x0d150310
    mov w2, #2
16: mov w1, #1
    str w1, [x0]
    ldr w3, [x0]
    cmp w1, w3
    b.ne fail
    str wzr, [x0]
    ldr w3, [x0], #4
    cbnz w3, fail
    subs w2, w2, #1
    b.ne 16b
    ldr x0, =0x0d152000
    mov w2, #4
17: mov w1, #0x9e
    str w1, [x0]
    ldr w3, [x0], #8
    cmp w1, w3
    b.ne fail
    subs w2, w2, #1
    b.ne 17b
    ldr x0, =0x0f000010
    ldrh w1, [x0, #0xc]
    cbnz w1, fail
    mov w1, #0x40c
    strh w1, [x0, #0xc]
    ldrh w2, [x0, #0xc]
    cmp w1, w2
    b.ne fail
    mov w1, #0x700
    strh w1, [x0, #0xe]
    ldrh w2, [x0, #0xe]
    cmp w1, w2
    b.ne fail
    mov w1, #0x80
    strb w1, [x0, #3]
    mov w1, #3
    strb w1, [x0, #1]
    ldrb w2, [x0, #3]
    cmp w2, #2
    b.ne fail
    mov w1, #0x55
    strh w1, [x0, #4]
#ifdef TEST_INVALID_UART_RX
    ldrh w1, [x0, #4]
#endif
    ldr x0, =0x0e100100
    mov w4, #3
18: mov w2, #8
19: ldr w1, [x0]
    cbnz w1, fail
    mov w1, #0x12000000
    str w1, [x0]
    mov w1, #0x30000000
    str w1, [x0, #4]
    mov w1, #0x10
    str w1, [x0, #8]
    str w1, [x0, #0xc]
    mov w1, #0x1234
    str w1, [x0, #0x10]
    orr w1, w2, w4, lsl #8
    str w1, [x0, #0x18]
    ldr w3, [x0, #0x18]
    cmp w1, w3
    b.ne fail
    add x0, x0, #0x20
    subs w2, w2, #1
    b.ne 19b
    sub x0, x0, #0x100
    add x0, x0, #0x10, lsl #12
    subs w4, w4, #1
    b.ne 18b
    ldr x0, =0x0e100100
    ldr w1, [x0, #0x18]
    cmp w1, #0x308
    b.ne fail
    ldr x0, =0x0e1201e0
    ldr w1, [x0, #0x18]
    cmp w1, #0x101
    b.ne fail
#ifdef TEST_INVALID_HDMAC_ENABLE
    ldr x0, =0x0e100180
    ldr w1, [x0]
    orr w1, w1, #0x80000000
    str w1, [x0]
#endif
#ifdef TEST_INVALID_IMAGE_WORK
    ldr x0, =0x153c0008
    mov w1, #1
    str w1, [x0]
#endif
#ifdef TEST_UNKNOWN_READ
    ldr x0, =0xdead0000
    ldr w1, [x0]
#endif
    ldr w1, =0x5a384f4b
    str w1, [x23]
done:
    wfi
    b done
transfer:
    mov w1, #1
    str w1, [x20, #0x10]
4:  ldr w1, [x20, #8]
    tbz w1, #0, 4b
    mov w1, #1
    str w1, [x20, #8]
    ldr w1, [x20, #8]
    cbnz w1, fail
    ret
fail:
    ldr x0, =0xbad00000
    str wzr, [x0]
    b fail
.ltorg
.org 0x2000
.rept 512
    .quad 0x123456789abcdef0
.endr
