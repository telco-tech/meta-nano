#!/bin/sh

GP=/sys/class/gpio
CHIP=432
OFFS=0
CO=$((CHIP + ${OFFS}))
LEDS=3

I=0

while [ ${I} -lt $((LEDS * 2)) ]; do
	echo $((CO + ${I})) > ${GP}/export
	echo out > ${GP}/gpio$((CO + ${I}))/direction
	echo 0 > ${GP}/gpio$((CO + ${I}))/value
	I=$((I + 1))
done

I=0

while [ ${I} -lt ${LEDS} ]; do
	echo 1 > ${GP}/gpio$((CO + $((I * 2))))/value
	I=$((I + 1))
done

sleep 3

I=0

while [ ${I} -lt $((LEDS * 2)) ]; do
	V=$(cat ${GP}/gpio$((CO + ${I}))/value)
	echo $((V ^ 1)) > ${GP}/gpio$((CO + ${I}))/value
	I=$((I + 1))
done

sleep 3

I=0

while [ ${I} -lt $((LEDS * 2)) ]; do
	echo 0 > ${GP}/gpio$((CO + ${I}))/value
	echo in > ${GP}/gpio$((CO + ${I}))/direction
	echo $((CO + ${I})) > ${GP}/unexport
	I=$((I + 1))
done

exit 0
