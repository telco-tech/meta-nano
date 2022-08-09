
PR = "r0"

inherit packagegroup

PACKAGES = "\
	${PN} \
	${PN}-tests \
	${PN}-benchmarks \
"
PROVIDES = "${PACKAGES}"

SUMMARY:${PN} = "ls1012a-nano board requirements"
RDEPENDS:${PN} = "\
	ppfe-firmware \
	kernel-module-pfe \
	kernel-module-i2c-ksz9897 \
"

SUMMARY:${PN}-tests = "some test tools and scripts for the ls1012a-nano board"
RDEPENDS:${PN}-tests = "\
	ls1012a-nano-hw-test-scripts \
"

RDEPENDS:${PN}-benchmarks = "\
	tiobench \
	fio \
	iperf2 \
	iperf3 \
	lmbench \
	memtester \
	tinymembench \
"
