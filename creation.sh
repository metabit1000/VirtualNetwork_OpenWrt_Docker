#!/bin/sh

xterm -e docker run --name pc -it --rm --network b1 metabit1000/debian &

docker run --name router1 -d --rm --network b1 metabit1000/openwrtimage
docker network connect b2 router1

docker run --name Internet -d --rm --network b2 metabit1000/apacheserver

docker ps

gnome-terminal -- bash -c "docker network inspect b1; exec bash"
gnome-terminal -- bash -c "docker network inspect b2; exec bash"

