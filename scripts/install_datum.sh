#!/bin/bash

source /usr/share/mynode/mynode_device_info.sh
source /usr/share/mynode/mynode_app_versions.sh

set -x
set -e

echo \"==================== INSTALLING APP ====================\"

# export bitcoin password
BTCPSW=$(cat /mnt/hdd/mynode/settings/.btcrpcpw)

# update repo and install libs
sudo apt update
sudo apt install cmake pkgconf libcurl4-openssl-dev libjansson-dev libmicrohttpd-dev libsodium-dev psmisc -y

# verify datum
#if [ "$(uname -m)" = "arm64" ]; then
#  echo "36635ce616117f5e0290270dfb201f7d6c5d755db4145a78b44962a32bc97077  datum_gateway" | sha256sum -c -
#fi
#
#if [ "$(uname -m)" = "x86_64" ]; then
#  echo "7bb738a2b30eb1939cfd74d0ff937e09e1f466bad223327deb1647c57803ba98  datum_gateway" | sha256sum -c -
#fi

# install datum
touch /opt/mynode/datum/datum_config.json
echo "{
  \"bitcoind\": {
    \"rpcuser\": \"mynode\",
    \"rpcpassword\": \"auto-config\",
    \"rpcurl\": \"127.0.0.1:8332\",
    \"work_update_seconds\": 40
  },
  \"api\": {
    \"listen_port\": 21000
  },
  \"mining\": {
    \"pool_address\": \"enter your bitcoin address if you solo mine\",
    \"coinbase_tag_primary\": \"DATUM on mynode\",
    \"coinbase_tag_secondary\": \"DATUM on mynode\",
    \"coinbase_unique_id\": 120
  },
  \"stratum\": {
    \"listen_port\": 23334,
    \"max_clients_per_thread\": 1000,
    \"max_threads\": 8,
    \"max_clients\": 2048,
    \"vardiff_min\": 16384,
    \"vardiff_target_shares_min\": 8,
    \"vardiff_quickdiff_count\": 8,
    \"vardiff_quickdiff_delta\": 8,
    \"share_stale_seconds\": 120,
    \"fingerprint_miners\": true
  },
  \"logger\": {
    \"log_level_console\": 2
  },
  \"datum\": {
    \"pool_host\": \"datum-beta1.mine.ocean.xyz\",
    \"pool_port\": 28915,
    \"pool_pubkey\": \"f21f2f0ef0aa1970468f22bad9bb7f4535146f8e4a8f646bebc93da3d89b1406f40d032f09a417d94dc068055df654937922d2c89522e3e8f6f0e649de473003\",
    \"pool_pass_workers\": true,
    \"pool_pass_full_users\": true,
    \"always_pay_self\": true,
    \"pooled_mining_only\": true
  }
}
" >> /opt/mynode/datum/datum_config.json

jq --arg BTCPSW "$BTCPSW" '.bitcoind.rpcpassword = $BTCPSW' /opt/mynode/datum/datum_config.json > /opt/mynode/datum/datum_config.json.tmp && mv /opt/mynode/datum/datum_config.json.tmp /opt/mynode/datum/datum_config.json


# give right permission
chown -R bitcoin:bitcoin /opt/mynode/datum/


echo \"================== DONE INSTALLING APP =================\"