# AArch64 QEMU
## Sync and Build Yocto Image for AArch64 QEMU

### Document Information
- **Version**: 1.0
- **Date**: July 11, 2025
- **Purpose**: Guide for syncing Yocto Project sources and building images for AArch64 QEMU emulation
- **Scope**: Development teams working with embedded Linux systems

---

### 1. Prerequisites

#### 1.1 System Requirements
- **Operating System**: Ubuntu 20.04 LTS or later (recommended)
- **Minimum Hardware**: 
  - 8 GB RAM (16 GB recommended)
  - 100 GB free disk space
  - Multi-core processor (4+ cores recommended)
- **Network**: Stable internet connection for initial sync

#### 1.2 Required Packages
Install the following packages before proceeding:

```bash
sudo apt update
sudo apt install -y gawk wget git diffstat unzip texinfo gcc build-essential \
chrpath socat cpio python3 python3-pip python3-pexpect xz-utils debianutils \
iputils-ping python3-git python3-jinja2 libegl1-mesa libsdl1.2-dev pylint3 \
xterm python3-subunit mesa-common-dev zstd liblz4-tool file locales
```

#### 1.3 User Configuration
Ensure your user account has proper git configuration:

```bash
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"
```

---

### 2. Environment Setup

#### 2.1 Create Working Directory
```bash
mkdir -p ~/yocto-workspace
cd ~/yocto-workspace
```

#### 2.2 Set Environment Variables
```bash
export YOCTO_WORKSPACE=~/yocto-workspace
export MACHINE=qemuarm64
export DISTRO=poky
```

---

### 3. Source Code Synchronization

#### 3.1 Clone Poky Repository
```bash
cd $YOCTO_WORKSPACE
git clone git://git.yoctoproject.org/poky
cd poky
```

#### 3.2 Checkout Stable Branch
```bash
# List available branches
git branch -a

# Checkout the latest stable release (adjust as needed)
git checkout kirkstone
```

#### 3.3 Verify Checkout
```bash
git log --oneline -5
git status
```

---

### 4. Build Environment Configuration

#### 4.1 Initialize Build Environment
```bash
cd $YOCTO_WORKSPACE/poky
source oe-init-build-env build-qemuarm64
```

**Note**: This command will change your working directory to `build-qemuarm64`

#### 4.2 Configure local.conf
Edit `conf/local.conf` to set the machine and optimize build settings:

```bash
# Edit the configuration file
nano conf/local.conf
```

**Key configurations to set/verify:**
```conf
# Machine Selection
MACHINE ?= "qemuarm64"

# Distro Selection
DISTRO ?= "poky"

# Parallel Build Configuration
BB_NUMBER_THREADS ?= "8"
PARALLEL_MAKE ?= "-j 8"

# Disk Space Monitoring
BB_DISKMON_DIRS ??= "\
    STOPTASKS,${TMPDIR},1G,100K \
    STOPTASKS,${DL_DIR},1G,100K \
    STOPTASKS,${SSTATE_DIR},1G,100K \
    STOPTASKS,/tmp,100M,100K \
    ABORT,${TMPDIR},100M,1K \
    ABORT,${DL_DIR},100M,1K \
    ABORT,${SSTATE_DIR},100M,1K \
    ABORT,/tmp,10M,1K"

# Package Management
PACKAGE_CLASSES ?= "package_rpm"

# Additional useful settings
INHERIT += "rm_work"
```

#### 4.3 Configure bblayers.conf
Verify `conf/bblayers.conf` contains necessary layers:

```bash
cat conf/bblayers.conf
```

---

### 5. Image Build Process

#### 5.1 Build Core Image
```bash
# Build minimal core image
bitbake core-image-minimal
```

#### 5.2 Alternative Image Options
```bash
# Build base image with more features
bitbake core-image-base

# Build full development image
bitbake core-image-full-cmdline

# Build image with graphics support
bitbake core-image-sato
```

#### 5.3 Monitor Build Progress
- Build time: 2-6 hours for initial build (depending on hardware)
- Subsequent builds will be faster due to shared state cache
- Monitor disk space during build process

---

### 6. Build Verification

#### 6.1 Check Build Output
```bash
ls -la tmp/deploy/images/qemuarm64/
```

**Expected files:**
- `core-image-minimal-qemuarm64.ext4` (root filesystem)
- `Image-qemuarm64.bin` (kernel image)
- `core-image-minimal-qemuarm64.qemuboot.conf` (QEMU boot configuration)

#### 6.2 Verify Image Integrity
```bash
# Check image file sizes
du -h tmp/deploy/images/qemuarm64/core-image-minimal-qemuarm64.ext4

# Verify kernel image
file tmp/deploy/images/qemuarm64/Image-qemuarm64.bin
```

---

### 7. QEMU Testing

#### 7.1 Run Image in QEMU
```bash
# Method 1: Using runqemu script
runqemu qemuarm64 core-image-minimal

# Method 2: Direct QEMU command
qemu-system-aarch64 \
    -machine virt \
    -cpu cortex-a57 \
    -m 1024 \
    -kernel tmp/deploy/images/qemuarm64/Image-qemuarm64.bin \
    -drive file=tmp/deploy/images/qemuarm64/core-image-minimal-qemuarm64.ext4,if=virtio,format=raw \
    -netdev user,id=net0 \
    -device virtio-net-device,netdev=net0 \
    -nographic \
    -append "root=/dev/vda rw console=ttyAMA0"
```

#### 7.2 Test System Functionality
Once booted, verify:
- System boots successfully
- Root login works
- Network connectivity (if configured)
- Basic commands function properly

---

### 8. Troubleshooting

#### 8.1 Common Build Issues

**Issue**: Fetch failures
```bash
# Solution: Clean downloads and retry
rm -rf downloads/*
bitbake -c cleanall <package-name>
bitbake <target-image>
```

**Issue**: Disk space errors
```bash
# Solution: Clean temporary files
bitbake -c clean <package-name>
# Or clean all temporary files
rm -rf tmp/
```

**Issue**: Missing dependencies
```bash
# Solution: Install missing host packages
sudo apt update
sudo apt install <missing-package>
```

#### 8.2 Build Logs
Check build logs for detailed error information:
```bash
# View latest build log
less tmp/log/cooker/qemuarm64/console-latest.log

# View specific task log
less tmp/work/qemuarm64-poky-linux/core-image-minimal/1.0-r0/temp/log.do_rootfs
```

---

### 9. Maintenance and Updates

#### 9.1 Update Sources
```bash
cd $YOCTO_WORKSPACE/poky
git fetch origin
git rebase origin/kirkstone
```

#### 9.2 Clean Build Environment
```bash
# Clean specific package
bitbake -c cleanall <package-name>

# Clean all temporary files
rm -rf tmp/

# Clean shared state cache (if needed)
rm -rf sstate-cache/
```

#### 9.3 Incremental Builds
After initial build, subsequent builds will be faster:
```bash
# Rebuild after changes
bitbake core-image-minimal
```

---

### 10. Quality Assurance Checklist

- [ ] All prerequisites installed
- [ ] Git configuration completed
- [ ] Source code successfully synced
- [ ] Build environment initialized
- [ ] Configuration files properly set
- [ ] Build completed without errors
- [ ] Output files generated correctly
- [ ] QEMU test successful
- [ ] System boots and functions properly
- [ ] Documentation updated

---

### 11. Document Control

| Version | Date | Changes | Author |
|---------|------|---------|---------|
| 1.0 | July 11, 2025 | Initial version | Development Team |

---

### 12. References

- [Yocto Project Documentation](https://docs.yoctoproject.org/)
- [BitBake User Manual](https://docs.yoctoproject.org/bitbake/)
- [QEMU Documentation](https://www.qemu.org/docs/master/)
- [Yocto Project Quick Build Guide](https://docs.yoctoproject.org/brief-yoctoprojectqs/index.html)