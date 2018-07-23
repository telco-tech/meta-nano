FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

SRC_URI += "\
	file://grub-install-emmc \
"

do_install_append() {
	install -d ${D}${bindir}
	install -m 0755 ${WORKDIR}/grub-install-emmc ${D}${bindir}/
}


pkg_postinst_grub() {
	if [ ! -x $D${base_bindir}/efibootmgr ]; then
		echo -e "#!/bin/sh\nexit 0" > $D${base_bindir}/efibootmgr
		chmod 0755 $D${base_bindir}/efibootmgr
	fi
}