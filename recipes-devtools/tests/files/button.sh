#!/bin/sh

GP=/sys/class/gpio
CHIP=432
OFFS=6
BUTTONS=2

CO=$((CHIP + ${OFFS}))

I=0

while [ ${I} -lt ${BUTTONS} ]; do
	echo $((CO + ${I})) > ${GP}/export

	GPATH=${GP}/gpio$((CO + ${I}))
	V=$(cat ${GPATH}/value)

	if [ ${V} -eq 1 ]; then
		echo "Please press and hold the button $((I + 1))"

		while : ; do
			sleep 1

			if [ $(cat ${GPATH}/value) -eq 0 ]; then
				echo "OK"
				break
			fi
		done
	else
		echo "Error: button invalid default value (button $((I + 1)) pressed ?)"
	fi

	echo $((CO + ${I})) > ${GP}/unexport
	I=$((I + 1))
done

exit 0
