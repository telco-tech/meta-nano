# append to recipes from meta-openembedded
FILESEXTRAPATHS_prepend := "${THISDIR}/${P}:${THISDIR}/${PN}:"

BBCLASSEXTEND += "native"

SRC_URI += "\
	file://fslqspi.patch \
	file://ls1012a.cfg \
"

do_install_append() {

	install -m 644 ${WORKDIR}/ls1012a.cfg ${D}${datadir}/openocd/scripts/target
}
