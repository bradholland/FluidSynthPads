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
	rm -f exporter
	rm -rf $(BUILD_DIR)

distclean: clean
	rm -f *.lv2/README
	rm -f *.lv2/*.sf2
	rm -f *.lv2/*.tar
	rm -f *.lv2/*.tar.7z

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

$(BUILD_DIR)/FluidSynthPads.lv2/FluidPlug.sf2:
	mkdir -p $(BUILD_DIR)/FluidSynthPads.lv2
	(cd $(BUILD_DIR)/FluidSynthPads.lv2 && \
		wget https://download.linuxaudio.org/musical-instrument-libraries/sf2/fluidr3-splitted/fluidr3gm_synthpad.sf2.tar.7z && \
		7z x fluidr3gm_synthpad.sf2.tar.7z && \
		7z x fluidr3gm_synthpad.sf2.tar && \
		mv fluidr3gm_synthpad.sf2 FluidPlug.sf2)

# ---------------------------------------------------------------------------------------------------------------------

$(BUILD_DIR)/FluidSynthPads.lv2/FluidPlug.so: source/FluidPlug.c
	mkdir -p $(BUILD_DIR)/FluidSynthPads.lv2
	$(CC) $< -DFLUIDPLUG_LABEL=\"FluidSynthPads\" $(BUILD_C_FLAGS) $(FLUIDSYNTH_FLAGS) $(LINK_FLAGS) $(FLUIDSYNTH_LIBS) $(SHARED) -o $@

# Build exporter first, then generate TTL files
exporter: source/Exporter.c
	$(CC) $< $(BUILD_C_FLAGS) $(FLUIDSYNTH_FLAGS) $(LINK_FLAGS) $(FLUIDSYNTH_LIBS) -o $@

$(BUILD_DIR)/FluidSynthPads.lv2/FluidPlug.ttl: source/FluidPlug.ttl.p1 source/FluidPlug.ttl.p2 exporter
	mkdir -p $(BUILD_DIR)/FluidSynthPads.lv2
	cp $(BUILD_DIR)/FluidSynthPads.lv2/FluidPlug.sf2 FluidPlug.sf2
	sed "s/xLABELx/FluidSynthPads/" source/FluidPlug.ttl.p1 > $@
	./exporter >> $@
	sed "s/xLABELx/FluidSynthPads/" source/FluidPlug.ttl.p2 >> $@
	rm -f FluidPlug.sf2

$(BUILD_DIR)/FluidSynthPads.lv2/manifest.ttl: source/manifest.ttl.in
	mkdir -p $(BUILD_DIR)/FluidSynthPads.lv2
	sed "s/xLABELx/FluidSynthPads/" source/manifest.ttl.in > $@

# ---------------------------------------------------------------------------------------------------------------------