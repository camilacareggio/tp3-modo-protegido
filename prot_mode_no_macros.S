/* https://github.com/cirosantilli/x86-bare-metal-examples#protected-mode */

#include "common.h"
BEGIN
    PUSH_ADX
    mov $0x0600, %ax
    mov $0x7, %bh
    mov $0x0, %cx
    mov $0x184f, %dx
    int $0x10
    CURSOR_POSITION
    POP_DAX




    .equ CODE_SEG, 8
    .equ DATA_SEG, gdt_data - gdt_start

    /* Tell the processor where our Global Descriptor Table is in memory. */
    lgdt gdt_descriptor

    /* Set PE (Protection Enable) bit in CR0 (Control Register 0),
     * effectively entering protected mode.
     */
    mov %cr0, %eax
    orl $0x1, %eax
    mov %eax, %cr0

    ljmp $CODE_SEG, $protected_mode
    gdt_start:
    gdt_null:
        .long 0x0
        .long 0x0
    gdt_code:
        .word 0xffff
        .word 0x0
        .byte 0x0
        .byte 0b10011010
        .byte 0b11001111
        .byte 0x0
    gdt_data:
        .word 0xffff
        .word 0x0
        .byte 0x0
        .byte 0b10010010
        .byte 0b11001111
        .byte 0x0
    gdt_end:
    gdt_descriptor:
        .word gdt_end - gdt_start
        .long gdt_start
    vga_current_line:
        .long 0
    .code32
    protected_mode:
        /* Setup the other segments.
        * Those movs are mandatory because they update the descriptor cache:
        * http://wiki.osdev.org/Descriptor_Cache
        */
        mov $DATA_SEG, %ax
        mov %ax, %ds
        mov %ax, %es
        mov %ax, %fs
        mov %ax, %gs
        mov %ax, %ss
        /* TODO detect the last memory address available properly.
        * It depends on how much RAM we have.
        */
        mov $0X7000, %ebp
        mov %ebp, %esp
    .endm

    /* Setup a single page directory, which give us 2^10 * 2^12 == 4MiB
    * of identity memory starting at address 0.
    * The currently executing code is inside that range, or else we'd jump somewhere and die.
    */
    .equ page_directory, __end_align_4k
    .equ page_table, __end_align_4k + 0x1000



    VGA_PRINT_STRING $message
    jmp .
message:
    .asciz "hello world"
