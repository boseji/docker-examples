#!/bin/sh

docker stop some-mysql
docker stop adminer
docker rm -f some-mysql adminer