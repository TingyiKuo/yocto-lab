# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a Yocto Project meta-layer (`meta-myiq9qemu`) for testing cross-compilation compatibility with Android devices. The primary goal is to verify if Yocto-built binaries and libraries can run on Android devices.

## Architecture

- **meta-myiq9qemu**: Custom Yocto layer for myiq9qemu platform
- **recipes-example/**: Contains sample recipes for testing cross-compilation
- **example/**: Basic C++ application recipe with BitBake build file
- **Build targets**: Supports multiple architectures including ARM64, QEMU emulation

## Key Files

- `recipes-example/example/example_0.1.bb`: BitBake recipe for building the hello-world C++ application
- `recipes-example/example/files/hello.cpp`: Simple C++ source demonstrating Yocto compilation
- `conf/layer.conf`: Layer configuration for meta-myiq9qemu (compatible with Scarthgap)

## Development Commands

### Yocto Build Environment Setup
```bash
# From yocto-lab root directory
source setup-environment <build-dir>
```

### Building Recipes
```bash
# Build the example application
bitbake example

# Build for specific target (from various build directories)
# For Pi3: build-rpi3/
# For Pi4: build-rpi4/ 
# For QEMU ARM64: build-qemuarm64/
# For Qualcomm: build-qcom-wayland/
```

### Layer Management
```bash
# Add this layer to build
bitbake-layers add-layer meta-myiq9qemu

# Show layer info
bitbake-layers show-layers
```

### Running QEMU Targets
```bash
# Various QEMU runners available in tools/
./tools/run-rpi3-qemu.sh
./tools/run-rpi4-qemu.sh
./tools/run-myiq9-qemu.sh
```

## Current Requirements

The user wants to create a library example that demonstrates:
1. A sample application that calls functions from another library
2. Both dynamic and static linking versions
3. Simple implementation using only stdlib
4. Cross-compilation compatibility testing for Android devices

## Build Targets Available

- Raspberry Pi 3 (build-rpi3/)
- Raspberry Pi 4 (build-rpi4/) 
- QEMU ARM64 (build-qemuarm64/)
- Qualcomm platforms (build-qcom-wayland/)

## Layer Dependencies

- **LAYERDEPENDS**: core
- **LAYERSERIES_COMPAT**: scarthgap
- **BBFILE_PRIORITY**: 6
