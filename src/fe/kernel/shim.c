// Copyright 2013 (c) Michael Williams, All rights reserved.
// The following code is licensed under the terms specified in LICENSE.md.

#include <fe/types.h>
#include <multiboot.h>

// TOOD(mtwilliams): Move this into Rust.
unsigned char *fe_kernel_shim_alloc(unsigned sz) {
  (void)sz;
  return NULL;
}

// TOOD(mtwilliams): Move this into Rust.
unsigned char *fe_kernel_shim_realloc(unsigned char *ptr, unsigned sz) {
  (void)ptr; (void)sz;
  return NULL;
}

// TOOD(mtwilliams): Move this into Rust.
void fe_kernel_shim_dealloc(unsigned char *ptr) {
  (void)ptr;
}

// See src/fe/kernel/bootstrap.asm.
extern void fe_kernel_halt(void);

// TODO(mtwilliams): Use a function pointer to alias to kernel::panic() when
//                   the kernel is sufficiently setup.
void fe_kernel_shim_abort(void) {
  fe_kernel_halt();
}

// We have to use a shim here as Rust doesn't support C-like unions, yet.
// See https://github.com/mozilla/rust/issues/5492.

// See src/fe/kernel/main.rs.
extern void fe_kernel_main(void);

void fe_kernel_shim_entry(unsigned long magic, unsigned long addr) {
  // Check to make sure we're booted by a multiboot-compliant boot loader, if
  // not not we'll panic and halt (see src/fe/kernel/bootstrap.asm).
  if (magic != MULTIBOOT_BOOTLOADER_MAGIC)
    return;

  multiboot_info_t *mbi = (multiboot_info_t *)addr;

  // TOOD(mtwilliams): Parse and pass this off to Rust.
  (void)mbi;

  fe_kernel_main();
}
