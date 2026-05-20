PREFIX ?= $(shell pwd)

.PHONY: build
build:
	mise exec -- cargo build

.PHONY: test
test:
	mise exec -- cargo test

.PHONY: install
install:
	mise exec -- cargo install --path . --root $(PREFIX)
