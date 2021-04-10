#!/bin/sh

ip route del default
ip route add default via 172.xx.xx.xx

route -n
