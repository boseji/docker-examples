FROM phusion/baseimage:latest

# Set the working directory to /code
# WORKDIR /code

# Copy the current directory contents into the container at /code
# ADD ./code /code

# Important Packages:
#
# gdb-arm-none-eabi/artful 7.11.90.20160917-0ubuntu1+9build1 amd64
#  GNU debugger for ARM Cortex-A/R/M processors
#
# binutils-arm-none-eabi/artful 2.27-9ubuntu1+9 amd64
#  GNU assembler, linker and binary utilities for ARM Cortex-A/R/M processors
#
# openocd/artful,now 0.10.0-1build1 amd64 [installed]
#  Open on-chip JTAG debug solution for ARM and MIPS systems
#
# gcc-arm-none-eabi/artful 15:5.4.1+svn241155-1 amd64
#  GCC cross compiler for ARM Cortex-A/R/M processors
#
RUN apt update
# Install necessary packages
RUN apt install -y apt-utils git-core nano curl wget 
RUN apt install -y openocd gdb-arm-none-eabi binutils-arm-none-eabi gcc-arm-none-eabi

# Generate the Keys as needed
# RUN	ssh-keygen -t rsa -b 4096

# Install rust
RUN curl https://sh.rustup.rs -sSf | sh
