#!/bin/sh

#pc with debian
xterm -e docker run --name pc -it --rm --cap-add=NET_ADMIN --network b1 metabit1000/debian &

#router1
docker run --name router1 -d --rm --network b1 metabit1000/openwrtimage
docker network connect b2 router1

#debian with a apache server (Internet)
#docker run --name Internet -d --rm --cap-add=NET_ADMIN --network b2 metabit1000/apacheserver

docker run --name Internet -d --rm --cap-add=NET_ADMIN --network b2 -v "$PWD/serverContent":/usr/local/apache2/htdocs/ metabit1000/apacheserver

#showing useful info
docker ps
gnome-terminal -- bash -c "docker network inspect b1; exec bash"
gnome-terminal -- bash -c "docker network inspect b2; exec bash"

#Setting the default route correctly of Internet and pc
docker exec -t pc /bin/bash -c "./configDefaultRoute.sh"
docker exec -t Internet /bin/bash -c "./configDefaultRoute.sh"
