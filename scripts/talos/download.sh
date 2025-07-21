#!/usr/bin/env bash

PROJECT_ROOT=$(readlink -e "$(dirname $0)/../..")
TALOS_MEDIA_PATH="$PROJECT_ROOT/terraform/infra/talos"
# renovate: datasource=docker depName=ghcr.io/siderolabs/installer
TALOS_VERSION="v1.10.5"
TALOS_SCHEMATIC_ID="06e6f5ace9d08b7595be32a03d6d779b2149404e8a5d32011c0b02a1f36b0499"

if [[ ! -d $TALOS_MEDIA_PATH ]] then
    mkdir $TALOS_MEDIA_PATH
fi

curl -L "https://factory.talos.dev/image/$TALOS_SCHEMATIC_ID/$TALOS_VERSION/nocloud-amd64.raw.xz" | xz -d > "$TALOS_MEDIA_PATH/nocloud-amd64.raw"
