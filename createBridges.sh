#!/bin/sh

sudo systemctl restart docker

docker network create -d bridge b1

docker network create -d bridge b2
