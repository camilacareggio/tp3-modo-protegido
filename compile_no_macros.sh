#!/bin/bash

echo "Compiling..."

# Compile program
gcc -m32 -c -ggdb3 -o 'prot_mode_no_macros.o' 'prot_mode_no_macros.S'
ld -melf_i386  -nostdlib -o 'prot_mode_no_macros.elf' -T 'linker.ld' 'prot_mode_no_macros.o'
objcopy -O binary 'prot_mode_no_macros.elf' 'prot_mode_no_macros.img'

echo "Complete"