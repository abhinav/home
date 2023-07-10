NAME = yabaictl
PREFIX ?= $(shell pwd)

# Reject the entire Makefile if go is not installed.
ifeq (,$(shell command -v cargo))
$(error cargo is not installed)
endif

.PHONY: build
build:
	cargo build

.PHONY: test
test:
	cargo test

.PHONY: install
ifeq (Darwin,$(shell uname -s))
install:
	cargo install --path . --force --root $(PREFIX)
else
install:
	@echo "Skipping install on non-Darwin platform."
endif
