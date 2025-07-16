SUMMARY = "bitbake-layers recipe"
DESCRIPTION = "Recipe created by bitbake-layers"
LICENSE = "MIT"

SRC_URI += "file://hello.cpp \
            file://mathlib.cpp \
            file://mathlib.h"

S = "${WORKDIR}"

do_compile() {
    # Compile library and application together (simple approach)
    ${CXX} hello.cpp mathlib.cpp -o hello-world
}

do_install() {
    install -d ${D}${bindir}
    install -m 0755 hello-world ${D}${bindir}/hello-world
}

python do_display_banner() {
    bb.plain("***********************************************");
    bb.plain("*                                             *");
    bb.plain("*  Example recipe created by bitbake-layers   *");
    bb.plain("*                                             *");
    bb.plain("***********************************************");
}

addtask display_banner before do_build