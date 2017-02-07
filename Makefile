SHELL := /bin/bash
QUIET ?= @

build_dir := .build

services := $(shell docker-compose config --services 2>/dev/null)

stack := /usr/local/bin/stack
stack_completions := /usr/local/share/zsh/site-functions/_stack

setup_targets := \
	$(stack) \
	$(stack_completions)

build_targets =	\
	$(addprefix $(build_dir)/, $(addsuffix .build, $(services)))

#
# Targets
#

# Download & configure developer environment.
setup: $(setup_targets)

# Build local docker images.
build: setup $(build_targets)

clean:
	rm -rf $(build_dir)

# Boot up current stack
up: build
up:
	docker-compose up

# This is a target to help you debug the Makefile whenever things
# don't work as you expect. You use it to print the value of a
# variable like so `make print-VARIABLENAME`, e.g.
# `make print-repositories`.
print-%: ; @echo $* is $($*)

#
# Rules
#

### setup

$(stack):
	$(call print, Linking script, $@ -> scripts/stack.sh)
	$(QUIET)ln -s $(abspath scripts/stack.sh) $@

$(stack_completions):
	$(call print, Linking zsh completions, $@ -> scripts/stack.completions)
	$(QUIET)ln -s $(abspath scripts/stack.completions) $@

### docker images

# Generic rule to build a service
$(build_dir)/%.build: $(wildcard ./services/%/docker/*)
	$(call print, Building docker image, $* - $(notdir $?) changed)
	$(QUIET)docker-compose build $*
	$(call touch, $@)

# Service declarations that we don't want to consider rebuilding.
$(build_dir)/mysql.build:
	$(call touch, $@)

#
# Functions
#

# $(call touch, file)
#   Used to touch a file while ensuring that any parent directories are
#   created beforehand.
define touch
	@mkdir -p $(dir $1)
	@touch $1
endef

# $(call print-rule, variable, extra)
#   Used to decorate the output before printing it to stdout.
define print
	@echo -e "[$(shell date +%H:%M:%S)] $(bold_green)$(strip $1)$(reset): $(strip $2)"
endef