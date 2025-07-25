# Patches for documentation of DT bindings.
FILESEXTRAPATHS:prepend := "${THISDIR}/dt-bindings:"

SRC_URI:append = " \
    file://qcs6490/0001-dt-bindings-phy-Add-QMP-UFS-PHY-comptible-for-SC7280.patch \
    file://qcs6490/0001-dt-bindings-arm-qcom-Add-QCM6490-Fairphone-5.patch \
    file://qcs6490/0001-dt-bindings-arm-qcom-Add-QCM6490-IDP-and-QCS6490-RB3.patch \
    file://qcs9100/0001-UPSTREAM-dt-bindings-remoteproc-qcom-sa8775p-pas-Doc.patch \
    file://qcs9100/0002-FROMLIST-dt-bindings-mailbox-qcom-ipcc-Add-GPDSP0-an.patch \
    file://qcs9100/0001-FROMLIST-dt-bindings-arm-qcom-ids-add-SoC-ID-for-QCS.patch \
    file://qcs9100/0003-FROMLIST-dt-bindings-arm-qcom-Document-QCS9100-compa.patch \
    file://qcs9100/0003-BACKPORT-dt-bindings-cache-qcom-llcc-Add-SA8775p-des.patch \
    file://qcs9100/0001-UPSTREAM-dt-bindings-crypto-qcom-prng-document-that-.patch \
    file://qcs9100/0001-BACKPORT-dt-bindings-firmware-qcom-scm-add-memory-re.patch \
    file://qcs9100/0001-FROMLIST-dt-bindings-clock-qcom-Add-SA8775P-video-cl.patch \
    file://qcs9100/0002-FROMLIST-dt-bindings-clock-qcom-Add-SA8775P-camera-clock-cont.patch \
    file://qcs9100/0003-FROMLIST-dt-bindings-clock-qcom-Add-SA8775P-display-clock-con.patch \
    file://common/0001-FROMLIST-dt-bindings-media-Add-video-support-for-QCO.patch \
    file://qcs9100/0005-QCLINUX-Revert-FROMLIST-dt-bindings-mailbox-qcom-ipc.patch \
    file://qcs9100/0001-UPSTREAM-dt-bindings-misc-qcom-fastrpc-increase-the-.patch \
    file://qcs9100/0002-UPSTREAM-dt-bindings-mailbox-qcom-ipcc-Add-GPDSP0-an.patch \
    file://qcs9100/0003-FROMLIST-dt-bindings-misc-qcom-fastrpc-document-new-.patch \
    file://qcs9100/0005-UPSTREAM-dt-bindings-display-msm-Document-MDSS-on-X1.patch \
    file://qcs9100/0006-UPSTREAM-dt-bindings-phy-qcom-edp-Add-X1E80100-PHY-c.patch \
    file://qcs9100/0001-UPSTREAM-regulator-dt-bindings-describe-the-PMU-modu.patch \
    file://qcs9100/0002-UPSTREAM-dt-bindings-net-wireless-qcom-ath11k-descri.patch \
    file://qcs9100/0004-FROMLIST-dt-bindings-mfd-qcom-tcsr-Add-compatible-fo.patch \
    file://qcs9100/0002-FROMGIT-dt-bindings-arm-qcom-add-sa8775p-ride-Rev-3.patch \
    file://qcs9100/0008-Revert-FROMLIST-dt-bindings-arm-qcom-Document-QCS910.patch \
    file://qcs9100/0009-FROMLIST-BACKPORT-dt-bindings-arm-qcom-Document-qcs9.patch \
    file://qcs9100/0001-FROMGIT-regulator-dt-bindings-describe-the-PMU-modul.patch \
    file://qcs9100/0002-FROMGIT-regulator-dt-bindings-qcom-qca6390-pmu-fix-t.patch \
    file://qcs9100/0003-FROMGIT-regulator-dt-bindings-qcom-qca6390-pmu-docum.patch \
    file://qcs9100/0004-FROMGIT-regulator-dt-bindings-qcom-qca6390-pmu-docum.patch \
    file://qcs9100/0001-FROMGIT-dt-bindings-crypto-qcom-qce-document-the-SA8.patch \
    file://qcs615/0001-FROMLIST-dt-bindings-nvmem-qfprom-Add-compatible-for.patch \
    file://qcs615/0002-FROMLIST-dt-bindings-mfd-qcom-tcsr-Add-compatible-fo.patch \
    file://qcs615/0003-FROMLIST-dt-bindings-watchdog-Document-Qualcomm-QCS6.patch \
    file://qcs615/0004-FROMGIT-dt-bindings-pinctrl-document-the-QCS615-Top-.patch \
    file://qcs615/0005-FROMLIST-dt-bindings-qcom-pdc-document-QCS615-Power-.patch \
    file://qcs615/0006-FROMLIST-dt-bindings-arm-qcom-document-QCS615-and-th.patch \
    file://qcs615/0007-FROMLIST-dt-bindings-arm-qcom-ids-add-SoC-ID-for-QCS.patch \
    file://qcs615/0008-FROMLIST-dt-bindings-clock-qcom-rpmhcc-Add-RPMHCC-bi.patch \
    file://qcs615/0009-FROMLIST-dt-bindings-clock-qcom-Add-QCS615-GCC-clock.patch \
    file://qcs615/0010-FROMLIST-dt-bindings-interconnect-document-the-RPMh-.patch \
    file://qcs615/0012-FROMGIT-dt-bindings-power-qcom-rpmpd-document-qcs615.patch \
    file://qcs615/0001-FROMLIST-dt-bindings-firmware-qcom-scm-document-QCS6.patch \
    file://qcs615/0002-FROMLIST-dt-bindings-arm-smmu-document-QCS615-APPS-S.patch \
    file://qcs615/0001-BACKPORT-FROMLIST-dt-bindings-cache-qcom-llcc-Docume.patch \
    file://qcs8300/0001-FROMLIST-dt-bindings-phy-Add-QMP-UFS-PHY-compatible-.patch \
    file://qcs8300/0002-FROMLIST-dt-bindings-remoteproc-qcom-sa8775p-pas-Doc.patch \
    file://qcs8300/0003-FROMGIT-dt-bindings-arm-smmu-Add-compatible-for-QCS8.patch \
    file://qcs8300/0004-FROMGIT-dt-bindings-ufs-qcom-Document-the-QCS8300-UF.patch \
    file://qcs8300/0005-FROMGIT-dt-bindings-mailbox-qcom-ipcc-Document-QCS83.patch \
    file://qcs8300/0006-FROMLIST-dt-bindings-nvmem-qfprom-Add-compatible-for.patch \
    file://qcs8300/0007-FROMGIT-dt-bindings-mfd-qcom-tcsr-Add-compatible-for.patch \
    file://qcs8300/0008-FROMGIT-dt-bindings-power-qcom-rpmpd-document-qcs830.patch \
    file://qcs8300/0010-FROMLIST-dt-bindings-interconnect-qcom-bwmon-Documen.patch \
    file://qcs8300/0011-FROMLIST-dt-bindings-qcom-pdc-document-QCS8300-Power.patch \
    file://qcs8300/0012-FROMLIST-dt-bindings-firmware-qcom-scm-document-SCM-.patch \
    file://qcs8300/0013-FROMLIST-dt-bindings-soc-qcom-add-qcom-qcs8300-imem-.patch \
    file://qcs8300/0014-FROMLIST-dt-bindings-soc-qcom-aoss-qmp-Document-the-.patch \
    file://qcs8300/0015-FROMLIST-dt-bindings-pinctrl-describe-qcs8300-tlmm.patch \
    file://qcs8300/0018-FROMLIST-dt-bindings-clock-qcom-Add-GCC-clocks-for-Q.patch \
    file://qcs8300/0020-FROMLIST-dt-bindings-interconnect-document-the-RPMh-.patch \
    file://qcs8300/0023-FROMLIST-dt-bindings-arm-qcom-document-QCS8300-SoC-a.patch \
    file://qcs615/0001-UPSTREAM-dt-bindings-phy-migrate-QMP-USB-PHY-binding.patch \
    file://qcs615/0002-BACKPORT-dt-bindings-phy-qcom-msm8998-qmp-usb3-phy-s.patch \
    file://qcs615/0003-UPSTREAM-dt-bindings-phy-qcom-msm8998-qmp-usb3-phy-s.patch \
    file://qcs615/0004-UPSTREAM-dt-bindings-phy-qcom-msm8998-qmp-usb3-phy-a.patch \
    file://qcs615/0005-UPSTREAM-dt-bindings-phy-qcom-msm8998-qmp-usb3-phy-s.patch \
    file://qcs615/0006-FROMLIST-dt-bindings-phy-qcom-msm8998-qmp-usb3-phy-A.patch \
    file://qcs615/0001-BACKPORT-dt-bindings-usb-qcom-dwc3-adjust-number-of-.patch \
    file://qcs615/0002-BACKPORT-dt-bindings-usb-dwc3-Clean-up-hs_phy_irq-in.patch \
    file://qcs615/0003-FROMLIST-dt-bindings-usb-qcom-dwc3-Add-QCS615-to-USB.patch \
    file://qcs615/0001-FROMLIST-dt-bindings-phy-qcom-qusb2-Add-bindings-for.patch \
    file://qcs615/0001-FROMLIST-dt-bindings-phy-Add-QMP-UFS-PHY-comptible-f.patch \
    file://qcs615/0002-FROMLIST-dt-bindings-ufs-qcom-Add-UFS-Host-Controlle.patch \
    file://qcs615/0002-FROMLIST-dt-bindings-net-qcom-ethqos-add-description.patch \
    file://qcs615/0001-BACKPORT-dt-bindings-mmc-Add-sdhci-compatible-for-QCS615.patch \
    file://qcs9100/0001-UPSTREAM-dt-bindings-display-msm-document-the-SM8650.patch \
    file://qcs9100/0002-UPSTREAM-dt-bindings-display-msm-Document-the-DPU-fo.patch \
    file://qcs9100/0003-FROMLIST-dt-bindings-display-msm-Document-MDSS-on-SA.patch \
    file://qcs9100/0004-FROMLIST-dt-bindings-display-msm-Document-the-DPU-fo.patch \
    file://qcs9100/0001-FROMLIST-dt-bindings-phy-Add-eDP-PHY-compatible-for-.patch \
    file://qcs9100/0004-FROMLIST-dt-bindings-display-msm-dp-controller-docum.patch \
    file://qcs8300/0001-UPSTREAM-dt-bindings-cache-qcom-llcc-Document-the-QC.patch \
    file://qcs9100/0002-FROMLIST-dt-bindings-display-msm-gmu-Add-Adreno-663-.patch \
    file://qcs8300/0001-UPSTREAM-dt-bindings-usb-qcom-dwc3-Add-QCS8300-to-US.patch \
    file://qcs8300/0002-UPSTREAM-dt-bindings-phy-qcom-usb-snps-femto-v2-Add-.patch \
    file://qcs8300/0003-UPSTREAM-dt-bindings-phy-qcom-sc8280xp-qmp-usb3-uni-.patch \
    file://common/0001-dt-bindings-power-reset-ref-reboot-mode-in-syscon-re.patch \
    file://common/0002-BACKPORT-dt-bindings-power-reset-Convert-mode-.-prop.patch \
    file://common/0003-FROMLIST-dt-bindings-arm-Document-reboot-mode-magic.patch \
    file://qcs8300/0001-FROMLIST-dt-bindings-watchdog-Document-Qualcomm-QCS8.patch \
    file://qcs615/0003-FROMLIST-dt-bindings-clock-Add-Qualcomm-QCS615-Camer.patch \
    file://qcs615/0005-FROMLIST-dt-bindings-clock-Add-Qualcomm-QCS615-Displ.patch \
    file://qcs615/0007-FROMLIST-dt-bindings-clock-Add-Qualcomm-QCS615-Graph.patch \
    file://qcs615/0009-FROMLIST-dt-bindings-clock-Add-Qualcomm-QCS615-Video.patch \
    file://qcs615/0001-FROMLIST-dt-bindings-mailbox-qcom-apcs-kpss-global-D.patch \
    file://qcs615/0002-FROMLIST-dt-bindings-aoss-qcom-Document-the-qcs615-A.patch \
    file://qcs6490/0002-UPSTREAM-dt-bindings-remoteproc-qcom-sc7180-pas-Add-.patch \
    file://qcs6490/0003-UPSTREAM-dt-bindings-remoteproc-qcom-sc7180-pas-Fix-.patch \
    file://qcs6490/0006-UPSTREAM-dt-bindings-remoteproc-qcom-sc7180-pas-Add-.patch \
    file://qcs615/0001-FROMLIST-dt-bindings-phy-qcom-sc8280xp-qmp-pcie-phy-.patch \
    file://qcs615/0003-FROMLIST-dt-bindings-PCI-qcom-Document-the-QCS615-PC.patch \
    file://qcs615/0001-FROMLIST-dt-bindings-display-msm-Add-SM6150-DSI-phy.patch \
    file://qcs615/0002-FROMLIST-dt-bindings-display-msm-dsi-controller-main.patch \
    file://qcs615/0003-FROMLIST-dt-bindings-display-msm-Add-SM6150-MDSS-DPU.patch \
    file://qcs615/0001-FROMLIST-dt-bindings-qcom-qcs615-venus-add-support-f.patch \
    file://common/0004-UPSTREAM-dt-bindings-Document-Marvell-Aquantia-PHY.patch \
    file://common/0031-UPSTREAM-dt-bindings-net-phy-Make-LED-active-low-pro.patch \
    file://common/0032-UPSTREAM-dt-bindings-net-phy-Document-LED-inactive-h.patch \
    file://common/0034-UPSTREAM-dt-bindings-net-Document-QCA808x-PHYs.patch \
    file://qcs615/0001-FROMLIST-dt-bindings-net-qcom-ethqos-revise-descript.patch \
    file://qcs615/0002-FROMLIST-dt-bindings-net-snps-dwmac-add-description-.patch \
    file://qcs8300/0001-FROMLIST-dt-bindings-crypto-qcom-prng-document-QCS83.patch \
    file://qcs8300/0001-FROMLIST-dt-bindings-crypto-qcom-qce-document-the-QC.patch \
    file://qcs8300/0001-FROMLIST-dt-bindings-dma-qcom-gpi-Add-QCS8300-compat.patch \
    file://qcs615/0001-FROMLIST-dt-bindings-display-msm-Document-DP-on-QCS6.patch \
    file://qcs615/0002-FROMLIST-dt-bindings-phy-qcom-msm8998-qmp-usb3-phy-A.patch \
    file://qcs9100/0001-dt-bindings-arm-qcom-ids-add-SoC-ID-for-QCS9075.patch \
    file://qcs9100/0003-dt-bindings-arm-qcom-Document-rb8-ride-ride-r3-on.patch \
    file://qcs615/0001-FROMGIT-dt-bindings-arm-smmu-document-QCS615-GPU-SMMU.patch \
    file://qcs615/0001-FROMLIST-dt-bindings-interconnect-qcom-bwmon-Documen.patch \
    file://qcs615/0001-FROMLIST-dt-bindings-display-msm-gpu-Document-A612-G.patch \
    file://qcs615/0002-FROMLIST-dt-bindings-display-msm-gmu-Document-RGMU.patch \
    file://qcs8300/0001-FROMLIST-dt-bindings-clock-qcom-Add-GPU-clocks-for-Q.patch \
    file://qcs8300/0003-FROMLIST-dt-bindings-clock-qcom-Add-CAMCC-clocks-for.patch \
    file://qcs8300/0005-FROMLIST-dt-bindings-clock-qcom-Add-QCS8300-video-cl.patch \
    file://qcs615/0001-FROMLIST-dt-bindings-net-stmmac-Tune-rx-sampling-occ.patch \
    file://qcs615/0001-FROMLIST-dt-bindings-pinctrl-qcom-correct-gpio-range.patch \
    file://qcs8300/0001-FROMLIST-dt-bindings-crypto-ice-document-the-qcs8300.patch \
    file://qcs8300/0001-FROMLIST-dt-bindings-display-msm-Document-the-DPU-fo.patch \
    file://qcs8300/0002-FROMLIST-dt-bindings-display-msm-Document-the-dp-con.patch \
    file://qcs8300/0003-FROMLIST-dt-bindings-display-msm-Document-MDSS-on-QC.patch \
    file://qcs8300/0005-FROMLIST-dt-bindings-phy-Add-eDP-PHY-compatible-for-.patch \
    file://qcs9100/0004-PENDING-dt-bindings-iio-adc-Add-support-for-QCOM-PMI.patch \
    file://qcs9100/0005-PENDING-dt-bindings-iio-Add-ADC5-GEN3-Channel-macros.patch \
    file://qcs9100/0006-PENDING-thermal-Add-bindings-support-for-mbg-tm.patch \
    file://qcs8300/0001-dt-bindings-phy-qcom-sc8280xp-qmp-pcie-phy-Document-.patch \
    file://qcs8300/0003-dt-bindings-PCI-qcom-pcie-sa8775p-document-qcs8300.patch \
    file://qcs9100/0001-FROMLIST-dt-bindings-i2c-qcom-i2c-geni-Document-DT-p.patch \
    file://qcs9100/0002-FROMLIST-spi-dt-bindings-Document-DT-properties-for-.patch \
    file://qcs9100/0003-FROMLIST-dt-bindings-serial-Document-DT-properties-f.patch \
    file://qcs615/0001-FROMLIST-dt-bindings-crypto-qcom-prng-document-QCS615.patch \
    file://qcs615/0001-FROMLIST-dt-bindings-crypto-qcom-qce-document-the-QC615.patch \
    file://qcs8300/0003-FROMLIST-dt-bindings-display-msm-gmu-Add-Adreno-623-.patch \
    file://qcs9100/0001-FROMLIST-dt-bindings-pinctrl-qcom-Add-egpio-function.patch \
    file://qcs9100/0001-PENDING-dt-bindings-interconnect-Add-EPSS-L3-DT-bind.patch \
    file://qcs9100/0003-PENDING-ASoC-dt-bindings-qcom-Document-soundcard-com.patch \
    file://qcs9075/0001-PENDING-dt-bindings-arm-qcom-Rename-qcs9075-rb8-to-q.patch \
    "
