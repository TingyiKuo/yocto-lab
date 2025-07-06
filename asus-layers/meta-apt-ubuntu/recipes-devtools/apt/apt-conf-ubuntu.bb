SUMMARY = "APT configuration for Ubuntu repositories"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

SRC_URI = "file://sources.list \
           file://apt.conf \
           file://99-disable-signature-check"


do_install() {
    install -d ${D}${sysconfdir}/apt
    install -d ${D}${sysconfdir}/apt/apt.conf.d
    install -d ${D}${sysconfdir}/apt/sources.list.d
    
    install -m 0644 ${WORKDIR}/sources.list ${D}${sysconfdir}/apt/
#    install -m 0644 ${WORKDIR}/apt.conf ${D}${sysconfdir}/apt/
    install -m 0644 ${WORKDIR}/99-disable-signature-check ${D}${sysconfdir}/apt/apt.conf.d/
}

FILES:${PN} = "${sysconfdir}/apt/*"
