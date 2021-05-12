#!/bin/sh

interface=$1
RES=`sshpass -p "openwrt" ssh root@10.0.4.2 '../scripts/check_route_'"$interface"'.sh'`

if [ "$RES" = "0" ]; then
	echo "The route on "$interface" is ok"
	exit 0
elif [ "$RES" = "2" ]; then 
	echo "The route on "$interface" has fallen"
	exit 2
else 
	echo "UNKNOWN"
	exit 3
fi
