#!/bin/sh

docker run --name some-mysql -v "$(pwd)/"data:/var/lib/mysql \
--user "$(id -u):$(id -g)" -v /etc/passwd:/etc/passwd:ro \
-e MYSQL_ROOT_PASSWORD=password -d mysql:5
