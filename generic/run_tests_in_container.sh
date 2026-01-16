#!/bin/sh

# Build the test container
echo "Building test container..."
docker build -t longpath-test -f Dockerfile.test .

# Run tests in container - without removing the container after execution
echo "Running tests in interactive mode..."
docker run -it longpath-test

echo "After exiting the container, you can run tests with:"
echo "  docker exec -it CONTAINER_ID bats test_longpath.bats"
echo ""
echo "To list running containers:"
echo "  docker ps"
echo ""
echo "To stop and remove the container when done:"
echo "  docker stop CONTAINER_ID && docker rm CONTAINER_ID"
