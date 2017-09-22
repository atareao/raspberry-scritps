#!/bin/bash

if [ "$(whoami)" != "root" ]; then
    echo "Run script as ROOT please. (sudo !!)"
    exit
fi

echo "deb http://mirrordirector.raspbian.org/raspbian/ stretch main contrib non-free rpi" > /etc/apt/sources.list.d/stretch.list
#echo "APT::Default-Release \"jessie\";" > /etc/apt/apt.conf.d/99-default-release
cat > /etc/apt/preferences << "EOF"
Package: *
Pin: release n=jessie
Pin-Priority: 600
EOF

## Updating Raspberry
apt update -y
apt upgrade -y
apt dist-upgrade -y


## Install apache
apt install -y apache2

## Installation of PHP 7
apt install -t stretch -y php7.0 php7.0-bz2 php7.0-cli php7.0-curl php7.0-gd php7.0-fpm php7.0-intl php7.0-json php7.0-mbstring php7.0-mcrypt php7.0-mysql php7.0-opcache php7.0-xml php7.0-zip php-imagick php-redis mariadb-server libapache2-mod-php7.0 apache2

mkdir /var/www/html
chown www-data:www-data /var/www/html
cat > /var/www/html/index.php << "EOF"
<?php phpinfo(); ?>
EOF

## Install MariaDB
apt install mariadb-server
mysql -u user -p

## phpMyAdmin
apt install phpmyadmin
cat > nano /etc/apache2/apache2.conf << "EOF"
Include /etc/phpmyadmin/apache.conf
EOF

service apache2 restart