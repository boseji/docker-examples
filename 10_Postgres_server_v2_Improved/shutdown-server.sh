#!/bin/sh

echo "Stopping the Docker Continer Instances"
docker stop some-postgres adminer
echo "Removing the Docker Containers"
docker rm -f some-postgres adminer
