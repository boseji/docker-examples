#!/bin/sh
docker run --rm -it -p 8080:8080 -v $(pwd)/src:/go/src/app/src go-docker-dev bash