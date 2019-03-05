#!/bin/bash

# Number of Processing Cores
CORES=$(nproc)
# Default with 2 cores only
BUILD_OPTIONS="V=99 -j$CORES"

# Faster Build with more Cores
#BUILD_OPTIONS="V=99 -j8"

# Debug Build option
#BUILD_OPTIONS="V=s"

set -e

echo
echo "-------------------------------------------------------------------------"
echo "   +++++ FINAL BUILD STEP +++++"
echo "-------------------------------------------------------------------------"
echo
echo " 1. Get to the Directory on Host mounted while creating the Continer"
cd /store/openwrt
echo
echo
echo "-------------------------------------------------------------------------"

echo
echo " 2. Initiate Prerequisite build"
echo
echo
make prereq
echo
echo
echo "-------------------------------------------------------------------------"

echo
echo " 3. Begin building"
echo
echo
echo "  Using Addon Options = $BUILD_OPTIONS"
echo
echo
export FORCE_UNSAFE_CONFIGURE=1
time make $BUILD_OPTIONS
echo
echo
echo "-------------------------------------------------------------------------"

echo
echo " 4. Getting the Build output"
echo
OUTPUT_FILE="/store/openwrt/bin/targets/ramips/mt76x8/\
openwrt-ramips-mt76x8-LinkIt7688-squashfs-sysupgrade.bin"
echo
echo "     checking for output file:"
echo
echo "     $OUTPUT_FILE"
echo
if [[ -e "$OUTPUT_FILE" ]]; then
    cp $OUTPUT_FILE /store/lks7688.img
else
    echo
    echo "Build File Not Found"
fi
echo
echo "-------------------------------------------------------------------------"

echo
echo " Done !"
echo
echo
echo "        Entering Container shell now:"
echo
bash
