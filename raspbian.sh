#!/bin/sh
TEMP=/tmp/answer$$
whiptail --title "Denarius [D]"  --menu  "Denarius [Raspbian] :" 20 0 0 1 "Install Denarius daemon Raspbian" 2 "Install Denarius QT [Raspbian]" 3 "Get Chaindata" 2>$TEMP
choice=`cat $TEMP`
case $choice in
        1)      echo 1 "Installing Denarius daemon Raspbian"
echo "Updating linux packages"
sudo apt-get update -y && sudo apt-get upgrade -y

echo "Installing git"
sudo apt install git -y

echo "Installing curl"
sudo apt-get install curl -y

echo "Installing PWGEN"
sudo apt-get install -y pwgen

echo "Installing 2G Swapfile"
sudo sed -i 's/CONF_SWAPSIZE=100/CONF_SWAPSIZE=2048/' /etc/dphys-swapfile
sudo /etc/init.d/dphys-swapfile stop
sudo /etc/init.d/dphys-swapfile start
free -m
#sudo fallocate -l 2G /swapfile
#sudo chmod 600 /swapfile
#sudo mkswap /swapfile
#sudo swapon /swapfile
#echo '/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab

echo "Installing Dependencies"
sudo apt-get --assume-yes install git unzip build-essential libssl-dev libdb++-dev libboost-all-dev libqrencode-dev libminiupnpc-dev libevent-dev autogen automake  libtool

echo "OpenSSL 1.0.1j"
sudo apt-get install make
wget https://www.openssl.org/source/openssl-1.0.1j.tar.gz
tar -xzvf openssl-1.0.1j.tar.gz
cd openssl-1.0.1j
./config
make depend
make
#make test
sudomake install
sudo ln -sf /usr/local/ssl/bin/openssl `which openssl`
cd ~
openssl version -v

#echo "Downloading Denarius Wallet"
#wget https://github.com/carsenk/denarius/releases/download/v3.2.5/denariusd-v3.2.5-ubuntu1604.tar.gz
#tar -xvf denariusd-v3.2.5-ubuntu1604.tar.gz -C /usr/local/bin
#rm denariusd-v3.2.5-ubuntu1604.tar.gz

echo "Installing Denarius Wallet"
git clone https://github.com/carsenk/denarius
cd denarius
git checkout v3.4
git pull
cd src
OPENSSL_INCLUDE_PATH=/usr/local/ssl/include OPENSSL_LIB_PATH=/usr/local/ssl/lib make -f makefile.arm -j4
strip denariusd
sudo cp ~/denarius/src/denariusd /usr/local/bin/denariusd

echo "Populate denarius.conf"
mkdir ~/.denarius
    # Get PI3 IP Address
    VPSIP=$(curl ipinfo.io/ip)
    # create rpc user and password
    rpcuser=$(openssl rand -base64 24)
    # create rpc password
    rpcpassword=$(openssl rand -base64 48)
    echo -e "rpcuser=$rpcuser\nrpcpassword=$rpcpassword\nserver=1\nlisten=1\ndaemon=1\naddnode=denarius.host\naddnode=denarius.win\naddnode=denarius.pro\naddnode=triforce.black\nrpcallowip=127.0.0.1\nexternalip=$VPSIP" > ~/.denarius/denarius.conf

echo "Add Daemon Cronjob"
(crontab -l ; echo "@reboot /usr/local/bin/denariusd")| crontab -
#(crontab -l ; echo "0 * * * * /usr/local/bin/denariusd stop")| crontab -
#(crontab -l ; echo "2 * * * * /usr/local/bin/denariusd")| crontab -

echo "Denarius Daemon, to start type denariusd"
                ;;
        2)      echo 2 "Installing Denarius QT [Raspbian]"
echo "Updating linux packages"
sudo apt-get update -y && sudo apt-get upgrade -y

echo "Installing git"
sudo apt install git -y

echo "Installing curl"
sudo apt-get install curl -y

echo "Installing 2G Swapfile"
sudo sed -i 's/CONF_SWAPSIZE=100/CONF_SWAPSIZE=2048/' /etc/dphys-swapfile
sudo /etc/init.d/dphys-swapfile stop
sudo /etc/init.d/dphys-swapfile start
free -m
#sudo fallocate -l 2G /swapfile
#sudo chmod 600 /swapfile
#sudo mkswap /swapfile
#sudo swapon /swapfile
#echo '/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab

echo "Installing Dependencies"
sudo apt-get --assume-yes install git unzip build-essential libdb++-dev libboost-all-dev libqrencode-dev libminiupnpc-dev libevent-dev autogen automake libtool libqt5gui5 libqt5core5a libqt5dbus5 qttools5-dev qttools5-dev-tools qt5-default

echo "OpenSSL 1.0.1j"
sudo apt-get install make
wget https://www.openssl.org/source/openssl-1.0.1j.tar.gz
tar -xzvf openssl-1.0.1j.tar.gz
cd openssl-1.0.1j
./config --openssldir=/usr/local/openssl1.0.1j shared
make
#  make test
sudo make install
ln -s /usr/local/openssl1.0.1j /usr/local/openssl
cd ~
openssl version -v

#echo "Downloading Denarius Wallet"
#wget https://github.com/carsenk/denarius/releases/download/v3.2.5/denariusd-v3.2.5-ubuntu1604.tar.gz
#tar -xvf denariusd-v3.2.5-ubuntu1604.tar.gz -C /usr/local/bin
#rm denariusd-v3.2.5-ubuntu1604.tar.gz

echo "Installing Denarius Wallet"
git clone https://github.com/carsenk/denarius
cd denarius
git checkout v3.4
git pull
qmake "USE_NATIVETOR=-" "USE_UPNP=1" "USE_QRCODE=1" OPENSSL_INCLUDE_PATH=/usr/local/openssl/include OPENSSL_LIB_PATH=/usr/local/openssl/lib denarius-qt.pro
make -j4
sudo cp ~/denarius/Denarius /usr/local/bin/Denarius
                ;;
        3)      echo 3 "Get Chaindata"

echo "Get Chaindata"
sudo apt-get -y install unzip
cd ~/.denarius
rm -rf database txleveldb smsgDB
wget https://github.com/carsenk/denarius/releases/download/v3.3.6/chaindata1612994.zip
unzip chaindata1612994.zip
                ;;
esac
echo Selected $choice
