# SOP: Sync and Build Yocto Image for Raspberry Pi 3

## Document Information
- **Document ID**: SOP-YOCTO-RPI3-001
- **Version**: 1.0
- **Date**: July 2025 (Updated for Scarthgap)
- **Approved By**: [Engineering Manager]
- **Review Date**: [6 months from creation]

## Purpose
This Standard Operating Procedure provides step-by-step instructions for syncing the Yocto Project source code and building a Linux image for Raspberry Pi 3 hardware.

## Scope
This procedure applies to software engineers and build engineers responsible for creating embedded Linux distributions using the Yocto Project for Raspberry Pi 3 platforms.

## Prerequisites

### System Requirements
- Linux host system (Ubuntu 18.04 LTS or later recommended)
- Minimum 50GB free disk space
- Minimum 4GB RAM (8GB recommended)
- Internet connection for downloading source code

### Required Packages
Install the following packages on Ubuntu/Debian:
```bash
sudo apt update
sudo apt install gawk wget git-core diffstat unzip texinfo gcc-multilib \
build-essential chrpath socat cpio python3 python3-pip python3-pexpect \
xz-utils debianutils iputils-ping python3-git python3-jinja2 libegl1-mesa \
libsdl1.2-dev pylint3 xterm python3-subunit mesa-common-dev
```

### User Setup
- Ensure user has sudo privileges
- Configure Git with name and email:
```bash
git config --global user.name "Your Name"
git config --global user.email "your.email@company.com"
```

## Procedure

### Step 1: Create Working Directory
1. Create a dedicated workspace directory:
```bash
mkdir -p ~/yocto-rpi3
cd ~/yocto-rpi3
```

2. Set environment variables:
```bash
export YOCTO_WORKSPACE=~/yocto-rpi3
export MACHINE=raspberrypi3
```

### Step 2: Download Yocto Project Sources
1. Clone the Poky repository (Yocto reference distribution):
```bash
git clone -b scarthgap https://git.yoctoproject.org/git/poky
cd poky
```

2. Clone the meta-raspberrypi layer:
```bash
git clone -b scarthgap https://git.yoctoproject.org/git/meta-raspberrypi
```

3. Clone OpenEmbedded layer (if additional packages needed):
```bash
git clone -b scarthgap https://git.openembedded.org/meta-openembedded
```

### Step 3: Initialize Build Environment
1. Source the build environment script:
```bash
source oe-init-build-env build-rpi3
```

2. This command will:
   - Create a `build-rpi3` directory
   - Change to the build directory
   - Set up the build environment

### Step 4: Configure Build
1. Edit `conf/local.conf`:
```bash
nano conf/local.conf
```

2. Add/modify the following lines:
```
MACHINE = "raspberrypi3"
DISTRO = "poky"
PACKAGE_CLASSES = "package_rpm"
EXTRA_IMAGE_FEATURES = "debug-tweaks"
USER_CLASSES = "buildstats"
PATCHRESOLVE = "noop"
BB_DISKMON_DIRS = "\
    STOPTASKS,${TMPDIR},1G,100K \
    STOPTASKS,${DL_DIR},1G,100K \
    STOPTASKS,${SSTATE_DIR},1G,100K \
    STOPTASKS,/tmp,100M,100K \
    ABORT,${TMPDIR},100M,1K \
    ABORT,${DL_DIR},100M,1K \
    ABORT,${SSTATE_DIR},100M,1K \
    ABORT,/tmp,10M,1K"
# Accept restricted licenses for Raspberry Pi firmware
LICENSE_FLAGS_ACCEPTED = "synaptics-killswitch"

PACKAGECONFIG:append:pn-qemu-native = " sdl"
PACKAGECONFIG:append:pn-nativesdk-qemu = " sdl"
```

3. Edit `conf/bblayers.conf`:
```bash
nano conf/bblayers.conf
```

4. Add the meta-raspberrypi layer:
```
BBLAYERS ?= " \
  /home/user/yocto-rpi3/poky/meta \
  /home/user/yocto-rpi3/poky/meta-poky \
  /home/user/yocto-rpi3/poky/meta-yocto-bsp \
  /home/user/yocto-rpi3/poky/meta-raspberrypi \
  /home/user/yocto-rpi3/poky/meta-openembedded/meta-oe \
  /home/user/yocto-rpi3/poky/meta-openembedded/meta-python \
  /home/user/yocto-rpi3/poky/meta-openembedded/meta-networking \
  "
```

### Step 5: Build the Image
1. Start the build process:
```bash
bitbake core-image-base
```

2. Alternative image options:
   - `core-image-minimal` - Minimal image
   - `core-image-base` - Basic image with package management
   - `core-image-full-cmdline` - Full command line image
   - `rpi-hwup-image` - Hardware-specific test image

3. Monitor build progress:
   - Build time: 2-6 hours (first build)
   - Subsequent builds: 30 minutes - 2 hours
   - Check for errors in terminal output

### Step 6: Verify Build Output
1. Navigate to images directory:
```bash
cd tmp/deploy/images/raspberrypi3
```

2. Verify the following files exist:
   - `core-image-base-raspberrypi3.rpi-sdimg` - SD card image
   - `core-image-base-raspberrypi3.tar.bz2` - Root filesystem archive
   - `bcm2837-rpi-3-b.dtb` - Device tree blob
   - `Image` - Kernel image (Linux 6.12.25 from Raspberry Pi foundation)

### Kernel Information
The Raspberry Pi 3 build uses the official Raspberry Pi kernel:
- **Version**: Linux 6.12.25
- **Source**: https://github.com/raspberrypi/linux.git
- **Branch**: rpi-6.12.y
- **Recipe**: `linux-raspberrypi_6.12.bb`
- **Features**: Includes Raspberry Pi-specific patches and drivers
- **Device Tree**: Supports overlays with `-@ -H epapr` flags

### Step 8: Test Image with QEMU Emulation (Optional)

Before flashing to hardware, you can test the image using QEMU emulation:

#### Method 1: Direct QEMU (Raspberry Pi 3 Emulation)
1. Install QEMU ARM system emulation:
```bash
sudo apt install qemu-system-arm
```

2. Navigate to the images directory:
```bash
cd tmp/deploy/images/raspberrypi3
```

3. Extract kernel and device tree:
```bash
# The kernel image
ls -la Image*

# Device tree files
ls -la *.dtb
```

4. Run QEMU with Raspberry Pi 3 emulation:

**For Console Only:**
```bash
qemu-system-aarch64 \
  -M raspi3b \
  -cpu cortex-a53 \
  -m 1024 \
  -kernel Image \
  -dtb bcm2837-rpi-3-b.dtb \
  -drive format=raw,file=core-image-weston-raspberrypi3.rpi-sdimg \
  -append "root=/dev/mmcblk0p2 rw rootwait console=ttyAMA0,115200" \
  -netdev user,id=net0 \
  -device usb-net,netdev=net0 \
  -serial stdio \
  -display none
```

**For GUI (Recommended for Weston/Sato images):**
```bash
qemu-system-aarch64 \
  -M raspi3b \
  -cpu cortex-a53 \
  -m 1024 \
  -kernel Image \
  -dtb bcm2837-rpi-3-b.dtb \
  -drive format=raw,file=core-image-weston-raspberrypi3.rpi-sdimg \
  -append "root=/dev/mmcblk0p2 rw rootwait console=tty1" \
  -netdev user,id=net0 \
  -device usb-net,netdev=net0 \
  -serial stdio \
  -display gtk,gl=on \
  -device usb-kbd \
  -device usb-mouse
```

**Alternative GUI Options:**
```bash
# Using SDL display
-display sdl,gl=on

# Using VNC (access via VNC viewer on localhost:5900)
-display vnc=:0

# Using SPICE (requires spice-client)
-display spice-app,gl=on
```

#### Method 2: Yocto's runqemu Tool
1. Source the build environment (if not already done):
```bash
cd /path/to/poky
source oe-init-build-env build-rpi3
```

2. Try runqemu (may need configuration):
```bash
runqemu raspberrypi3 core-image-weston
```

#### Method 3: Convert to Generic ARM Image for Better Emulation
1. Build a generic ARM image for better QEMU compatibility:
```bash
# In conf/local.conf, temporarily change:
MACHINE = "qemuarm64"

# Build image
bitbake core-image-weston

# Run with runqemu
runqemu qemuarm64 core-image-weston
```

#### Emulation Limitations
- **Hardware-specific features**: GPIO, camera, hardware video acceleration won't work
- **Performance**: Emulation is slower than real hardware
- **Driver compatibility**: Some Raspberry Pi-specific drivers may not function
- **Display**: May need adjustments for graphics testing

#### What You Can Test
- ✅ Basic boot process and kernel functionality
- ✅ System services and init process
- ✅ Package installations and dependencies
- ✅ Network connectivity (emulated)
- ✅ File system structure
- ✅ User applications (basic functionality)
- ❌ GPIO operations
- ❌ Camera interface
- ❌ Hardware-accelerated graphics
- ❌ Real-time performance

### Step 9: Flash Image to SD Card
1. Insert SD card (minimum 4GB) into host system

2. Identify SD card device:
```bash
lsblk
```

3. Flash image to SD card:
```bash
sudo dd if=core-image-base-raspberrypi3.rpi-sdimg of=/dev/sdX bs=4M status=progress
sync
```
**Warning**: Replace `/dev/sdX` with actual SD card device. Double-check device name to avoid data loss.

4. Safely eject SD card:
```bash
sudo eject /dev/sdX
```

## Quality Assurance

### Build Verification
- [ ] Build completes without errors
- [ ] All required output files are generated
- [ ] Image file size is reasonable (typically 100-500MB)
- [ ] Checksum verification passes

### Boot Testing
- [ ] Raspberry Pi 3 boots from SD card
- [ ] System reaches login prompt
- [ ] Network connectivity functional
- [ ] GPIO access working (if required)

## Troubleshooting

### Common Issues

**Build Errors**
- **Missing dependencies**: Install required packages listed in prerequisites
- **Disk space**: Ensure minimum 50GB free space
- **Network timeouts**: Check internet connection and proxy settings

**Boot Issues**
- **No boot**: Verify SD card is properly flashed
- **Kernel panic**: Check device tree and kernel configuration
- **No display**: Verify HDMI connection and display settings

**Performance Issues**
- **Slow build**: Increase parallel build tasks in local.conf: `BB_NUMBER_THREADS = "8"`
- **Memory issues**: Add swap space or increase RAM

## Maintenance

### Regular Tasks
- Update source repositories monthly
- Clean build directories periodically: `bitbake -c cleanall <image-name>`
- Archive successful builds for future reference

### Updates
- Monitor Yocto Project releases
- Update layer versions consistently
- Test builds after updates

## Documentation References
- [Yocto Project Documentation](https://docs.yoctoproject.org/)
- [meta-raspberrypi Layer Documentation](https://git.yoctoproject.org/meta-raspberrypi/)
- [Raspberry Pi 3 Hardware Documentation](https://www.raspberrypi.org/documentation/)

## Approval
- **Prepared by**: [Engineer Name]
- **Reviewed by**: [Senior Engineer Name]
- **Approved by**: [Engineering Manager Name]
- **Date**: [Current Date]

---
*This SOP should be reviewed and updated every 6 months or when significant changes occur in the Yocto Project or Raspberry Pi 3 support.*