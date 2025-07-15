

sudo -v
export WORK_TARGET=~/killme/justkill
export SYSTEM_MNT=${WORK_TARGET}/system

export PI3_WESTON_KERNEL_IMG=${WS}/build-rpi4/tmp/deploy/images/raspberrypi4-64/Image
export PI3_WESTON_KERNEL_DTB=${WS}/build-rpi4/tmp/deploy/images/raspberrypi4-64/bcm2711-rpi-4-b.dtb

export AARCH64_QEMU=./tools/qemu/build/qemu-system-aarch64
mkdir -p ${SYSTEM_MNT}

export RPI_WIC_IMG=$(find ${WS}/build-rpi4/tmp/deploy/images/raspberrypi4-64 -name "core-image-weston-raspberrypi4-64.rootfs-*.wic.bz2")

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
	-machine raspi4b \
	-cpu cortex-a72 \
	-m 2048 \
	-kernel ${PI3_WESTON_KERNEL_IMG} \
	-dtb ${PI3_WESTON_KERNEL_DTB} \
	-drive format=raw,file=${RPIIMG} \
	-append "root=/dev/mmcblk0p2 rw rootwait console=ttyAMA0,115200 console=tty1" \
	-netdev user,id=net0 \
	-device usb-net,netdev=net0 \
    -monitor telnet:127.0.0.1:5555,server,nowait \
    -serial mon:stdio \
	-device usb-kbd \
	-device usb-mouse \
	-display gtk

