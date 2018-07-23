FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

SRC_URI += "\
	file://ls1012a.rcwi \
	file://ls1012ananofw.rcw \
	file://ls1012ananofw_2xphy.rcw \
	file://ls1012ananofw_switch.rcw \
	file://byte_swap.tcl \
"

do_configure_prepend() {
	mkdir -p ${S}/ls1012ananofw/rcw

	cp ${WORKDIR}/*.rcwi ${S}/ls1012ananofw/
	cp ${WORKDIR}/ls1012ananofw.rcw ${S}/ls1012ananofw/
	cp ${WORKDIR}/*_*.rcw ${S}/ls1012ananofw/rcw/
	cp ${WORKDIR}/*.tcl ${S}/ls1012ananofw/rcw/

	echo "include ../Makefile.inc" > ${S}/ls1012ananofw/Makefile
	touch ${S}/ls1012ananofw/README

	sed -i '/^BOARDS/ {s/ls1012ananofw//;s/= /= ls1012ananofw /}' ${S}/Makefile
}

do_compile_append() {
	pushd ls1012ananofw/rcw

	for I in $(find -name "*.bin"); do
		./byte_swap.tcl ${I} ${I}.swp8 8
		mv -f ${I}.swp8 ${I}
	done

	popd
}