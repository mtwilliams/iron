# Copyright 2013 (c) Michael Williams, All rights reserved.
# The following code is licensed under the terms specified in LICENSE.md.

################################################################################
# Configuration:                                                               #
#  * Flags, includes, dependencies, directories, etc.                          #
#  * Toolchain and architecture                                                #
#  * Prefixes and suffixes                                                     #
#  * Debugging                                                                 #
################################################################################

# See ./configure
-include config.mk

################################################################################
# Flags, includes, dependencies, directories, etc.                             #
################################################################################

ASFLAGS  :=
CFLAGS   := -std=c99 -pedantic -Wall -Wextra -Wfloat-equal -Wshadow \
            -Wunsafe-loop-optimizations -Wpointer-arith -Wcast-qual \
            -Wcast-align -Wmissing-field-initializers -Wpacked \
            -Wpadded -Wredundant-decls -Wunreachable-code -Winline \
            -ffreestanding
CXXFLAGS := -std=c++98 -pedantic -Wall -Wextra -Wfloat-equal -Wshadow \
            -Wunsafe-loop-optimizations -Wpointer-arith -Wcast-qual \
            -Wcast-align -Wmissing-field-initializers -Wpacked \
            -Wpadded -Wredundant-decls -Wunreachable-code -Winline \
            -ffreestanding
RSFLAGS  :=
INCLUDES := -Iinclude

################################################################################

LDFLAGS      :=
DEPENDENCIES :=

################################################################################

BIN_DIR := bin
LIB_DIR := lib
OBJ_DIR := obj
SRC_DIR := src
RSFLAGS += -L $(SRC_DIR)

COMMIT   := $(shell git log --pretty=oneline | wc -l)
REVISION := $(shell git rev-parse HEAD)

################################################################################
# Toolchain and architecture                                                   #
################################################################################

UNAME_S := $(shell uname -s)
UNAME_M := $(shell uname -m)

# Determine the current platform based on `uname -s`:
# http://en.wikipedia.org/wiki/Uname is immensely helpful here.
ifeq ($(findstring CYGWIN_NT,$(UNAME_S)),CYGWIN_NT)
  PLATFORM := windows-cygwin
endif
ifeq ($(findstring MINGW32_NT,$(UNAME_S)),MINGW32_NT)
  PLATFORM := windows-mingw
endif
ifeq ($(findstring Darwin,$(UNAME_S)),Darwin)
  PLATFORM := macosx
endif
ifeq ($(findstring Linux,$(UNAME_S)),Linux)
  PLATFORM := linux
endif

# Building on Windows is too much hassle:
ifeq ($PLATFORM,windows-cygwin)
  $error(Windows-based based builds are too much of a hassle.)
endif
ifeq ($PLATFORM,windows-mingw)
  $error(Windows-based based builds are too much of a hassle.)
endif

# Determine the current architecture based on `uname -m`:
# Again, http://en.wikipedia.org/wiki/Uname is immensely helpful here.
ifeq ($(findstring i386,$(UNAME_M)),i386)
  ARCHITECTURE := x86
endif
ifeq ($(findstring i686,$(UNAME_M)),i686)
  ARCHITECTURE := x86
endif
ifeq ($(findstring i686-64,$(UNAME_M)),i686-64)
  ARCHITECTURE := x86-64
endif
ifeq ($(findstring amd64,$(UNAME_M)),amd64)
  ARCHITECTURE := x86-64
endif
ifeq ($(findstring x86_64,$(UNAME_M)),x86_64)
  ARCHITECTURE := x86-64
endif

# Default to x86 if no target architecture is specified:
ifndef TARGET_ARCHITECTURE
  $(warning No target architecture specified!)
  $(warning Defaulting to x86...)
  TARGET_ARCHITECTURE := x86
endif

# Make sure the target architecture is supported:
ifeq ($(TARGET_ARCHITECTURE),x86)
  TARGET_ARCHITECTURE_IS_SUPPORTED := yes
endif
ifneq ($(TARGET_ARCHITECTURE_IS_SUPPORTED),yes)
  $(error Compilation support for '$(TARGET_ARCHITECTURE)' isn't available right now.)
endif

# Select and setup toolchains by target architecture:
ifeq ($(TARGET_ARCHITECTURE),x86)
  AS      := nasm
  LD      := i586-elf-ld
  CC      := i586-elf-gcc
  CXX     := i586-elf-g++
  RUSTC   := rustc
  ASFLAGS += -f elf32
  LDFLAGS += -melf_i386
  RSFLAGS += --target i386-intel-linux
endif

################################################################################
# Debugging                                                                    #
################################################################################

ifeq ($(DEBUG),yes)
  CFLAGS += -g
  CXXFLAGS += -g
  RSFLAGS +=
endif
ifneq ($(DEBUG),yes)
  CFLAGS += -O3
  CXXFLAGS += -O3
  RSFLAGS += --opt-level=3
endif

################################################################################
# Rules:                                                                       #
#  * General                                                                   #
#  * Kernel                                                                    #
################################################################################

################################################################################
# General                                                                      #
################################################################################

.PHONY: all docs clean install run

all: hdd.img

docs:

clean:
	@rm -rf $(BIN_DIR)
	@rm -rf $(LIB_DIR)
	@rm -rf $(OBJ_DIR)
	@rm -rf boot/iron
	@rm -rf hdd.img

install:

run:

hdd.img: boot/grub/grub.cfg boot/iron/kernel
	@echo "[IMG] hdd.img"
	@cp hdd.template.img hdd.img
	@sudo rm -rf hdd
	@sudo mkdir hdd
	@sudo mount -o loop,offset=1048576 hdd.img hdd
	@sudo rm -rf hdd/boot/*
	@sudo cp -rf boot/* hdd/boot/
	@sudo umount hdd
	@sudo rm -rf hdd

################################################################################
# Kernel                                                                       #
################################################################################

OBJS := $(OBJ_DIR)/fe/kernel/bootstrap.o
OBJS += $(OBJ_DIR)/fe/kernel/shim.o
OBJS += $(OBJ_DIR)/fe/kernel/kernel.o

boot/iron/kernel: $(OBJS) $(SRC_DIR)/fe/kernel/linker.ld
	@echo "[LD] $@"
	@mkdir -p boot/iron
	@$(LD) $(LDFLAGS) -T $(SRC_DIR)/fe/kernel/linker.ld -o boot/iron/kernel $(OBJS) $(DEPENDENCIES)

$(OBJ_DIR)/fe/kernel/bootstrap.o: $(SRC_DIR)/fe/kernel/bootstrap.asm
	@echo "[ASM] $@"
	@mkdir -p ${@D}
	@$(AS) $(ASFLAGS) -Iinclude/ -o $@ $<

-include $(OBJ_DIR)/fe/kernel/shim.d
$(OBJ_DIR)/fe/kernel/shim.o: $(SRC_DIR)/fe/kernel/shim.c
	@echo "[CC] $@"
	@mkdir -p ${@D}
	@$(CC) $(CFLAGS) $(INCLUDES) -c $< -o $@
	@$(CC) $(CFLAGS) $(INCLUDES) -MM -MT $@ -c $< > $(patsubst %.o,%.d,$@)

SOURCES := $(shell find vendor/rust-core/core -name '*.rs')
SOURCES += $(shell find $(SRC_DIR)/fe/kernel -name '*.rs')

$(OBJ_DIR)/fe/kernel/kernel.o: $(SOURCES) $(SRC_DIR)/fe/kernel/kernel.rc
	@echo "[RUST] $@"
	@mkdir -p ${@D}
	@$(RUSTC) $(RSFLAGS) --lib -c $(SRC_DIR)/fe/kernel/kernel.rc -o $@
