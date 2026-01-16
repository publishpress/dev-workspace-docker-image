SHELL := /bin/bash
IMAGE_NAME := publishpress/dev-workspace-terminal
FULL_VERSION := $(shell grep "DEV_WORKSPACE_VERSION=" Dockerfile | sed 's/.*DEV_WORKSPACE_VERSION=\([0-9]*\.[0-9]*\.[0-9]*\).*/\1/')
MAJOR_VERSION := $(shell echo $(FULL_VERSION) | cut -d. -f1)
MINOR_VERSION := $(shell echo $(FULL_VERSION) | cut -d. -f2)
IMAGE_TAG_FULL := generic-$(FULL_VERSION)
IMAGE_TAG_MAJOR := generic-$(MAJOR_VERSION)
IMAGE_TAG_MINOR := generic-$(MINOR_VERSION)
PLATFORMS := linux/amd64,linux/arm64

.PHONY: help build build-provenance push bootstrap slim version

all: help

define build
	docker compose -f compose.yaml build
	docker tag ${IMAGE_NAME}:${IMAGE_TAG_FULL} ${IMAGE_NAME}:${IMAGE_TAG_MAJOR}
	docker tag ${IMAGE_NAME}:${IMAGE_TAG_FULL} ${IMAGE_NAME}:${IMAGE_TAG_MAJOR}.${MINOR_VERSION}
endef

define push
	docker buildx build --platform ${PLATFORMS} --provenance=mode=max --push \
		--cache-from type=registry,ref=${IMAGE_NAME}:buildcache \
		--cache-to type=registry,ref=${IMAGE_NAME}:buildcache,mode=max \
		-t ${IMAGE_NAME}:${IMAGE_TAG_MAJOR} \
		-t ${IMAGE_NAME}:${IMAGE_TAG_MAJOR}.${MINOR_VERSION} \
		-t ${IMAGE_NAME}:${IMAGE_TAG_FULL} .
endef

define bootstrap
	brew install docker-slim
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

build-provenance: ## Build the Docker image with provenance attestations
	@echo "Building the image with provenance attestations..."
	docker buildx build --platform ${PLATFORMS} --provenance=mode=max \
		--cache-from type=registry,ref=${IMAGE_NAME}:buildcache \
		--cache-to type=registry,ref=${IMAGE_NAME}:buildcache,mode=max \
		-t ${IMAGE_NAME}:${IMAGE_TAG_MAJOR} \
		-t ${IMAGE_NAME}:${IMAGE_TAG_MAJOR}.${MINOR_VERSION} \
		-t ${IMAGE_NAME}:${IMAGE_TAG_FULL} .
	@echo "Image built with provenance attestations successfully!"

push: ## Push the Docker image to the registry
	@echo "Pushing the image..."
	@$(call push)

bootstrap: ## Install required tools
	@echo "Bootstrapping the environment..."
	@$(call bootstrap)
	@echo "Environment bootstrapped successfully!"

slim: ## Create a slim version of the Docker image
	@docker-slim build \
		--target ${IMAGE_NAME}:${IMAGE_TAG_FULL} \
		--tag ${IMAGE_NAME}:slim-${IMAGE_TAG_FULL} \
		--http-probe=false

version: ## Display the current version
	@echo $(FULL_VERSION)
