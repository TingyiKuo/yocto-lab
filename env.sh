#!/bin/bash

export WS="$(pwd)"
echo "WS set to $WS"

echo 

echo To build QCOM Wayland:
echo MACHINE=qcs9100-ride-sx DISTRO=qcom-wayland QCOM_SELECTED_BSP=custom source setup-environment build-qcom-wayland
echo MACHINE=qcs9100-ride-sx DISTRO=qcom-robotics-ros2-jazzy QCOM_SELECTED_BSP=custom source setup-robotics-environment build-qcom-robotics-ros2-jazzy
echo
echo To build Raspberry Pi3/Pi4
echo source ${OEROOT}/oe-init-build-env build-rpi3
echo source ${OEROOT}/oe-init-build-env build-rpi4



