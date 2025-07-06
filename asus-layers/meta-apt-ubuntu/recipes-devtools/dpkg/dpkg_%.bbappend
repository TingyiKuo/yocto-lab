# Enable zstd support in dpkg
PACKAGECONFIG:append = " zstd"
DEPENDS += "zstd"

# Ensure zstd is available at runtime
RDEPENDS:${PN} += "zstd libzstd"
