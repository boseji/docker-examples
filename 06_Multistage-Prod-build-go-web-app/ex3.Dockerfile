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
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o main src/main.go

FROM alpine:3.7 as production
# add ca-certificates in case you need them
RUN apk update && apk add ca-certificates && rm -rf /var/cache/apk/*
# set working directory
WORKDIR /app
# copy the binary from builder
COPY --from=builder /go/src/app/main .
# run the binary
CMD ["./main"]