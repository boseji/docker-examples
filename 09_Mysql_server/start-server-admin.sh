#!/bin/sh

docker run --name some-mysql -v "$(pwd)/"data:/var/lib/mysql \
--user "$(id -u):$(id -g)" -v /etc/passwd:/etc/passwd:ro \
-e MYSQL_ROOT_PASSWORD=password -d mysql:5

echo "Staring Adminer on Port localhost:1080"

docker run --name adminer --link some-mysql:db \
-p 1080:8080 adminer:4