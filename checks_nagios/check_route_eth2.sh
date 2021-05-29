#!/bin/sh

RES=`ping -c 1 63.45.7.2 | awk '/packets received/ {print $4}'`

if [ "$RES" == "1" ]; then
        echo 0
else
        echo 2
fi
