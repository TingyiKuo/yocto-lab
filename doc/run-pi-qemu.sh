
sudo -v
export WORK_TARGET=~/killme/justkill
export SYSTEM_MNT=${WORK_TARGET}/system
mkdir -p ${SYSTEM_MNT}

#export RPI_WIC_IMG=$(find ~/ssd1/pegasus/yocto/myrpi/build-rpi/tmp/deploy/images/raspberrypi3 -name "core-image-minimal-raspberrypi3.rootfs-*.wic.bz2")
export RPI_WIC_IMG=$(find ~/ssd1/pegasus/yocto/myrpi/build-rpi/tmp/deploy/images/raspberrypi3 -name "core-image-weston-raspberrypi3.rootfs-*.wic.bz2")

echo RPI_WIC_IMG=${RPI_WIC_IMG}
cp ${RPI_WIC_IMG} ${WORK_TARGET}/system.img.wic.bz2
sudo -v
rm ${WORK_TARGET}/system.img.wic
bzip2 -d ${WORK_TARGET}/system.img.wic.bz2

# extend system image
truncate -s 64G ${WORK_TARGET}/64g-system.img
sudo virt-resize --expand /dev/sda2 ${WORK_TARGET}/system.img.wic ${WORK_TARGET}/64g-system.img
sudo mount -v -o offset=$(echo $(fdisk -l ${WORK_TARGET}/64g-system.img | grep 64g-system.img2 | awk '{print $2}')*512 | bc) ${WORK_TARGET}/64g-system.img ${SYSTEM_MNT}

# Kernel 
sudo -v
cd /home/tingyikuo/ssd1/pegasus/qemu_kvm/emu-rasbpi/kernel-src/linux-6.6.51/
sudo ARCH=arm64 CROSS_COMPILE=/bin/aarch64-linux-gnu- make modules_install INSTALL_MOD_PATH=${SYSTEM_MNT}


sudo umount ${SYSTEM_MNT}
export RPIIMG=${WORK_TARGET}/64g-system.img



# No GUI
echo qemu-system-aarch64 -machine virt -cpu cortex-a72 -smp 8 -m 8G \
    -kernel /home/tingyikuo/ssd1/pegasus/qemu_kvm/emu-rasbpi/kernel-src/linux-6.6.51/arch/arm64/boot/Image \
    -append "root=/dev/vda2 rootfstype=ext4 rw panic=0 console=ttyAMA0" \
    -drive format=raw,file=${RPIIMG},if=none,id=hd0,cache=writeback \
    -device virtio-blk,drive=hd0,bootindex=0 \
    -netdev user,id=mynet,hostfwd=tcp::2222-:22 \
    -device virtio-net-pci,netdev=mynet \
    -monitor telnet:127.0.0.1:5555,server,nowait \
    -nographic \
    -serial mon:stdio
echo
	
# GUI
qemu-system-aarch64 -machine virt -cpu cortex-a72 -smp 8 -m 8G \
    -kernel /home/tingyikuo/ssd1/pegasus/qemu_kvm/emu-rasbpi/kernel-src/linux-6.6.51/arch/arm64/boot/Image \
    -append "root=/dev/vda2 rootfstype=ext4 rw panic=0 console=ttyAMA0" \
    -drive format=raw,file=${RPIIMG},if=none,id=hd0,cache=writeback \
    -device virtio-blk,drive=hd0,bootindex=0 \
    -netdev user,id=mynet,hostfwd=tcp::2222-:22 \
    -device virtio-net-pci,netdev=mynet \
    -monitor telnet:127.0.0.1:5555,server,nowait \
    -device virtio-gpu \
    -device virtio-mouse \
    -device virtio-keyboard \
    -serial mon:stdio
echo
# kill $(pidof qemu-system-aarch64)	

# https://triplehelix-consulting.com/yocto-full-demo-gui-raspberry-pi-detailed-manual/