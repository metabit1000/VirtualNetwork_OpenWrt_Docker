#!/bin/sh

#sudo systemctl restart docker #restart docker daemon

echo "Removing bridge networks..."
for n in $(seq 1 8)
do
  docker network rm b${n}
done

docker network ls
