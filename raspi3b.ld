SECTIONS {
    . = 0x80000;       /* typical load address for RPi3/4 */
    .text : {
        KEEP(*(.text.boot))
        *(.text*)
    }
    .rodata : { *(.rodata*) }
    .data : { *(.data*) }
    .bss : {
        __bss_start = .;
        *(.bss*)
        __bss_end = .;
    }
    _end = .;
}
