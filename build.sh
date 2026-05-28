#!/usr/bin/env bash

set -ex

TINT_RANGE_H="ext/tint-extract/src/tint/lang/core/ir/analysis/integer_range_analysis.h"
TINT_RANGE_CC="ext/tint-extract/src/tint/lang/core/ir/analysis/integer_range_analysis.cc"

if [ -f "$TINT_RANGE_H" ] && [ -f "$TINT_RANGE_CC" ]; then
    perl -pi -e 's/GetInfo\(const FunctionParam\* param, uint32_t index = 0\)/GetInfo(const FunctionParam* param, int index = 0)/g' "$TINT_RANGE_H"
    perl -pi -e 's/GetInfo\(const FunctionParam\* param, uint32_t index\)/GetInfo(const FunctionParam* param, int index)/g' "$TINT_RANGE_CC"
    if ! grep -q '#include <cstdint>' "$TINT_RANGE_H"; then
        perl -0pi -e 's/#include <memory>/#include <cstdint>\n#include <memory>/' "$TINT_RANGE_H"
    fi
fi

./fibs build

if [ $(uname -s) = 'Darwin' ]; then
    SHDC_PROFILE="macos-make-release"
else
    SHDC_PROFILE="linux-make-release"
fi

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
