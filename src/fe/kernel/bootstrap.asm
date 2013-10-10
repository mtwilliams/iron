; Copyright 2013 (c) Michael Williams, All rights reserved.
; The following code is licensed under the terms specified in LICENSE.md.

[BITS 32]

%include "multiboot.asm"

; ============================================================================ ;
;  Multiboot Header (multiboot):                                               ;
; ============================================================================ ;

MULTIBOOT_HEADER_FLAGS    equ MULTIBOOT_PAGE_ALIGN | MULTIBOOT_MEMORY_INFO
MULTIBOOT_HEADER_CHECKSUM equ -(MULTIBOOT_HEADER_MAGIC + MULTIBOOT_HEADER_FLAGS)

SECTION .multiboot
ALIGN 4

  dd MULTIBOOT_HEADER_MAGIC
  dd MULTIBOOT_HEADER_FLAGS
  dd MULTIBOOT_HEADER_CHECKSUM

; ============================================================================ ;
;  Stack (fe_bootstrapping_stack):                                             ;
; ============================================================================ ;

SECTION [.fe_bootstrapping_stack nobits]
ALIGN 4

fe_bootstrapping_stack_btm:

  resb 16384

fe_bootstrapping_stack_top:

; ============================================================================ ;
;  Shim (see vendor/rust-core/core/iron.rs):                                   ;
; ============================================================================ ;

SECTION .text
GLOBAL _GLOBAL_OFFSET_TABLE_
_GLOBAL_OFFSET_TABLE_:

SECTION .text
GLOBAL __morestack
__morestack:

SECTION .text
GLOBAL fe_kernel_halt
fe_kernel_halt:

  cli
  hlt

; ============================================================================ ;
;  Bootstrap (fe_kernel_bootstrap):                                            ;
; ============================================================================ ;

SECTION .text
EXTERN fe_kernel_shim_entry
GLOBAL fe_kernel_bootstrap
fe_kernel_bootstrap:

  mov esp, fe_bootstrapping_stack_top
  mov [gs:0x30], dword 0

  push ebx
  push eax
  call fe_kernel_shim_entry

  jmp fe_kernel_halt
