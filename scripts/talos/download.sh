#!/usr/bin/env bash

PROJECT_ROOT=$(readlink -e "$(dirname $0)/../..")
TALOS_MEDIA_PATH="$PROJECT_ROOT/terraform/infra/talos"
# renovate: datasource=docker depName=ghcr.io/siderolabs/installer
TALOS_VERSION="v1.9.1"

if [[ ! -d $TALOS_MEDIA_PATH ]] then
    mkdir $TALOS_MEDIA_PATH
fi

curl -L "https://factory.talos.dev/image/08079c6f79b249205d2822eeb0f4dcc53c0e1481dd0d9cb29b6099a05ec45057/$TALOS_VERSION/nocloud-amd64.raw.xz" | xz -d > "$TALOS_MEDIA_PATH/nocloud-amd64.raw"
