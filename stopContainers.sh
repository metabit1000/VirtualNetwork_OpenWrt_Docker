#!/bin/sh

echo "Stopping Docker containers..."
docker stop pc
docker stop droppyDMZ 
docker stop nagios
docker stop FW
docker stop MW
docker stop R1
docker stop R2
docker stop ISP1
docker stop ISP2
docker stop Internet
docker stop Portainer

docker ps -a #info de los containers corriendo

