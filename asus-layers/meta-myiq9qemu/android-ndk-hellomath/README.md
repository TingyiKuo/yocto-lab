# Android NDK HelloMath - Yocto Cross-Compilation Test

This project demonstrates linking Yocto-built libraries with Android NDK applications, testing cross-compilation compatibility between Yocto and Android platforms.

## Project Structure


## Prerequisites

1. **Yocto Build Environment**: Set up and sourced
2. **Android NDK**: Installed and configured
3. **Bazel**: Installed for building the NDK project

## Building Process

### Step 1: Build Yocto Libraries

First, build the mathlib using Yocto for ARM64:

```bash
# From yocto-lab root directory
source setup-environment build-qcom-wayland  # or any ARM64 build

# Add the meta-myiq9qemu layer if not already added
bitbake-layers add-layer meta-myiq9qemu

# Build the mathlib for ARM64
bitbake mathlib
```

This produces ARM64 libraries compatible with Android ARMv8-A devices.

### Step 2: Copy Libraries to NDK Project

#### Option A: Using the automated script
```bash
# From the android-ndk-hellomath directory
./build_yocto_libs.sh
```

This script will:
- Build the mathlib using bitbake
- Copy the static library (`libmathlib.a`) to `libs/static/`
- Copy the shared library (`libmathlib.so`) to `libs/dynamic/`

#### Option B: Manual copy process
After building with `bitbake mathlib`, manually copy the libraries:

```bash
# Find the built libraries
find /path/to/build-dir -name "libmathlib.*" 2>/dev/null

# Example paths (adjust for your build directory):
# Static library location:
# /build-qcom-wayland/tmp-glibc/sysroots-components/armv8-2a/mathlib/usr/lib/libmathlib.a
# Dynamic library location:
# /build-qcom-wayland/tmp-glibc/sysroots-components/armv8-2a/mathlib/usr/lib/libmathlib.so.1.0

# Copy static library
cp /path/to/build-dir/tmp-glibc/sysroots-components/armv8-2a/mathlib/usr/lib/libmathlib.a \
   libs/static/

# Copy dynamic library
cp /path/to/build-dir/tmp-glibc/sysroots-components/armv8-2a/mathlib/usr/lib/libmathlib.so.1.0 \
   libs/dynamic/libmathlib.so

# Verify libraries are copied
ls -la libs/static/libmathlib.a libs/dynamic/libmathlib.so
```

### Step 3: Verify Architecture Compatibility

First, verify that the Yocto libraries are built for ARM64 (ARMv8-A):

```bash
# Check library architectures
file libs/static/libmathlib.a libs/dynamic/libmathlib.so

# Expected output:
# libs/static/libmathlib.a: current ar archive  
# libs/dynamic/libmathlib.so: ELF 64-bit LSB shared object, ARM aarch64
```

Test the build structure (this will show architecture compatibility):
```bash
# This will fail with architecture mismatch (expected behavior)
bazel build :test_static
# Error: "libmathlib.a(mathlib.o) is incompatible with elf64-x86-64"
# This confirms ARM64 libraries are correctly cross-compiled!
```

### Step 4: Android NDK Integration (Future)

For actual Android NDK builds, you would need to:

1. **Install Android NDK** (r25c or later)
2. **Configure Bazel Android toolchain**:

```bash
# Example future configuration in MODULE.bazel:
bazel_dep(name = "rules_android", version = "0.1.1")

# Build with Android NDK for ARM64
bazel build :hellomath_static --platforms=@androidndk//:android-arm64-v8a
bazel build :hellomath_dynamic --platforms=@androidndk//:android-arm64-v8a
```

The ARM64 Yocto libraries should be compatible with Android NDK ARM64 builds since both target the same architecture (ARMv8-A).

## Testing Cross-Compilation Compatibility

The hellomath application provides JNI functions that can be called from Android Java code:

- `stringFromJNI()`: Returns a test string showing mathlib function results
- `testMathAdd(int a, int b)`: Tests the add_numbers function
- `testMathMultiply(int a, int b)`: Tests the multiply_numbers function

## Verification Steps

1. **Library Architecture**: Verify that Yocto libraries are built for the correct target architecture (ARM64/ARMv7)
2. **Symbol Compatibility**: Check that all symbols from mathlib are properly linked
3. **Runtime Testing**: Test the compiled NDK library on actual Android devices
4. **ABI Compatibility**: Verify Android ABI compatibility with Yocto-built libraries

## Troubleshooting

### Library Not Found
- Ensure Yocto build completed successfully
- Check that libraries are copied to the correct paths
- Verify library architecture matches target Android architecture

### Linking Errors
- Check that mathlib.h matches the compiled library interface
- Verify that C/C++ calling conventions are compatible
- Ensure all required symbols are exported from the library

### Android NDK Issues
- Verify Android NDK is properly installed
- Check that ANDROID_NDK_HOME environment variable is set
- Ensure target Android API level is compatible

## Key Learning Points

This project helps verify:
1. **Cross-compilation compatibility** between Yocto and Android toolchains
2. **ABI compatibility** between Yocto-built libraries and Android runtime
3. **Linking behavior** differences between static and dynamic libraries
4. **Symbol resolution** in cross-platform scenarios

## Next Steps

After successful compilation:
1. Integrate the NDK library into a full Android application
2. Test on physical Android devices
3. Profile performance differences between static and dynamic linking
4. Test with more complex Yocto libraries and dependencies
