
yocto-builder-TAG=amito4/yocto-builder
user_id=$(shell id -u)
user_name=$(shell id -un)
user_group=$(shell id -g)
WS=$(shell pwd)
OEROOT=${WS}/layers/poky

AARCH64_QEMU=./tools/qemu/build/qemu-system-aarch64


#####################################################################
# HELP

.PHONY: show_help
show_help:
	grep .PHONY Makefile
	# source ./tools/set-ws-env.sh No work..

all:show_help

#####################################################################
# Docker image for builder

# build yocto-builder docker image
yocto-builder: docker/Dockerfile.local
	docker image build \
		--build-arg userid=${user_id} \
		--build-arg groupid=${user_group} \
		--build-arg username=${user_name} \
		-f docker/Dockerfile.local \
		-t ${yocto-builder-TAG} docker

.PHONY: build-yocto-builder
build-yocto-builder: yocto-builder


# interactive run without any build environment
.PHONY: itrun-builder
itrun-builder: yocto-builder
	docker run -it --rm \
		-v /home/yocto/cache:/home/yocto/cache \
		-v ${PWD}:${PWD} \
		-w ${PWD} \
		-e WS=${PWD} \
		-e OEROOT="${PWD}/layers/poky" \
		${yocto-builder-TAG} \
		bash -c 'echo WS=$$WS; echo OEROOT=$$OEROOT; exec bash'


#####################################################################
# Code sync

.PHONY: check-submodules
check-submodules:
	@echo "Checking git submodules..."
	@git config --file .gitmodules --get-regexp path | awk '{print $$2}' | while read -r path; do \
		if [ ! -f "$$path/.git" ]; then \
			echo "Submodule '$$path' not initialized. Please run 'git submodule update --init --recursive'"; \
			exit 1; \
		fi; \
		done
	@echo "All git submodules are initialized."

.PHONY: repo-init
#repo-init:setup-environment
repo-init: check-submodules
	repo init -u https://github.com/qualcomm-linux/qcom-manifest -b qcom-linux-scarthgap -m qcom-6.6.90-QLI.1.5-Ver.1.1.xml
	repo sync






#####################################################################
# Image: QCOM Wayland (build-qcom-wayland)

# There are 4 image supported now.
#
# qcom-minimal-image            | A minimal rootfs image that boots to shell 
# qcom-console-image            | Boot to shell with package group to bring in all the basic packages
# qcom-multimedia-image         |  Image recipe includes recipes for multimedia software components, such as, audio, Bluetooth®, camera, computer vision, display, and video.
# qcom-multimedia-test-image    |  Image recipe that includes tests
QCOM_IMAGE=qcom-console-image


# Different QCOM distro need different repo.

# BSP build: High-level OS and prebuilt firmware (GPS only)  |  qcom-6.6.90-QLI.1.5-Ver.1.1.xml  |  qcom-wayland
# BSP build + Qualcomm IM SDK build:  |  qcom-6.6.90-QLI.1.5-Ver.1.1_qim-product-sdk-2.0.1.xml   |  qcom-wayland
# BSP build + Real-time kernel build:  |  qcom-6.6.90-QLI.1.5-Ver.1.1_realtime-linux-1.1.xml   |    qcom-wayland
# BSP build + QIR SDK build:  |  qcom-6.6.90-QLI.1.5-Ver.1.1_robotics-product-sdk-1.1.xml   |   qcom-robotics-ros2-humble

QCOM_DISTRO=qcom-wayland

# interactive run QCOM Wayland builder
.PHONY: itrun-qcom-wayland-builder
itrun-qcom-wayland-builder: yocto-builder
	docker run -it --rm \
		-v /home/yocto/cache:/home/yocto/cache \
		-v ${PWD}:${PWD} \
		-w ${PWD} \
		-e WS=${PWD} \
		-e OEROOT="${PWD}/layers/poky" \
		${yocto-builder-TAG} \
		bash -c 'echo WS=$$WS; echo OEROOT=$$OEROOT; exec bash'

# build QCOM Wayland
.PHONY: build-qcom-wayland
build-qcom-wayland: yocto-builder
	docker run --rm \
		-v /home/yocto/cache:/home/yocto/cache \
		-v ${PWD}:${PWD} \
		-w ${PWD} \
		${yocto-builder-TAG} \
		bash -c "MACHINE=qcs9100-ride-sx DISTRO=${QCOM_DISTRO} QCOM_SELECTED_BSP=custom source setup-environment build-${QCOM_DISTRO} && bitbake ${QCOM_IMAGE}"

# clean build QCOM Wayland
.PHONY: clean-build-qcom-wayland
clean-build-qcom-wayland: yocto-builder
	docker run --rm \
		-v /home/yocto/cache:/home/yocto/cache \
		-v ${PWD}:${PWD} \
		-w ${PWD} \
		${yocto-builder-TAG} \
		bash -c "MACHINE=qcs9100-ride-sx DISTRO=${QCOM_DISTRO} QCOM_SELECTED_BSP=custom source setup-environment build-${QCOM_DISTRO} && bitbake -c cleanall ${QCOM_IMAGE} && bitbake ${QCOM_IMAGE}"

# fetch QCOM Wayland
.PHONY: fetch-qcom-wayland
fetch-qcom-wayland: yocto-builder
	docker run --rm \
		-v /home/yocto/cache:/home/yocto/cache \
		-v ${PWD}:${PWD} \
		-w ${PWD} \
		${yocto-builder-TAG} \
		bash -c "MACHINE=qcs9100-ride-sx DISTRO=${QCOM_DISTRO} QCOM_SELECTED_BSP=custom source setup-environment build-${QCOM_DISTRO} && bitbake ${QCOM_IMAGE} --runall fetch"

# run QCOM Wayland
.PHONY: run-qcom-wayland
run-qcom-wayland:
	WS=${WS} . tools/run-myiq9-qemu.sh ${QCOM_DISTRO} ${QCOM_IMAGE}


#####################################################################
# Image: Raspberry Pi 4 (build-rpi4)

# interactive run Pi3 builder
.PHONY: itrun-pi4-builder
itrun-pi4-builder: yocto-builder
	docker run -it --rm \
		-v /home/yocto/cache:/home/yocto/cache \
		-v ${PWD}:${PWD} \
		-w ${PWD} \
		-e WS=${PWD} \
		-e OEROOT="${PWD}/layers/poky" \
		${yocto-builder-TAG} \
		bash -c 'echo WS=$$WS; echo OEROOT=$$OEROOT; source ${OEROOT}/oe-init-build-env build-rpi4 ; exec bash'

# build Pi4
.PHONY: build-pi4
build-pi4: yocto-builder
	docker run --rm \
		-v /home/yocto/cache:/home/yocto/cache \
		-v ${PWD}:${PWD} \
		-w ${PWD} \
		${yocto-builder-TAG} \
		bash -c "source ${OEROOT}/oe-init-build-env build-rpi4 && bitbake core-image-weston"

# clean build Pi4
.PHONY: clean-build-pi4
clean-build-pi4: yocto-builder
	docker run --rm \
		-v /home/yocto/cache:/home/yocto/cache \
		-v ${PWD}:${PWD} \
		-w ${PWD} \
		${yocto-builder-TAG} \
		bash -c "source ${OEROOT}/oe-init-build-env build-rpi4 && bitbake -c cleanall core-image-weston && bitbake core-image-weston"

# fetch Pi4
.PHONY: fetch-pi4
fetch-pi4: yocto-builder
	docker run --rm \
		-v /home/yocto/cache:/home/yocto/cache \
		-v ${PWD}:${PWD} \
		-w ${PWD} \
		${yocto-builder-TAG} \
		bash -c "source ${OEROOT}/oe-init-build-env build-rpi4 && bitbake core-image-weston --runall fetch"


# run QEMU Pi4
.PHONY: run-pi4
run-pi4:
	WS=${WS} . tools/run-rpi4-qemu.sh

# flash Pi4 image to SD card
.PHONY: flash-pi4
flash-pi4:
	WS=${WS} . tools/flash-rpi4.sh


#####################################################################
# Image: Raspberry Pi 3 (build-rpi3)

# interactive run Pi3 builder
.PHONY: itrun-pi3-builder
itrun-pi3-builder: yocto-builder
	docker run -it --rm \
		-v /home/yocto/cache:/home/yocto/cache \
		-v ${PWD}:${PWD} \
		-w ${PWD} \
		-e WS=${PWD} \
		-e OEROOT="${PWD}/layers/poky" \
		${yocto-builder-TAG} \
		bash -c 'echo WS=$$WS; echo OEROOT=$$OEROOT; source ${OEROOT}/oe-init-build-env build-rpi3 ; exec bash'

# build Pi3
.PHONY: build-pi3
build-pi3: yocto-builder
	docker run --rm \
		-v /home/yocto/cache:/home/yocto/cache \
		-v ${PWD}:${PWD} \
		-w ${PWD} \
		${yocto-builder-TAG} \
		bash -c "source ${OEROOT}/oe-init-build-env build-rpi3 && bitbake core-image-weston"

# clean build Pi3
.PHONY: clean-build-pi3
clean-build-pi3: yocto-builder
	docker run --rm \
		-v /home/yocto/cache:/home/yocto/cache \
		-v ${PWD}:${PWD} \
		-w ${PWD} \
		${yocto-builder-TAG} \
		bash -c "source ${OEROOT}/oe-init-build-env build-rpi3 && bitbake -c cleanall core-image-weston && bitbake core-image-weston"

# fetch Pi3
.PHONY: fetch-pi3
fetch-pi3: yocto-builder
	docker run --rm \
		-v /home/yocto/cache:/home/yocto/cache \
		-v ${PWD}:${PWD} \
		-w ${PWD} \
		${yocto-builder-TAG} \
		bash -c "source ${OEROOT}/oe-init-build-env build-rpi3 && bitbake core-image-weston --runall fetch"


# run QEMU Pi3
.PHONY: run-pi3
run-pi3:
	WS=${WS} . tools/run-rpi3-qemu.sh

#####################################################################
# Image: QEMU Westron (build-qemuarm64)

QEMU_WESTON_ROOTFS_EXT4=${WS}/build-qemuarm64/tmp/deploy/images/qemuarm64/core-image-weston-qemuarm64.rootfs.ext4
QEMU_WESTON_KERNEL_IMG=${WS}/build-qemuarm64/tmp/deploy/images/qemuarm64/Image


# interactive run QEMU builder
.PHONY: itrun-qemu-builder-weston
itrun-qemu-builder-weston: yocto-builder
	docker run -it --rm \
		-v /home/yocto/cache:/home/yocto/cache \
		-v ${PWD}:${PWD} \
		-w ${PWD} \
		-e WS=${PWD} \
		-e OEROOT="${PWD}/layers/poky" \
		${yocto-builder-TAG} \
		bash -c 'echo WS=$$WS; echo OEROOT=$$OEROOT; . ${OEROOT}/oe-init-build-env build-qemuarm64 ; exec bash'

# build QEMU image
.PHONY: build-qemu-weston
build-qemu-weston: yocto-builder
	docker run --rm \
		-v /home/yocto/cache:/home/yocto/cache \
		-v ${PWD}:${PWD} \
		-w ${PWD} \
		${yocto-builder-TAG} \
		bash -c '. ${OEROOT}/oe-init-build-env build-qemuarm64 && bitbake  core-image-weston '

# clean build QEMU
.PHONY: clean-build-qemu-weston
clean-build-qemu-weston: yocto-builder
	docker run --rm \
		-v /home/yocto/cache:/home/yocto/cache \
		-v ${PWD}:${PWD} \
		-w ${PWD} \
		${yocto-builder-TAG} \
		bash -c ". ${OEROOT}/oe-init-build-env build-qemuarm64 && bitbake -c cleanall core-image-weston && bitbake core-image-weston"

# fetch QEMU
.PHONY: fetch-qemu-weston
fetch-qemu-weston: yocto-builder
	docker run --rm \
		-v /home/yocto/cache:/home/yocto/cache \
		-v ${PWD}:${PWD} \
		-w ${PWD} \
		${yocto-builder-TAG} \
		bash -c ". ${OEROOT}/oe-init-build-env build-qemuarm64 && bitbake core-image-weston --runall fetch"

# run QEMU
.PHONY: run-qemu-weston
run-qemu-weston:
	# WS=${WS} . tools/run-myiq9-qemu.sh
	${AARCH64_QEMU} \
     -machine virt,gic-version=3,virtualization=on \
     -cpu max \
     -smp 8 \
     -m 8G \
     -kernel ${QEMU_WESTON_KERNEL_IMG} \
     -append "root=/dev/vda rootfstype=ext4 rw panic=0 console=ttyAMA0 earlycon" \
     -drive format=raw,file=${QEMU_WESTON_ROOTFS_EXT4},if=none,id=hd0,cache=writeback \
     -device virtio-blk-pci,drive=hd0,bootindex=0 \
     -netdev user,id=net0 \
     -device virtio-net-pci,netdev=net0 \
     -monitor telnet:127.0.0.1:5555,server,nowait \
     -serial mon:stdio \
    -device qemu-xhci,id=usb \
    -device usb-tablet,bus=usb.0 \
    -device virtio-keyboard-pci \
    -device virtio-gpu-pci \
     -display gtk,gl=on,grab-on-hover=on


#####################################################################
# Tool: QEMU

# build QEMU
.PHONY: build-emulator
build-emulator:
	cd tools/qemu && \
	if [ -e build ]; then \
		mv build build-$(shell date +%s).bak && \
		echo "Backup created."; \
	else \
		echo "No 'build' directory to back up."; \
	fi && \
	mkdir build && \
	cd build && \
	../configure \
		--enable-fdt \
		--enable-pixman \
		--enable-gtk \
		--enable-sdl \
		--enable-opengl \
		--enable-virglrenderer \
		--enable-slirp \
		--enable-virtfs \
		--enable-vhost-net \
		--enable-vhost-user \
		--target-list=aarch64-softmmu,arm-softmmu && \
	make -j

# The --enable-virglrenderer need
# sudo apt install libvirglrenderer-dev

 
.PHONY: run-qemu
run-qemu:
	${AARCH64_QEMU} \
     -machine virt,gic-version=3,virtualization=on \
     -cpu max \
     -smp 8 \
     -m 8G \
     -kernel ${KERNEL_IMG} \
     -append "root=/dev/vda rootfstype=ext4 rw panic=0 console=ttyAMA0 earlycon" \
     -drive format=raw,file=${RPIIMG},if=none,id=hd0,cache=writeback \
     -device virtio-blk-pci,drive=hd0,bootindex=0 \
     -netdev user,id=net0 \
     -device virtio-net-pci,netdev=net0 \
     -monitor telnet:127.0.0.1:5555,server,nowait \
     -serial mon:stdio \
    -device qemu-xhci,id=usb \
    -device usb-tablet,bus=usb.0 \
    -device virtio-keyboard-pci \
    -device virtio-gpu-pci \
     -display gtk,gl=on,grab-on-hover=on
	
.PHONY: kill-qemu
kill-qemu:
	@pid=$$(pidof qemu-system-aarch64); \
	if [ -n "$$pid" ]; then \
		echo "Killing QEMU process: $$pid"; \
		kill $$pid; \
	else \
		echo "No QEMU AArch64 process found."; \
	fi
