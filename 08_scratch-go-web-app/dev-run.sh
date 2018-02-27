#!/bin/sh
#ext=`docker images | grep go-dev-machine | cut -d " " -f1`
echo
echo "    Building the new Development Image ...."
echo
docker build -t go-dev-machine -f dev.Dockerfile .
echo
echo "    Running the Development Machine Console"
echo
echo "       you can use the Glide commands here "
echo "        Example: "
echo " # glide get github.com/julienschmidt/httprouter"
echo
if [ "$1" == "gin" ];then
	echo
	echo "  so you want to use Gin .."
	echo
	echo "  set --appPort 8080 --port 8000"
	echo " So that the application remains unchanged but "
    docker run --rm -it -p 8080:8000 -v "$PWD":/go/src/app go-dev-machine bash
else
    docker run --rm -it -p 8080:8080 -v "$PWD":/go/src/app go-dev-machine bash
fi
echo
echo "    Removing the Vendor directory if any ...."
echo
sudo rm -rf vendor
echo
echo " : Finally Delete the development image... :"
echo
docker rmi go-dev-machine
echo
echo "   Let's look at the docker images left one last time .."
echo
docker images
echo
echo