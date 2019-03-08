#!/bin/sh

echo "this assumes you have dependencies already"
sleep 10

cd ~/Downloads
wget https://github.com/buzzkillb/denarius-pi3/releases/download/v3.3.8alpha/denariusd
chmod +x denariusd
sudo cp denariusd /usr/local/bin/denariusd

echo "to run daemon type denariusd"
echo "if this doesn't work try installing dependencies"
echo "sudo apt-get --assume-yes install git unzip build-essential libssl-dev libdb++-dev libboost-all-dev libqrencode-dev libminiupnpc-dev libgmp-dev libevent-dev autogen automake libtool"
