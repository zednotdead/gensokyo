#!/usr/bin/env bash

PROJECT_ROOT=$(readlink -e "$(dirname $0)/../..")
if [[ -d "$PROJECT_ROOT/_out" ]] then
    echo -e "A config already exists! Remove it with\n\n\trm -rf _out\n\nOr don't, because something else might have gone wrong."
    exit 1
fi

INFRA_PATH="$PROJECT_ROOT/terraform/infra"
RAW_ADDRESSES=$(cd $INFRA_PATH && tofu output -json | jq -rc .ip_addresses.value[] | sed 's/\/24//g')
declare -a ADDRESSES=($(echo $RAW_ADDRESSES | tr "\n" " "))

CONTROL_PLANE_IP=${ADDRESSES[0]}

echo "[INFO] Generating a config for the cluster connecting to $CONTROL_PLANE_IP"

talosctl gen config gensokyo https://$CONTROL_PLANE_IP:6443 \
    --output-dir _out \
    --config-patch-control-plane @$INFRA_PATH/patch/allow-worker-on-control-plane.yaml

