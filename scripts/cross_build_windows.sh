#!/usr/bin/env bash

# ============================================================
# Monito Desktop
# Windows Cross Build (MinGW-w64)
#
# Developed by Droidand
# ============================================================

set -Eeuo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(realpath "$SCRIPT_DIR/..")"
BUILD_DIR="$PROJECT_ROOT/build-windows"

GREEN="\033[92m"
RED="\033[91m"
YELLOW="\033[93m"
BLUE="\033[94m"
RESET="\033[0m"

echo
echo -e "${BLUE}========================================${RESET}"
echo -e "${BLUE} Monito Desktop Windows Cross Build${RESET}"
echo -e "${BLUE}========================================${RESET}"
echo

echo "Project : $PROJECT_ROOT"
echo "Build   : $BUILD_DIR"
echo

TOOLS=(
    cmake
    ninja
    x86_64-w64-mingw32-gcc
    x86_64-w64-mingw32-g++
)

for tool in "${TOOLS[@]}"; do
    if ! command -v "$tool" >/dev/null; then
        echo -e "${RED}Missing dependency: $tool${RESET}"
        exit 1
    fi
done

mkdir -p "$BUILD_DIR"

echo -e "${YELLOW}[1/2] Configuring...${RESET}"

cmake \
    -S "$PROJECT_ROOT" \
    -B "$BUILD_DIR" \
    -G Ninja \
    -DCMAKE_SYSTEM_NAME=Windows \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_C_COMPILER=x86_64-w64-mingw32-gcc \
    -DCMAKE_CXX_COMPILER=x86_64-w64-mingw32-g++

echo
echo -e "${YELLOW}[2/2] Building...${RESET}"

START=$(date +%s.%N)

cmake --build "$BUILD_DIR" --parallel

END=$(date +%s.%N)
ELAPSED=$(awk "BEGIN {printf \"%.2f\", $END-$START}")

EXE="$BUILD_DIR/MonitoDesktopApp.exe"

echo

if [[ -f "$EXE" ]]; then
    echo -e "${GREEN}✔ Build Success (${ELAPSED}s)${RESET}"
    echo
    echo "Output:"
    echo "  $EXE"
else
    echo -e "${RED}Build failed: executable not found.${RESET}"
    exit 1
fi