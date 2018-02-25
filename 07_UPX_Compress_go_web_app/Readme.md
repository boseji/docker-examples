# Example of UPX compressed Go Web App

This example focuses on creating an even smaller image by compressing the executable built from the earlier stages.

We achieve this using 

[UPX][4]:
**Ultimate Packager for eXecutables**

We derive upon the the know how of the following (for development):

  1. Creating the Go application with dependency on [httprouter][1]

  2. Create a Development System with 

       a. Dockerfile [`dev.Dockerfile`][9] to create a development image with [Glide][2] and [codegangsta/gin tool][3] installed

       b. Shell script [`dev-run.sh`][10] to run the shell into the created image. *Note that the scrip automatically deletes the created development image after completion*

  3. Installation of dependencies for `glide.yaml` and `glide.lock` using the command `glide get` with the respective repository URI. In this case we would be using [httprouter][1]

  4. Remember to remove the `vendor` directory before exiting the development console.

The new Step would be to install UPX in our builder stage.

We do that with the following addition:

[**Dockerfile**][11]

```Dockerfile
# Add xz-utils for the installation of UPX
RUN apt-get update && apt-get install -y xz-utils \
	&& rm -rf /var/lib/apt/lists/*
# install UPX
RUN wget -qO- https://github.com/upx/upx/releases/download/v3.94/upx-3.94-amd64_linux.tar.xz |\
    tar -xJO upx-3.94-amd64_linux/upx > /bin/upx &&\
	chmod a+x /bin/upx
```

The above steps includes the following stages:

 1. Update the Local repository

 2. Install `xz-utils` needed to un-archive the UPX tool

 3. Download the UPX tool using `wget`

 4. Extract the UPX tool archive

 5. Install the UPX tool into the system and make it executable

We have also tried to create a download-able image of the Docker build.

This helps to reduce the burden of storing multiple version of the production docker container in local docker registry.

We achieve this by [`docker save`][6] Command.

When we wish to run container based on this image we call the
[`docker load`][7] command.

The full sequence is covered in the shell script [`run.sh`][12].

Additionally this script ensures that the generated image file is built and loaded before initiating the `run` command.

This image file can now be loaded into the deployment server and a specific `run` command there shall be issued.

Best part is the generated image is only **6 MB** !

This is great and its so small, we knocked off nearly half of the image capacity from [last example][13]

<!---
	These are the Reference Links
-->

 [1]: https://github.com/julienschmidt/httprouter

 [2]: https://github.com/Masterminds/glide

 [3]: https://github.com/codegangsta/gin

 [4]: https://upx.github.io/

 [5]: https://blog.hasura.io/the-ultimate-guide-to-writing-dockerfiles-for-go-web-apps-336efad7012c

 [6]: https://docs.docker.com/engine/reference/commandline/save/

 [7]: https://docs.docker.com/engine/reference/commandline/load/

 [8]: https://docs.docker.com/config/containers/resource_constraints/

 [9]: https://github.com/boseji/dockerPlayground/tree/master/7_UPX_Compress_go_web_app/dev.Dockerfile

 [10]: https://github.com/boseji/dockerPlayground/tree/master/7_UPX_Compress_go_web_app/dev-run.sh

 [11]: https://github.com/boseji/dockerPlayground/tree/master/7_UPX_Compress_go_web_app/Dockerfile

 [12]: https://github.com/boseji/dockerPlayground/tree/master/7_UPX_Compress_go_web_app/run.sh

 [13]: https://github.com/boseji/dockerPlayground/tree/master/06_Multistage-Prod-build-go-web-app

