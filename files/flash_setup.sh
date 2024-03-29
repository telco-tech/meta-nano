#!/bin/bash

###
#
# You may setup variables:
# IP_INSTALL	- the ip address used by u-boot
# IP_NANO	- the ip address used by install image (may be IP_INSTALL)
# IP_SERVER	- the bootp server ip address
# IP_NETMASK	- ip netmask
#
# IMAGE_INSTALL - the install image name
# IMAGE_BASE	- the image name, to install on emmc
#
###

# bootpd or atftpd may use sbin path
[ "${PATH}" = "${PATH/sbin}" ] \
	&& PATH=$PATH:/sbin:/usr/sbin/

if [ -n "$(which openocd)" ]; then
	echo -e "Warning: found openocd in PATH. This version may not work with ls1012a cpu\n"
	A=n
	read -p "Continue? [y/N]:" A

	if [ -n "${A}" -a "${A}" != "y" -a "${A}" != "Y" ]; then
		exit 1
	fi
fi

WDIR=tmp-glibc

if [ ! -d ${WDIR} ]; then
	WDIR=build*/${WDIR}

	if [ ! -d ${WDIR} ]; then
		echo "Failed to find the yocto build directory."
		exit 1
	fi
fi

if [ -z "$(which atftpd)" ]; then
	MISSING="${MISSING}Failed to find atftpd binary - Please install atftpd package (ie. apt-get install atftpd)"
fi

if [ -z "$(which bootpd)" ]; then
	MISSING="${MISSING}Failed to find bootpd binary - Please install bootp package (ie. apt-get install bootp)"
fi

if [ -n "${MISSING}" ]; then
	echo -e "${MISSING}"
	exit 1
fi


kill_service() {
	SPID=${1}
	SNAME=${2}
	CMDLINE=$(cat /proc/${SPID}/cmdline)

	if [ "${CMDLINE}" != "${CMDLINE/${SNAME}}" ]; then
		kill ${SPID}
	fi
}

ERROR=1

trap cleanup EXIT

cleanup() {

	if [ ${ERROR} -gt 0 ]; then

		if [ -n "${PID_ATFTPD}" ]; then
			kill_service ${PID_ATFTPD} atftpd
		fi

		if [ -n "${PID_BOOTPD}" ]; then
			kill_service ${PID_BOOTPD} bootpd
		fi

		if [ -n "${BOOTPTAB}" ]; then
			rm ${BOOTPTAB}
		fi
	fi
}

# Network variables

if [ -z "${IP_SERVER}" ]; then

	IP_SERVER=$(ip addr show eth0 | sed -n '/inet /{s/.*inet \([0-9.]*\).*/\1/;p}' | head -n1)

	if [ -z "${IP_SERVER}" ]; then

		echo "Failed to get the bootpd server address - Please set the IP_SERVER environment variable"
		exit

	fi

fi

if [ -z "${IP_INSTALL}" ]; then

	H=${IP_SERVER##*.}

	[ ${H} -gt 250 ] \
		&& H=$((H - 1)) \
		|| H=$((H + 1))

	IP_INSTALL=${IP_SERVER%.*}.${H}
fi

[ -z "${IP_NANO}" ] \
	&& IP_NANO=${IP_INSTALL}

[ -z "${IP_NETMASK}" ] \
	&& IP_NETMASK=255.255.255.0

[ -z "${IMAGE_INSTALL}" ] \
	&& IMAGE_INSTALL=fitImage-ls1012anano-install-ls1012anano-ls1012anano

[ -z "${IMAGE_BASE}" ] \
	&& IMAGE_BASE=nano-image-ls1012anano.tar.gz


# atftpd setup

DRUN=

if killall -0 atftpd 2>/dev/null; then
	read -n1 -p "Restart tftp daemon? [Y/n]: " DRUN
fi

if [ -z "${DRUN}" -o "${DRUN}" = "Y" -o "${DRUN}" = "y" ]; then

	echo "Starting tftp daemon..."

	sudo atftpd --daemon ${PWD}/${WDIR}/deploy/images/ls1012anano || exit

	PID_ATFTPD=${!}

	if [ -z "${PID_ATFTPD}" ]; then
		for I in $(find /proc -maxdepth 1 -type d -name "[0-9]*"); do

			[ ! -d ${I} ] \
				&& continue

			if [ $(grep -c "^atftpd" ${I}/cmdline) -gt 0 ]; then
				PID_ATFTPD=${I##*/}
				break
			fi
		done
	fi
fi

# bootpd setup

DRUN=

if killall -0 bootpd 2>/dev/null; then
	read -n1 -p "Restart bootpd daemon? [Y/n]: " DRUN
fi

if [ -z "${DRUN}" -o "${DRUN}" = "Y" -o "${DRUN}" = "y" ]; then

	BOOTPTAB=$(tempfile)

	cat << EOF > ${BOOTPTAB}
install:\\
	:ht=ethernet:\\
	:ha=001122334455:\\
	:ip=${IP_INSTALL}:\\
	:sm=${IP_NETMASK}:\\
	:sa=${IP_SERVER}:\\
	:bf=${IMAGE_INSTALL}:

nano:\\
	:ht=ethernet:\\
	:ha=001122334456:\\
	:ip=${IP_NANO}:\\
	:sm=${IP_NETMASK}:\\
	:sa=${IP_SERVER}:\\
	:bf=${IMAGE_BASE}:
EOF

	echo "Starting bootp daemon..."

	sudo bootpd -d -s ${BOOTPTAB} &

	PID_BOOTPD=${!}
fi

ERROR=0

exit 0
