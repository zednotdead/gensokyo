#!/usr/bin/env bash

PROJECT_ROOT=$(readlink -e "$(dirname $0)/../..")
TALOS_MEDIA_PATH="$PROJECT_ROOT/terraform/infra/talos"
# renovate: datasource=docker depName=ghcr.io/siderolabs/installer
TALOS_VERSION="v1.12.4"
TALOS_SCHEMATIC_ID="fa23e89863f791904fa30b723a158fc75d9a1d5e778277f832977b5b6968080c"

if [[ ! -d $TALOS_MEDIA_PATH ]] then
    mkdir $TALOS_MEDIA_PATH
fi

curl -L "https://factory.talos.dev/image/$TALOS_SCHEMATIC_ID/$TALOS_VERSION/nocloud-amd64.raw.xz" | xz -d > "$TALOS_MEDIA_PATH/nocloud-amd64.raw"
