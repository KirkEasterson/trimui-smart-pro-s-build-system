APP_LABEL = Trimui-App
APP_DESCRIPTION = Program for the Trimui Smart Pro S

APP_LABEL_SLUG = $(shell echo "$(APP_LABEL)" | tr ' ' '_')
BUILD_DIR = build/$(APP_LABEL_SLUG)
OUT = $(BUILD_DIR)/$(APP_LABEL_SLUG)

SDK_BASE = /sdk/sdk_tg5050_linux_v1.0.0/host
TOOLCHAIN_DIR = $(SDK_BASE)/aarch64-buildroot-linux-gnu
SYSROOT_DIR = $(TOOLCHAIN_DIR)/sysroot
SDL_DIR = $(SYSROOT_DIR)/usr/include/SDL2

# Compiler Setup
CXX = $(SDK_BASE)/bin/aarch64-none-linux-gnu-g++
CXXFLAGS = -I$(SDL_DIR)/include -I$(SYSROOT_DIR)/include -I.
LDFLAGS = -L$(SYSROOT_DIR)/lib -L$(SYSROOT_DIR)/lib/mali -Wl,-rpath-link=$(SYSROOT_DIR)/lib/mali
LIBS = -lSDL2 -lSDL2_ttf -lfreetype -lz -lbz2 -lGLESv2 -lEGL -lm

SRC = src/main.cpp

all: $(OUT) copy_resources

$(OUT): $(SRC)
	mkdir -p $(BUILD_DIR)
	$(CXX) $(SRC) -o $(OUT) $(CXXFLAGS) $(LDFLAGS) $(LIBS)

copy_resources:
	# Copy icon into folder
	cp res/icon.png $(BUILD_DIR)/icon.png

	# Create config.json
	echo '{' > $(BUILD_DIR)/config.json
	echo '  "label":"$(APP_LABEL)",' >> $(BUILD_DIR)/config.json
	echo '  "icon":"icon.png",' >> $(BUILD_DIR)/config.json
	echo '  "iconsel":"icon.png",' >> $(BUILD_DIR)/config.json
	echo '  "launch":"launch.sh",' >> $(BUILD_DIR)/config.json
	echo '  "description":"$(APP_DESCRIPTION)"' >> $(BUILD_DIR)/config.json
	echo '}' >> $(BUILD_DIR)/config.json

	# Create launch.sh
	echo '#!/bin/sh' > $(BUILD_DIR)/launch.sh
	echo 'cd $$(dirname "$$0")' >> $(BUILD_DIR)/launch.sh
	echo '' >> $(BUILD_DIR)/launch.sh
	echo 'export LD_LIBRARY_PATH=$$(dirname "$$0")/lib:$$LD_LIBRARY_PATH' >> $(BUILD_DIR)/launch.sh
	echo './$(APP_LABEL_SLUG)' >> $(BUILD_DIR)/launch.sh
	chmod +x $(BUILD_DIR)/launch.sh

	# Copy font into res folder
	mkdir -p $(BUILD_DIR)/res
	cp res/arial.ttf $(BUILD_DIR)/res/

clean:
	rm -rf $(BUILD_DIR)
