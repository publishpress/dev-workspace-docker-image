SHELL := /bin/bash

all: help

help:
	@echo "Available targets:"
	@awk '/^[a-zA-Z0-9_-]+:/ {print "  " $$1}' $(MAKEFILE_LIST)

.PHONY: push-all bootstrap-buildx

include make/docker.mk

bootstrap-buildx: ## Create or select the multi-platform buildx builder
	@$(call ensure_buildx_builder)
	@echo "Buildx builder '$(BUILDX_BUILDER)' is ready."

push-all:
	./scripts/push-all.sh
