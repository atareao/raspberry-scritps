#!/bin/bash

if [ "$(whoami)" != "root" ]; then
    echo "Run script as ROOT please. (sudo !!)"
    exit
fi

echo "=== Updating Raspberry ==="
apt update -y
apt upgrade -y

echo "=== Install dependencies ==="
apt install git libreadline-dev libconfig-dev libssl-dev lua5.2 liblua5.2-dev
apt install libevent-dev make

echo "=== Cloning telegram-cli ==="
rm -rf tg
git clone --recursive https://github.com/vysheng/tg.git
cd tg
./configure
make
cp bin/telegram-cli /usr/bin
mkdir -p /etc/telegram-cli
cp server.pub /etc/telegram-cli/server.pub
cd ..
#rm -rf tg
