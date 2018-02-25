#!/bin/sh
[ ! -e "go-prod-docker.img" ] && ./build.sh
docker load -q -i go-prod-docker.img
docker run --rm -it -p 8080:8080 go-prod-docker ./main
echo