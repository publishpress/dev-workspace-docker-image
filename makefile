SHELL := /bin/bash
IMAGE_NAME := publishpress/dev-workspace-terminal
IMAGE_TAG := generic-4.3.4
PLATFORMS := linux/amd64,linux/arm64
TITLE_COLOR := \033[1;33m
SUCCESS_COLOR := \033[1;32m
DEFAULT_COLOR := \033[0m

.PHONY: help build push bootstrap slim

all: help

define echo_colored
	@echo -e "\n$(1)$(2)${DEFAULT_COLOR}\n"
endef

define build
	docker compose -f compose.yaml build
endef

define push
	docker buildx build --platform ${PLATFORMS} --push -t ${IMAGE_NAME}:${IMAGE_TAG} .
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

push: ## Push the Docker image to the registry
	@$(call echo_colored,${TITLE_COLOR},"Pushing the image...")
	@$(call push)

bootstrap: ## Install required tools
	@$(call echo_colored,${TITLE_COLOR},"Bootstrapping the environment...")
	@$(call bootstrap)

slim: ## Create a slim version of the Docker image
	@docker-slim build \
		--target ${IMAGE_NAME}:${IMAGE_TAG} \
		--tag ${IMAGE_NAME}:slim-${IMAGE_TAG} \
		--http-probe=false
