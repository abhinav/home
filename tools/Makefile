# List of subdirectories of tools to call `make install` in.
TOOLS = git-bco

SHELL = bash

# Directory of this Makefile.
TOOLS_DIR := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))

# Install to ~/.local/bin by default.
PREFIX ?= $(abspath $(TOOLS_DIR)/../.local)

# Installs all tools to $(PREFIX).
.PHONY: install
install::

# Generate an 'install-$tool' target for each tool.
# Append it to the 'install' target.
define tool-template
install-$(1):
	@make -C $(1) install PREFIX=$(PREFIX)

install:: install-$(1)
endef

$(foreach tool,$(TOOLS),$(eval $(call tool-template,$(tool))))
