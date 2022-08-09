# append to recipes from meta-openembedded
FILESEXTRAPATHS:prepend := "${THISDIR}/${P}:${THISDIR}/${PN}:"

inherit native

SRC_URI += "\
	file://fslqspi.patch \
	file://autosetup_tool_test.patch \
	file://ls1012a.cfg \
"

do_install:append() {

	install -m 644 ${WORKDIR}/ls1012a.cfg ${D}${datadir}/openocd/scripts/target
}
