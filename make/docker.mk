BUILDX_BUILDER ?= publishpress-multiarch
PLATFORMS ?= linux/amd64,linux/arm64

UNAME_M := $(shell uname -m)
NATIVE_ARCH := $(if $(filter $(UNAME_M),x86_64 amd64),amd64,$(if $(filter $(UNAME_M),aarch64 arm64),arm64,$(UNAME_M)))
BUILD_PLATFORM ?= linux/$(NATIVE_ARCH)

# Requires a docker-container buildx driver for multi-platform builds and registry cache export.
define ensure_buildx_builder
	@if ! docker buildx inspect $(BUILDX_BUILDER) >/dev/null 2>&1; then \
		echo "Creating buildx builder '$(BUILDX_BUILDER)'..."; \
		docker buildx create --name $(BUILDX_BUILDER) --driver docker-container --bootstrap; \
	fi
	@docker buildx use $(BUILDX_BUILDER) >/dev/null
endef

# Build for all PLATFORMS. Images remain in the buildx cache (multi-platform
# manifests cannot be loaded into the local Docker engine).
define docker_build
	$(call ensure_buildx_builder)
	docker buildx build --builder $(BUILDX_BUILDER) --platform $(PLATFORMS) \
		-t $(IMAGE_NAME):$(IMAGE_TAG) .
endef

# Build one platform and load it into the local Docker engine.
# Override platform: make build-local BUILD_PLATFORM=linux/arm64
define docker_build_local
	$(call ensure_buildx_builder)
	docker buildx build --builder $(BUILDX_BUILDER) --platform $(BUILD_PLATFORM) --load \
		-t $(IMAGE_NAME):$(IMAGE_TAG) .
endef

.PHONY: build-local
build-local: ## Build for one platform and load into local Docker
	@echo "Building for $(BUILD_PLATFORM)..."
	@$(call docker_build_local)
	@echo "Image loaded successfully!"

define docker_push
	$(call ensure_buildx_builder)
	docker buildx build --builder $(BUILDX_BUILDER) --platform $(PLATFORMS) --provenance=mode=max --push \
		--cache-from type=registry,ref=$(IMAGE_NAME):buildcache \
		--cache-to type=registry,ref=$(IMAGE_NAME):buildcache,mode=max \
		-t $(IMAGE_NAME):$(IMAGE_TAG) .
endef

.PHONY: bootstrap-buildx
bootstrap-buildx: ## Create or select the multi-platform buildx builder
	$(call ensure_buildx_builder)
	@echo "Buildx builder '$(BUILDX_BUILDER)' is ready."
