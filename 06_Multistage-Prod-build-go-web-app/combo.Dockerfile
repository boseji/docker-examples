# Builder Image for Making the Executable
FROM golang:1.8 as builder
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
RUN go build src/main.go
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o main src/main.go

# Minimum System For the Production Image
FROM alpine:3.7 as Production
# add ca-certificates in case you need them
RUN apk update && apk add ca-certificates && rm -rf /var/cache/apk/*
# set working directory
WORKDIR /root
# copy the binary from builder - note Here the External Image Tag is used
#   do not confuse this with the 'builder' tag used above
COPY --from=gobuilder:latest /go/src/app/main .
# run the binary
CMD ["./main"]