#!/bin/sh

docker run --name some-postgres -v "$(pwd)/"data:/var/lib/postgresql/data \
-e POSTGRES_PASSWORD=password -d postgres:10

## Optional Command for User Mapping of local to internal Docker 
##    HAS SECURITY RISK

# docker run --name some-postgres -v "$(pwd)/"data:/var/lib/postgresql/data \
# --user "$(id -u):$(id -g)" -v /etc/passwd:/etc/passwd:ro \
# -e POSTGRES_PASSWORD=password -d postgres:10