SUMMARY = "Example application with dynamic library linking"
DESCRIPTION = "Recipe for testing dynamic linking with custom library"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://LICENSE;md5=16257211ae52567965e4ca7137f94939"

SRC_URI += "file://hello.cpp \
            file://mathlib.cpp \
            file://mathlib.h \
            file://LICENSE"

S = "${WORKDIR}"

do_compile() {
    # Compile the library as shared object with version
    ${CXX} ${CXXFLAGS} ${LDFLAGS} -fPIC -shared mathlib.cpp -Wl,-soname,libmath.so.1 -o libmath.so.1.0.0
    
    # Create symlinks for library
    ln -sf libmath.so.1.0.0 libmath.so.1
    ln -sf libmath.so.1.0.0 libmath.so
    
    # Compile the application and link with the shared library
    ${CXX} ${CXXFLAGS} ${LDFLAGS} hello.cpp -L. -lmath -o hello-dynamic
}

do_install() {
    install -d ${D}${bindir}
    install -d ${D}${libdir}
    
    # Install the executable
    install -m 0755 hello-dynamic ${D}${bindir}/hello-dynamic
    
    # Install the shared library and symlinks
    install -m 0755 libmath.so.1.0.0 ${D}${libdir}/libmath.so.1.0.0
    ln -sf libmath.so.1.0.0 ${D}${libdir}/libmath.so.1
    ln -sf libmath.so.1.0.0 ${D}${libdir}/libmath.so
}

# Package the library properly
FILES:${PN} += "${libdir}/libmath.so.1.0.0 ${libdir}/libmath.so.1"
FILES:${PN}-dev += "${libdir}/libmath.so"

# Add runtime dependency
RDEPENDS:${PN} = "${PN} (= ${EXTENDPKGV})"

python do_display_banner() {
    bb.plain("***********************************************");
    bb.plain("*                                             *");
    bb.plain("*  Dynamic linking example for Yocto         *");
    bb.plain("*                                             *");
    bb.plain("***********************************************");
}

addtask display_banner before do_build