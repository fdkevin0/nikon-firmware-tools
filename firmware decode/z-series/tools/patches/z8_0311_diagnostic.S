/* Z8 3.11 only. Linked at 0x412a3200 by build_z8_diagnostic.py.
 * This is a preflight hook, not an additional command-table descriptor.
 * A zero return means the stock dispatcher must NOT call a command handler:
 * stock_response has already prepared the response, as on stock rejection paths.
 */
.section .text, "ax", @progbits
.balign 4
.global diagnostic_preflight
.type diagnostic_preflight, %function
diagnostic_preflight:
    ldrh w8, [x0, #6]
    mov w9, #0x94fd
    cmp w8, w9
    b.ne stock_fallback
    ldr w8, [x0, #12]
    mov w9, #0xf0ff
    cmp w8, w9
    b.ne stock_fallback

    /* Only this exact new request is handled here. No private-session access. */
    ldr w8, [x0]
    cmp w8, #32
    b.ne bad_count
    ldrh w8, [x0, #4]
    cmp w8, #1
    b.ne bad_parameter
    ldp w8, w9, [x0, #16]
    ldp w10, w11, [x0, #24]
    orr w8, w8, w9
    orr w8, w8, w10
    orr w8, w8, w11
    cbnz w8, bad_parameter
    mov w1, #0x2001
    adr x3, diagnostic_info
    b prepare_response

bad_count:
    mov w1, #0x2006
    b error_response
bad_parameter:
    mov w1, #0x201d
error_response:
    adr x3, zero_parameters
prepare_response:
    mov w2, #5
    mov w4, #0
    str x30, [sp, #-16]!
    bl stock_response
    ldr x30, [sp], #16
    mov w0, #0
    ret

stock_fallback:
    /* Exact displaced instruction at 0x407fe27c; all other stock code stays. */
    sub sp, sp, #0x50
    b stock_preflight_resume
.size diagnostic_preflight, .-diagnostic_preflight

.balign 4
diagnostic_info:
    .word 0x2001       /* inner status OK */
    .word 0x4744464e   /* ASCII bytes "NFDG" in little endian */
    .word 0x00010000   /* patch version 1.0.0: major<<16 | minor<<8 | patch */
    .word 2070         /* model id, decimal */
    .word 0x00000311   /* base Nikon firmware C 3.11 */
zero_parameters:
    .word 0, 0, 0, 0, 0

.section .note.GNU-stack, "", @progbits
