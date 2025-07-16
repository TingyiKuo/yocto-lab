SUMMARY = "Example application with static library linking"
DESCRIPTION = "Recipe for testing static linking with custom library"
LICENSE = "MIT"

SRC_URI += "file://hello.cpp \
            file://mathlib.cpp \
            file://mathlib.h"

S = "${WORKDIR}"

do_compile() {
    # Compile the library as static archive
    ${CXX} ${CXXFLAGS} -c mathlib.cpp -o mathlib.o
    ${AR} rcs libmath.a mathlib.o
    
    # Compile the application and link with the static library
    ${CXX} ${CXXFLAGS} hello.cpp -L. -lmath -static -o hello-static
}

do_install() {
    install -d ${D}${bindir}
    
    # Install the statically linked executable
    install -m 0755 hello-static ${D}${bindir}/hello-static
}

python do_display_banner() {
    bb.plain("***********************************************");
    bb.plain("*                                             *");
    bb.plain("*  Static linking example for Yocto          *");
    bb.plain("*                                             *");
    bb.plain("***********************************************");
}

addtask display_banner before do_build