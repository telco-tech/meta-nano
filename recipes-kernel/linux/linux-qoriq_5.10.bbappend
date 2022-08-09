FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:${THISDIR}/${P}:"

INITRAMFS_IMAGE = "ls1012anano-install"

# KZS9897 Drivers:
#   https://github.com/Microchip-Ethernet/EVB-KSZ9477

SRC_URI += "\
	file://fsl-pfe_02_fix_eth_priv_vs_gemac_num.patch \
	file://fsl-pfe_03_fix_rx_desc_count.patch \
	file://fsl-pfe_04_fix_of_gemac_child.patch \
	file://ksz9897_01_v1.2.3.patch \
	file://ksz9897_04_of_property.patch \
	file://ksz9897_07_sgmii_phy_mode.patch \
	file://ksz9897_08_skb_append_datato_frags_reimp.patch \
	file://dp83867_add_dt_led_setup.patch \
	file://dp83867_add_pwdn_pin_devicetree_parameter.patch \
	file://fix_fsl_1012a_dtsi_usb0.patch \
	file://fsl_1012a_dtsi_usb0_clocks.patch \
	file://ls1012anano_dts.patch \
	file://ls1012anano.cfg \
"

DELTA_KERNEL_DEFCONFIG:append = "ls1012anano.cfg"
