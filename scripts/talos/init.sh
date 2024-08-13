#!/usr/bin/env bash

PROJECT_ROOT=$(readlink -e "$(dirname $0)/../..")
INFRA_PATH="$PROJECT_ROOT/terraform/infra"
RAW_ADDRESSES=$(cd $INFRA_PATH && tofu output -json | jq -rc .ip_addresses.value[] | sed 's/\/24//g')

declare -a ADDRESSES=($(echo $RAW_ADDRESSES | tr "\n" " "))

for node_address in ${ADDRESSES[@]}; do
    talosctl apply-config --insecure --nodes $node_address --file "$PROJECT_ROOT/_out/controlplane.yaml"
done
