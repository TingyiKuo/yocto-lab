# 使用 Yocto 打造你的 Raspberry Pi 系統


## 下載 poky 。

```
mkdir my-rpi && cd my-rpi
git clone -b hardknott git://git.yoctoproject.org/poky.git
```

## 準備 meta-raspberrypi 層
```
git clone -b hardknott git://git.yoctoproject.org/meta-raspberrypi
```

## 初始化開發環境

```
source poky/oe-init-build-env build-rpi
```

## 加入 meta-raspibary 層

```
bitbake-layers add-layer ../meta-raspberrypi
```

## 修改配置

```
 sed -i 's/^MACHINE.*/MACHINE ?= "raspberrypi3"/g' conf/local.conf
 sed -i '/^#DL_DIR ?= "${TOPDIR}\/downloads"/ a DL_DIR ?= \"${HOME}/yocto/downloads"' conf/local.conf
 sed -i 's/^PACKAGE_CLASSES.*/PACKAGE_CLASSES ?= "package_ipk"/g' conf/local.conf
 echo 'RPI_USE_U_BOOT = "1"' >> conf/local.conf
 echo 'ENABLE_UART = "1"' >> conf/local.conf
```

## 開始編譯

```
bitbake core-image-minimal
```

## 寫入 SD Card

```
 bzip -Dk core-image-minimal-raspberrypi3.wic.bz2
 sudo dd if=core-image-minimal-raspberrypi3.wic of=${SD_CARD}
 bs=40960
```

