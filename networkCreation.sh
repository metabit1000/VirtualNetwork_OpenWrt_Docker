#!/bin/sh

echo "Creating virtual network..."

#pc with debian
xterm -e docker run --name pc -e DISPLAY=$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix -it --rm --cap-add=NET_ADMIN --network b1 metabit1000/debian &

#DMZ
docker run --name droppyDMZ -d --rm -p 8989:8989 --cap-add=NET_ADMIN --network b2 metabit1000/droppy
docker cp serverContent/file1.txt droppyDMZ:/files/file1.txt #file d'exemple

#Nagios
docker run --name nagios -d --rm -p 25 -p 80:80 --network b3 quantumobject/docker-nagios

#FW
docker run --name FW -d --rm --cap-add=NET_ADMIN --network b1 metabit1000/fwrouter
docker network connect b2 FW
docker network connect b4 FW
docker network connect b3 FW

#MW
docker run --name MW -d --rm --cap-add=NET_ADMIN --privileged --network b4 metabit1000/mwrouter1
docker network connect b5.1 MW
docker network connect b5.2 MW

#R1 #cambiar...
docker run --name R1 -d --rm --cap-add=NET_ADMIN --network b6 metabit1000/r1router
docker network connect b5.1 R1

#R2 #cambiar...
docker run --name R2 -d --rm --cap-add=NET_ADMIN --network b7 metabit1000/r2router
docker network connect b5.2 R2

#ISP1
docker run --name ISP1 -d --rm --cap-add=NET_ADMIN --network b8 metabit1000/isp1router
docker network connect b6 ISP1

#ISP2
docker run --name ISP2 -d --rm --cap-add=NET_ADMIN --network b8 metabit1000/isp2router
docker network connect b7 ISP2

#debian with a apache server (Internet)
docker run --name Internet -e DISPLAY=$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix -d --rm --cap-add=NET_ADMIN --network b8 -v "$PWD/serverContent":/usr/local/apache2/htdocs/ metabit1000/apacheserver

#showing useful info
echo ''
echo "Info of the running Docker containers:"
docker ps -a
echo ''

#Setting the default route correctly of Internet, pc and the file server.
echo "Routing table of the pc:"
docker exec -t pc /bin/bash -c "./configDefaultRoute.sh"
echo ''
echo "Routing table of the Internet server:"
docker exec -t Internet /bin/bash -c "./configDefaultRoute.sh"
echo ''
echo "Routing table of the file server:"
docker exec -t droppyDMZ /bin/ash -c "./configDefaultRoute.sh"
docker exec -t droppyDMZ /bin/ash -c "/etc/init.d/sshd restart" > /dev/null #ssh settings

docker exec -t MW /bin/ash -c "mwan3 stop" > /dev/null
docker exec -t MW /bin/ash -c "ip route del default"
docker exec -t MW /bin/ash -c "ip route del default"
docker exec -t MW /bin/ash -c "ip route add default via 10.5.1.2 metric 10"
docker exec -t MW /bin/ash -c "ip route add default via 10.5.2.2 metric 20"
docker exec -t MW /bin/ash -c "sysctl -w net.ipv4.conf.eth1.rp_filter=0"
docker exec -t MW /bin/ash -c "sysctl -w net.ipv4.conf.eth2.rp_filter=0"

#Portainer to get info of the containers using a web interface
docker run --name Portainer -d -p 9000:9000 -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data portainer/portainer

#menu...
#display images/estructura.png &
#docker exec -t Internet /bin/bash -c "firefox" &

