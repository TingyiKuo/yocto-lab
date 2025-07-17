SUMMARY = "Math library for testing Yocto cross-compilation with Android NDK"
DESCRIPTION = "A simple math library that provides basic arithmetic functions for testing cross-compilation compatibility between Yocto-built libraries and Android NDK applications"
HOMEPAGE = "https://github.com/TingyiKuo/yocto-lab"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://LICENSE;md5=d0a0d8970522d85bf898ca41ec59c9dc"

SRC_URI = "file://mathlib.c \
           file://mathlib.h \
           file://LICENSE \
          "

S = "${WORKDIR}"

do_compile() {
    # Build shared library
    ${CC} ${CFLAGS} -fPIC -shared -o libmathlib.so.1.0 mathlib.c ${LDFLAGS}
    ln -sf libmathlib.so.1.0 libmathlib.so
    
    # Build static library
    ${CC} ${CFLAGS} -c mathlib.c -o mathlib.o
    ${AR} rcs libmathlib.a mathlib.o
}

do_install() {
    install -d ${D}${libdir}
    install -d ${D}${includedir}
    
    # Install shared library
    install -m 0755 libmathlib.so.1.0 ${D}${libdir}/
    ln -sf libmathlib.so.1.0 ${D}${libdir}/libmathlib.so
    
    # Install static library
    install -m 0644 libmathlib.a ${D}${libdir}/
    
    # Install header
    install -m 0644 mathlib.h ${D}${includedir}/
}

PACKAGES = "${PN} ${PN}-dev ${PN}-staticdev ${PN}-dbg"

FILES:${PN} = "${libdir}/libmathlib.so.*"
FILES:${PN}-dev = "${includedir}/mathlib.h ${libdir}/libmathlib.so"
FILES:${PN}-staticdev = "${libdir}/libmathlib.a"
FILES:${PN}-dbg = "${libdir}/.debug/"

BBCLASSEXTEND = "native nativesdk"