#!/usr/bin/make -f
# Makefile for FluidPlug #
# ---------------------- #
# Modified for FluidSynthPads only

include Makefile.mk

DESTDIR =
PREFIX  = /usr
BUILD_DIR = build

# ---------------------------------------------------------------------------------------------------------------------

all: build

clean:
	rm -rf $(BUILD_DIR)
	rm -f exporter

distclean: clean

install:
	install -d $(DESTDIR)$(PREFIX)/lib/lv2/FluidSynthPads.lv2
	install -m 644 \
		$(BUILD_DIR)/FluidSynthPads.lv2/*.sf2 \
		$(BUILD_DIR)/FluidSynthPads.lv2/*.so \
		$(BUILD_DIR)/FluidSynthPads.lv2/*.ttl \
		$(DESTDIR)$(PREFIX)/lib/lv2/FluidSynthPads.lv2

# ---------------------------------------------------------------------------------------------------------------------

build: FluidSynthPads

download: $(BUILD_DIR)/FluidSynthPads.lv2/FluidPlug.sf2

# ---------------------------------------------------------------------------------------------------------------------

FluidSynthPads: \
	$(BUILD_DIR)/FluidSynthPads.lv2/FluidPlug.sf2 \
	$(BUILD_DIR)/FluidSynthPads.lv2/FluidPlug.so \
	$(BUILD_DIR)/FluidSynthPads.lv2/FluidPlug.ttl \
	$(BUILD_DIR)/FluidSynthPads.lv2/manifest.ttl

# ---------------------------------------------------------------------------------------------------------------------

$(BUILD_DIR)/exporter: source/Exporter.c
	mkdir -p $(BUILD_DIR)
	$(CC) $< $(BUILD_C_FLAGS) $(FLUIDSYNTH_FLAGS) $(LINK_FLAGS) $(FLUIDSYNTH_LIBS) -o $@

$(BUILD_DIR)/FluidSynthPads.lv2/FluidPlug.sf2:
	mkdir -p $(BUILD_DIR)/FluidSynthPads.lv2
	cd $(BUILD_DIR)/FluidSynthPads.lv2 && \
		wget https://download.linuxaudio.org/musical-instrument-libraries/sf2/fluidr3-splitted/fluidr3gm_synthpad.sf2.tar.7z && \
		7z x fluidr3gm_synthpad.sf2.tar.7z && \
		7z x fluidr3gm_synthpad.sf2.tar && \
		mv fluidr3gm_synthpad.sf2 FluidPlug.sf2 && \
		rm -f *.tar.7z *.tar

$(BUILD_DIR)/FluidSynthPads.lv2/FluidPlug.so: source/FluidPlug.c
	mkdir -p $(BUILD_DIR)/FluidSynthPads.lv2
	$(CC) $< -DFLUIDPLUG_LABEL=\"FluidSynthPads\" $(BUILD_C_FLAGS) $(FLUIDSYNTH_FLAGS) $(LINK_FLAGS) $(FLUIDSYNTH_LIBS) $(SHARED) -o $@

$(BUILD_DIR)/FluidSynthPads.lv2/FluidPlug.ttl: source/FluidPlug.ttl.p1 source/FluidPlug.ttl.p2 $(BUILD_DIR)/exporter
	mkdir -p $(BUILD_DIR)/FluidSynthPads.lv2
	cd $(BUILD_DIR)/FluidSynthPads.lv2 && \
		sed "s/xLABELx/FluidSynthPads/" ../../source/FluidPlug.ttl.p1 > FluidPlug.ttl && \
		ln -f FluidPlug.sf2 ./FluidPlug.sf2 && \
		../exporter >> FluidPlug.ttl && \
		sed "s/xLABELx/FluidSynthPads/" ../../source/FluidPlug.ttl.p2 >> FluidPlug.ttl

$(BUILD_DIR)/FluidSynthPads.lv2/manifest.ttl: source/manifest.ttl.in
	mkdir -p $(BUILD_DIR)/FluidSynthPads.lv2
	sed "s/xLABELx/FluidSynthPads/" $< > $@

# ---------------------------------------------------------------------------------------------------------------------