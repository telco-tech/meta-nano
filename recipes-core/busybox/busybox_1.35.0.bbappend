FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SRC_URI:append = " \
	file://busybox-modprobe_add_config_dir_option.patch \
	file://busybox-modprobe_softdep.patch \
	file://network.cfg \
	file://tools.cfg \
"
