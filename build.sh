#!/usr/bin/env bash

set -ex
export LC_ALL=C

if ! command -v deno >/dev/null 2>&1; then
    if [ -x "./sokol-shdc" ]; then
        echo "WARN: deno not found; using existing ./sokol-shdc"
        exit 0
    fi
    echo "Error: deno not found (required by ./fibs)"
    echo "Install deno, then rerun build:"
    echo "  Arch:   sudo pacman -S deno"
    echo "  Debian: curl -fsSL https://deno.land/install.sh | sh"
    exit 1
fi

TINT_RANGE_H="ext/tint-extract/src/tint/lang/core/ir/analysis/integer_range_analysis.h"
TINT_RANGE_CC="ext/tint-extract/src/tint/lang/core/ir/analysis/integer_range_analysis.cc"

if [ -f "$TINT_RANGE_H" ] && [ -f "$TINT_RANGE_CC" ]; then
    if ! grep -q '#include <cstdint>' "$TINT_RANGE_H"; then
        perl -0pi -e 's/#include <memory>/#include <cstdint>\n#include <memory>/' "$TINT_RANGE_H"
    fi
fi

UNAME=$(uname -s)

if [ "$UNAME" = 'Darwin' ]; then
    if [ "$(uname -m)" = "arm64" ]; then
        PROFILES=("macos-arm64-make-release" "macos-arm64-ninja-release")
    else
        PROFILES=("macos-x64-make-release" "macos-x64-ninja-release")
    fi
elif [ "$UNAME" = 'Linux' ]; then
    if [ "$(uname -m)" = "aarch64" ]; then
        PROFILES=("linux-arm64-make-release" "linux-arm64-ninja-release")
    else
        PROFILES=("linux-x64-make-release" "linux-x64-ninja-release")
    fi
elif [ "${UNAME#*MINGW}" != "$UNAME" ] || [ "${UNAME#*MSYS}" != "$UNAME" ]; then
    PROFILES=("win-vstudio-x64-release")
else
    echo "Error: unsupported platform '$UNAME'"
    exit 1
fi

SHDC_PROFILE=""
for profile in "${PROFILES[@]}"; do
    if ./fibs config "$profile"; then
        SHDC_PROFILE="$profile"
        break
    fi
done

if [ -z "$SHDC_PROFILE" ]; then
    echo "Error: failed to configure sokol-tools with any profile: ${PROFILES[*]}"
    exit 1
fi

./fibs build

SHDC_DIST_PATH=".fibs/dist/$SHDC_PROFILE/sokol-shdc"
SHDC_BUILD_PATH=".fibs/build/$SHDC_PROFILE/sokol-shdc"

if [ -f "$SHDC_DIST_PATH" ]; then
    cp "$SHDC_DIST_PATH" .
elif [ -f "$SHDC_BUILD_PATH" ]; then
    cp "$SHDC_BUILD_PATH" .
else
    echo "Error: sokol-shdc not found in $SHDC_DIST_PATH or $SHDC_BUILD_PATH"
    exit 1
fi
