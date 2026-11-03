NODE_VERSION := 26
SHELL := /bin/bash
IMAGE_NAME := publishpress/dev-workspace-terminal
IMAGE_TAG := node-${NODE_VERSION}

include ../../make/docker.mk

.PHONY: help build build-local push bootstrap-buildx run

all: help

define build
	$(call docker_build)
endef

define push
	$(call docker_push)
endef

define run
	docker run --rm -it \
		-e HOST_UID="$$(id -u)" \
		-e HOST_GID="$$(id -g)" \
		$(IMAGE_NAME):$(IMAGE_TAG) $(CMD)
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

run: ## Run a shell in the image. Override with CMD="node -v"
	@echo "Running the image..."
	@$(call run)
