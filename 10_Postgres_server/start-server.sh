#!/bin/sh

docker run --name some-postgres -v "$(pwd)/"data:/var/lib/postgresql/data \
--user "$(id -u):$(id -g)" -v /etc/passwd:/etc/passwd:ro \
-e POSTGRES_PASSWORD=password -d postgres:10
