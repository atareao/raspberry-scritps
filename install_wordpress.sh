#!/bin/bash

if [ "$(whoami)" != "root" ]; then
    echo "Run script as ROOT please. (sudo !!)"
    exit
fi

if [[ $# -eq 0 ]] ; then
    echo 'You must set the name of the directory'
    exit 0
fi
DIRECTORY="${1,,}"
PARENTDIR="$(dirname "$(pwd)")"
echo "Installing WordPress in "$DIRECTORY
if [ -d "$DIRECTORY" ]; then
    rm -rf $DIRECTORY
fi
mkdir $DIRECTORY
cd $DIRECTORY
echo "$(pwd)"
wget http://wordpress.org/latest.tar.gz
tar xfz latest.tar.gz
cp -r wordpress/* ./
rm -rf wordpress
rm -f latest.tar.gz
cd ..
chown -R www-data:www-data $DIRECTORY
find $DIRECTORY -type d -print -exec chmod 775 {} \;
find $DIRECTORY -type f -print -exec chmod 664 {} \;