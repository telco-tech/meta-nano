#!/bin/sh

##
#	this is an script to flash the ls1012a-nano board
#
#	USAGE: flash_nano.sh [section]
#
#	examples:
#		flash_nano.sh			: this will flash all images (MAC if set)
#		flash_nano.sh RCW		: flash only the rcw image
#		flash_nano.sh "RCW PFE"		: flash rcw image and pfe firmware
#
#	to flash the ethernet MAC addresses:
#		PFE_MAC0=00:11:22:33:44:55 PFE_MAC1=00:22:33:44:55:66 flash_nano.sh MAC
#
#	or with all other images:
#		PFE_MAC0=00:11:22:33:44:55 PFE_MAC1=00:22:33:44:55:66 flash_nano.sh
#
##

SECTIONS=${1:-"RCW MAC UBOOT PFE"}

# NOTE: must be absolute or relative to openocd working directory
IMAGE_PATH=tmp-glibc/deploy/images/ls1012anano

RCW_SECTOR_START=0
RCW_SECTOR_END=0
RCW_ADDRESS=0
RCW_FILE=rcw/ls1012anano/rcw/ls1012anano_switch.bin

MAC_SECTOR_START=4
MAC_SECTOR_END=4
MAC_ADDRESS=0x40000

UBOOT_SECTOR_START=16
UBOOT_SECTOR_END=24
UBOOT_ADDRESS=0x100000
UBOOT_FILE=u-boot-ls1012anano.bin-qspi

PFE_SECTOR_START=160
PFE_SECTOR_END=160
PFE_ADDRESS=0xa00000
PFE_FILE=engine-pfe-bin/pfe_fw_sbl.itb

#\_________________________________________/#

trap cleanup EXIT

cleanup() {
	if [ -n "${MAC_FILE}" -a -f "${MAC_FILE}" ]; then
		rm ${MAC_FILE}
	fi

	if [ -n "${PID_OPENOCD}" ]; then
		kill ${PID_OPENOCD}
	fi
}

if [ ${IMAGE_PATH:0:1} != "/" -a ! -d ${IMAGE_PATH} ]; then

	TMPDIR=$(find build* -maxdepth 1 -type d -name tmp-glibc)

	if [ -n "${TMPDIR}" ]; then
		cd ${TMPDIR%tmp-glibc}
	else
		echo "Please change directory to folder containing ${IMAGE_PATH}"
		exit 1
	fi
fi

if [ -z "${PFE_MAC0}" -a -z "${PFE_MAC1}" ]; then
	SECTIONS=${SECTIONS/MAC}

else
	MAC_FILE=$(tempfile)

	if [ -n "${PFE_MAC0}" ]; then
		echo -en $(echo -n ${PFE_MAC0} | sed 's/://g;s/\(..\)/\\x\1/g') > ${MAC_FILE}
	fi

	if [ -n "${PFE_MAC1}" ]; then
		echo -en $(echo -n ${PFE_MAC1} | sed 's/://g;s/\(..\)/\\x\1/g') >> ${MAC_FILE}
	fi
fi

PATH=${PWD}/$(find tmp-glibc/sysroots -name openocd | sed -n '/bin\/openocd/{s/\/openocd//p}'):$PATH

if [ -z "$(which openocd)" ]; then
	echo "Failed to find openocd binary (Please try: bitbake openocd-native && bitbake build-sysroots)"
	exit 1
fi

openocd -f interface/ftdi/olimex-arm-usb-ocd-h.cfg -f target/ls1012a.cfg &

PID_OPENOCD=${!}

# time for openocd to start
sleep 3

if [ ! -d /proc/${PID_OPENOCD} ]; then
	echo "Failed to start openocd (Olimex connected?)"
	unset PID_OPENOCD
	exit 1
fi

# S25FS512S - disable 4-kB Erase (CR3NV - Uniform Sector Architecture)
# TODO fslqspi read_register 0 0x04 != 0x08
(echo "halt; fslqspi write_register 0 0x04 0x08;") | telnet localhost 4444


for S in ${SECTIONS}; do

	START=$(VN=${S}_SECTOR_START; echo ${!VN})
 	END=$(VN=${S}_SECTOR_END; echo ${!VN})
	ADDR=$(VN=${S}_ADDRESS; echo ${!VN})
	FILE=$(VN=${S}_FILE; echo ${!VN})

	if [ ${FILE:0:1} != '/' ]; then
		FILE=${IMAGE_PATH}/${FILE}
	fi

	FILE_SIZE=$(stat -L -c %s ${FILE}) || exit

	(echo "halt;" \
	      "flash protect 0 ${START} ${END} off;" \
	      "flash erase_sector 0 ${START} ${END};" \
	      "fslqspi endian 0 BE32;" \
	      "flash write_bank 0 ${FILE} ${ADDR};") \
	| nc localhost 4444 \
	| while read LINE; do

		if [ "${LINE:1:5}" = "rror:" -o "${LINE:0:16}" = "Nothing to write" ]; then

			echo "Failed to write ${FILE} to ${ADDR}"
			exit 1

		else
			SUCCESS="wrote ${FILE_SIZE} bytes from file"

			if [ "${LINE:0:${#SUCCESS}}" = "${SUCCESS}" ]; then
 				NCPID=$(ps -eo pid,args | sed -n '/nc localhost 4444/{/sed/d;s/^[[:space:]]*\([0-9]*\).*/\1/;p}')
				kill ${NCPID}
			fi
		fi
	done

done

echo "+-------------------------------------------+"
echo "|                                           |"
echo "|           Write QSPI: Success             |"
echo "|                                           |"
echo "+-------------------------------------------+"

exit 0
