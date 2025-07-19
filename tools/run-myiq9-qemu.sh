#/bin/bash


export WORK_TARGET=~/killme/justkill

export KERNEL_IMG=${WS}/build-qcom-wayland/tmp-glibc/deploy/images/qcs9100-ride-sx/Image

export AARCH64_QEMU_SYS=./tools/qemu/build/qemu-system-aarch64
export AARCH64_QEMU_IMG=./tools/qemu/build/qemu-img

export RPI_EXT4_IMG=$(find ${WS}/build-qcom-wayland/tmp-glibc/deploy/images/qcs9100-ride-sx -name "qcom-console-image-qcs9100-ride-sx.rootfs-*.ext4")

# Create WORK_TARGET directory if it doesn't exist
mkdir -p "${WORK_TARGET}"
export RPIIMG=${WORK_TARGET}/system.img.ext4

echo

echo "Checking if ${RPIIMG} is older than ${RPI_EXT4_IMG}..."
if [ ! -f "${RPIIMG}" ] || \
   [ "${RPI_EXT4_IMG}" -nt "${RPIIMG}" ]; then
    cp "${RPI_EXT4_IMG}" "${RPIIMG}"
	# extend system image
	${AARCH64_QEMU_IMG} resize ${RPIIMG} 32G
else
    echo "${RPIIMG} is up to date, no copy needed."
fi

echo

# No GUI
${AARCH64_QEMU_SYS} \
    -machine virt,virtualization=on \
    -cpu max  -smp 8 -m 12G \
    -kernel ${KERNEL_IMG} \
    -append "root=/dev/vda rootfstype=ext4 rw panic=0 systemd.log_level=debug systemd.log_target=console console=ttyAMA0" \
    -drive format=raw,file=${RPIIMG},if=none,id=hd0,cache=writeback \
    -device virtio-blk,drive=hd0,bootindex=0 \
    -netdev user,id=mynet,hostfwd=tcp::2222-:22 \
    -device virtio-net-pci,netdev=mynet \
    -monitor telnet:127.0.0.1:5555,server,nowait \
    -nographic \
    -serial mon:stdio
echo

: <<'END_COMMENT'
# GUI. not succeed yet..
echo Skip~ ${AARCH64_QEMU_SYS} \
    -machine virt -cpu cortex-a57 -smp 8 -m 8G \
    -kernel ${KERNEL_IMG} \
    -append "root=/dev/vda rootfstype=ext4 rw panic=0 console=ttyAMA0" \
    -drive format=raw,file=${RPIIMG},if=none,id=hd0,cache=writeback \
    -device virtio-blk,drive=hd0,bootindex=0 \
    -monitor telnet:127.0.0.1:5555,server,nowait \
    -device virtio-gpu \
    -device virtio-mouse \
    -device virtio-keyboard \
    -serial mon:stdio
echo
END_COMMENT

