#!/bin/bash

source /usr/share/mynode/mynode_device_info.sh
source /usr/share/mynode/mynode_app_versions.sh

set -x
set -e

echo "==================== INSTALLING APP ===================="
# export bitcoin password
BTCPSW=$(sudo cat /mnt/hdd/mynode/settings/.btcrpcpw)

# update repo and install libs
sudo apt update
sudo apt install cmake pkgconf libcurl4-openssl-dev libjansson-dev libmicrohttpd-dev libsodium-dev psmisc -y

# build datum
cd datum_gateway-0.2.2beta/
cmake . && make

# install datum
sudo mkdir -p /opt/mynode/datum/
sudo mv datum_gateway /opt/mynode/datum/
sudo touch /opt/mynode/datum/datum_config.json

# give right permission
sudo chown -R datum:datum /opt/mynode/datum/


echo "================== DONE INSTALLING APP ================="