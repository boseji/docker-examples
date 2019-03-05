#!/bin/bash

set -e
echo
echo "-------------------------------------------------------------------------"
echo " +++ Depencies Installation +++"
echo "-------------------------------------------------------------------------"
echo
echo " 1. Updating Repository"
echo
sudo apt-get update
echo
echo "-------------------------------------------------------------------------"

echo
echo " 2. Upgrading"
echo
sudo apt-get upgrade -y
echo
echo "-------------------------------------------------------------------------"

echo
echo " 3. Depencencies install"
echo
sudo apt install -y nano autoconf automake libtool make patch texinfo gettext pkg-config git g++ make libncurses5-dev subversion libssl-dev gawk libxml-parser-perl unzip wget python xz-utils
echo
echo "-------------------------------------------------------------------------"

echo
echo " 4. Cleanup"
echo
sudo apt-get autoclean -y
sudo apt-get autoremove -y
echo
echo "-------------------------------------------------------------------------"

echo
echo " Done!"
echo
echo "   Now running '3_Get_Sources.sh'"
echo
bash ./3_Get_Sources.sh