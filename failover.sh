#!/bin/sh

INTERVAL=10
TARGET="63.45.8.3"
PACKETS=1
USINGWAN=1 #by default wan interface is working
WANGW="10.5.1.2"
WANBGW="10.5.2.2"
WANSTATUS=`cat /sys/class/net/eth1/operstate`
WANBSTATUS=`cat /sys/class/net/eth2/operstate`

echo "Testing if there's some failover via wan..."
# while sleep $INTERVAL
# do
	# echo "Interfaces status: "	
	# echo "Wan status : $WANSTATUS"
	# echo "Wanb status : $WANBSTATUS"
	
	# RET=`ping -c $PACKETS $TARGET | awk '/packets received/ {print $4}'`
	# if [ "$RET" -ne "$PACKETS" ]; then
		# if [ "$USINGWAN" = "1" ]; then
			# ip route del default via $WANGW metric 10
			# USINGWAN=2
			# echo "Changed wan to wanb"
		# fi
	# fi
        
	# sleep $INTERVAL	
	# if [ "$USINGWAN" = "2" ]; then 
		# echo "Testing if the route via wan is up..."	
		# ip route add default via $WANGW metric 10
		# RET=`ping -c $PACKETS $TARGET | awk '/packets received/ {print $4}'`
		# if [ "$RET" = "$PACKETS" ]; then
			# USINGWAN=1
			# echo "Route fixed. Changed wanb to wan"
		# else
			# ip route del default via $WANGW metric 10
			# echo "Route not fixed."
		# fi
	# fi
# done;


while sleep $INTERVAL
do
	echo "Interfaces status: "	
	echo "Wan status : $WANSTATUS"
	echo "Wanb status : $WANBSTATUS"
	
	RET=`ping -c $PACKETS -I eth1 $TARGET | awk '/packets received/ {print $4}'`
	if [ "$RET" -ne "$PACKETS" ]; then
		if [ "$USINGWAN" = "1" ]; then
			ip route del default via $WANGW metric 10
			#uci set network.wan.metric='20'
			ip route add default via $WANGW metric 20
			USINGWAN=2
			echo "Changed wan to wanb"
		fi
	else 
		if [ "$USINGWAN" = "2" ]; then
			ip route del default via $WANGW metric 20
			#uci set network.wan.metric='10'
			ip route add default via $WANGW metric 10
			USINGWAN=1
			echo "Route fixed. Changed wanb to wan"
		fi
	fi
done;

#ubus call network.interface.wan down && ubus call network.interface.wan up

