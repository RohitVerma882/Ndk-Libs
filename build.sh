#!/usr/bin/env bash

set -euo pipefail

if [[ -z "${NDK_PATH:-}" ]]; then
    echo "Error: NDK_PATH environment variable is not set." >&2
    exit 1
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BUILD_DIR="${SCRIPT_DIR}/build"
OUT_DIR="${SCRIPT_DIR}/out"

API=24
ABIS=("arm64-v8a" "armeabi-v7a" "x86_64" "x86")

mkdir -p "$BUILD_DIR"
mkdir -p "$OUT_DIR"

for ABI in "${ABIS[@]}"; do
    BUILD_ABI_DIR="${BUILD_DIR}/${ABI}"

    mkdir -p "$BUILD_ABI_DIR"

    cmake -G Ninja \
        -DANDROID_NDK="$NDK_PATH" \
        -DCMAKE_TOOLCHAIN_FILE="${NDK_PATH}/build/cmake/android.toolchain.cmake" \
        -DANDROID_ABI="$ABI" \
        -DANDROID_PLATFORM=android-"$API" \
        -DCMAKE_BUILD_TYPE=Release \
        -DANDROID_STL=c++_static \
        -DANDROID_ARM_NEON=ON \
        -B "$BUILD_ABI_DIR" \
        -S "$SCRIPT_DIR"

    ninja -C "$BUILD_ABI_DIR" -j"$(nproc)"
done

for PKG_DIR in "$OUT_DIR"/*/; do
    if [[ -d "$PKG_DIR" && "$(ls -A "$PKG_DIR")" ]]; then
        PKG_NAME=$(basename "${PKG_DIR%/}")
        tar -cJf "${BUILD_DIR}/${PKG_NAME}.tar.xz" -C "$OUT_DIR" "$PKG_NAME"
    fi
done