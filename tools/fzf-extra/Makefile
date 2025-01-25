SHELL := /bin/bash
PROJECT_ROOT = $(dir $(abspath $(lastword $(MAKEFILE_LIST))))
PREFIX ?= $(PROJECT_ROOT)/zig-out

.PHONY: install
install:
	zig build --prefix $(PREFIX) -Doptimize=ReleaseSafe
