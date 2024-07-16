WORKSPACE_VERSION=4

all: build

help:
	@echo "Available targets:"
	@awk '/^[a-zA-Z0-9_-]+:/ {print "  " $$1}' $(MAKEFILE_LIST)

.PHONY: build buildpush

build:
	docker compose -f compose.yaml build

buildpush:
	docker buildx build --platform linux/amd64,linux/arm64 --push -t publishpress/dev-workspace-terminal:generic-$(WORKSPACE_VERSION) .
