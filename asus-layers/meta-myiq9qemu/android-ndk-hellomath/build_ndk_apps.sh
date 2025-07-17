#!/bin/bash

# Build script for Android NDK HelloMath applications
# This script builds both static and dynamic versions using Android NDK directly

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
NDK_PATH="/opt/android-sdk/ndk/28.2.13676358"
COMPILER="${NDK_PATH}/toolchains/llvm/prebuilt/linux-x86_64/bin/aarch64-linux-android34-clang++"

echo "Building Android NDK HelloMath applications..."
echo "Using NDK: $NDK_PATH"
echo "Compiler: $COMPILER"

# Check if we're in Docker environment
if [ ! -f "$COMPILER" ]; then
    echo "Error: Android NDK compiler not found at $COMPILER"
    echo "Please run this script inside the Docker container:"
    echo "  ./ndk-build-env/itrun-ndk-build-env.sh"
    exit 1
fi

# Check if libraries exist
if [ ! -f "libs/static/libmathlib.a" ]; then
    echo "Error: Static library not found. Run build_yocto_libs.sh first."
    exit 1
fi

if [ ! -f "libs/dynamic/libmathlib.so" ]; then
    echo "Error: Dynamic library not found. Run build_yocto_libs.sh first."
    exit 1
fi

echo ""
echo "Building static-linked applications..."

# Build hellomath static
echo "  Building hellomath_static..."
$COMPILER -o hellomath_static src/main/cpp/hellomath.cpp \
    -I src/main/cpp \
    -L libs/static \
    -lmathlib \
    -static

# Build simple test static
echo "  Building simple_test_static..."
$COMPILER -o simple_test_static src/main/cpp/simple_test.cpp \
    -I src/main/cpp \
    -L libs/static \
    -lmathlib \
    -static

echo ""
echo "Building dynamic-linked applications..."

# Build hellomath dynamic
echo "  Building hellomath_dynamic..."
$COMPILER -o hellomath_dynamic src/main/cpp/hellomath.cpp \
    -I src/main/cpp \
    -L libs/dynamic \
    -lmathlib \
    -Wl,-rpath,libs/dynamic

# Build simple test dynamic
echo "  Building simple_test_dynamic..."
$COMPILER -o simple_test_dynamic src/main/cpp/simple_test.cpp \
    -I src/main/cpp \
    -L libs/dynamic \
    -lmathlib \
    -Wl,-rpath,libs/dynamic

echo ""
echo "Build complete! Generated binaries:"
echo "  Static applications:"
echo "    hellomath_static      - Main console application (static)"
echo "    simple_test_static    - Test application (static)"
echo "  Dynamic applications:"
echo "    hellomath_dynamic     - Main console application (dynamic)"
echo "    simple_test_dynamic   - Test application (dynamic)"

echo ""
echo "Verifying architectures (if file command is available):"
if command -v file > /dev/null 2>&1; then
    file hellomath_static hellomath_dynamic simple_test_static simple_test_dynamic
else
    echo "  file command not available, but all binaries are built for ARM64 Android"
fi

echo ""
echo "All applications are built for ARM64 and ready for Android deployment!"