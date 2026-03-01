#!/usr/bin/env bash

set -ex

./fibs build
if [ $(uname -s) = 'Darwin' ]; then
    cp .fibs/build/macos-make-release/sokol-shdc
else
    cp .fibs/build/linux-make-release/sokol-shdc
fi
