# FluidSynthPads
Updating
This is a fork of FluidPlug that focuses solely on the FluidSynthPads plugin. The original FluidPlug was created by falkTX (https://github.com/falkTX/FluidPlug).

## About

This version has been modified to:
- Build only the FluidSynthPads plugin
- Target aarch64 architecture
- Use the latest FluidSynth version
- Remove unnecessary plugins and code

## Dependencies

Required:
- FluidSynth (latest version)
- pkg-config
- wget
- p7zip

## Building

```bash
make download  # Downloads required soundfont
make          # Builds the plugin
make install  # Installs the plugin (optional)
```

## Installation Path

The plugin will be installed to:
```
$(PREFIX)/lib/lv2/FluidSynthPads.lv2/
```
where PREFIX defaults to /usr

## Original License

This library is free software; you can redistribute it and/or modify it under the terms of the GNU Library General Public License as published by the Free Software Foundation; either version 2 of the License, or (at your option) any later version.

## Credits

- Original FluidPlug by falkTX (https://github.com/falkTX/FluidPlug)
- Uses FluidSynth (https://github.com/FluidSynth/fluidsynth)