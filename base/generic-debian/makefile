SHELL := /bin/bash
IMAGE_NAME := publishpress/dev-workspace-terminal
IMAGE_TAG := generic-debian

include ../../make/docker.mk

.PHONY: help build build-provenance push bootstrap bootstrap-buildx slim

all: help

define build
	docker compose -f compose.yaml build
endef

define push
	$(call ensure_buildx_builder)
	docker buildx build --builder $(BUILDX_BUILDER) --platform $(PLATFORMS) --provenance=mode=max --push \
		--cache-from type=registry,ref=${IMAGE_NAME}:buildcache-generic-debian \
		--cache-to type=registry,ref=${IMAGE_NAME}:buildcache-generic-debian,mode=max \
		-f Dockerfile \
		-t ${IMAGE_NAME}:${IMAGE_TAG} ..
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
	$(call ensure_buildx_builder)
	docker buildx build --builder $(BUILDX_BUILDER) --platform $(PLATFORMS) --provenance=mode=max \
		--cache-from type=registry,ref=${IMAGE_NAME}:buildcache-generic-debian \
		--cache-to type=registry,ref=${IMAGE_NAME}:buildcache-generic-debian,mode=max \
		-f Dockerfile \
		-t ${IMAGE_NAME}:${IMAGE_TAG} ..
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
		--target ${IMAGE_NAME}:${IMAGE_TAG} \
		--tag ${IMAGE_NAME}:slim-${IMAGE_TAG} \
		--http-probe=false
