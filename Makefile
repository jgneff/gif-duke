# ======================================================================
# Makefile - creates a bilevel animated GIF from a sequence of images
# Copyright (C) 2019 John Neffenger
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.
# ======================================================================
SHELL = /bin/bash

# Commands
CONVERT = convert
MKBITMAP = mkbitmap
POTRACE = potrace
INKSCAPE = inkscape

# Command options (mkbitmap defaults: -f 4 -s 2 -3 -t 0.45)
MKBITMAP_FLAGS = --filter 16 --scale 2 --cubic --threshold 0.45
POTRACE_FLAGS = --backend svg --resolution 90 --turdsize 2
INKSCAPE_FLAGS = --export-height=400

# Image processing options
monochrome = -layers Flatten -dither None -monochrome -negate
animation = -delay 13 -dispose None -loop 0 -background white
threshold = -threshold 60%

# Lists of prerequisite files
gif_list := $(shell echo T{01..10}.gif)

# ======================================================================
# Pattern Rules
# ======================================================================

%.ppm: src/%.gif
	$(CONVERT) $< $@

%.pbm: %.ppm
	$(MKBITMAP) $(MKBITMAP_FLAGS) --output $@ $<

%.svg: %.pbm
	$(POTRACE) $(POTRACE_FLAGS) --output $@ $<

%.png: %.svg
	$(INKSCAPE) $(INKSCAPE_FLAGS) --export-png=$@ $<

%.gif: %.png
	$(CONVERT) $< $(monochrome) $@

# ======================================================================
# Explicit rules
# ======================================================================

.PHONY: all clean

all: duke-waving.gif

duke-waving.gif: $(gif_list)
	$(CONVERT) $(animation) $^ -coalesce $@

clean:
	rm -f T??.ppm T??.pbm T??.svg T??.png
	rm -f duke-waving.gif T??.gif
