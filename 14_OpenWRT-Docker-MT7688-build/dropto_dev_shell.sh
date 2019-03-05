#!/bin/bash

echo
echo "-------------------------------------------------------------------------"
echo
echo
echo "  1. Get the Updated docker container"
echo
if [ -z $(docker images -q openwrtbuilder:latest) ]; then
    echo
    echo "  The Docker OpenWRT Builder image doesnot exists."
    echo
    docker build -t openwrtbuilder .
    if [ -z $(docker images -q openwrtbuilder:latest) ]; then
        echo
        echo " Could not get the docker Image built."
        echo
        exit 1
    fi
    echo
else
    echo
    echo "  Skipping building Docker OpenWRT Builder image, it already exists."
    echo
fi

echo "-------------------------------------------------------------------------"
echo
echo " 2. Entering Shell"
echo
echo "      The present directory is mounted as '/store'"
echo
echo
docker run --rm -it -v "$(pwd)":/store -w /store --name mt7688-builder\
    openwrtbuilder bash
echo
echo
