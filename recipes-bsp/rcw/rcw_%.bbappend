FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

SRC_URI += "\
	file://ls1012a.rcwi \
	file://ls1012anano.rcw \
	file://ls1012anano_2xphy.rcw \
	file://ls1012anano_switch.rcw \
	file://byte_swap.tcl \
"

do_configure_prepend() {
	mkdir -p ${S}/ls1012anano/rcw

	cp ${WORKDIR}/*.rcwi ${S}/ls1012anano/
	cp ${WORKDIR}/ls1012anano.rcw ${S}/ls1012anano/
	cp ${WORKDIR}/*_*.rcw ${S}/ls1012anano/rcw/
	cp ${WORKDIR}/*.tcl ${S}/ls1012anano/rcw/

	echo "include ../Makefile.inc" > ${S}/ls1012anano/Makefile
	touch ${S}/ls1012anano/README

	sed -i '/^BOARDS/ {s/ls1012anano//;s/= /= ls1012anano /}' ${S}/Makefile
}

do_compile_append() {
	pushd ls1012anano/rcw

	for I in $(find -name "*.bin"); do
		./byte_swap.tcl ${I} ${I}.swp8 8
		mv -f ${I}.swp8 ${I}
	done

	popd
}