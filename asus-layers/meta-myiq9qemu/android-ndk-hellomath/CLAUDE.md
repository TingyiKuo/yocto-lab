# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is an Android NDK project that demonstrates cross-compilation compatibility between Yocto-built libraries and Android NDK applications. The project tests static and dynamic linking of ARM64 libraries built with Yocto in an Android development environment.

## Architecture

The project consists of:
- **Yocto-built libraries**: ARM64 mathlib compiled with Yocto toolchain
- **Android NDK application**: C++ applications that consume the Yocto libraries
- **Docker build environment**: Containerized Android NDK + Bazel build system
- **Static/Dynamic linking**: Both linking modes are tested for compatibility

## Key Files

- `BUILD`: Bazel build configuration with static/dynamic library imports and binary targets
- `MODULE.bazel`: Bazel module configuration with Android NDK dependency
- `.bazelrc`: Bazel configuration for Android ARM64 cross-compilation
- `src/main/cpp/hellomath.cpp`: Main console application that uses mathlib functions
- `src/main/cpp/simple_test.cpp`: Simple test application for library validation
- `src/main/cpp/mathlib.h`: Header interface for Yocto-built mathlib
- `libs/static/libmathlib.a`: ARM64 static library built with Yocto
- `libs/dynamic/libmathlib.so`: ARM64 shared library built with Yocto

## Development Commands

### Prerequisites Setup
```bash
# Bazel 8+ with workspace support is required
# Docker for containerized NDK build environment
```

### Yocto Library Building (already done, don't need to do)
```bash
# From yocto-lab root directory, source build environment
source setup-environment build-qcom-wayland  # or other ARM64 target

# Build the mathlib recipe
bitbake mathlib

# Copy libraries to NDK project (automated)
./build_yocto_libs.sh
```

### Docker Build Environment
```bash
# Build the Docker image (one-time setup)
cd ndk-build-env/
docker build --build-arg userid=$(id -u) --build-arg groupid=$(id -g) --build-arg username=$(id -un) -t ndk-builder .

# Run interactive build environment
./itrun-ndk-build-env.sh
```

### Building NDK Applications

#### Method 1: Using Build Script (Recommended)
```bash
# Inside Docker container
./build_ndk_apps.sh
```

This builds all applications:
- `hellomath_static` - Main console application (static linking)
- `hellomath_dynamic` - Main console application (dynamic linking)  
- `simple_test_static` - Test application (static linking)
- `simple_test_dynamic` - Test application (dynamic linking)

#### Method 2: Manual NDK Build
```bash
# Inside Docker container
NDK_COMPILER="/opt/android-sdk/ndk/28.2.13676358/toolchains/llvm/prebuilt/linux-x86_64/bin/aarch64-linux-android34-clang++"

# Static linking
$NDK_COMPILER -o hellomath_static src/main/cpp/hellomath.cpp -I src/main/cpp -L libs/static -lmathlib -static

# Dynamic linking
$NDK_COMPILER -o hellomath_dynamic src/main/cpp/hellomath.cpp -I src/main/cpp -L libs/dynamic -lmathlib -Wl,-rpath,libs/dynamic
```

#### Method 3: Bazel Build (Legacy - Complex Configuration)
```bash
# Inside Docker container (Bazel configuration needs work)
bazel build :hellomath_static --config=android_arm64
bazel build :hellomath_dynamic --config=android_arm64
```

### Testing and Validation
```bash
# Run build validation script
./test_build.sh

# Check library architecture compatibility
file libs/static/libmathlib.a libs/dynamic/libmathlib.so

# Verify built applications
file hellomath_static hellomath_dynamic simple_test_static simple_test_dynamic

# Expected output:
# hellomath_static:    ELF 64-bit LSB executable, ARM aarch64, version 1 (SYSV), statically linked
# hellomath_dynamic:   ELF 64-bit LSB pie executable, ARM aarch64, version 1 (SYSV), dynamically linked, interpreter /system/bin/linker64
# simple_test_static:  ELF 64-bit LSB executable, ARM aarch64, version 1 (SYSV), statically linked  
# simple_test_dynamic: ELF 64-bit LSB pie executable, ARM aarch64, version 1 (SYSV), dynamically linked, interpreter /system/bin/linker64
```

### Build Success Verification

✅ **Cross-compilation successful**: Yocto ARM64 libraries successfully link with Android NDK applications  
✅ **Static linking**: `hellomath_static` and `simple_test_static` built as statically linked ARM64 binaries  
✅ **Dynamic linking**: `hellomath_dynamic` and `simple_test_dynamic` built as dynamically linked ARM64 binaries  
✅ **Architecture compatibility**: All binaries target ARM aarch64 architecture suitable for Android devices  
✅ **Library compatibility**: Yocto-built `libmathlib.a` and `libmathlib.so` successfully integrated

## Build Configuration

### Bazel Configuration
- **MODULE.bazel**: Uses `rules_android_ndk` with NDK r28
- **BUILD**: Defines `cc_import` targets for Yocto libraries and `cc_binary` targets for applications
- **.bazelrc**: Configures `android_arm64` build config with clang toolchain

### Docker Environment
- **Base**: Ubuntu 22.04 with OpenJDK 17
- **Android NDK**: r28.2.13676358 
- **Bazel**: 8.3.1 with workspace support enabled
- **Build tools**: Android SDK command-line tools and platform-tools

## Architecture Testing

The project validates:
1. **Cross-compilation compatibility**: Yocto ARM64 libraries → Android NDK applications
2. **ABI compatibility**: ARMv8-A Yocto libraries work with Android NDK ARM64 target
3. **Linking behavior**: Both static and dynamic linking scenarios
4. **Symbol resolution**: C/C++ calling conventions between Yocto and Android toolchains

## Build Dependencies

- **Yocto Environment**: Must be sourced with ARM64 target (e.g., `build-qcom-wayland`)
- **mathlib Recipe**: Yocto recipe that builds the library (located in parent meta-layer)
- **Android NDK**: r28+ with ARM64 support
- **Bazel**: 8.3.1+ with workspace support
- **Docker**: For containerized build environment

## Common Issues

- **Architecture mismatch**: Ensure Yocto libraries are built for ARM64 target
- **Missing libraries**: Run `build_yocto_libs.sh` to copy Yocto-built libraries
- **Bazel workspace**: Enable workspace support in Bazel 8+ with `--enable_workspace`
- **NDK path**: Set `ANDROID_NDK_HOME` or let Bazel auto-detect NDK location