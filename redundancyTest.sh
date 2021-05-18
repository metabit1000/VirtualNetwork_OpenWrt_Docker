#!/bin/bash

TARGET="63.45.8.3"
PACKETS=1

echo "The test is going to start. Eth1 of R1 router is going to stop in order to test the failover and a timer will start. 
Please make sure that the redundancy option (mwan3, vrrp or code) is running." 
echo "Do you want to continue?(yes/no)"
read input

echo "Current route: "
docker exec -t pc /bin/bash -c "traceroute 63.45.8.3"

if [ "$input" == "yes" ]; then
	echo "Stopping eth0 interface of R1 router"
	docker exec -t R1 /bin/ash -c "ubus call network.interface.lan down"
	sleep 3
	echo "Starting timer"
	start_time="$(date -u +%s.%N)"
	RET=`docker exec -t pc /bin/bash -c "ping -c 1 -w 1 63.45.8.3 | grep -oP '\d+(?= received)'"`
	sleep 1
	echo $RET
	echo "$RET"
	while [[ $RET < 1 ]] #checking if the route has changed
	do
		RET=`docker exec -t pc /bin/bash -c "ping -c 1 -w 1 63.45.8.3 | grep -oP '\d+(?= received)'"`
		echo $RET
	done
	echo "Route changed. Backup route set."
	end_time="$(date -u +%s.%N)"
	
	elapsed="$(bc <<<"$end_time-$start_time")"
	echo "Total of $elapsed seconds elapsed (FAILOVER)"
	
	echo "Do you want to restart eth1 interface? (yes/no)"
	read input
	if [ "$input" == "yes" ]; then
		docker exec -t R1 /bin/ash -c "ubus call network.interface.lan up"
		echo "done"
	fi
fi
echo "Test finished"
