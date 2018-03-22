# MySQL Docker Hub Image

https://hub.docker.com/_/mysql/

## Start a mysql server instance

Starting a MySQL instance is simple:

`$ docker run --name some-mysql -e MYSQL_ROOT_PASSWORD=my-secret-pw -d mysql:tag`

... where `some-mysql` is the name you want to assign to your container, `my-secret-pw` is the **password** to be set for the MySQL root user and tag is the tag specifying the MySQL version you want. See the list above for relevant tags.

The Default user being `root` to login. Later more users can be created.

## Connect to MySQL from an application in another Docker container

This image exposes the **standard MySQL port (3306)**, so container linking makes the MySQL instance available to other application containers. Start your application container like this in order to link it to the MySQL container:

`$ docker run --name some-app --link some-mysql:mysql -d application-that-uses-mysql`

## Connect to MySQL from the MySQL command line client

The following command starts another mysql container instance and runs the mysql command line client against your original mysql container, allowing you to execute SQL statements against your database instance:

`$ docker run -it --link some-mysql:mysql --rm mysql sh -c 'exec mysql -h"$MYSQL_PORT_3306_TCP_ADDR" -P"$MYSQL_PORT_3306_TCP_PORT" -uroot -p"$MYSQL_ENV_MYSQL_ROOT_PASSWORD"'`

... where `some-mysql` is the name of your original mysql container.

This image can also be used as a client for non-Docker or remote MySQL instances:

`$ docker run -it --rm mysql mysql -hsome.mysql.host -usome-mysql-user -p`
More information about the MySQL command line client can be found in the MySQL documentation

## Container shell access and viewing MySQL logs

The docker exec command allows you to run commands inside a Docker container. The following command line will give you a bash shell inside your mysql container:

`$ docker exec -it some-mysql bash`

The MySQL Server log is available through Docker's container log:

`$ docker logs some-mysql`

## Data Storage

The Docker documentation is a good starting point for understanding the different storage options and variations, and there are multiple blogs and forum postings that discuss and give advice in this area. We will simply show the basic procedure here for the latter option above:

1. Create a data directory on a suitable volume on your host system, e.g. /my/own/datadir.
2. Start your mysql container like this:

`$ docker run --name some-mysql -v /my/own/datadir:/var/lib/mysql -e MYSQL_ROOT_PASSWORD=my-secret-pw -d mysql:tag`

The `-v /my/own/datadir:/var/lib/mysql` part of the command mounts the `/my/own/datadir` directory from the underlying host system as `/var/lib/mysql` inside the container, where MySQL by default will write its data files.

Note that users on host systems with SELinux enabled may see issues with this. The current workaround is to assign the relevant SELinux policy type to the new data directory so that the container will be allowed to access it:

`$ chcon -Rt svirt_sandbox_file_t /my/own/datadir`

## Usage against an existing database

If you start your `mysql` container instance with a data directory that already contains a database (specifically, a `mysql` subdirectory), the `$MYSQL_ROOT_PASSWORD` variable should be omitted from the run command line; **it will in any case be ignored, and the pre-existing database will not be changed in any way.**

## Creating database dumps

Most of the normal tools will work, although their usage might be a little convoluted in some cases to ensure they have access to the mysqld server. A simple way to ensure this is to use docker exec and run the tool from the same container, similar to the following:

`$ docker exec some-mysql sh -c 'exec mysqldump --all-databases -uroot -p"$MYSQL_ROOT_PASSWORD"' > /some/path/on/your/host/all-databases.sql`

