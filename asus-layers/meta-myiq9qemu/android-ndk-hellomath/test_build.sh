#!/bin/bash

# Test script to verify the build setup

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "Testing Bazel NDK HelloMath Build Setup..."

# Check if required files exist
echo "Checking project structure..."
check_file() {
    if [ -f "$1" ]; then
        echo "✓ $1"
    else
        echo "✗ $1 (missing)"
        return 1
    fi
}

check_dir() {
    if [ -d "$1" ]; then
        echo "✓ $1/"
    else
        echo "✗ $1/ (missing)"
        return 1
    fi
}

check_file "WORKSPACE"
check_file "BUILD"
check_file ".bazelrc"
check_file "src/main/cpp/hellomath.cpp"
check_file "src/main/cpp/mathlib.h"
check_dir "libs/static"
check_dir "libs/dynamic"

echo ""
echo "Checking for Yocto libraries..."
if [ -f "libs/static/libmathlib.a" ]; then
    echo "✓ Static library found"
    file libs/static/libmathlib.a
else
    echo "✗ Static library not found - run build_yocto_libs.sh first"
fi

if [ -f "libs/dynamic/libmathlib.so" ]; then
    echo "✓ Dynamic library found"
    file libs/dynamic/libmathlib.so
else
    echo "✗ Dynamic library not found - run build_yocto_libs.sh first"
fi

echo ""
echo "Checking Bazel..."
if command -v bazel &> /dev/null; then
    echo "✓ Bazel found: $(bazel version | head -1)"
else
    echo "✗ Bazel not found - please install Bazel"
    exit 1
fi

echo ""
echo "Checking Android NDK..."
if [ -n "$ANDROID_NDK_HOME" ] && [ -d "$ANDROID_NDK_HOME" ]; then
    echo "✓ Android NDK found at: $ANDROID_NDK_HOME"
else
    echo "⚠ ANDROID_NDK_HOME not set or directory not found"
    echo "  Bazel will try to auto-detect NDK location"
fi

echo ""
echo "Test complete! If libraries are present, you can build with:"
echo "  bazel build :hellomath_static --config=android_arm64"
echo "  bazel build :hellomath_dynamic --config=android_arm64"