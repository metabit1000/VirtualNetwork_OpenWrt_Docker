#!/bin/sh

echo "Creating virtual network..."

#pc with debian
xterm -e docker run --name pc -it --rm --cap-add=NET_ADMIN --network b1 metabit1000/debian &

#DMZ
docker run --name droppyDMZ -d --rm --network b2 silverwind/droppy

#Nagios

#FW
docker run --name FW -d --rm --network b1 metabit1000/fwrouter
docker network connect b2 FW
docker network connect b4 FW

#MW
docker run --name MW -d --rm --network b5 metabit1000/mwrouter
docker network connect b4 MW

#R1
docker run --name R1 -d --rm --network b6 metabit1000/r1router
docker network connect b5 R1

#R2
docker run --name R2 -d --rm --network b7 metabit1000/r2router
docker network connect b5 R2

#ISP1
docker run --name ISP1 -d --rm --network b8 metabit1000/isp1router
docker network connect b6 ISP1

#ISP2
docker run --name ISP2 -d --rm --network b8 metabit1000/isp2router
docker network connect b7 ISP2

#debian with a apache server (Internet)
docker run --name Internet -d --rm --cap-add=NET_ADMIN --network b8 -v "$PWD/serverContent":/usr/local/apache2/htdocs/ metabit1000/apacheserver

#showing useful info
docker ps -a

#Setting the default route correctly of Internet and pc
docker exec -t pc /bin/bash -c "./configDefaultRoute.sh"
docker exec -t Internet /bin/bash -c "./configDefaultRoute.sh"

#menu...
