#!/bin/bash
set -e

IMAGE_NAME="project-builder"

# Build the project if needed
if [ ! -f ../build/Project ]; then
    ./build.sh
fi

# Run the application
podman run --rm \
    -e DISPLAY="$DISPLAY" \
    -v /tmp/.X11-unix:/tmp/.X11-unix:rw \
    -v "$(pwd)/..:/workspace:Z" \
    --security-opt label=type:container_runtime_t \
    "$IMAGE_NAME" \
    /workspace/build/Project