#!/bin/sh

#sudo systemctl restart docker #restart docker daemon

echo "Removing bridge networks..."
for n in $(seq 1 8)
do
  docker network rm b${n}
done

docker network rm b5.1
docker network rm b5.2

docker network ls
