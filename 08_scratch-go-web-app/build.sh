#!/bin/sh
docker build --target builder -t builder .
docker build --target production -t go-prod-docker .
docker save --output go-prod-docker.img go-prod-docker
docker rmi builder go-prod-docker