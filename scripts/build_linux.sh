#!/usr/bin/env bash

set -Eeuo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(realpath "$SCRIPT_DIR/..")"
BUILD_DIR="$PROJECT_ROOT/build"

GREEN="\033[92m"
RED="\033[91m"
YELLOW="\033[93m"
BLUE="\033[94m"
RESET="\033[0m"

echo -e "${BLUE}== Monito Desktop Build ==${RESET}"
echo
echo "Project : $PROJECT_ROOT"
echo "Build   : $BUILD_DIR"
echo

mkdir -p "$BUILD_DIR"

echo -e "${YELLOW}Configuring...${RESET}"

cmake \
    -S "$PROJECT_ROOT" \
    -B "$BUILD_DIR" \
    -G Ninja

echo

echo -e "${YELLOW}Building...${RESET}"

START=$(date +%s.%N)

cmake --build "$BUILD_DIR" --parallel

END=$(date +%s.%N)
ELAPSED=$(awk "BEGIN {printf \"%.2f\", $END-$START}")

echo
echo -e "${GREEN}✔ Build Success (${ELAPSED}s)${RESET}"

EXECUTABLE="$BUILD_DIR/MonitoDesktopApp"

if [[ ! -x "$EXECUTABLE" ]]; then
    echo -e "${RED}Executable not found:${RESET}"
    echo "$EXECUTABLE"
    exit 1
fi

echo
echo -e "${BLUE}Launching...${RESET}"
echo

cd "$BUILD_DIR"

exec "./MonitoDesktopApp"