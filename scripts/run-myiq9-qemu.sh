
sudo -v
export WORK_TARGET=~/killme/justkill
export SYSTEM_MNT=${WORK_TARGET}/system
mkdir -p ${SYSTEM_MNT}


# ~/ssd1/repos/github.com/TingyiKuo/myiq9qemu/build-qcom-wayland/tmp-glibc/deploy/images/qcs9100-ride-sx
/home/tingyikuo/ssd1/repos/github.com/TingyiKuo/myiq9qemu/build-qcom-wayland/tmp-glibc/deploy/images/qcs9100-ride-sx

export RPI_WIC_IMG=$(find ~/ssd1/repos/github.com/TingyiKuo/myiq9qemu/build-qcom-wayland/tmp-glibc/deploy/images/qcs9100-ride-sx -name "qcom-multimedia-image-qcs9100-ride-sx.rootfs-*.ext4")

 "core-image-weston-qcs9100-ride-sx.rootfs-*.ext4")


echo RPI_WIC_IMG=${RPI_WIC_IMG}
cp ${RPI_WIC_IMG} ${WORK_TARGET}/system.img
sudo -v

# extend system image
truncate -s 32G ${WORK_TARGET}/system.img

LOOPID=$(sudo losetup -f) && echo ${LOOPID}
sudo losetup ${LOOPID} ${WORK_TARGET}/system.img

sudo e2fsck -f ${LOOPID}
# might need to goto /home/tingyikuo/ssd1/pegasus/e2fsprogs
# and build latest e2fsck

sudo resize2fs -f -p ${LOOPID}
sudo losetup -d ${LOOPID}

sudo mount -v ${WORK_TARGET}/system.img ${SYSTEM_MNT}


# Kernel 
cd /home/tingyikuo/ssd1/pegasus/qemu_kvm/emu-rasbpi/kernel-src/linux-6.6.51/

sudo ARCH=arm64 CROSS_COMPILE=/bin/aarch64-linux-gnu- make modules_install INSTALL_MOD_PATH=${SYSTEM_MNT}

sudo umount ${SYSTEM_MNT}
export RPIIMG=${WORK_TARGET}/system.img


# No GUI
echo Skip~ qemu-system-aarch64 -machine virt -cpu cortex-a72 -smp 8 -m 8G \
    -kernel /home/tingyikuo/ssd1/pegasus/qemu_kvm/emu-rasbpi/kernel-src/linux-6.6.51/arch/arm64/boot/Image \
    -append "root=/dev/vda rootfstype=ext4 rw panic=0 systemd.log_level=debug systemd.log_target=console console=ttyAMA0" \
    -drive format=raw,file=${RPIIMG},if=none,id=hd0,cache=writeback \
    -device virtio-blk,drive=hd0,bootindex=0 \
    -netdev user,id=mynet,hostfwd=tcp::2222-:22 \
    -device virtio-net-pci,netdev=mynet \
    -monitor telnet:127.0.0.1:5555,server,nowait \
    -nographic \
    -serial mon:stdio
echo
	
# GUI
/home/tingyikuo/ssd1/pegasus/qemu_kvm/qemu-src/qemu/build/qemu-system-aarch64 -machine virt -cpu cortex-a55 -smp 8 -m 8G \
    -kernel /home/tingyikuo/ssd1/pegasus/qemu_kvm/emu-rasbpi/kernel-src/linux-6.6.51/arch/arm64/boot/Image \
    -append "root=/dev/vda rootfstype=ext4 rw panic=0 console=ttyAMA0" \
    -drive format=raw,file=${RPIIMG},if=none,id=hd0,cache=writeback \
    -device virtio-blk,drive=hd0,bootindex=0 \
    -monitor telnet:127.0.0.1:5555,server,nowait \
    -device virtio-gpu \
    -device virtio-mouse \
    -device virtio-keyboard \
    -serial mon:stdio
echo
# kill $(pidof qemu-system-aarch64)	


RPIIMG=/home/tingyikuo/ssd1/repos/github.com/TingyiKuo/myiq9qemu/build-qcom-wayland/tmp-glibc/deploy/images/qcs9100-ride-sx/qcom-multimedia-image-qcs9100-ride-sx.rootfs.ext4
KERNEL_IMG=/home/tingyikuo/ssd1/repos/github.com/TingyiKuo/myiq9qemu/build-qcom-wayland/tmp-glibc/deploy/images/qcs9100-ride-sx/Image
AARCH64_QEMU=/home/tingyikuo/ssd1/pegasus/qemu_kvm/qemu-src/qemu/build/qemu-system-aarch64
${AARCH64_QEMU} \
     -machine virt,gic-version=3,virtualization=on \
     -cpu max \
     -smp 8 \
     -m 8G \
     -kernel ${KERNEL_IMG} \
     -append "root=/dev/vda rootfstype=ext4 rw panic=0 console=ttyAMA0 earlycon" \
     -drive format=raw,file=${RPIIMG},if=none,id=hd0,cache=writeback     -device virtio-blk-pci,drive=hd0,bootindex=0     -netdev user,id=net0     -device virtio-net-pci,netdev=net0     -monitor telnet:127.0.0.1:5555,server,nowait     -device virtio-gpu-pci     -device virtio-mouse     -device virtio-keyboard     -serial mon:stdio


