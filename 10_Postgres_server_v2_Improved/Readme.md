# Postgres Server Instance : Improved Version

Here we would create a **Postgres** Database server instance.

https://hub.docker.com/_/postgres/

And we would be using **Adminer** for database administration.

https://hub.docker.com/_/adminer/ 

Additionally we would be able to backup and restore the DB inside the container.
No messing with the local and guest users.

## Pulling the Correct Image

`docker pull postgres:11`

This version is the same as `11.2 , 11, latest` at the time (03-Mar-2019)

But to save space we would use the Alpine versions:

`docker pull postgres:11.2-alpine`

## Starting the Server

We have created the script for this.

**[`start-server.sh`](https://github.com/boseji/dockerPlayground/blob/master/10_Postgres_server_v2_Improved/start-server.sh)**

```shell
docker run --name some-postgres -v "$(pwd)/":/store \
-e POSTGRES_PASSWORD=password -d postgres:11.2-alpine
```

Here are the pieces of the above command:

1. We are creating a named container `some-postgres` again this is copied from the documentation as its used in multiple places.

2. Mount the Data folder: `-v "$(pwd)/":/store` Is used to backup the DB if needed.
   **Note:** Here the data is stored in the container itself no additional external
   storage. This helps to reduce the complexity and prevent loss.

3. Setup the password for the database default user `postgres` to be *very insecure* "password". `-e POSTGRES_PASSWORD=password` 

This sets the environment variable for the password `POSTGRES_PASSWORD` used in Postgres.

**Note :** The port from the created `some-postgres` container would always be **standard Postgres port (5432)** with the default user **`postgres`** already present.

## Rest of the Container operations are similar to previous project [09_Mysql_server](https://github.com/boseji/dockerPlayground/tree/master/09_Mysql_server)

## Starting with Adminer

**Postgres** can also use the standard **Adminer** package for visual database
management.

**[`start-server-admin.sh`](https://github.com/boseji/dockerPlayground/blob/master/10_Postgres_server_v2_Improved/start-server-admin.sh)**

Make sure the set the *System* as `PostgreSQL`.

The default user would be `postgres` and like said earlier `POSTGRES_PASSWORD` 
is the password.

## Adminer configuration is similar to the previous project [09_Mysql_server](https://github.com/boseji/dockerPlayground/tree/master/09_Mysql_server)

## IMPORTANT

Do no modify or add tables to **System Databases** - `postgres`, `template0` and
`template1`. Create a New Database to begin.

## Shell Instance of your ***Postgres*** server

Connect your DB instance that we named `some-postgres` earlier via shell.

**[`server-shell.sh`](https://github.com/boseji/dockerPlayground/blob/master/10_Postgres_server_v2_Improved/server-shell.sh)**

```docker
docker exec -it some-postgres sh
```

Its important to note that in-order to run some special commands 
such as `pg_dumpall` (backup - covered next) you need `sudo` privilege.
This would be typically to the Admin user like `postgres`

```shell
sudo su - postgres
```

or for Alpine:

```shell
su - postgres
```

Then you can use the special commands.

Some more notes explaining about ERROR:

`pg_dumpall: could not connect to database "template1": FATAL:  role "root" does not exist`

**[FIX-OWNER-ERROR-POSTGRES.md](https://github.com/boseji/dockerPlayground/blob/master/10_Postgres_server_v2_Improved/FIX-OWNER-ERROR-POSTGRES.md)**

## Backup DB

Similar to the earlier way to enter the shell we can run some commands:
**Note:** that while starting the container the preset directory is 
mounted as `/store` in our `some-postgres` container.

**[server-backup.sh](https://github.com/boseji/dockerPlayground/blob/master/10_Postgres_server_v2_Improved/server-backup.sh)**

```shell
docker exec -it some-postgres sh -c 'su - postgres -c pg_dumpall > /store/pgBackup'
sudo chown $USER pgBackup
```
**Note:** Here there is no compression in the backup so it might be 
large on your resources.

## Restore Backup of DB

The restore process is also similar. We just take the dump out file `pgBackup`
and use the `psql -f` command to recreate our DB. 

**[server-restore.sh](https://github.com/boseji/dockerPlayground/blob/master/10_Postgres_server_v2_Improved/server-restore.sh)**

```shell
docker exec -it some-postgres sh -c 'su - postgres -c "psql -f /store/pgBackup postgres"'
```

