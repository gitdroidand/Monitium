#!/usr/bin/env bash

# ============================================================
# Monito Desktop
# Build Script for macOS
#
# Developed by Droidand
# ============================================================

set -Eeuo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(realpath "$SCRIPT_DIR/..")"

PROJECT_NAME="MonitoDesktop"
BUILD_DIR="$PROJECT_ROOT/build"

GREEN="\033[92m"
RED="\033[91m"
YELLOW="\033[93m"
BLUE="\033[94m"
RESET="\033[0m"

echo
echo -e "${BLUE}========================================${RESET}"
echo -e "${BLUE}      Monito Desktop Build (macOS)${RESET}"
echo -e "${BLUE}========================================${RESET}"
echo

echo "Project : $PROJECT_ROOT"
echo "Build   : $BUILD_DIR"
echo

# ------------------------------------------------------------
# Dependencies
# ------------------------------------------------------------

command -v cmake >/dev/null || {
    echo -e "${RED}CMake is not installed.${RESET}"
    exit 1
}

GENERATOR=""

if command -v ninja >/dev/null; then
    GENERATOR="-G Ninja"
else
    echo -e "${YELLOW}Ninja not found. Using default generator.${RESET}"
fi

mkdir -p "$BUILD_DIR"

echo
echo -e "${YELLOW}[1/3] Configuring...${RESET}"

cmake \
    -S "$PROJECT_ROOT" \
    -B "$BUILD_DIR" \
    $GENERATOR \
    -DCMAKE_BUILD_TYPE=Release

echo
echo -e "${YELLOW}[2/3] Building...${RESET}"

START=$(date +%s.%N)

cmake --build "$BUILD_DIR" --parallel

END=$(date +%s.%N)
ELAPSED=$(awk "BEGIN {printf \"%.2f\", $END-$START}")

echo
echo -e "${GREEN}[3/3] Build completed in ${ELAPSED}s${RESET}"

APP=$(find "$BUILD_DIR" -name "*.app" -type d | head -n 1)

echo

if [[ -n "$APP" ]]; then
    echo "Application Bundle:"
    echo "  $APP"
else
    echo "Executable:"
    echo "  $BUILD_DIR/$PROJECT_NAME"
fi

echo
echo -e "${GREEN}✔ Build completed successfully.${RESET}"