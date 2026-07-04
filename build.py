#!/usr/bin/env python3

import subprocess
import sys
import time
from pathlib import Path

PROJECT_ROOT = Path(__file__).parent
BUILD_DIR = PROJECT_ROOT / "build"

GREEN = "\033[92m"
RED = "\033[91m"
YELLOW = "\033[93m"
BLUE = "\033[94m"
RESET = "\033[0m"


def run(cmd):
    process = subprocess.run(cmd)
    return process.returncode


print(f"{BLUE}== Monito Desktop Build =={RESET}")

BUILD_DIR.mkdir(exist_ok=True)

print(f"{YELLOW}Configuring...{RESET}")

if run([
    "cmake",
    "-S", str(PROJECT_ROOT),
    "-B", str(BUILD_DIR),
    "-G", "Ninja"
]):
    print(f"{RED}Configuration failed.{RESET}")
    sys.exit(1)

print(f"{YELLOW}Building...{RESET}")

start = time.perf_counter()

code = run([
    "cmake",
    "--build",
    str(BUILD_DIR),
    "-j"
])

elapsed = time.perf_counter() - start

if code != 0:
    print(f"{RED}Build Failed!{RESET}")
    sys.exit(code)

print(f"{GREEN}Build Success ({elapsed:.2f}s){RESET}")

exe = BUILD_DIR / "MonitoDesktopApp"

print(f"{BLUE}Launching...{RESET}")

subprocess.run([str(exe)])