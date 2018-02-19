# Python based Website example

## Building the Image

`docker build -t python-site1 .`

This would create the Image `python-site1` that can be listed by:

`docker images`

## Spinning up a Container using the Image

`docker run -p 4000:80 --name psite1 python-site1`

In this command a Container named as `psite1` would be created from the image `python-site1` and the Container's `port 80` would be mapped to the *Host* `port 4000`

Hence one can browse the website by typing `http://localhost:4000`

Due to the nature of the application this would show up as an terminal application. And would need a `Ctrl+C` to terminate.

However one can run the application as a daemon :

`docker run -d -p 4000:80 --name psite1 python-site1`

## Killing the Container

In case the Container is running in daemon mode then :

`docker kill <container ID or name>`

Or even easier to Kill all by this command:

`docker ps -aq | xargs docker kill`

## Removing the Container

`docker rm <container ID or name>`

Again for removing any and all containers ;

`docker ps -aq | xargs docker rm -f`

The flag `-f` helps remove any containers that have hanged or have trouble closing down.
