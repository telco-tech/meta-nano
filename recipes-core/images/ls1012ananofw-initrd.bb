DESCRIPTION = "Small image capable of booting a device."

LICENSE = "MIT"

IMAGE_FSTYPES = "cpio.gz"
IMAGE_LINGUAS = ""
IMAGE_FEATURES = "debug-tweaks"

PACKAGE_INSTALL = "\
	packagegroup-core-boot \
	dropbear \
	${VIRTUAL-RUNTIME_base-utils} \
	udev \
	base-passwd \
	${ROOTFS_BOOTSTRAP_INSTALL} \
	kernel-modules \
	ppfe-firmware \
"

inherit core-image

do_fix_named_link() {
	# fix for class kernel-itbimage

	[ ! -e ${DEPLOY_DIR_IMAGE}/${PN}-${MACHINE}.cpio.gz ] \
		&& ln -sf ${IMAGE_NAME}.rootfs.cpio.gz ${DEPLOY_DIR_IMAGE}/${PN}-${MACHINE}.cpio.gz

}

IMAGE_POSTPROCESS_COMMAND += "do_fix_named_link;"
