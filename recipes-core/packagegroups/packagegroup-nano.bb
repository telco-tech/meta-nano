
PR = "r0"

inherit packagegroup

PACKAGES = "\
	${PN} \
	${PN}-tests \
	${PN}-benchmarks \
"
PROVIDES = "${PACKAGES}"

SUMMARY_${PN} = "ls1012a-nano board requirements"
RDEPENDS_${PN} = "\
	ppfe-firmware \
	kernel-module-pfe \
	kernel-module-i2c-ksz9897 \
"

SUMMARY_${PN}-tests = "some test tools and scripts for the ls1012a-nano board"
RDEPENDS_${PN}-tests = "\
	ls1012a-nano-hw-test-scripts \
"

RDEPENDS_${PN}-benchmarks = "\
	tiobench \
	fio \
	iperf2 \
	iperf3 \
	lmbench \
	memtester \
	tinymembench \
"
