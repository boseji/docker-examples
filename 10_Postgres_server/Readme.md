# Postgres Server Instance

Here we would create a **Postgres** Database server instance.

https://hub.docker.com/_/postgres/

And we would be using **Adminer** for database administration.

https://hub.docker.com/_/adminer/ 

## Pulling the Correct Image

`docker pull postgres:10`

This version is the same as `10.3 , 10, latest` at the time (22-Mar-2018)

## Starting the Server

We have created the script for this.

**[`start-server.sh`](https://github.com/boseji/dockerPlayground/blob/master/10_Postgres_server/start-server.sh)**

```shell
docker run --name some-postgres -v "$(pwd)/"data:/var/lib/postgresql/data \
-e POSTGRES_PASSWORD=password -d postgres:10
```

Here are the pieces of the above command:

1. We are creating a named container `some-postgres` again this is copied from the documentation as its used in multiple places.

2. Mount the Data folder: `-v "$(pwd)/"data:/var/lib/postgresql/data` for database storage

3. Setup the password for the database default user `postgres` to be *very insecure* "password". `-e POSTGRES_PASSWORD=password` 

This sets the environment variable for the password `POSTGRES_PASSWORD` used in Postgres.

**Note :** The port from the created `some-postgres` container would always be **standard Postgres port (5432)** with the default user **`postgres`** already present.

## Rest of the Container operations are similar to previous project [09_Mysql_server](https://github.com/boseji/dockerPlayground/tree/master/09_Mysql_server)

## Adminer configuration is similar to the previous project [09_Mysql_server](https://github.com/boseji/dockerPlayground/tree/master/09_Mysql_server)