FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

SRC_URI += "\
	file://01_nanofw_board.patch \
	file://02_efi_select_emmc_user_data_part.patch \
	file://03_IS25WPxxx_qspi_flash_info.patch \
"
