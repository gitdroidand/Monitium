#!/usr/bin/env bash

set -e

ROOT="$(cd "$(dirname "$0")" && pwd)"
SCRIPTS="$ROOT/scripts"

CONFIG="$ROOT/.build_platform"

DEFAULT_PLATFORM="linux"

############################################

save_platform() {
    echo "$1" > "$CONFIG"
}

load_platform() {
    if [ -f "$CONFIG" ]; then
        cat "$CONFIG"
    else
        echo "$DEFAULT_PLATFORM"
    fi
}

run_platform() {
    case "$1" in
        linux)
            exec "$SCRIPTS/build_linux.sh"
            ;;

        windows)
            exec "$SCRIPTS/cross_build_windows.sh"
            ;;

        macos)
            exec "$SCRIPTS/build_macos.sh"
            ;;

        *)
            echo "Unknown platform."
            exit 1
            ;;
    esac
}

show_menu() {

    CURRENT=$(load_platform)

    echo
    echo "==================================="
    echo "      Monito Desktop Builder"
    echo "==================================="
    echo
    echo "Current Platform : $CURRENT"
    echo
    echo "1) Linux"
    echo "2) Windows (Cross Build)"
    echo "3) macOS"
    echo "4) Exit"
    echo

    read -rp "Select: " CHOICE

    case "$CHOICE" in
        1)
            save_platform linux
            run_platform linux
            ;;

        2)
            save_platform windows
            run_platform windows
            ;;

        3)
            save_platform macos
            run_platform macos
            ;;

        *)
            exit 0
            ;;
    esac
}

############################################

case "$1" in

    --help)

cat << EOF

Monito Desktop Builder

Usage:

./build.sh
./build.sh --switch
./build.sh --platform linux
./build.sh --platform windows
./build.sh --platform macos

EOF

exit 0
;;

    --switch)
        show_menu
        ;;

    --platform)

        [ -z "$2" ] && {
            echo "Missing platform."
            exit 1
        }

        save_platform "$2"

        run_platform "$2"
        ;;

    "")

        PLATFORM=$(load_platform)

        run_platform "$PLATFORM"
        ;;

    *)

        echo "Unknown argument."

        exit 1

esac