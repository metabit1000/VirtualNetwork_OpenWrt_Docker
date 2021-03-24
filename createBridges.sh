#!/bin/sh

#sudo systemctl restart docker #restart docker daemon

echo "Creating bridge networks..."
for n in $(seq 1 8)
do
  docker network create -d bridge b${n}
done

docker network ls
