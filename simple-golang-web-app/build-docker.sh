#!/bin/sh
docker build -t go-docker-dev .
docker run --rm -it -p 8080:8080 go-docker-dev