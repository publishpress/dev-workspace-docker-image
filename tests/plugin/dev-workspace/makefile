SHELL := /bin/bash
IMAGE_NAME := publishpress/dev-workspace-terminal
IMAGE_TAG := generic-4.3.2
PLATFORMS := linux/amd64,linux/arm64
TITLE_COLOR := \033[1;33m
SUCCESS_COLOR := \033[1;32m
DEFAULT_COLOR := \033[0m

all: help

define echo_colored
	@echo -e "\n$(1)$(2)${DEFAULT_COLOR}\n"
endef

define build
	source ./.env && \
		CONTAINER_NAME=$${CONTAINER_NAME} \
		IMAGE_NAME=$${IMAGE_NAME} \
		BIN_PATH=$${BIN_PATH} \
		CACHE_PATH=$${CACHE_PATH} \
		$${BIN_PATH}/exec build "$$@";
endef

define push
	source ./.env && \
		CONTAINER_NAME=$${CONTAINER_NAME} \
		IMAGE_NAME=$${IMAGE_NAME} \
		BIN_PATH=$${BIN_PATH} \
		CACHE_PATH=$${CACHE_PATH} \
		$${BIN_PATH}/exec build-push "$$@";
endef

define update
	source ./.env && \
	CONTAINER_NAME=$${CONTAINER_NAME} \
	IMAGE_NAME=$${IMAGE_NAME} \
	BIN_PATH=$${BIN_PATH} \
	CACHE_PATH=$${CACHE_PATH} \
	$${BIN_PATH}/exec update "$$@"
endef


help:
	@echo "Usage: make [target]"
	@echo ""
	@echo "Targets:"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2}'

.PHONY: build buildpush update

build: ## Build the Docker image
	@$(call echo_colored,${TITLE_COLOR},"Building the image...")
	@$(call build)
	$(call echo_colored,${SUCCESS_COLOR},"Image built successfully!")

push: ## Push the Docker image to the registry
	@$(call echo_colored,${TITLE_COLOR},"Pushing the image...")
	@$(call push)
	$(call echo_colored,${SUCCESS_COLOR},"Image pushed successfully!")

update: ## Update the Docker images
	@$(call echo_colored,${TITLE_COLOR},"Updating the image...")
	@$(call update)
	$(call echo_colored,${SUCCESS_COLOR},"Image updated successfully!")
