#!/bin/sh

echo "Creating virtual network..."

#pc with debian
xterm -e docker run --name pc -it --rm --cap-add=NET_ADMIN --network b1 metabit1000/debian &

#DMZ
docker run --name droppyDMZ -d --rm --cap-add=NET_ADMIN --network b2 metabit1000/droppy
docker cp serverContent/file1.txt droppyDMZ:/files/file1.txt #file d'exemple

#Nagios
docker run --name nagios -d --rm -p 25 -p 80:80 --network b3 quantumobject/docker-nagios

#FW
docker run --name FW -d --rm --cap-add=NET_ADMIN --network b1 metabit1000/fwrouter
docker network connect b2 FW
docker network connect b4 FW
docker network connect b3 FW

#MW
docker run --name MW -d --rm --cap-add=NET_ADMIN --network b5 metabit1000/mwrouter
docker network connect b4 MW

#R1
docker run --name R1 -d --rm --cap-add=NET_ADMIN --network b6 metabit1000/r1router
docker network connect b5 R1

#R2
docker run --name R2 -d --rm --cap-add=NET_ADMIN --network b7 metabit1000/r2router
docker network connect b5 R2

#ISP1
docker run --name ISP1 -d --rm --cap-add=NET_ADMIN --network b8 metabit1000/isp1router
docker network connect b6 ISP1

#ISP2
docker run --name ISP2 -d --rm --cap-add=NET_ADMIN --network b8 metabit1000/isp2router
docker network connect b7 ISP2

#debian with a apache server (Internet)
docker run --name Internet -d --rm --cap-add=NET_ADMIN --network b8 -v "$PWD/serverContent":/usr/local/apache2/htdocs/ metabit1000/apacheserver

#showing useful info
echo ''
echo "Info of the running Docker containers:"
docker ps -a
echo ''

#Setting the default route correctly of Internet and pc
echo "Routing table of the pc:"
docker exec -t pc /bin/bash -c "./configDefaultRoute.sh"
echo ''
echo "Routing table of the Internet server:"
docker exec -t Internet /bin/bash -c "./configDefaultRoute.sh"
echo ''
echo "Routing table of the file server:"
docker exec -t droppyDMZ /bin/ash -c "./configDefaultRoute.sh"

#menu...
#display images/estructura.png &

