SUMMARY = "Example application with dynamic library linking"
DESCRIPTION = "Recipe for testing dynamic linking with custom library"
LICENSE = "MIT"

SRC_URI += "file://hello.cpp \
            file://mathlib.cpp \
            file://mathlib.h"

S = "${WORKDIR}"

do_compile() {
    # Compile the library as shared object
    ${CXX} ${CXXFLAGS} -fPIC -shared mathlib.cpp -o libmath.so
    
    # Compile the application and link with the shared library
    ${CXX} ${CXXFLAGS} hello.cpp -L. -lmath -o hello-dynamic
}

do_install() {
    install -d ${D}${bindir}
    install -d ${D}${libdir}
    
    # Install the executable
    install -m 0755 hello-dynamic ${D}${bindir}/hello-dynamic
    
    # Install the shared library
    install -m 0755 libmath.so ${D}${libdir}/libmath.so
}

FILES:${PN} += "${libdir}/libmath.so"

python do_display_banner() {
    bb.plain("***********************************************");
    bb.plain("*                                             *");
    bb.plain("*  Dynamic linking example for Yocto         *");
    bb.plain("*                                             *");
    bb.plain("***********************************************");
}

addtask display_banner before do_build