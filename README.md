# myiq9qemu
Build and run IQ9 image on QEMU



## To Build


Step0: Emu github environment

export GITHUB_WORKSPACE=${PWD}


Step1: sync QCT's repo

```bash
#repo init -u https://github.com/qualcomm-linux/qcom-manifest -b qcom-linux-scarthgap -m qcom-6.6.65-QLI.1.4-Ver.1.1.xml
repo init -u https://github.com/qualcomm-linux/qcom-manifest -b qcom-linux-scarthgap -m qcom-6.6.65-QLI.1.4-Ver.1.1_robotics-product-sdk-1.1.xml
repo sync -j$(nproc)
```

Step2: prepare yocto-builder

```bash
docker build --build-arg userid=$(id -u) \
             --build-arg groupid=$(id -g) \
             --build-arg username=$(id -un) \
             -t yocto-builder \
             -f docker/Dockerfile docker
```                              

Step3: build image

```baseh
docker run --rm \
    -v "/home/yocto-mirror/downloads:/home/yocto-mirror/downloads" \
    -v ${GITHUB_WORKSPACE}:/app \
    -w /app \
    yocto-builder \
    bash -c " \
        MACHINE=qcs9100-ride-sx DISTRO=qcom-wayland QCOM_SELECTED_BSP=base source setup-environment build-qcom-wayland && \
        bitbake core-image-minimal \
    "
# or

docker run -it --rm \
    -v "/home/yocto-mirror/downloads:/home/yocto-mirror/downloads" \
    -v ${GITHUB_WORKSPACE}:/app \
    -w /app \
    yocto-builder \
    bash

# in docker
MACHINE=qcs9100-ride-sx DISTRO=qcom-wayland QCOM_SELECTED_BSP=base source setup-environment build-qcom-wayland
bitbake core-image-minimal

MACHINE=qcs9100-ride-sx DISTRO=qcom-robotics-ros2-jazzy QCOM_SELECTED_BSP=custom source setup-environment build-qcs9100-base
bitbake qcom-robotics-full-image

```

Thomas's command

```base
export EXTRALAYERS="meta-qcom-extras meta-qcom-robotics-extras" && \
export CUST_ID="213195" && \
export FWZIP_PATH="/ssd1/workarea/IQ9100/IQ9100_firmware_extras/qualcomm-linux-spf-1-0_hlos_oem_metadata/QCS9100.LE.1.0/common/build/ufs/bin" && \
MACHINE=qcs9100-ride-sx && export DISTRO=qcom-robotics-ros2-jazzy && QCOM_SELECTED_BSP=custom && source setup-robotics-environment && \
../qirp-build qcom-robotics-full-image
```

## Self hosted runner 

Need to put the downloads folder at /home/yocoto/downloads and make sure have permissions


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

