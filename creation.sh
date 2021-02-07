#!/bin/sh

xterm -e sudo docker run --name pc -it --network b1 metabit1000/debian &

sudo docker run --name router1 -d --network b1 metabit1000/openwrtimage
sudo docker network connect b2 router1

sudo docker run --name Internet -d --network b2 metabit1000/apacheserver

sudo docker ps

gnome-terminal -- bash -c "sudo docker network inspect b1; exec bash"
gnome-terminal -- bash -c "sudo docker network inspect b2; exec bash"

