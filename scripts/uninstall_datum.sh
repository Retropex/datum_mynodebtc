#!/bin/bash

source /usr/share/mynode/mynode_device_info.sh
source /usr/share/mynode/mynode_app_versions.sh

echo "==================== UNINSTALLING APP ===================="

sudo rm -rf /opt/mynode/datum/

echo "================== DONE UNINSTALLING APP ================="
