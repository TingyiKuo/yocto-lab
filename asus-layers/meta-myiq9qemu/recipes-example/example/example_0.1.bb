SUMMARY = "bitbake-layers recipe"
DESCRIPTION = "Recipe created by bitbake-layers"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://LICENSE;md5=16257211ae52567965e4ca7137f94939"

SRC_URI += "file://hello.cpp \
            file://mathlib.cpp \
            file://mathlib.h \
            file://LICENSE"

S = "${WORKDIR}"

do_compile() {
    # Compile library and application together (simple approach)
    ${CXX} ${CXXFLAGS} ${LDFLAGS} hello.cpp mathlib.cpp -o hello-world
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