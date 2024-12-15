#!/usr/bin/make -f
# Makefile for FluidPlug #
# ---------------------- #
# Created by falkTX
# Modified for FluidSynthPads only

include Makefile.mk

DESTDIR =
PREFIX  = /usr

# ---------------------------------------------------------------------------------------------------------------------

all: build

clean:
	rm -f *.lv2/*.so exporter

distclean: clean
	rm -f *.lv2/README
	rm -f *.lv2/*.sf2
	rm -f *.lv2/*.tar
	rm -f *.lv2/*.tar.7z

install:
	install -d $(DESTDIR)$(PREFIX)/lib/lv2/FluidSynthPads.lv2
	install -m 644 \
		FluidSynthPads.lv2/*.sf2 \
		FluidSynthPads.lv2/*.so \
		FluidSynthPads.lv2/*.ttl \
		$(DESTDIR)$(PREFIX)/lib/lv2/FluidSynthPads.lv2
	cp -r FluidSynthPads.lv2/modgui  $(DESTDIR)$(PREFIX)/lib/lv2/FluidSynthPads.lv2

# ---------------------------------------------------------------------------------------------------------------------

build: FluidSynthPads

# ---------------------------------------------------------------------------------------------------------------------

FluidSynthPads: \
	FluidSynthPads.lv2/FluidPlug.sf2 \
	FluidSynthPads.lv2/FluidPlug.so \
	FluidSynthPads.lv2/FluidPlug.ttl \
	FluidSynthPads.lv2/manifest.ttl

# ---------------------------------------------------------------------------------------------------------------------

FluidSynthPads.lv2/FluidPlug.sf2:
	-@mkdir -p $(shell dirname $@)
	@sf2_file=$$(find source -name "*.sf2" -print -quit); \
	if [ -n "$$sf2_file" ]; then \
		cp "$$sf2_file" FluidSynthPads.lv2/FluidPlug.sf2; \
	else \
		echo "No .sf2 file found in the /source folder"; \
		exit 1; \
	fi

# ---------------------------------------------------------------------------------------------------------------------

%.lv2/FluidPlug.so: source/FluidPlug.c
	$(CC) $&lt; -DFLUIDPLUG_LABEL=\"$*\" $(BUILD_C_FLAGS) $(FLUIDSYNTH_FLAGS) $(LINK_FLAGS) $(FLUIDSYNTH_LIBS) $(SHARED) -o $@

%.lv2/FluidPlug.ttl:
	sed "s/xLABELx/$*/" source/FluidPlug.ttl.p1 > $*.lv2/FluidPlug.ttl
	cd $*.lv2 && ../exporter >> FluidPlug.ttl
	sed "s/xLABELx/$*/" source/FluidPlug.ttl.p2 >> $*.lv2/FluidPlug.ttl

%.lv2/manifest.ttl:
	sed "s/xLABELx/$*/" source/manifest.ttl.in > $*.lv2/manifest.ttl

# ---------------------------------------------------------------------------------------------------------------------

exporter: source/Exporter.c
	$(CC) $&lt; $(BUILD_C_FLAGS) $(FLUIDSYNTH_FLAGS) $(LINK_FLAGS) $(FLUIDSYNTH_LIBS) -o $@

# ---------------------------------------------------------------------------------------------------------------------
