# Yocto lab

## To sync this repo

```bash
git clone --recursive https://github.com/TingyiKuo/yocto-lab.git
cd yocto-lab
```

## Quick Guide for qcom-console-image


* Step 1: sync QCT's repo (make repo-init)

After sync this repo, do 

```bash
make repo-init
```

* Step 2: Build yocto builder (Docker image)

```bash
make build-yocto-builder
```

* step 3: Build QCOM's image

Note: The download and sstate files will be located at /home/yocto/cache
make sure you have this folder with permissions

See the build-qcom-wayland/conf/site.conf

```bash
make build-qcom-wayland
```

* step 4: Build QEMU emulator

```bash
make build-emulator
```

* step 5: Run QEMU

```bash
make run-qcom-wayland
```

If you don't modify any password related config, the default password should be

```bash
user:root
password:oelinux123
```

* Step 6: Kill QEMU

You may use another terminal to kill qemu.

```bash
make kill-qemu
```

* Note: Debug with Yocto env

You man interactive run into yocto-builder by

```bash
make itrun-qcom-wayland-builder
```

and run 'env' to have QCOM's weston build environment.


```bash
. env.sh
```

choose the image you want to build

| Image recipe | Description |
|----------|:---------:|
| qcom-minimal-image            | A minimal rootfs image that boots to shell | 
| qcom-console-image            | Boot to shell with package group to bring in all the basic packages | 
| qcom-multimedia-image         |  Image recipe includes recipes for multimedia software components, such as, audio, Bluetooth®, camera, computer vision, display, and video. | 
| qcom-multimedia-test-image    |  Image recipe that includes tests | 


## Quick Guide for qemu-aarch64, Raspiberry Pi3/4

* Build QEMU emulator if not yet

```bash
make build-emulator
```

* sync code

```bash
make repo-init
```

* Build qemu-arm64 Rpi3 or Rpi4

```bash
# For qemu-arm64
make build-qemu-weston
make run-qemu-weston

# For Pi4
make build-pi4
make run-pi4

# For Pi3
make build-pi3
make run-pi3
```

or you can flash image to a SD card.

```bash
make flash-pi4
```

## About QCOM's repo layout

The "make repo-init" will help to do repo init and sync as below:

```bash
repo init -u https://github.com/qualcomm-linux/qcom-manifest -b qcom-linux-scarthgap -m qcom-6.6.90-QLI.1.5-Ver.1.1.xml
repo sync -j$(nproc)

export WS=${PWD}
export OEROOT="$WS/layers/poky"
echo WS=$WS
echo OEROOT=$OEROOT
```

This is the build SOP from QCT's official reference:

https://docs.qualcomm.com/bundle/publicresource/topics/80-70020-254/github_workflow_unregistered_users.html?vproduct=1601111740013072&version=1.5#github-workflow-unregistered-users



The yocto is at layers/poky

```xml
<remote fetch="https://git.yoctoproject.org" name="yocto" review="git.yoctoproject.org"/>
..
 <project name="poky" path="layers/poky" remote="yocto" revision="0ce88bc3474d29122e6f319cf474e5c5dce55419" upstream="refs/heads/scarthgap"/>
```

The Distro supported by QCOM are 'qcom-wayland' and 'qcom-robotics-ros2-humble', need to repo init different manifest. This repo currently init qcom-wayland only.

-| SKU | manifest file | distribution |
-|----------|:---------:|---------:|
-| BSP build: High-level OS and prebuilt firmware (GPS only)  |  qcom-6.6.90-QLI.1.5-Ver.1.1.xml  |  qcom-wayland  |
-| BSP build + Qualcomm IM SDK build:  |  qcom-6.6.90-QLI.1.5-Ver.1.1_qim-product-sdk-2.0.1.xml   |  qcom-wayland  |
-| BSP build + Real-time kernel build:  |  qcom-6.6.90-QLI.1.5-Ver.1.1_realtime-linux-1.1.xml   |    qcom-wayland  |
-| BSP build + QIR SDK build:  |  qcom-6.6.90-QLI.1.5-Ver.1.1_robotics-product-sdk-1.1.xml   |   qcom-robotics-ros2-humble  |

## To sync code from to my kernel git.


For the limitation of size pushing to github, my idea is to take advantage of already existed project on github and fork it

Here I choose https://github.com/linuxkit/linux

I fork it to my own repo [linuxkit/linux](https://github.com/TingyiKuo/linux.git)


To merge Linux ORG's branch


```bash
cd Tingyi/linux
git remote add git-kernel-org git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git
git fetch git-kernel-org linux-6.6.y
git checkout -b my-linux-6.6.y git-kernel-org/linux-6.6.y

git reset --hard 943e0aeece93a9c2329215d02621e634adf6d790 # This is from the code base..

git push origin my-linux-6.6.y
```

To merge QCT's customize branch


```bash

git remote add git-codelinaro-org https://git.codelinaro.org/clo/la/kernel/qcom.git
git fetch git-codelinaro-org kernel.qclinux.1.0.r1-rel
git checkout -b my-kernel.qclinux.1.0.r1-rel git-codelinaro-org/kernel.qclinux.1.0.r1-rel

git reset --hard e21546bdd3154f9ee83a579f2e3c80d313c1169d # This is from the code base..

git push origin my-kernel.qclinux.1.0.r1-rel


```

