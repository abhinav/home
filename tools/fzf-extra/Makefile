SHELL := /bin/bash
PROJECT_ROOT = $(dir $(abspath $(lastword $(MAKEFILE_LIST))))
PREFIX ?= $(PROJECT_ROOT)

export GOBIN ?= $(PREFIX)/bin
export PATH := $(GOBIN):$(PATH)

ALT_C_COMMAND = $(GOBIN)/_fzf_alt_c_command

.PHONY: install
install: $(ALT_C_COMMAND)

$(ALT_C_COMMAND): $(wildcard cmd/_fzf_alt_c_command/*.go)
	go install ./cmd/_fzf_alt_c_command
