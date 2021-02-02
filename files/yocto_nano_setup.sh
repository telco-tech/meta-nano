#!/bin/sh

# Branches: yocto bitbake
YBRANCH=dunfell
BBRANCH=1.46

# yocto core
# http://www.openembedded.org/wiki/OE-Core_Standalone_Setup

if [ ! -d .git ]; then
	git init || exit 1
	git remote add origin git://git.openembedded.org/openembedded-core || exit 1
	git fetch || exit 1

	git checkout ${YBRANCH} || exit 1
fi

if [ ! -d bitbake ]; then
	git clone git://git.openembedded.org/bitbake bitbake || exit 2

	git -C bitbake checkout ${BBRANCH} || exit 2
fi

# meta-openembedded
if [ ! -d meta-openembedded ]; then
	git clone git://git.openembedded.org/meta-openembedded || exit 3

	git -C meta-openembedded checkout ${YBRANCH} || exit 3
fi

# meta-freescale
if [ ! -d meta-freescale ]; then
	git clone git://git.yoctoproject.org/meta-freescale || exit 4

	git -C meta-freescale checkout ${YBRANCH} || exit 4
fi

# mata-nano & meta-freescale in die bblayers.conf.sample eintragen
[ $(grep -c meta-nano meta/conf/bblayers.conf.sample) -eq 0 ] \
	&& sed -i \
		-e '/meta/a\  ##OEROOT##/meta-nano \\' \
		-e '/meta/a\  ##OEROOT##/meta-freescale \\' \
		-e '/meta/a\  ##OEROOT##/meta-openembedded\/meta-python \\' \
		-e '/meta/a\  ##OEROOT##/meta-openembedded\/meta-networking \\' \
		-e '/meta/a\  ##OEROOT##/meta-openembedded\/meta-oe \\' \
		meta/conf/bblayers.conf.sample

echo -e "\n\n"
echo "Die naechsten Schritte:"
echo "  cd oe-core"
echo "  export MACHINE=ls1012anano"
echo "  source ./oe-init-build-env"
echo "  bitbake linux-qoriq"

echo ""
A=y
read -p "Ausfuehren? [Y/n]:" A

if [ -n "${A}" -a "${A}" != "y" -a "${A}" != "Y" ]; then
	exit 0
fi

cd oe-core
export MACHINE=ls1012anano
. ./oe-init-build-env
bitbake linux-qoriq openocd-native nano-image
bitbake build-sysroots

exit 0
