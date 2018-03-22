#!/bin/sh

docker run --name some-mysql -v "$(pwd)/"data:/var/lib/mysql \
-e MYSQL_ROOT_PASSWORD=password -d mysql:5
