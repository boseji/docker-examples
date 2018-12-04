FROM ubuntu:latest

# Set the working directory to /work
# WORKDIR /work

# Copy the current directory contents into the container at /work
# ADD ./work /work

# Important Packages:
RUN DEBIAN_FRONTEND=noninteractive apt update && \
  apt upgrade -y &&\
  apt install -y apt-utils git-core nano curl wget python vim net-tools lsb-release iputils-ping
# Generate the Keys as needed
# RUN	cat /dev/zero | ssh-keygen -t rsa -b 8192 -C "my-ubuntu-docker" -N "" -q && cp .ssh/id_rsa.pub /work/newkey.pub

