DESCRIPTION = "Small image capable of booting a device."

LICENSE = "MIT"

IMAGE_FSTYPES = "cpio.gz"
IMAGE_LINGUAS = ""
IMAGE_FEATURES = "debug-tweaks"

PACKAGE_INSTALL = "\
	packagegroup-core-boot \
	packagegroup-core-ssh-dropbear \
	udev \
	\
	${ROOTFS_BOOTSTRAP_INSTALL} \
	kernel-modules \
	ppfe-firmware \
	\
	util-linux-sfdisk \
	e2fsprogs-mke2fs \
	e2fsprogs-tune2fs \
	ethtool \
	iperf3 \
	tcpdump \
"

inherit core-image

do_fix_named_link() {
	# fix for class kernel-itbimage

	[ ! -e ${DEPLOY_DIR_IMAGE}/${PN}-${MACHINE}.cpio.gz ] \
		&& ln -sf ${IMAGE_NAME}.rootfs.cpio.gz ${DEPLOY_DIR_IMAGE}/${PN}-${MACHINE}.cpio.gz

}

IMAGE_POSTPROCESS_COMMAND += "do_fix_named_link;"
