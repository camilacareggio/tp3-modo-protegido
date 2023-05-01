/* https://github.com/cirosantilli/x86-bare-metal-examples#protected-mode */

#include "common.h"
BEGIN
    CLEAR
    PROTECTED_MODE
    VGA_PRINT_STRING $message
    jmp .
message:
    .asciz "hello world"
    
 /* 
Compile and run:
gcc -m32 -c -ggdb3 -o 'protected_mode_macros.o' 'protected_mode_macros.S'
ld -melf_i386  -nostdlib -o 'protected_mode_macros.elf' -T 'linker.ld' 'protected_mode_macros.o'
objcopy -O binary 'protected_mode_macros.elf' 'protected_mode_macros.img'

qemu-system-x86_64 --drive file=protected_mode_macros.img,format=raw,index=0,media=disk
*/
