all: build

help:
	@echo "Available targets:"
	@awk '/^[a-zA-Z0-9_-]+:/ {print "  " $$1}' $(MAKEFILE_LIST)

.PHONY: build push

build:
	docker compose -f compose.yaml build

push:
	docker buildx build --platform linux/amd64,linux/arm64 --push -t publishpress/dev-workspace-terminal:generic-4.0.1 .
