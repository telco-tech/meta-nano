FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

SRC_URI += "\
	file://01_nanofw_board.patch \
	file://02_efi_select_emmc_user_data_part.patch \
"