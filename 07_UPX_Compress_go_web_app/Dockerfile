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

# Now for the Production Image
FROM alpine:3.7 as production
# add ca-certificates in case you need them
RUN apk update && apk add ca-certificates && rm -rf /var/cache/apk/*
# set working directory
WORKDIR /root
# copy the binary from builder - note Here the External Image Tag is used
#   do not confuse this with the 'builder' tag used above
COPY --from=builder /go/src/app/main .
# run the binary
CMD ["./main"]