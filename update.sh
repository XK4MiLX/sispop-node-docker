#!/bin/bash
NAME=$1
NAME="${NAME:-sispop-node}"
HOST_DIR=$2
HOST_DIR="${HOST_DIR:-sispop-node}"
GIT=$3
GIT="${GIT:-xk4milx/sispop-node-docker:latest}"

docker stop $NAME
docker rm $NAME
docker pull xk4milx/sispop-node-docker:latest
docker run -d -p 22020:22020 -p 22021:22021 -p 20000:20000 -p 50000:50000 -p 1090:1090/udp --device=/dev/net/tun --cap-add=NET_ADMIN --restart=always -v /home/$USER/$HOST_DIR:/root --name $NAME $GIT
docker exec -it $NAME supervisorctl stop all
docker exec -it $NAME rm -rf /root/.sispop/lmdb
docker exec -it $NAME supervisorctl start all
