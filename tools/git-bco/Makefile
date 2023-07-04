PREFIX ?= zig-out

# Reject the entire Makefile if zig is not installed.
ifeq (,$(shell command -v zig))
$(error zig is not installed)
endif

.PHONY: build
build:
	zig build

.PHONY: test
test:
	zig build test

.PHONY: install
install:
	zig build -Doptimize=ReleaseFast \
		--prefix $(PREFIX) install
