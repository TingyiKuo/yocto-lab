#!/bin/bash

# Script to build Yocto mathlib libraries and copy them to the NDK project

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
YOCTO_ROOT="${SCRIPT_DIR}/../../../.."
NDK_PROJECT_DIR="${SCRIPT_DIR}"

echo "Building Yocto mathlib libraries..."

# You need to source the Yocto environment first
# Example: source setup-environment build-qemuarm64

if [ -z "$BUILDDIR" ]; then
    echo "Error: Yocto build environment not sourced!"
    echo "Please run: source setup-environment <build-dir>"
    echo "Example: source setup-environment build-qemuarm64"
    exit 1
fi

echo "Building mathlib with bitbake..."
cd "$YOCTO_ROOT"
bitbake mathlib

# Find the built libraries in sysroots
TMPDIR=$(bitbake -e mathlib | grep "^TMPDIR=" | cut -d'"' -f2)
SYSROOT_DIR="${TMPDIR}/sysroots-components/armv8-2a/mathlib/usr/lib"

if [ ! -d "$SYSROOT_DIR" ]; then
    echo "Error: Built libraries not found in $SYSROOT_DIR"
    exit 1
fi

echo "Copying libraries to NDK project..."

# Copy static library
mkdir -p "${NDK_PROJECT_DIR}/libs/static"
cp "${SYSROOT_DIR}/libmathlib.a" "${NDK_PROJECT_DIR}/libs/static/"

# Copy dynamic library
mkdir -p "${NDK_PROJECT_DIR}/libs/dynamic"
cp "${SYSROOT_DIR}/libmathlib.so.1.0" "${NDK_PROJECT_DIR}/libs/dynamic/libmathlib.so"

echo "Libraries copied successfully!"
echo "Static library: ${NDK_PROJECT_DIR}/libs/static/libmathlib.a"
echo "Dynamic library: ${NDK_PROJECT_DIR}/libs/dynamic/libmathlib.so"
echo ""
echo "Now you can build the NDK project with:"
echo "  bazel build :hellomath_static --config=android_arm64"
echo "  bazel build :hellomath_dynamic --config=android_arm64"