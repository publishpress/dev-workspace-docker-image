WP_CLI_VERSION := 2
PHP_VERSION := 8.5
SHELL := /bin/bash
IMAGE_NAME := publishpress/dev-workspace-wpcli
IMAGE_TAG := wpcli-${WP_CLI_VERSION}-php-${PHP_VERSION}

include ../../make/docker.mk

.PHONY: help build build-local push bootstrap-buildx

all: help

define build
	$(call docker_build)
endef

define push
	$(call docker_push)
endef

help:
	@echo "Usage: make [target]"
	@echo ""
	@echo "Targets:"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2}'

build: ## Build the Docker image
	@echo "Building the image..."
	@$(call build)
	@echo "Image built successfully!"

push: ## Push the Docker image to the registry
	@echo "Pushing the image..."
	@$(call push)
