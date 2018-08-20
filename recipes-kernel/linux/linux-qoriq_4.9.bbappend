FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:${THISDIR}/files:"

INITRAMFS_IMAGE = "ls1012ananofw-initrd"

SRC_URI += "\
	file://fsl-pfe_01_fix_second_serdes_setup.patch \
	file://fsl-pfe_02_fix_eth_priv_vs_gemac_num.patch \
	file://fsl-pfe_03_fix_rx_desc_count.patch \
	file://ksz9897_01_v1.1.9.patch \
	file://ksz9897_02_fix_and_integrate.patch \
	file://ksz9897_03_ppfe.patch \
	file://ksz9897_04_single_led_mode.patch \
	file://IS25WPxxx_qspi_flash_info.patch \
	file://dp83867_add_dt_led_setup.patch \
	file://dp83867_sysfs_register_debug.patch;apply=no \
	file://ls1012ananofw_dts.patch \
	file://ls1012ananofw.cfg \
"

DELTA_KERNEL_DEFCONFIG_append = "ls1012ananofw.cfg"