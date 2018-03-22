#!/bin/sh

docker run --name some-mongo -v "$(pwd)/"data:/data/db \
-d mongo:3.6 --auth