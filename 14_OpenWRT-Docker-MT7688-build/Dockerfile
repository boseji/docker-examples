FROM ubuntu:14.04

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y nano autoconf automake libtool make patch texinfo gettext \
    pkg-config git g++ make libncurses5-dev subversion libssl-dev gawk \
    libxml-parser-perl unzip wget python xz-utils && \
    apt-get autoclean -y && \
    apt-get autoremove -y
