#!/bin/sh
docker run --rm -v "$PWD"/src:/usr/src/myapp -w /usr/src/myapp golang:1.8 go build -v
mv src/myapp .