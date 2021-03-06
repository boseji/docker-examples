#!/bin/bash

OPENWRT_REPO="https://github.com/openwrt/openwrt.git"
OPENWRT_VERSION="v18.06.2"

set -e
echo
echo "-------------------------------------------------------------------------"
echo "  +++++ Setting Up Sources +++++"
echo "-------------------------------------------------------------------------"
echo
echo " 1. Get to the Directory on Host mounted while creating the Continer"
cd /store
echo
echo
echo "-------------------------------------------------------------------------"

if [[ ! -d openwrt ]];then
echo
echo " 2. Obtain the Source Repository"
echo
echo " from $OPENWRT_REPO "
echo
git clone $OPENWRT_REPO
echo
echo
echo "-------------------------------------------------------------------------"
fi

echo
echo " 3. Enter the correct location and branch"
echo
echo "  go to ./openwrt"
cd openwrt
if [ "$(git branch | grep \* | cut -d ' ' -f2)" != "$OPENWRT_VERSION" ];then
echo
echo "  And Checkout Version = $OPENWRT_VERSION"
echo
echo
git checkout -b $OPENWRT_VERSION
fi
echo
echo
echo "-------------------------------------------------------------------------"

echo
echo " 4. Get the Feeds Correct"
echo
cp feeds.conf.default feeds.conf
echo src-git linkit https://github.com/MediaTek-Labs/linkit-smart-7688-feed.git >> feeds.conf
echo
echo " 5. Install the Feeds"
echo
echo "    Update the Feeds"
echo
echo
./scripts/feeds update
echo
echo
echo "    Install all the Feeds"
echo
echo
./scripts/feeds install -a
echo
echo
echo
echo "-------------------------------------------------------------------------"

echo
echo
echo "    Done !!!"
echo
echo
