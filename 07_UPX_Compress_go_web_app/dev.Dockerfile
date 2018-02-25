# Setup the Developer System
FROM golang:1.8
# Add xz-utils for the installation of UPX
RUN apt-get update && apt-get install -y xz-utils \
	&& rm -rf /var/lib/apt/lists/*
# install UPX
RUN wget -qO- https://github.com/upx/upx/releases/download/v3.94/upx-3.94-amd64_linux.tar.xz |\
    tar -xJO upx-3.94-amd64_linux/upx > /bin/upx &&\
	chmod a+x /bin/upx
# Install Glide
RUN go get github.com/Masterminds/glide
# install gin runner
RUN go get github.com/codegangsta/gin
# Set Working Directory
WORKDIR /go/src/app

