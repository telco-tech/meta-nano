FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:${THISDIR}/${P}:"

SRC_URI += "\
	file://01_nano_board.patch \
	file://02_efi_select_emmc_user_data_part.patch \
	file://03_disable-unneeded-messages.patch \
"
