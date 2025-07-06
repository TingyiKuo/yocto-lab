# Add APT functionality to qcom-multimedia-image


IMAGE_FEATURES += " ssh-server-openssh package-management"

IMAGE_INSTALL += " \
    apt \
    dpkg \
    gnupg \
    ca-certificates \
    curl \
    apt-conf-ubuntu \
    "


# Create _apt user and initialize dpkg database with correct architecture
ROOTFS_POSTPROCESS_COMMAND += "create_apt_user; dpkg_db_init; configure_dpkg_arch; "


create_apt_user() {
    # Create _apt user for APT security
    if ! grep -q "^_apt:" ${IMAGE_ROOTFS}/etc/passwd; then
        echo "_apt:x:100:65534::/nonexistent:/usr/sbin/nologin" >> ${IMAGE_ROOTFS}/etc/passwd
    fi
    if ! grep -q "^nogroup:" ${IMAGE_ROOTFS}/etc/group; then
        echo "nogroup:x:65534:" >> ${IMAGE_ROOTFS}/etc/group
    fi
}

dpkg_db_init() {
    # Initialize dpkg database
    mkdir -p ${IMAGE_ROOTFS}/var/lib/dpkg/{info,updates,parts}
    mkdir -p ${IMAGE_ROOTFS}/var/lib/dpkg/alternatives
    touch ${IMAGE_ROOTFS}/var/lib/dpkg/status
    touch ${IMAGE_ROOTFS}/var/lib/dpkg/available
    touch ${IMAGE_ROOTFS}/var/lib/dpkg/diversions
    touch ${IMAGE_ROOTFS}/var/lib/dpkg/statoverride
}

configure_dpkg_arch() {
    # Set the correct target architecture
    echo "arm64" > ${IMAGE_ROOTFS}/var/lib/dpkg/arch
    
    # Create dpkg configuration
    mkdir -p ${IMAGE_ROOTFS}/etc/dpkg/dpkg.cfg.d
    
    # Create basic dpkg.cfg
    cat > ${IMAGE_ROOTFS}/etc/dpkg/dpkg.cfg << EOF
# dpkg configuration file
log /var/log/dpkg.log
EOF
}

