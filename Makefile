
yocto-builder-TAG=amito4/yocto-builder
user_id=$(shell id -u)
user_name=$(shell id -un)
user_group=$(shell id -g)
root_path=$(shell pwd)

RPIIMG=${root_path}/build-qcom-wayland/tmp-glibc/deploy/images/qcs9100-ride-sx/qcom-multimedia-image-qcs9100-ride-sx.rootfs.ext4
KERNEL_IMG=${root_path}/build-qcom-wayland/tmp-glibc/deploy/images/qcs9100-ride-sx/Image
AARCH64_QEMU=./tools/qemu/build/qemu-system-aarch64


.PHONY: show_help
show_help:
	@echo "make : show help"
	@echo "make run-qemu : launch qemu"
	@echo "make build-image : build docker image"
	@echo "make login-builder : login into interactive container"
	@echo "make build-qcom-wayland : build build-qcom-wayland"
	@echo "make build-qemu :"
	
	
	
all:show_help

# build yocto-builder docker image
builder-docker-image_${user_id}.stamp: docker/Dockerfile.local
	docker image build \
		--build-arg userid=${user_id} \
		--build-arg groupid=${user_group} \
		--build-arg username=${user_name} \
		-f docker/Dockerfile.local \
		-t ${yocto-builder-TAG} docker
	touch $@


.PHONY: yocto-builder
yocto-builder: builder-docker-image_${user_id}.stamp

# login into docker container		
.PHONY: login-builder
login-builder: yocto-builder
	docker run -it --rm \
		-v /home/yocto/cache:/home/yocto/cache \
		-v ${PWD}:${PWD} \
		-w ${PWD} \
		${yocto-builder-TAG} \
		bash


.PHONY: repo-init
#repo-init:setup-environment
repo-init:
	repo init -u https://github.com/qualcomm-linux/qcom-manifest -b qcom-linux-scarthgap -m qcom-6.6.90-QLI.1.5-Ver.1.1.xml
	repo sync



# login into docker container		
.PHONY: build-qcom-wayland
build-qcom-wayland: yocto-builder
	docker run -it --rm \
		-v /home/yocto/cache:/home/yocto/cache \
		-v ${PWD}:${PWD} \
		-w ${PWD} \
		${yocto-builder-TAG} \
		bash -c "MACHINE=qcs9100-ride-sx DISTRO=qcom-wayland QCOM_SELECTED_BSP=custom source setup-environment build-qcom-wayland && bitbake qcom-multimedia-image"

.PHONY: build
build: build-qcom-wayland

# login into docker container
.PHONY: clean-build-qcom-wayland
clean-build-qcom-wayland: yocto-builder
	docker run -it --rm \
		-v /home/yocto/cache:/home/yocto/cache \
		-v ${PWD}:${PWD} \
		-w ${PWD} \
		${yocto-builder-TAG} \
		bash -c "MACHINE=qcs9100-ride-sx DISTRO=qcom-wayland QCOM_SELECTED_BSP=custom source setup-environment build-qcom-wayland && bitbake -c cleanall qcom-multimedia-image && bitbake qcom-multimedia-image"

.PHONY: clean-build
clean-build: clean-build-qcom-wayland

# login into docker container
.PHONY: fetch-qcom-wayland
fetch-qcom-wayland: yocto-builder
	docker run -it --rm \
		-v /home/yocto/cache:/home/yocto/cache \
		-v ${PWD}:${PWD} \
		-w ${PWD} \
		${yocto-builder-TAG} \
		bash -c "MACHINE=qcs9100-ride-sx DISTRO=qcom-wayland QCOM_SELECTED_BSP=custom source setup-environment build-qcom-wayland && bitbake -c cleanall qcom-multimedia-image && bitbake qcom-multimedia-image --runall fetch"

# login into docker container
.PHONY: build-qcom-wayland-no-download
build-qcom-wayland-no-download: yocto-builder
	docker run -it --rm \
		-v /home/yocto/cache:/home/yocto/cache \
		-v ${PWD}:${PWD} \
		-w ${PWD} \
		${yocto-builder-TAG} \
		bash -c "MACHINE=qcs9100-ride-sx DISTRO=qcom-wayland QCOM_SELECTED_BSP=custom source setup-environment build-qcom-wayland && BB_NO_NETWORK=1 bitbake qcom-multimedia-image"


# build QEMU
.PHONY: build-qemu
build-qemu:
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

#     -cpu cortex-a57  why panic?

#     -display gtk,gl=on \
#     -device virtio-gpu-pci \
#     -device virtio-mouse \
#     -device virtio-keyboard \
