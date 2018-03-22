#!/bin/sh

docker run --name some-postgres -v "$(pwd)/"data:/var/lib/postgresql/data \
--user "$(id -u):$(id -g)" -v /etc/passwd:/etc/passwd:ro \
-e POSTGRES_PASSWORD=password -d postgres:10

echo "Staring Adminer on Port localhost:1080"

docker run --name adminer --link some-postgres:db \
-p 1080:8080 adminer:4

##