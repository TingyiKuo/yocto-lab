# myiq9qemu
Build and run IQ9 image on QEMU

# Build a BSP image

The board support package (BSP) image build has software components for the Qualcomm device support and software features applicable to Qualcomm SoCs. This build includes a reference distribution configuration for the Qualcomm development kits. For more details, see Qualcomm Linux metadata layers.


## To Build with GitHub for unregistered users (U) / Registered users (R)


https://docs.qualcomm.com/bundle/publicresource/topics/80-70020-254/github_workflow_unregistered_users.html?vproduct=1601111740013072&version=1.5#github-workflow-unregistered-users

Step1: sync QCT's repo

```bash
repo init -u https://github.com/qualcomm-linux/qcom-manifest -b qcom-linux-scarthgap -m qcom-6.6.90-QLI.1.5-Ver.1.1.xml

repo sync -j$(nproc)
```


| SKU | manifest file | distribution |
|----------|:---------:|---------:|
| BSP build: High-level OS and prebuilt firmware (GPS only)  |  qcom-6.6.90-QLI.1.5-Ver.1.1.xml  |  qcom-wayland  |
| BSP build + Qualcomm IM SDK build:  |  qcom-6.6.90-QLI.1.5-Ver.1.1_qim-product-sdk-2.0.1.xml   |  qcom-wayland  |
| BSP build + Real-time kernel build:  |  qcom-6.6.90-QLI.1.5-Ver.1.1_realtime-linux-1.1.xml   |    qcom-wayland  |
| BSP build + QIR SDK build:  |  qcom-6.6.90-QLI.1.5-Ver.1.1_robotics-product-sdk-1.1.xml   |   qcom-robotics-ros2-humble  |




Step2: prepare yocto-builder image

```bash
docker image build --build-arg userid=$(id -u) \
             --build-arg groupid=$(id -g) \
             --build-arg username=$(id -un) \
             -t yocto-builder \
             -f docker/Dockerfile.local docker


```                              

Step3: login into docker containner

```baseh

docker run -it --rm \
    -v "/home/yocto/cache:/home/yocto/cache" \
    -v ${PWD}:${PWD} \
    -w ${PWD} \
    amito4/yocto-builder \
    bash

# or

. docker/login-into-docker


```


Step4: setup and build inside docker


```bash

# This will create folder "build-qcom-wayland" and conf/* files if not exist.

MACHINE=qcs9100-ride-sx DISTRO=qcom-wayland QCOM_SELECTED_BSP=custom source setup-environment build-qcom-wayland
#MACHINE=qemuarm64 DISTRO=qcom-wayland QCOM_SELECTED_BSP=custom source setup-environment build-qemu-wayland <-- To porting.

# choose image recipe

bitbake qcom-multimedia-image
```

| Image recipe | Description |
|----------|:---------:|
| qcom-minimal-image            | A minimal rootfs image that boots to shell | 
| qcom-console-image            | Boot to shell with package group to bring in all the basic packages | 
| qcom-multimedia-image         |  Image recipe includes recipes for multimedia software components, such as, audio, Bluetooth®, camera, computer vision, display, and video. | 
| qcom-multimedia-test-image    |  Image recipe that includes tests | 


## Output
/home/tingyikuo/ssd1/repos/github.com/TingyiKuo/myiq9qemu/build-qcom-wayland/tmp-glibc/deploy/images/qcs9100-ride-sx

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


## To run QEMU
```base
# runqemu qemux86-64 qcom-multimedia-image ext4 <-- Not work

RPIIMG=/home/tingyikuo/ssd1/repos/github.com/TingyiKuo/myiq9qemu/build-qcom-wayland/tmp-glibc/deploy/images/qcs9100-ride-sx/qcom-multimedia-image-qcs9100-ride-sx.rootfs.ext4
/home/tingyikuo/ssd1/pegasus/qemu_kvm/qemu-src/qemu/build/qemu-system-aarch64 -machine virt -cpu cortex-a55 -smp 8 -m 8G \
    -kernel /home/tingyikuo/ssd1/repos/github.com/TingyiKuo/myiq9qemu/build-qcom-wayland/tmp-glibc/deploy/images/qcs9100-ride-sx/Image \
    -append "root=/dev/vda rootfstype=ext4 rw panic=0 console=ttyAMA0" \
    -drive format=raw,file=${RPIIMG},if=none,id=hd0,cache=writeback \
    -device virtio-blk,drive=hd0,bootindex=0 \
    -monitor telnet:127.0.0.1:5555,server,nowait \
    -device virtio-gpu \
    -device virtio-mouse \
    -device virtio-keyboard \
    -serial mon:stdio
``

If you don't modify any password related config, the default password should be

```
user:root
password:oelinux123
```


# Note


Below are notes for reference.

Thomas's command


```baseh
# For 
MACHINE=qcs9100-ride-sx DISTRO=qcom-robotics-ros2-jazzy QCOM_SELECTED_BSP=custom source setup-environment build-qcs9100-base
../qirp-build qcom-robotics-full-image

```

```base
export EXTRALAYERS="meta-qcom-extras meta-qcom-robotics-extras" && \
export CUST_ID="213195" && \
export FWZIP_PATH="/ssd1/workarea/IQ9100/IQ9100_firmware_extras/qualcomm-linux-spf-1-0_hlos_oem_metadata/QCS9100.LE.1.0/common/build/ufs/bin" && \
MACHINE=qcs9100-ride-sx && export DISTRO=qcom-robotics-ros2-jazzy && QCOM_SELECTED_BSP=custom && source setup-robotics-environment && \
../qirp-build qcom-robotics-full-image
```

## Self hosted runner 

Need to put the downloads folder at /home/yocoto/downloads and make sure have permissions


## Note

cd layers

git clone https://github.com/OSSystems/meta-browser.git
cd meta-browser/
git checkout scarthgap
git checkout 1ed2254d72a4c25879014c98be287a7e3e22904c

git clone https://git.yoctoproject.org/meta-lts-mixins
cd meta-lts-mixins
git checkout scarthgap/rust
git checkout 1793a1b8fc92cf8688c72b7fd4181e3a2f5ade55

git clone https://github.com/kraj/meta-clang.git
cd meta-clang/
git checkout scarthgap
git checkout 8c77b427408db01b8de4c04bd3d247c13c154f92



