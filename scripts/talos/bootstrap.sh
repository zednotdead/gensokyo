#!/usr/bin/env bash

PROJECT_ROOT=$(readlink -e "$(dirname $0)/../..")
INFRA_PATH="$PROJECT_ROOT/infra"
RAW_ADDRESSES=$(cd $INFRA_PATH && tofu output -json | jq -rc .ip_addresses.value[] | sed 's/\/24//g')
declare -a ADDRESSES=($(echo $RAW_ADDRESSES | tr "\n" " "))

CONTROL_PLANE_IP=${ADDRESSES[0]}

talosctl config endpoint $CONTROL_PLANE_IP
talosctl config node $CONTROL_PLANE_IP
talosctl bootstrap
