FROM golang:1.8 as devmachine
# install glide
RUN go get github.com/Masterminds/glide
# install gin
RUN go get github.com/codegangsta/gin
# Create the Working Directory
WORKDIR /go/src/app
# add glide.yaml and glide.lock
ADD glide.yaml glide.yaml
ADD glide.lock glide.lock
# add the Script for Gin Runner
ADD gin-runner gin-runner
# install packages
RUN glide install
# add source code
ADD src src
# Run the Go file
CMD ["go", "run", "src/main.go"]