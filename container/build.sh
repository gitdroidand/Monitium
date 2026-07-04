#!/bin/bash
set -e

IMAGE_NAME="project-builder"

# Build the container image
podman build -t "$IMAGE_NAME" -f Containerfile ..

# Build the project inside the container
podman run --rm \
    -v "$(pwd)/..:/workspace:Z" \
    "$IMAGE_NAME" \
    bash -c "mkdir -p /workspace/build && cd /workspace/build && cmake .. && make -j$(nproc)"

echo "✅ Build complete! Run ./run.sh to start the application."