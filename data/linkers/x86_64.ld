ENTRY(start)
OUTPUT_FORMAT(elf64-x86-64)

KERNEL_OFFSET = 0x100000;

SECTIONS
{
    . = KERNEL_OFFSET;

    .text : { *(.text) }
    .data : { *(.data) }
    .bss : { *(.bss) }
}