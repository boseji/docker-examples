# MySQL Server Instance

This project focuses on getting up and running with a Docker image of the [MySQL Database Server](https://hub.docker.com/_/mysql/).

For check out and monitoring the Database we are going to use the [Adminer](https://hub.docker.com/_/adminer/) tool. Which again is a docker container driven service that links to the database.

Here is some outline on the MySQL image:

https://github.com/boseji/dockerPlayground/blob/master/09_Mysql_server/Mysql_docker.md

And Here is some outline on the Adminer image:

https://github.com/boseji/dockerPlayground/blob/master/09_Mysql_server/adminer_docker.md

## Getting the Instance running

First pull down the correct **MySQL image**, here we are using the `mysql:5` also short for `mysql:5.7.21` at the time (21-Mar-2018).

`docker pull mysql:5`

Now we have put together a command in the script file 

**[`start-server.sh`](https://github.com/boseji/dockerPlayground/blob/master/09_Mysql_server/start-server.sh)**

```shell
docker run --name some-mysql -v "$(pwd)/"data:/var/lib/mysql \
-e MYSQL_ROOT_PASSWORD=password -d mysql:5
```

Let's try look at the command and figure out what's happening.

1. First we notice that we are creating a Named container `some-mysql` this was copied from the docs since most of the commands in the documentation use it as it is.

2. Next we are mounting a local volume `-v "$(pwd)/"data:/var/lib/mysql`. This means that under the current directory the `data` directory is mapped to `/var/lib/mysql` where typically the database is stored. This helps to keep a persistent copy of the database in the local disk.

Then, this local copy can later be reused for another container instance created. The idea is to have the container instance be temporary but the data to prevail even after the container is destroyed.

3. Next we set a *very weak* password `-e MYSQL_ROOT_PASSWORD=password`. This sets the root password for the database as an Environment Variable in the container.

4. Finally we are creating a background running daemon `-d mysql:5`

**Note :** The port from the created `some-mysql` container would always be **standard MySQL port (3306)**.

## Shell into the Instance

During the run of the server as a daemon one might want to access the server via terminal.

**[`server-shell.sh`](https://github.com/boseji/dockerPlayground/blob/master/09_Mysql_server/server-shell.sh)**

```shell
docker exec -it some-mysql bash
```

This would help to enter into a MySQL console also.

## Monitoring and Administering the Database

Apart from being able to create this container based MySQL server we also need to be able to manage, edit and maintain the server data.

For this we would use the **[`Adminer`](https://www.adminer.org/)** a single PHP script server for administration of databases.

For this we have new Shell script that would start the **Adminer** directly with the server.

**[`start-server-admin.sh`](https://github.com/boseji/dockerPlayground/blob/master/09_Mysql_server/start-server-admin.sh)**

```shell
echo "Staring Adminer on Port localhost:1080"

docker run --name adminer --link some-mysql:db \
-p 1080:8080 adminer:4
```

Here we are mapping the internal `:8080` port to an outside port `:1080` and linking it to the previously created MySQL container `some-mysql`.

## Stopping the Instance

This is provided in the script

**[`shutdown-server.sh`](https://github.com/boseji/dockerPlayground/blob/master/09_Mysql_server/shutdown-server.sh)**

```shell
docker stop some-mysql
```

This would send a `SIGTERM` / `SIGKILL` that would automatically shutdown the MySQL daemon. And hence safely stop the container.

Additionally we can remove the container by:

```shell
docker rm -f some-mysql
```
