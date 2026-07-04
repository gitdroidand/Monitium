#!/usr/bin/env bash

# ============================================================
# Monito Desktop
# Build Script for macOS
#
# Developed by Droidand
# ============================================================

set -e

PROJECT_NAME="MonitoDesktop"
BUILD_DIR="build"

echo
echo "========================================"
echo "      Monito Desktop Build (macOS)"
echo "========================================"
echo

# ------------------------------------------------------------
# Check dependencies
# ------------------------------------------------------------

command -v cmake >/dev/null 2>&1 || {
    echo "Error: CMake is not installed."
    exit 1
}

command -v ninja >/dev/null 2>&1 || {
    echo "Warning: Ninja not found."
    echo "Falling back to default CMake generator."
    GENERATOR=""
}

if command -v ninja >/dev/null 2>&1; then
    GENERATOR="-G Ninja"
fi

# ------------------------------------------------------------
# Create build directory
# ------------------------------------------------------------

mkdir -p "$BUILD_DIR"

echo "[1/3] Configuring project..."

cmake \
    -S . \
    -B "$BUILD_DIR" \
    $GENERATOR \
    -DCMAKE_BUILD_TYPE=Release

echo
echo "[2/3] Building..."

cmake --build "$BUILD_DIR"

echo
echo "[3/3] Done!"
echo

APP=$(find "$BUILD_DIR" -name "*.app" | head -n 1)

if [ -n "$APP" ]; then
    echo "Application bundle:"
    echo "$APP"
else
    echo "Executable:"
    echo "$BUILD_DIR/$PROJECT_NAME"
fi

echo
echo "Build completed successfully."