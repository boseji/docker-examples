#!/bin/sh

echo "-------------------------------------------------------------------------"
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
echo "   Now running ''./3_Get_Sources.sh'"
echo "     as OS Depencies installation is already done in Docker file"
echo "     so not running the '2_install_dependencies.sh' anymore"
echo
echo
docker run --rm -it -v "$(pwd)":/store -w /store --name mt7688-builder\
    openwrtbuilder bash -c "./3_Get_Sources.sh"
