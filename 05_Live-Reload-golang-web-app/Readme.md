# Example of Live Reloading Golang web app for Development

Setup of [Glide](https://glide.sh/) in the Docker is done at the time of building the image. *Glide* is used as the package management for *Golang* dependncies of the web app. 

The example go program uses the https://github.com/julienschmidt/httprouter which is inserted using the **Glide** Package management

We have added the capability to live reload on changes using the [codegangsta/Gin](https://github.com/codegangsta/gin) tool. And Yes its not the `Gin/Gonic` thing this is a seprate tool but named similar.

[*codegangsta/Gin*](https://github.com/codegangsta/gin) helps to auto reload and build the web app as soon as changes are observed in the soruce file. This would helpful to do development. It works like running the `go run src/main.go` every time your source file changes.

*Gin* uses 2 ports:
  
  1. Proxy Port - This is exposed to the outer world, like the actual system or inside the docker container. It is sepcified by the flag `--port` flag in the *Gin* command.

  2. Application Port - This is the port used by the Web App and is proxied by *Gin* to the outer world by the Proxy Port. This is specified by the flag `--appPort`. In a real world application one may need to change this as per the need.

In our case since we are building upon our earlier example `04_golang-webapp-with-glide-support`, we have already set the port in the web app as `8080`. This port specified in the Web App would become our *Application Port*. In order to give a diffrent port for the proxy we would use `8000` for the *Gin* *Proxy Port*. Finally we would map this Proxy Port from inside the docker container to the expternal port `8080` on the Host.

Thus for us we can run the folling *Gin* command inside the container:

```shell
gin --path src --port 8000 --appPort 8080 run main.go
```

Here the `--path` flag actually specifes the location where the source files are present.

Now in order to speed this command we would add a shell script inside the docker container called `gin-runner` which would help us type the command easier. 

Here the steps:

  1. First run the `build-docker.sh` to generate the build image

  2. Next run a `bash` shell into the built docker image with the special port mapping of `-p 8080:8000`(Host port to *Gin* Proxy Port mapping). To do this use the script `run-docker-ginbash.sh`. 

  3. Now in the container shell to run the program use the command

  ```shell
  ./gin-runner
  ```

  This would execute the program with the dependencies included with the particualar port mapping. And since the Soruce directory is mounted into the conatiner, any changes to the soruce file would cause a new `go run` command to get triggerd.

At this point one can also try running the full container app by using the script `run-docker-app.sh`


**Note**: In both cases the port used by application is `:8080` which is mapped by *Gin* internally to `:8000` and then mapped back to `:8080` on the host.