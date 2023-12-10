SHELL := /bin/bash
PROJECT_ROOT = $(dir $(abspath $(lastword $(MAKEFILE_LIST))))

# 'go install' into the project's bin directory
# and add it to the PATH.
export GOBIN ?= $(PROJECT_ROOT)/bin
export PATH := $(GOBIN):$(PATH)

ERRTRACE := $(GOBIN)/errtrace

.PHONY: install
install: build
	@if ! grep -q '^gh u\b' <(gh extension list); then \
		gh extension install .; \
	fi

build: lint $(wildcard *.go)
	go build

.PHONY: lint
lint: errtrace-lint

.PHONY: errtrace-lint
errtrace-lint: $(ERRTRACE)
	@OUT=$$($(ERRTRACE) -l *.go); \
	if [ "$$OUT" != "" ]; then \
		echo "outdated files:"; \
		echo "$$OUT"; \
		exit 1; \
	fi

.PHONY: errtrace
errtrace: $(ERRTRACE)
	$(ERRTRACE) -w *.go

$(ERRTRACE):
	go install braces.dev/errtrace/cmd/errtrace
