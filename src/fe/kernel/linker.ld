/* Copyright 2013 (c) Michael Williams, All rights reserved.
   The following code is licensed under the terms specified in LICENSE.md. */

ENTRY(fe_kernel_bootstrap)

SECTIONS
{
  . = 1M;

  .multiboot BLOCK(4K) : ALIGN(4K) {
    *(.multiboot)
  }

  .text BLOCK(4K) : ALIGN(4K) {
    *(.text)
    *(.text*)
  }

  .rodata BLOCK(4K) : ALIGN(4K) {
    *(.rodata)
    *(.rodata*)
  }

  .data BLOCK(4K) : ALIGN(4K) {
    *(.data)
    *(.data*)
  }

  .bss BLOCK(4K) : ALIGN(4K) {
    *(COMMON)
    *(.bss)
    *(.bss*)
    *(.fe_bootstrapping_stack)
  }
}
