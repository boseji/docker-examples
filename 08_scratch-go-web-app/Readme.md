# Example of Scratch based Golang Web app

This derives upon the previous example of [UPX compressed Image][4] called
[`07_UPX_Compress_go_web_app`][9]

The only diffrence here is that the execution build or the *Production* image

is made using [**Scratch**][10].

Have a look at the new Docker file:

[**Dockerfile**][11]

```Dockerfle
# Setup the Developer System
FROM golang:1.8 as builder
# Add xz-utils for the installation of UPX
RUN apt-get update && apt-get install -y xz-utils \
	&& rm -rf /var/lib/apt/lists/*
# install UPX
RUN wget -qO- https://github.com/upx/upx/releases/download/v3.94/upx-3.94-amd64_linux.tar.xz |\
    tar -xJO upx-3.94-amd64_linux/upx > /bin/upx &&\
	chmod a+x /bin/upx
# Install Glide
RUN go get github.com/Masterminds/glide
# install gin runner if needed
#RUN go get github.com/codegangsta/gin
# Set Working Directory
WORKDIR /go/src/app
# Add the Specific Files for Glide
ADD glide.lock glide.lock
ADD glide.yaml glide.yaml
# Run the Glide install Command
#RUN glide get --non-interactive github.com/julienschmidt/httprouter && \
#	glide install
RUN glide install
# Insert the Source directory
ADD src src
# Run Build command
RUN GOOS=linux CGO_ENABLED=0 go build -a -installsuffix app -o main src/main.go
# Remove Debug Symbols from the executable
RUN strip --strip-unneeded main
# Now run UPX on the Final Executable
RUN upx main
# Run the program continuously with Gin Runner If needed
#CMD ["gin", "run", "--port 8000", "--appPort 8080", "src/main.go"]

# Production Machine using Scratch
FROM scratch as production
# set working directory
WORKDIR /root
# copy the binary from builder - note Here the External Image Tag is used
#   do not confuse this with the 'builder' tag used above
COPY --from=builder /go/src/app/main .
# run the binary
CMD ["./main"]

```


As you can see that creating the final **Scratch** based production image is easy and if we look at the image size 

Its only **1.3 MB**! Great isn't it.

<pre>
REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
go-prod-docker      latest              9ec982290542        12 minutes ago      1.29MB
golang              1.8                 0d283eb41a92        10 days ago         713MB
hello-world         latest              48b5124b2768        13 months ago       1.84kB
</pre>


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

 [9]: https://github.com/boseji/dockerPlayground/tree/master/07_UPX_Compress_go_web_app

 [10]: https://hub.docker.com/_/scratch/

 [11]: https://github.com/boseji/dockerPlayground/tree/master/08_scratch-go-web-app
