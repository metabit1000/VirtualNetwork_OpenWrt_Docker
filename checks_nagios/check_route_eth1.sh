#!/bin/sh

RES=`ping -c 1 -I eth1 63.45.8.3 | awk '/packets received/ {print $4}'`

if [ "$RES" -ne "1" ]; then
	echo 2
else 
	echo 0
fi
