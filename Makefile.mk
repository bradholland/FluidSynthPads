#!/usr/bin/make -f
# Makefile for FluidPlug #
# --------------------- #
# Modified for aarch64 only

# ---------------------------------------------------------------------------------------------------------------------
# Check for fluidsynth

HAVE_FLUIDSYNTH = $(shell pkg-config --exists fluidsynth && echo true)

ifneq ($(HAVE_FLUIDSYNTH),true)
$(error fluidsynth missing, cannot continue)
endif

# ---------------------------------------------------------------------------------------------------------------------
# Set compiler and architecture flags

CC  = gcc
CXX = g++

# ---------------------------------------------------------------------------------------------------------------------
# Set build and link flags - optimized for aarch64

BASE_FLAGS = -Wall -Wextra -Wshadow -pipe
BASE_OPTS  = -O2 -ffast-math -march=armv8-a -mtune=generic -fdata-sections -ffunction-sections

# Add PIC flags (always needed for shared libraries on aarch64)
BASE_FLAGS += -fPIC -DPIC

# Set optimization and visibility flags
BASE_FLAGS += -DNDEBUG $(BASE_OPTS) -fvisibility=hidden
CXXFLAGS   += -fvisibility-inlines-hidden

# Common linker flags for aarch64
LINK_OPTS  = -fdata-sections -ffunction-sections -Wl,--gc-sections -Wl,-O1 -Wl,--as-needed -Wl,--strip-all

BUILD_C_FLAGS   = $(BASE_FLAGS) -std=gnu99 $(CFLAGS)
BUILD_CXX_FLAGS = $(BASE_FLAGS) -std=gnu++0x $(CXXFLAGS)
LINK_FLAGS      = $(LINK_OPTS) $(LDFLAGS) -Wl,--no-undefined

# ---------------------------------------------------------------------------------------------------------------------
# Set fluidsynth flags

FLUIDSYNTH_FLAGS = $(shell pkg-config --cflags fluidsynth)
FLUIDSYNTH_LIBS  = $(shell pkg-config --libs fluidsynth)

# ---------------------------------------------------------------------------------------------------------------------
# Set shared lib extension and CLI arg

LIB_EXT = .so
SHARED = -shared

# ---------------------------------------------------------------------------------------------------------------------