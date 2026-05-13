.PHONY: build run app clean

BINARY_NAME := PomodoroApp
APP_NAME := PomodoroApp.app
BUILD_DIR := .build/release
APP_DIR := $(APP_NAME)/Contents

build:
	swift build -c release

run:
	swift run

app: build
	rm -rf $(APP_NAME)
	mkdir -p $(APP_DIR)/MacOS
	mkdir -p $(APP_DIR)/Resources
	cp $(BUILD_DIR)/$(BINARY_NAME) $(APP_DIR)/MacOS/
	cp Info.plist $(APP_DIR)/
	chmod +x $(APP_DIR)/MacOS/$(BINARY_NAME)

clean:
	swift package clean
	rm -rf $(APP_NAME)
