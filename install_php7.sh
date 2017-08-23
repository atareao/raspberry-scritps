#!/bin/bash

if [ "$(whoami)" != "root" ]; then
    echo "Run script as ROOT please. (sudo !!)"
    exit
fi

echo "deb http://mirrordirector.raspbian.org/raspbian/ stretch main contrib non-free rpi" > /etc/apt/sources.list.d/stretch.list
echo "APT::Default-Release \"jessie\";" > /etc/apt/apt.conf.d/99-default-release

## Updating Raspberry
apt update -y
apt upgrade -y
apt dist-upgrade -y


## Installation of PHP 7
apt install -t stretch -y php7.0 php7.0-fpm php7.0-cli php7.0-opcache php7.0-mbstring php7.0-curl php7.0-xml php7.0-gd php7.0-mysql

update-rc.d nginx defaults
update-rc.d php7.0-fpm defaults

sed -i 's/^;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/' /etc/php/7.0/fpm/php.ini
sed -i 's/# server_names_hash_bucket_size/server_names_hash_bucket_size/' /etc/nginx/nginx.conf

cat > /etc/nginx/sites-enabled/default << "EOF"
# Default server
server {
    listen 80 default_server;
    listen [::]:80 default_server;
    
    server_name _;
    root /var/www/default/public;
    index index.php index.html index.htm default.html;

    location / {
        try_files $uri $uri/ =404;
    }

    # pass the PHP scripts to FastCGI server
    location ~ \.php$ {
        include snippets/fastcgi-php.conf;
        fastcgi_pass unix:/run/php/php7.0-fpm.sock;
    }

    # optimize static file serving
    location ~* \.(jpg|jpeg|gif|png|css|js|ico|xml)$ {
        access_log off;
        log_not_found off;
        expires 30d;
    }

    # deny access to .htaccess files, should an Apache document root conflict with nginx
    location ~ /\.ht {
        deny all;
    }
}