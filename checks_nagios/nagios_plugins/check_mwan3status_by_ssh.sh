#!/bin/sh

interface=$1
sub1="online"
sub2="offline"
sub3="disabled"

RES=`sshpass -p "openwrt" ssh root@10.0.4.2 '../scripts/check_mwan3status_'"$interface"'.sh'`

if [[ "$RES" == *"$sub1"* ]]; then
	echo "$RES"
	exit 0
elif [[ "$RES" == *"$sub2"* ]]; then
	echo "$RES"
	exit 2
else 
	echo "$RES"
	exit 3
fi
