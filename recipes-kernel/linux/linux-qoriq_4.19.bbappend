FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:${THISDIR}/${P}:"

INITRAMFS_IMAGE = "ls1012anano-install"

# KZS9897 Drivers:
#   https://github.com/Microchip-Ethernet/EVB-KSZ9477

# ksz9897_08_single_led_mode
#   DS80000759C page 13 - LEDx_0 in Single-LED Mode does not indicate link activity

SRC_URI += "\
	file://fsl-pfe_01_fix_second_serdes_setup.patch;apply=no \
	file://fsl-pfe_02_fix_eth_priv_vs_gemac_num.patch \
	file://fsl-pfe_03_fix_rx_desc_count.patch \
	file://fsl-pfe_04_fix_of_gemac_child.patch \
	file://ksz9897_01_v1.2.2.patch \
	file://ksz9897_02_ptp_clock.patch \
	file://ksz9897_03_fix_i2c.patch;apply=no \
	file://ksz9897_04_of_property.patch \
	file://ksz9897_05_i2c_wrreg_size.patch \
	file://ksz9897_06_phy_id_vs_port_id.patch \
	file://ksz9897_07_sgmii_phy_mode.patch \
	file://ksz9897_08_single_led_mode.patch;apply=no \
	file://dp83867_add_dt_led_setup.patch \
	file://ls1012anano_dts.patch \
	file://ls1012anano.cfg \
	\
	file://fix_config_ahci_qoriq.patch;apply=no \
"

DELTA_KERNEL_DEFCONFIG_append = "ls1012anano.cfg"
