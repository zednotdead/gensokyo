#!/usr/bin/env bash

PROJECT_ROOT=$(readlink -e "$(dirname $0)/../..")
TALOS_MEDIA_PATH="$PROJECT_ROOT/terraform/infra/talos"
# renovate: datasource=docker depName=ghcr.io/siderolabs/installer
TALOS_VERSION="v1.10.5"
TALOS_SCHEMATIC_ID="c922b1884dbba1e8df59bc0d971cf78a47af3487863a4e08c9ecbc5158d4a8d6"

if [[ ! -d $TALOS_MEDIA_PATH ]] then
    mkdir $TALOS_MEDIA_PATH
fi

curl -L "https://factory.talos.dev/image/$TALOS_SCHEMATIC_ID/$TALOS_VERSION/nocloud-amd64.raw.xz" | xz -d > "$TALOS_MEDIA_PATH/nocloud-amd64.raw"
