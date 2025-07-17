
# Yocto and Android build ABI compatibility test

This is a report about testing cross-compilation compatibility with Android devices. 
The primary goal is to verify if Yocto-built binaries and libraries can run on Android devices.

## Result

1. yocto exec + yocto .so -> NG
2. yocto exec only (dynamic build) -> NG, need to link
3. yocto exec + yocto .a (static build) -> OK.
4. Android exec + yocto .so --> (need libc++_shared.so)
5. Android exec + yocto .a --> OK


## Observe shared library by yocto build executable

tingyikuo@P6820-PLX1:~/killme/justkill$ find -name hello-* | xargs readelf -d 

File: ./y/usr/bin/hello-world

Dynamic section at offset 0xfd50 contains 29 entries:
  Tag        Type                         Name/Value
 0x0000000000000001 (NEEDED)             Shared library: [libstdc++.so.6]
 0x0000000000000001 (NEEDED)             Shared library: [libc.so.6]
...
 
readelf: Warning: Separate debug info file /home/tingyikuo/killme/justkill/y/usr/bin/hello-world found, but CRC does not match - ignoring

File: ./z/usr/bin/hello-dynamic

Dynamic section at offset 0xfd28 contains 30 entries:
  Tag        Type                         Name/Value
 0x0000000000000001 (NEEDED)             Shared library: [libmath.so.1]
 0x0000000000000001 (NEEDED)             Shared library: [libstdc++.so.6]
 0x0000000000000001 (NEEDED)             Shared library: [libc.so.6]
...

File: ./x/usr/bin/hello-static

There is no dynamic section in this file.

### observe prebuilt so

tingyikuo@P6820-PLX1:~/ssd1/repos/github.com/TingyiKuo/yocto-lab/build-qcom-wayland/tmp-glibc/sysroots-components/armv8-2a/qcom-adreno$ find -type f -name "*\.so*" | xargs readelf -d | grep "Shared library" | sort -u
 0x0000000000000001 (NEEDED)             Shared library: [ld-linux-aarch64.so.1]
 0x0000000000000001 (NEEDED)             Shared library: [libadreno_utils.so.1]
 0x0000000000000001 (NEEDED)             Shared library: [libc.so.6]
 0x0000000000000001 (NEEDED)             Shared library: [libdmabufheap.so.0]
 0x0000000000000001 (NEEDED)             Shared library: [libEGL_adreno.so.1]
 0x0000000000000001 (NEEDED)             Shared library: [libgbm.so.1]
 0x0000000000000001 (NEEDED)             Shared library: [libgcc_s.so.1]
 0x0000000000000001 (NEEDED)             Shared library: [libglib-2.0.so.0]
 0x0000000000000001 (NEEDED)             Shared library: [libgsl.so.1]
 0x0000000000000001 (NEEDED)             Shared library: [libllvm-glnext.so.1]
 0x0000000000000001 (NEEDED)             Shared library: [libm.so.6]
 0x0000000000000001 (NEEDED)             Shared library: [libpropertyvault.so.0]
 0x0000000000000001 (NEEDED)             Shared library: [libstdc++.so.6]
 0x0000000000000001 (NEEDED)             Shared library: [libwayland-client.so.0]
 0x0000000000000001 (NEEDED)             Shared library: [libwayland-server.so.0]
 0x0000000000000001 (NEEDED)             Shared library: [libX11-xcb.so.1]
 0x0000000000000001 (NEEDED)             Shared library: [libxcb-image.so.0]
 0x0000000000000001 (NEEDED)             Shared library: [libxcb.so.1]
 0x0000000000000001 (NEEDED)             Shared library: [libz.so.1]
tingyikuo@P6820-PLX1:~/ssd1/repos/github.com/TingyiKuo/yocto-lab/build-qcom-wayland/tmp-glibc/sysroots-components/armv8-2a/qcom-adreno$ find -type f -name "*\.so*" 
./usr/lib/libvulkan_adreno.so.1
./usr/lib/libq3dtools_esx.so.1
./usr/lib/libeglSubDriverWayland.so.1
./usr/lib/libllvm-qcom.so.1
./usr/lib/libGLESv1_CM_adreno.so.1
./usr/lib/libOpenCL.so.1
./usr/lib/libEGL_adreno.so.1
./usr/lib/libadreno_utils.so.1
./usr/lib/libq3dtools_adreno.so.1
./usr/lib/libCB.so.1
./usr/lib/libllvm-qgl.so.1
./usr/lib/libgsl.so.1
./usr/lib/libeglSubDriverX11.so.1
./usr/lib/libOpenCL_adreno.so.1
./usr/lib/libGLESv2_adreno.so.2
./usr/lib/libllvm-glnext.so.1


## observe bazel build android sample

