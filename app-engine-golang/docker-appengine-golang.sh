#!/bin/bash
export GOLANGVERSION='1.9'
apt update && apt install -y curl python nano vim wget git apt-transport-https
curl https://sdk.cloud.google.com/ | bash
wget 'https://storage.googleapis.com/golang/go$GOLANGVERSION.linux-amd64.tar.gz'
tar -C /usr/local -xzf 'go$GOLANGVERSION.linux-amd64.tar.gz'
rm 'go$GOLANGVERSION.linux-amd64.tar.gz'
echo 'export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin' >> ~/.bashrc
echo 'export GOPATH=$HOME/go' >> ~/.bashrc
mkdir -p ~/go/src ~/go/bin
wget https://goo.gl/FEjiMK -O .gitconfig
ssh-keygen -t rsa -b 4096
. source ~/.bashrc
gcloud components install app-engine-go app-engine-python