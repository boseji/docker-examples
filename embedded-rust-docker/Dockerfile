FROM ubuntu:16.04

# Set the working directory to /code
WORKDIR /code

# Copy the current directory contents into the container at /code
ADD ./code /code

# Install necessary packages
RUN sudo apt update && sudo apt upgrade -y && \
	sudo apt install -y python git-core nano vim arm-none-eabi-binutils arm-none-eabi-gdb openocd

# Install rust
RUN curl https://sh.rustup.rs -sSf | sh
