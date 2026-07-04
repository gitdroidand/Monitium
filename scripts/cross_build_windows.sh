#!/usr/bin/env bash

set -e

PROJECT_ROOT="$(cd "$(dirname "$0")" && pwd)"
BUILD_DIR="$PROJECT_ROOT/build-windows"

GREEN="\033[92m"
RED="\033[91m"
YELLOW="\033[93m"
BLUE="\033[94m"
RESET="\033[0m"

echo -e "${BLUE}== Monito Desktop Windows Cross Build ==${RESET}"

# ------------------------------------------------------------
# Check required tools
# ------------------------------------------------------------

for tool in cmake ninja x86_64-w64-mingw32-g++ x86_64-w64-mingw32-gcc
do
    if ! command -v "$tool" >/dev/null 2>&1; then
        echo -e "${RED}Missing dependency: ${tool}${RESET}"
        exit 1
    fi
done

mkdir -p "$BUILD_DIR"

echo -e "${YELLOW}Configuring...${RESET}"

cmake \
    -S "$PROJECT_ROOT" \
    -B "$BUILD_DIR" \
    -G Ninja \
    -DCMAKE_SYSTEM_NAME=Windows \
    -DCMAKE_C_COMPILER=x86_64-w64-mingw32-gcc \
    -DCMAKE_CXX_COMPILER=x86_64-w64-mingw32-g++

echo -e "${YELLOW}Building...${RESET}"

START=$(date +%s.%N)

cmake --build "$BUILD_DIR" -j"$(nproc)"

END=$(date +%s.%N)

ELAPSED=$(awk "BEGIN {printf \"%.2f\", $END-$START}")

echo -e "${GREEN}Windows Build Success (${ELAPSED}s)${RESET}"

echo
echo -e "${BLUE}Output:${RESET}"
echo "$BUILD_DIR/MonitoDesktopApp.exe"