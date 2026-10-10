/* Pinned Z8 C 3.11; menu framework and display helpers remain stock. */
.include "z8_0311_diagnostic.S"
.section .text, "ax", @progbits
.balign 4
.global ui_version, ui_node, ui_text, ui_draw, ui_close
ui_version:
    stp x19, x30, [sp, #-16]!
    mov x19, x1
    bl stock_version
    movz x8, #0x2e33
    movk x8, #0x3131, lsl #16
    movk x8, #0x5020, lsl #32
    str x8, [x19]             /* 3.11 P, within the stock 10-byte buffer. */
    ldp x19, x30, [sp], #16
    ret

ui_node:
    cmp w0, #2
    b.ne 1f
    and w8, w1, #0xffff
    cmp w8, #0x600
    b.ne 1f
    ldr x0, node_address
    ret
1:  cmp w0, #6               /* Displaced stock instruction, including flags. */
    b stock_node_resume

ui_text:
    mov w8, #0x7ff0
    cmp w1, w8
    b.eq new_title
    cmp w1, #0x379
    b.ne stock_text
    stp x0, x1, [sp, #-48]!
    stp x2, x3, [sp, #16]
    str x30, [sp, #32]
    bl stock_current_node
    cbz x0, 1f
    ldr w8, [x0]
    mov w9, #2
    movk w9, #0x600, lsl #16
    cmp w8, w9
    b.eq 2f
1:  ldp x0, x1, [sp]
    ldp x2, x3, [sp, #16]
    ldr x30, [sp, #32]
    add sp, sp, #48
stock_text:
    mov x9, #0xac48
    b stock_text_resume
2:  ldp x0, x1, [sp]
    ldp x2, x3, [sp, #16]
    ldr x30, [sp, #32]
    add sp, sp, #48
new_title:
    adr x8, ui_title
    str x8, [x2]
    mov w8, #32
    str w8, [x3]
    ret

/* New title inherits the existing Firmware version text's font metadata. */
.macro metadata name, resume
.global \name
\name:
    mov w8, #0x7ff0
    cmp w1, w8
    b.ne 1f
    mov w1, #0x379
1:  mov x8, #0xcd5c
    b \resume
.endm
metadata ui_text_class, stock_text_class_resume
metadata ui_text_size, stock_text_size_resume
metadata ui_text_flags, stock_text_flags_resume
metadata ui_text_spacing, stock_text_spacing_resume
metadata ui_text_style, stock_text_style_resume
metadata ui_text_weight, stock_text_weight_resume
metadata ui_text_options, stock_text_options_resume
metadata ui_text_alignment, stock_text_alignment_resume

.global ui_text_normalize
ui_text_normalize:
    ldr w8, [x0]
    mov w9, #0x7ff0
    cmp w8, w9
    b.ne 1f
    str x30, [sp, #-32]!
    mov w8, #0x379
    str w8, [sp, #16]
    add x0, sp, #16
    mov x9, #0xcd5c
    bl stock_text_normalize_resume
    ldr x30, [sp], #32
    ret
1:  mov x9, #0xcd5c
    b stock_text_normalize_resume

ui_draw:
    stp x19, x20, [sp, #-64]!
    stp x21, x22, [sp, #16]
    stp x23, x30, [sp, #32]
    add x19, x0, #0x18
    strh wzr, [sp, #48]
    mov w0, #3
    bl stock_page_mode
    adr x20, hide_objects
1:  ldr w0, [x20], #4
    cbz w0, 3f
    mov x1, x19
    bl stock_find_object
    cbz x0, 1b
    mov w1, #0
    bl stock_visibility
    b 1b
3:  adr x20, display_fields
    mov w21, #4
4:  ldr w0, [x20]
    mov x1, x19
    bl stock_find_object
    mov x1, x0
    ldr x0, [x20, #8]
    add x2, sp, #48
    bl stock_display_label
    ldr w0, [x20, #4]
    mov x1, x19
    bl stock_find_object
    mov x1, x0
    ldr x0, [x20, #16]
    add x2, sp, #48
    bl stock_display_value
    add x20, x20, #24
    subs w21, w21, #1
    b.ne 4b
    ldp x23, x30, [sp, #32]
    ldp x21, x22, [sp, #16]
    ldp x19, x20, [sp], #64
    ret

ui_close:
    mov w0, #2
    mov w1, #0x297
    b stock_navigate

.balign 8
node_address: .quad 0xa02ab4500
hide_objects:
    .word 0x10c0, 0x10c1, 0x10c2, 0x10c3, 0x10c4, 0x10c5, 0x10c6
    .word 0x10c7, 0x10c8, 0x10c9, 0x10ca, 0xd80, 0xd7f, 0xd7a, 0xd7e
    .word 0x3896, 0x38f0, 0x38ee, 0
.balign 8
display_fields:
    .word 0x10c1, 0x10c2
    .quad id_label, id_value
    .word 0x10c3, 0x10c4
    .quad patch_label, patch_value
    .word 0x10c5, 0x10c6
    .quad model_label, model_value
    .word 0x10c7, 0x10c8
    .quad version_label, version_value
id_label: .asciz "ID"
id_value: .asciz "NFDG"
patch_label: .asciz "P"
patch_value: .asciz "1.0.0"
model_label: .asciz "M"
model_value: .asciz "Z8 2070"
version_label: .asciz "C"
version_value: .asciz "3.11 P"
.balign 8
.global ui_title, ui_code_end
ui_title: .hword 78,70,68,71,32,100,105,97,103,110,111,115,116,105,99,115
ui_code_end:
.include "ui_data.S"
