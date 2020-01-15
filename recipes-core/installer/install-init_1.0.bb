DESCRIPTION = "The install_init package add files to install an image"
SECTION = "base"
PR = "r0"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COREBASE}/meta/COPYING.MIT;md5=3da9cfbcb788c80a0384361b4de20420"

INHIBIT_DEFAULT_DEPS = "1"
ALLOW_EMPTY_${PN} = "1"

SRC_URI = "\
	file://init \
	file://60boot \
"

do_install() {
	install -d ${D}
	install -m 0755 ${WORKDIR}/init ${D}

	install -d ${D}/etc/udhcpc.d
	install -m 0755 ${WORKDIR}/60boot ${D}/etc/udhcpc.d/
}

FILES_${PN} += "*"
