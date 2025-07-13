
yocto-builder-TAG=amito4/yocto-builder
user_id=$(shell id -u)
user_name=$(shell id -un)
user_group=$(shell id -g)
WS=$(shell pwd)
OEROOT=${WS}/layers/poky

RPIIMG=${WS}/build-qcom-wayland/tmp-glibc/deploy/images/qcs9100-ride-sx/qcom-multimedia-image-qcs9100-ride-sx.rootfs.ext4
KERNEL_IMG=${WS}/build-qcom-wayland/tmp-glibc/deploy/images/qcs9100-ride-sx/Image
AARCH64_QEMU=./tools/qemu/build/qemu-system-aarch64


#####################################################################
# HELP

.PHONY: show_help
show_help:
	grep .PHONY Makefile

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

.PHONY: build-image
build-image: yocto-builder


#####################################################################
# Code sync

.PHONY: repo-init
#repo-init:setup-environment
repo-init:
	repo init -u https://github.com/qualcomm-linux/qcom-manifest -b qcom-linux-scarthgap -m qcom-6.6.90-QLI.1.5-Ver.1.1.xml
	repo sync

#####################################################################
# Image: QCOM Wayland (build-qcom-wayland)

# login QCOM Wayland builder
.PHONY: login-qcom-wayland-builder
login-qcom-wayland-builder: yocto-builder
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
		bash -c "MACHINE=qcs9100-ride-sx DISTRO=qcom-wayland QCOM_SELECTED_BSP=custom source setup-environment build-qcom-wayland && bitbake qcom-multimedia-image"

# clean build QCOM Wayland
.PHONY: clean-build-qcom-wayland
clean-build-qcom-wayland: yocto-builder
	docker run --rm \
		-v /home/yocto/cache:/home/yocto/cache \
		-v ${PWD}:${PWD} \
		-w ${PWD} \
		${yocto-builder-TAG} \
		bash -c "MACHINE=qcs9100-ride-sx DISTRO=qcom-wayland QCOM_SELECTED_BSP=custom source setup-environment build-qcom-wayland && bitbake -c cleanall qcom-multimedia-image && bitbake qcom-multimedia-image"

# fetch QCOM Wayland
.PHONY: fetch-qcom-wayland
fetch-qcom-wayland: yocto-builder
	docker run --rm \
		-v /home/yocto/cache:/home/yocto/cache \
		-v ${PWD}:${PWD} \
		-w ${PWD} \
		${yocto-builder-TAG} \
		bash -c "MACHINE=qcs9100-ride-sx DISTRO=qcom-wayland QCOM_SELECTED_BSP=custom source setup-environment build-qcom-wayland && bitbake qcom-multimedia-image --runall fetch"


#####################################################################
# Image: QEMU Westron (build-qemuarm64)

QEMU_WESTON_ROOTFS_EXT4=${WS}/build-qemuarm64/tmp/deploy/images/qemuarm64/core-image-weston-qemuarm64.rootfs.ext4
QEMU_WESTON_KERNEL_IMG=${WS}/build-qemuarm64/tmp/deploy/images/qemuarm64/Image


# login QEMU builder
.PHONY: login-qemu-builder-weston
login-qemu-builder-weston: yocto-builder
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
		--enable-gtk \
		--enable-slirp \
		--enable-virtfs \
		--enable-vhost-net \
		--enable-vhost-user \
		--target-list=aarch64-softmmu && \
	make -j

# 
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
