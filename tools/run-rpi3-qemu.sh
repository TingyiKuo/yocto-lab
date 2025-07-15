

export WORK_TARGET=~/killme/justkill

export PI3_WESTON_KERNEL_IMG=${WS}/build-rpi3/tmp/deploy/images/raspberrypi3-64/Image
export PI3_WESTON_KERNEL_DTB=${WS}/build-rpi3/tmp/deploy/images/raspberrypi3-64/bcm2710-rpi-3-b.dtb

export AARCH64_QEMU_SYS=./tools/qemu/build/qemu-system-aarch64
export AARCH64_QEMU_IMG=./tools/qemu/build/qemu-img

export RPI_WIC_IMG=$(find ${WS}/build-rpi3/tmp/deploy/images/raspberrypi3-64 -name "core-image-weston-raspberrypi3-64.rootfs-*.wic.bz2")

# Create WORK_TARGET directory if it doesn't exist
mkdir -p "${WORK_TARGET}"
export RPIIMG=${WORK_TARGET}/system.img.wic

echo "Checking if ${RPIIMG}.bz2 is older than ${RPI_WIC_IMG}..."
if [ ! -f "${RPIIMG}.bz2" ] || \
   [ "${RPI_WIC_IMG}" -nt "${RPIIMG}.bz2" ]; then
    cp "${RPI_WIC_IMG}" "${RPIIMG}.bz2"
else
    echo "${RPIIMG}.bz2 is up to date, no copy needed."
fi

echo "Checking if ${RPIIMG} is older than ${RPIIMG}.bz2..."
if [ ! -f "${RPIIMG}" ] || \
   [ "${RPIIMG}.bz2" -nt "${RPIIMG}" ]; then
    if [ -f "${RPIIMG}" ]; then
        echo "Performing removal of old file: rm ${RPIIMG}"
        rm "${RPIIMG}"
    fi
    bzip2 -d "${RPIIMG}.bz2"
	# extend system image
	${AARCH64_QEMU_IMG} resize ${RPIIMG} 16G
else
    echo "${RPIIMG} is up to date, no decompression needed."
fi


	
# GUI
${AARCH64_QEMU_SYS} \
	-machine raspi3b \
	-cpu cortex-a53 \
	-m 1024 \
	-kernel ${PI3_WESTON_KERNEL_IMG} \
	-dtb ${PI3_WESTON_KERNEL_DTB} \
	-drive format=raw,file=${RPIIMG},if=sd \
	-append "root=/dev/mmcblk0p2 rootwait rw console=ttyAMA0,115200 console=tty1" \
	-netdev user,id=net0 \
	-device usb-net,netdev=net0 \
    -monitor telnet:127.0.0.1:5555,server,nowait \
	-device usb-kbd \
	-device usb-mouse \
	-vga std \
	-display gtk,zoom-to-fit=on

