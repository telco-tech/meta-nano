DESCRIPTION = "Some Scripts to test parts of the ls1012a-nano board"
SECTION = "develop"
PR = "r0"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COREBASE}/meta/COPYING.MIT;md5=3da9cfbcb788c80a0384361b4de20420"

SRC_URI = "\
	file://led.sh \
	file://button.sh \
"

do_install() {
	TDIR=${D}${libexecdir}/test

	install -d ${TDIR}

	install -m 0755 ${WORKDIR}/led.sh ${TDIR}/
	install -m 0755 ${WORKDIR}/button.sh ${TDIR}/
}

FILES:${PN} += "*"
