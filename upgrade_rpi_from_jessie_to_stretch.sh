apt update
apt upgrade
sed -i 's/jessie/stretch/g' /etc/apt/sources.list
apt update
apt upgrade
apt dist-upgrade
apt autoremove
apt clean
shutdown -r now
