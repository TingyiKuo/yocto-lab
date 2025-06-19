# myiq9qemu
Build and run IQ9 image on QEMU



## To Build


Step0: Emu github environment

export GITHUB_WORKSPACE=${PWD}


Step1: sync QCT's repo

```bash
repo init -u https://github.com/qualcomm-linux/qcom-manifest -b qcom-linux-scarthgap -m qcom-6.6.65-QLI.1.4-Ver.1.1.xml
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
        bitbake -f core-image-minimal \
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

```

## Self hosted runner 

Need to put the downloads folder at /home/yocoto/downloads and make sure have permissions


## To sync code from to my kernel git.

```bash
cd src/linux-6.6.y
git remote add git-kernel-org git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git
git fetch git-kernel-org linux-6.6.y
git checkout -b my-linux-6.6.y git-kernel-org/linux-6.6.y

git reset --hard 943e0aeece93a9c2329215d02621e634adf6d790 # This is from the code base..

git push origin my-linux-6.6.y
```


