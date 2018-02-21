# Example of Production Multi-stage build of Golang web app

This examples builds upon the Last 2 examples:

 1. [04_golang-webapp-with-glide-support](https://github.com/boseji/dockerPlayground/tree/master/04_golang-webapp-with-glide-support) Explaining the ***Glide*** package management

 2. [05_Live-Reload-golang-web-app](https://github.com/boseji/dockerPlayground/tree/master/05_Live-Reload-golang-web-app) Explaining Live Reload via the [codegangsta/Gin](https://github.com/codegangsta/gin) tool.

The main intention of this example is to Show 
  
  *  How build a Go web app into Executable

  *  How the Multi Stage build works

  *  What are the problems of the default `Multisage Build` as on date (Feb'2018)

  *  How to Improve upon and create a fix for non-removeable intermidiate docker images

## Building the Go Web App for Production

Lets get started by first understanding how we are going to build an executable.

Typically a Golang excutable needs to built for the specific environment/OS.

```shell
go build src/main.go
```

This should typically build it for our Host. However the build image would take
the name of the directory.

In this case `06_Multistage-Prod-build-go-web-app` if you are building this particualr directory.

Thats not ideal and we need a proper name for our app.

So we improve the command:

```shell
go build -o main src/main.go
```

This command would build the things into an executable named `main` and we can run this by typing `./main`.

However we need to be very specific about how we want the executable to work.
Since we are actually going to do this inside the *Docker Container*.

Here is the Improved upon command:

```shell
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o main src/main.go
```

Here are the Details:

  * `CGO_ENABLED=0` disables the `cgo` compiler (not sure about this one !)

  * `GOOS=linux` Set the target build operation to geneare a linux binary

  * `-a` flag forces rebuilding of packages that are already up-to-date

  * `-installsuffix cgo` renames the build depencies and directory with added suffix to separate them from default builds. In this case we are using `cgo` and the suffix.

  * `-o main` specifies the output file name

Lets now do and build a docker Image:

[**Ex1.Dockerfile**](https://github.com/boseji/dockerPlayground/blob/master/06_Multistage-Prod-build-go-web-app/ex1.Dockerfile)

```Dockerfile
FROM golang:1.8
# install glide
RUN go get github.com/Masterminds/glide
# Create the Working Directory
WORKDIR /go/src/app
# add glide.yaml and glide.lock
ADD glide.yaml glide.yaml
ADD glide.lock glide.lock
# install packages
RUN glide install
# add source code
ADD src src
# build the source
#RUN go build src/main.go
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o main src/main.go
# Finally Execute the Program
CMD ["./main"]
```

We can `docker build` this by using:

```shell
docker build -t go-docker-prod -f ex1.Dockerfile .
```

The above command would specifically target the file `ex1.Dockerfile` and use the same directory as the default root of operations.

Lets now run the newly created docker container:

```shell
docker run --rm -it -p 8080:8080 go-docker-prod
```

This command is warapped in the file `run-docker-prod-app.sh`.

This above command should work successfully ans show the following log message:

```shell
2018/02/21 02:29:06 Starting Server (with httprouter) on Port 8080
```

Thats fine a great but there is some thing to note.

Lets now look at **Size** of the docker container created for production:

```shell
$ docker images
REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
go-docker-prod      latest              8799f9509e95        4 minutes ago       736MB
golang              1.8                 0d283eb41a92        3 days ago          713MB
alpine              3.7                 3fd9065eaf02        6 weeks ago         4.15MB
```

Notice that our `go-docker-prod` is **736 MB** !!

That's not very good, we would ideally like to have a *smaller Image*.
Since there might be other service container and even the *smallest VMs* you can buy at $5 don't have much space and memory.

## Building Lean production Image


## Multi-Stage Build

## Improving upon default 'Multi-Stage' Builds
