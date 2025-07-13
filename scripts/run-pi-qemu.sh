

sudo -v
export WORK_TARGET=~/killme/justkill
export SYSTEM_MNT=${WORK_TARGET}/system

export PI3_WESTON_ROOTFS_EXT3=${WS}/build-rpi3/tmp/deploy/images/raspberrypi3/core-image-weston-raspberrypi3.rootfs.ext3
export PI3_WESTON_KERNEL_IMG=${WS}/build-rpi3/tmp/deploy/images/raspberrypi3/zImage
export PI3_WESTON_KERNEL_DTB=${WS}/build-rpi3/tmp/deploy/images/raspberrypi3/bcm2710-rpi-3-b.dtb

export AARCH64_QEMU=./tools/qemu/build/qemu-system-aarch64
mkdir -p ${SYSTEM_MNT}

export RPI_WIC_IMG=$(find ${WS}/build-rpi3/tmp/deploy/images/raspberrypi3 -name "core-image-weston-raspberrypi3.rootfs-*.wic.bz2")

echo RPI_WIC_IMG=${RPI_WIC_IMG}
cp ${RPI_WIC_IMG} ${WORK_TARGET}/system.img.wic.bz2
sudo -v
rm ${WORK_TARGET}/system.img.wic
bzip2 -d ${WORK_TARGET}/system.img.wic.bz2

# extend system image
truncate -s 64G ${WORK_TARGET}/64g-system.img
sudo virt-resize --expand /dev/sda2 ${WORK_TARGET}/system.img.wic ${WORK_TARGET}/64g-system.img
export RPIIMG=${WORK_TARGET}/64g-system.img
	
# GUI
${AARCH64_QEMU} \
	-M raspi3b \
	-cpu cortex-a53 \
	-m 1024 \
	-kernel ${PI3_WESTON_KERNEL_IMG} \
	-dtb ${PI3_WESTON_KERNEL_DTB} \
	-drive format=raw,file=${PI3_WESTON_ROOTFS_EXT3} \
	-append "root=/dev/sda rw console=tty1" \
	-netdev user,id=net0 \
	-device usb-net,netdev=net0 \
	-serial stdio \
	-display gtk,gl=on \
	-device usb-kbd \
	-device usb-mouse