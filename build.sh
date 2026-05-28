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
    cp .fibs/build/macos-make-release/sokol-shdc
else
    cp .fibs/build/linux-make-release/sokol-shdc
fi
