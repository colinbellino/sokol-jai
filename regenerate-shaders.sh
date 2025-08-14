#!/usr/bin/env bash
set -e

if [ -z "$1" ]
then
    echo "Give me path to sokol-shdc"
    exit 1
fi

sokol_shdc="$1"

for shader in $(find examples -mindepth 2 -maxdepth 2 -type f -name "*.glsl"); do
    echo "Compiling shader: $shader"
    "$sokol_shdc" --input "$shader" --output "${shader%.glsl}.jai" --format sokol_jai --slang glsl410:hlsl5:metal_macos
done
