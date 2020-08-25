SUMMARY = "A small image just capable of allowing a device to boot and is suitable for some tests"

IMAGE_INSTALL = "\
	packagegroup-core-boot \
	packagegroup-nano \
	packagegroup-nano-tests \
	packagegroup-nano-benchmarks \
	packagegroup-core-ssh-dropbear \
	packagegroup-core-tools-debug \
	${CORE_IMAGE_EXTRA_INSTALL} \
"

IMAGE_LINGUAS = " "

LICENSE = "MIT"

inherit core-image

do_setup_modprobe_d() {

	mkdir -p ${IMAGE_ROOTFS}/etc/modprobe.d

	# load the ksz9897 (Switch) driver before the package engine
	echo "softdep pfe pre: kernel/drivers/net/ethernet/micrel/ksz9897/i2c-ksz9897.ko" > ${IMAGE_ROOTFS}/etc/modprobe.d/pfe.conf


	# also add an "softdep" to udev
	UDR=${IMAGE_ROOTFS}/lib/udev/rules.d/80-drivers.rules

	if [ -f ${UDR} -a $(grep -c pfe ${UDR}) -eq 0 ]; then

		sed -i '/^LABEL=\"drivers_end\"/i SUBSYSTEM==\"module\", KERNEL==\"pfe\", RUN{builtin}+=\"kmod load i2c_ksz9897\"' ${UDR}

	fi
}

IMAGE_PREPROCESS_COMMAND += "do_setup_modprobe_d;"
