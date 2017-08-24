#!/bin/bash

if [ "$(whoami)" != "root" ]; then
    echo "Run script as ROOT please. (sudo !!)"
    exit
fi

echo "=== Updating Raspberry ==="
apt update -y
apt upgrade -y

echo "=== Install helpers ==="
apt install jq

echo "=== Installing transmission ==="
apt install -y transmission-daemon

echo "=== Stopping transmission daemon ==="
service transmission-daemon stop 

echo "=== our user pi in debian-transmission group ==="
usermod -a -G pi debian-transmission
#maybe: transmission-daemon group

echo "=== Creating directories ==="
mkdir -p /srv/torrents/tmp

echo "=== Changing owner ==="
chown -R debian-transmission:debian-transmission /srv/torrents

echo "=== Changing permissions ==="
find /srv/torrents -type d -print -exec chmod 775 {} \;
find /srv/torrents -type f -print -exec chmod 664 {} \;

echo "=== Editing config file ==="
SETTINGS=/etc/transmission-daemon/settings.json
TEMPORAL=/etc/transmission-daemon/temporal.json

cp $SETTINGS $SETTINGS.backup
jq '.["download-dir"]'='"/srv/torrents"' $SETTINGS > $TEMPORAL && mv $TEMPORAL $SETTINGS
jq '.["incomplete-dir"]'='"/srv/torrents/tmp"' $SETTINGS > $TEMPORAL && mv $TEMPORAL $SETTINGS
jq '.["rpc-authentication-required"]'='true' $SETTINGS > $TEMPORAL && mv $TEMPORAL $SETTINGS
jq '.["rpc-bind-address"]'='"0.0.0.0"' $SETTINGS > $TEMPORAL && mv $TEMPORAL $SETTINGS
jq '.["rpc-enabled"]'='true' $SETTINGS > $TEMPORAL && mv $TEMPORAL $SETTINGS
jq '.["rpc-password"]'='"TUPASSWORD"' $SETTINGS > $TEMPORAL && mv $TEMPORAL $SETTINGS
jq '.["rpc-port"]'='9091' $SETTINGS > $TEMPORAL && mv $TEMPORAL $SETTINGS
jq '.["rpc-url"]'='"/transmission/"' $SETTINGS > $TEMPORAL && mv $TEMPORAL $SETTINGS
jq '.["rpc-username"]'='"pi"' $SETTINGS > $TEMPORAL && mv $TEMPORAL $SETTINGS
jq '.["rpc-whitelist"]'='"0.0.0.0"' $SETTINGS > $TEMPORAL && mv $TEMPORAL $SETTINGS
jq '.["rpc-whitelist-enabled"]'='false' $SETTINGS > $TEMPORAL && mv $TEMPORAL $SETTINGS

service transmission-daemon start



