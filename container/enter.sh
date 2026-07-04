#!/bin/bash
set -e

IMAGE_NAME="project-builder"

# Build the container image if it doesn't exist
if ! podman image exists "$IMAGE_NAME"; then
    podman build -t "$IMAGE_NAME" -f Containerfile ..
fi

# Enter the container environment
podman run --rm -it \
    -v "$(pwd)/..:/workspace:Z" \
    "$IMAGE_NAME"