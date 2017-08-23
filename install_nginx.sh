#!/bin/bash

## Updating Raspberry
apt update && sudo apt upgrade -y

## Installation
apt install nginx

## avoid conflicts
rm -r /etc/nginx/sites-available/default
touch /etc/nginx/sites-available/default
cat > /etc/nginx/sites-available/default <<EOF

server {
    listen 80 default_server;
    server_name www.atareao.es;
    root /var/www/html;
    index index.html index.htm;

    location / {
        try_files \$uri \$uri/ /index.html;
    }
}

EOF

## restart nginx
nginx -s reload