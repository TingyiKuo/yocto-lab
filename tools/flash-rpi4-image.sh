

sudo -v
export WORK_TARGET=~/killme/justkill


export RPI_WIC_IMG=$(find ${WS}/build-rpi4/tmp/deploy/images/raspberrypi4-64 -name "core-image-weston-raspberrypi4-64.rootfs-*.wic.bz2")

echo RPI_WIC_IMG=${RPI_WIC_IMG}
cp ${RPI_WIC_IMG} ${WORK_TARGET}/system.img.wic.bz2
sudo -v
rm ${WORK_TARGET}/system.img.wic
bzip2 -d ${WORK_TARGET}/system.img.wic.bz2
export RPIIMG=${WORK_TARGET}/system.img.wic

# Flasher
SD_DEV=$(lsblk -o NAME,TYPE,RM,SIZE,MODEL | grep -E 'disk\s+1' | awk '{print "/dev/" $1}' | head -n 1)
echo "Detected SD device: $SD_DEV"

echo rpi-imager --cli ${RPIIMG} ${SD_DEV}

