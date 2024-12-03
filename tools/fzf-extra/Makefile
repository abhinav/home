SHELL := /bin/bash
PROJECT_ROOT = $(dir $(abspath $(lastword $(MAKEFILE_LIST))))
PREFIX ?= $(PROJECT_ROOT)

.PHONY: install
install:
	cargo install --path . --root $(PREFIX)
