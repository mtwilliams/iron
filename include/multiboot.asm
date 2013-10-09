; Copyright (C) 1999, 2003, 2007, 2008, 2009  Free Software Foundation, Inc.
;
; Permission is hereby granted, free of charge, to any person obtaining a copy
; of this software and associated documentation files (the "Software"), to
; deal in the Software without restriction, including without limitation the
; rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
; sell copies of the Software, and to permit persons to whom the Software is
; furnished to do so, subject to the following conditions:
;
; The above copyright notice and this permission notice shall be included in
; all copies or substantial portions of the Software.
;
; THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
; IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
; FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL ANY
; DEVELOPER OR DISTRIBUTOR BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
; WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR
; IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

%ifndef _MULTIBOOT_ASM_
%define _MULTIBOOT_ASM_

; How many bytes from the start of the file we search for the header.
MULTIBOOT_SEARCH                        equ 8192

; The magic field should contain this.
MULTIBOOT_HEADER_MAGIC                  equ 0x1BADB002

; This should be in %eax.
MULTIBOOT_BOOTLOADER_MAGIC              equ 0x2BADB002

; The bits in the required part of flags field we don't support.
MULTIBOOT_UNSUPPORTED                   equ 0x0000fffc

; Alignment of multiboot modules.
MULTIBOOT_MOD_ALIGN                     equ 0x00001000

; Alignment of the multiboot info structure.
MULTIBOOT_INFO_ALIGN                    equ 0x00000004

; Flags set in the 'flags' member of the multiboot header.

; Align all boot modules on i386 page (4KB) boundaries.
MULTIBOOT_PAGE_ALIGN                    equ 0x00000001

; Must pass memory information to OS.
MULTIBOOT_MEMORY_INFO                   equ 0x00000002

; Must pass video information to OS.
MULTIBOOT_VIDEO_MODE                    equ 0x00000004

; This flag indicates the use of the address fields in the header.
MULTIBOOT_AOUT_KLUDGE                   equ 0x00010000

; Flags to be set in the 'flags' member of the multiboot info structure.

; is there basic lower/upper memory information?
MULTIBOOT_INFO_MEMORY                   equ 0x00000001
; is there a boot device set?
MULTIBOOT_INFO_BOOTDEV                  equ 0x00000002
; is the command-line defined?
MULTIBOOT_INFO_CMDLINE                  equ 0x00000004
; are there modules to do something with?
MULTIBOOT_INFO_MODS                     equ 0x00000008

; These next two are mutually exclusive

; is there a symbol table loaded?
MULTIBOOT_INFO_AOUT_SYMS                equ 0x00000010
; is there an ELF section header table?
MULTIBOOT_INFO_ELF_SHDR                 equ 0X00000020

; is there a full memory map?
MULTIBOOT_INFO_MEM_MAP                  equ 0x00000040

; Is there drive info?
MULTIBOOT_INFO_DRIVE_INFO               equ 0x00000080

; Is there a config table?
MULTIBOOT_INFO_CONFIG_TABLE             equ 0x00000100

; Is there a boot loader name?
MULTIBOOT_INFO_BOOT_LOADER_NAME         equ 0x00000200

; Is there a APM table?
MULTIBOOT_INFO_APM_TABLE                equ 0x00000400

; Is there video information?
MULTIBOOT_INFO_VIDEO_INFO               equ 0x00000800

%endif ; ! _MULTIBOOT_ASM_
