# Example of Simple Docker packaging for Golang web app

This example shows 2 important ways to work with Docker:

  1. How to use Docker to build your application .

  2. How to build a complete Docker Image, so that the Container can be resused
  as a portable version of the app.

## Quick Docker build

Use the program `quickbuild.sh` to generate a executable file `myapp` which
is built using the docker image `golang:1.8` based on **debian**.

More inputs on this visit:

https://hub.docker.com/_/golang/

Or search for `golang` at https://hub.docker.com and visit the official repository.

## Portable Docker Container

For this we need to have the special `Dockerfile` designed to run the application.

And in-order to build the image and run the container, one needs to run the command `build-docker.sh`.


**Note**: In both cases the port used by application is `:8080` which needs to be mapped.