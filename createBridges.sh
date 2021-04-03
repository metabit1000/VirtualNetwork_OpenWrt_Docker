#!/bin/sh

#sudo systemctl restart docker #restart docker daemon

echo "Creating bridge networks..."

echo "Private IPs:"

docker network create --driver=bridge --subnet=10.0.1.0/24 --ip-range=10.0.1.0/24 --gateway=10.0.1.5 b1

docker network create --driver=bridge --subnet=10.0.2.0/24 --ip-range=10.0.2.0/24 --gateway=10.0.2.5 b2

docker network create --driver=bridge --subnet=10.0.3.0/24 --ip-range=10.0.3.0/24 --gateway=10.0.3.5 b3

docker network create --driver=bridge --subnet=10.0.4.0/24 --ip-range=10.0.4.0/24 --gateway=10.0.4.5 b4

docker network create --driver=bridge --subnet=10.0.5.0/24 --ip-range=10.0.5.0/24 --gateway=10.0.5.5 b5

echo ""


echo "Public IPs:"

docker network create --driver=bridge --subnet=63.45.6.0/24 --ip-range=63.45.6.0/24 --gateway=63.45.6.5 b6

docker network create --driver=bridge --subnet=63.45.7.0/24 --ip-range=63.45.7.0/24 --gateway=63.45.7.5 b7

docker network create --driver=bridge --subnet=63.45.8.0/24 --ip-range=63.45.8.0/24 --gateway=63.45.8.5 b8

echo ""

docker network ls



