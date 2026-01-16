SHELL := /bin/bash
IMAGE_NAME := publishpress/dev-workspace-terminal
IMAGE_TAG := library-tooltips
PLATFORMS := linux/amd64,linux/arm64

.PHONY: help build push

all: help

define build
	docker build --platform ${PLATFORMS} -t ${IMAGE_NAME}:${IMAGE_TAG} .
endef

define push
	docker buildx build --platform ${PLATFORMS} --provenance=mode=max --push \
		--cache-from type=registry,ref=${IMAGE_NAME}:buildcache \
		--cache-to type=registry,ref=${IMAGE_NAME}:buildcache,mode=max \
		-t ${IMAGE_NAME}:${IMAGE_TAG} .
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
