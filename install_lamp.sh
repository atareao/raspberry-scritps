#!/bin/bash

if [ "$(whoami)" != "root" ]; then
    echo "Run script as ROOT please. (sudo !!)"
    exit
fi

echo "deb http://mirrordirector.raspbian.org/raspbian/ stretch main contrib non-free rpi" > /etc/apt/sources.list.d/stretch.$
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
apt install -t stretch -y php7.0 php7.0-mysql libapache2-mod-php7.0

mkdir /var/www/html
chown www-data:www-data /var/www/html
find /var/www/html -type d -print -exec chmod 775 {} \;
find /var/www/html -type f -print -exec chmod 664 {} \;
usermod -aG www-data pi
cat > /var/www/html/index.php << "EOF"
<?php phpinfo(); ?>
EOF

## Install MariaDB
apt install mariadb-server
mysql -u user -p

/etc/init.d/apache2 restart
