#!/usr/bin/make -f
# Makefile for FluidPlug #
# --------------------- #
# Modified for aarch64 Linux cross-compilation

# ---------------------------------------------------------------------------------------------------------------------
# Set cross-compilation toolchain
CC  = aarch64-linux-gnu-gcc
CXX = aarch64-linux-gnu-g++

# ---------------------------------------------------------------------------------------------------------------------
# Check for fluidsynth and lv2

HAVE_FLUIDSYNTH = $(shell pkg-config --exists fluidsynth && echo true)
HAVE_LV2 = $(shell pkg-config --exists lv2 && echo true)

ifneq ($(HAVE_FLUIDSYNTH),true)
$(error fluidsynth missing, cannot continue)
endif

ifneq ($(HAVE_LV2),true)
$(error lv2 missing, cannot continue)
endif

# ---------------------------------------------------------------------------------------------------------------------
# Set build and link flags - optimized for aarch64 Linux

BASE_FLAGS = -Wall -Wextra -Wshadow -pipe
BASE_OPTS  = -O2 -ffast-math -march=armv8-a -mtune=generic -fdata-sections -ffunction-sections

# Add PIC flags (always needed for shared libraries)
BASE_FLAGS += -fPIC -DPIC

# Set optimization and visibility flags
BASE_FLAGS += -DNDEBUG $(BASE_OPTS) -fvisibility=hidden
CXXFLAGS   += -fvisibility-inlines-hidden

# Linux-specific linker flags
LINK_OPTS  = -fdata-sections -ffunction-sections -Wl,--gc-sections -Wl,-O1 -Wl,--as-needed -Wl,--strip-all -Wl,--no-undefined

# ---------------------------------------------------------------------------------------------------------------------
# Set fluidsynth and lv2 flags

FLUIDSYNTH_FLAGS = $(shell pkg-config --cflags fluidsynth)
FLUIDSYNTH_LIBS  = $(shell pkg-config --libs fluidsynth)

LV2_FLAGS = $(shell pkg-config --cflags lv2)
LV2_LIBS = $(shell pkg-config --libs lv2)

BUILD_C_FLAGS   = $(BASE_FLAGS) -std=gnu99 $(CFLAGS) $(LV2_FLAGS)
BUILD_CXX_FLAGS = $(BASE_FLAGS) -std=gnu++0x $(CXXFLAGS) $(LV2_FLAGS)
LINK_FLAGS      = $(LINK_OPTS) $(LDFLAGS) $(LV2_LIBS)

# ---------------------------------------------------------------------------------------------------------------------
# Set shared lib extension and CLI arg for Linux

LIB_EXT = .so
SHARED = -shared

# ---------------------------------------------------------------------------------------------------------------------