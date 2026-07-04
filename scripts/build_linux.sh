#!/usr/bin/env bash

set -e

PROJECT_ROOT="$(cd "$(dirname "$0")" && pwd)"
BUILD_DIR="$PROJECT_ROOT/build"

GREEN="\033[92m"
RED="\033[91m"
YELLOW="\033[93m"
BLUE="\033[94m"
RESET="\033[0m"

echo -e "${BLUE}== Monito Desktop Build ==${RESET}"

mkdir -p "$BUILD_DIR"

echo -e "${YELLOW}Configuring...${RESET}"

cmake \
    -S "$PROJECT_ROOT" \
    -B "$BUILD_DIR" \
    -G Ninja

echo -e "${YELLOW}Building...${RESET}"

START=$(date +%s.%N)

cmake --build "$BUILD_DIR" -j

END=$(date +%s.%N)

ELAPSED=$(awk "BEGIN {printf \"%.2f\", $END - $START}")

echo -e "${GREEN}Build Success (${ELAPSED}s)${RESET}"

EXECUTABLE="$BUILD_DIR/MonitoDesktopApp"

echo -e "${BLUE}Launching...${RESET}"

exec "$EXECUTABLE"