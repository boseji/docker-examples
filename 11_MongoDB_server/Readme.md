# MongoDB Server Instance

Here we would be creating a secure **MongoDB** container.

https://hub.docker.com/_/mongo/

It is important that we make the instance secure. Since initially when the container instance is created it is not secure.

## Getting the Image

`docker pull mongodb:3.6`

Which refers to `3.6.3, 3.6, 3, latest, 3.6.3-jessie (3.6/Dockerfile)` version at the time (22-Mar-2018).

## Spinning the Container for the First time

**WARNING !** There is not security of protection for this container on the first run.

```shell
docker run --name some-mongo -v "$(pwd)/"data:/data/db \
-d mongo:3.6 --auth
```

Let's look at this command

## Correct Way to Use MongoDB container !SECURELY!

### Step 1: Start the Initial Instance

```shell
docker run --name some-mongo -v "$(pwd)/"data:/data/db \
-d mongo:3.6 --auth
```

This would do the creation of the Database and associate the local `data` directory as the external *bind mounted* storage.

### Step 2: Connecting and configure ADMIN user

#### 1. Enter into the Shell of the Container

`docker exec -it some-mongo bash`

#### 2. Run the `mongo` command-line interface to actually create the **ADMIN** user 

`$ mongo`

```shell
MongoDB shell version v3.6.3
connecting to: mongodb://127.0.0.1:27017
MongoDB server version: 3.6.3
Welcome to the MongoDB shell.
For interactive help, type "help".
For more comprehensive documentation, see
	http://docs.mongodb.org/
Questions? Try the support group
	http://groups.google.com/group/mongodb-user
>
```

#### 3. In the `mongo` command-line create the User as follows:

Select the administration database:

`> use admin`

```shell
switched to db admin
```

Enter the Create User command:

`> db.createUser({user:"dbuser",pwd:"password",roles: [ { role: "userAdminAnyDatabase", db: "admin" } ]})`

```shell
Successfully added user: {
	"user" : "dbuser",
	"roles" : [
		{
			"role" : "userAdminAnyDatabase",
			"db" : "admin"
		}
	]
}
```

Here we create the user ***`dbuser`*** who will be our **ADMIN** for all Databases with a *very weak* password : `"password"`

#### 4. Quit the Interface and Exit the Bash terminal

`> quit()`

`$ exit`

#### 5. Stop the Docker container after this

Stopping the Instance

`docker stop some-mongo`

`docker rm some-mongo`

We now have a configured System Available

### Step 3: Creating the Actual Database

This step is needed to create the db that we are going to use in our application.

#### 1. Start the Instance Again

```shell
docker run --name some-mongo -v "$(pwd)/"data:/data/db \
-d mongo:3.6 --auth
```

#### 2. Enter into the `mongo` Command-line of the container using **ADMIN** user credentials

`docker exec -it some-mongo mongo -u dbuser -p password --authenticationDatabase admin`

```shell
MongoDB shell version v3.6.3
connecting to: mongodb://127.0.0.1:27017
MongoDB server version: 3.6.3
>
```

#### 3. Create the Application Database

`> use myowndb`

```shell
switched to db myowndb
```

Here the `myowndb` is the name of the Database that we have chosen to be out Application Data base

#### 4. Create a User for Application Database

Again we would use the Create user command:

`db.createUser({ user: 'mydb_admin', pwd: 'password', roles: ["readWrite", "dbAdmin"] });`

```shell
Successfully added user: { "user" : "mydb_admin", "roles" : [ "readWrite", "dbAdmin" ] }
```

Here we have created an user `mydb_admin` with a *weak password* `'password'`.

We would use this user credentials to run our Application to DB link.

#### 5. Quit the Interface

`> quit()`

`$ exit`

#### We are ready to Do some MongoDB now !!

From now on just starting the Instance is enough to get everything working.

**Plus its now SECURE**


## Robomongo / Robo3T : MongoDB User Interface

https://robomongo.org/

We are going to use the **Robo 3T** since its free and multi platform compatible.

In order to connect our new Mongo container `some-mongo` we need to find the IP address:

`docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' some-mongo`

Configuration for Connection in **Robo 3T** 

1. **Connection** Tab

Address : use the IP address just obtained

Port: 27017 (We have kept this default)

2. **Authentication** Tab

Remember this from earlier steps where we created the application database.

Database : `myowndb`

User Name: `mydb_admin`

Password: `password`

AuthMechanism: SCRAM-SHA1 (Keep it unchanged)

3. Click on **Save**

4. Finally in the **MongoDB connection** window select the connection we just configured and press **Connect**

### Thats It - We are now connected to our Application database.

## Reference Links:

https://hackernoon.com/securing-mongodb-on-your-server-1fc50bd1267b

http://rancher.com/securing-containerized-instance-mongodb/