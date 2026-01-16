SHELL := /bin/bash
IMAGE_NAME := publishpress/dev-workspace-terminal
FULL_VERSION := $(shell grep "DEV_WORKSPACE_VERSION=" compose.yaml | sed 's/.*DEV_WORKSPACE_VERSION=\([0-9]*\.[0-9]*\.[0-9]*\).*/\1/')
MAJOR_VERSION := $(shell echo $(FULL_VERSION) | cut -d. -f1)
MINOR_VERSION := $(shell echo $(FULL_VERSION) | cut -d. -f2)
IMAGE_TAG_FULL := generic-$(FULL_VERSION)
IMAGE_TAG_MAJOR := generic-$(MAJOR_VERSION)
IMAGE_TAG_MINOR := generic-$(MINOR_VERSION)
PLATFORMS := linux/amd64,linux/arm64
TITLE_COLOR := \033[1;33m
SUCCESS_COLOR := \033[1;32m
DEFAULT_COLOR := \033[0m

.PHONY: help build push bootstrap slim bump-patch bump-minor bump-major version

all: help

define echo_colored
	@echo -e "\n$(1)$(2)${DEFAULT_COLOR}\n"
endef

define build
	docker compose -f compose.yaml build
endef

define push
	docker buildx build --platform ${PLATFORMS} --provenance=mode=max --push \
		-t ${IMAGE_NAME}:${IMAGE_TAG_FULL} \
		-t ${IMAGE_NAME}:${IMAGE_TAG_MAJOR} \
		-t ${IMAGE_NAME}:${IMAGE_TAG_MAJOR}.${MINOR_VERSION} .
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
	@$(call echo_colored,${TITLE_COLOR},"Building the image...")
	@$(call build)
	$(call echo_colored,${SUCCESS_COLOR},"Image built successfully!")

build-provenance: ## Build the Docker image with provenance attestations
	@$(call echo_colored,${TITLE_COLOR},"Building the image with provenance attestations...")
	docker buildx build --platform ${PLATFORMS} --provenance=mode=max -t ${IMAGE_NAME}:${IMAGE_TAG_FULL} .
	$(call echo_colored,${SUCCESS_COLOR},"Image built with provenance attestations successfully!")

push: ## Push the Docker image to the registry
	@$(call echo_colored,${TITLE_COLOR},"Pushing the image...")
	@$(call push)

bootstrap: ## Install required tools
	@$(call echo_colored,${TITLE_COLOR},"Bootstrapping the environment...")
	@$(call bootstrap)

slim: ## Create a slim version of the Docker image
	@docker-slim build \
		--target ${IMAGE_NAME}:${IMAGE_TAG_FULL} \
		--tag ${IMAGE_NAME}:slim-${IMAGE_TAG_FULL} \
		--http-probe=false

version: ## Display the current version
	@echo $(FULL_VERSION)
