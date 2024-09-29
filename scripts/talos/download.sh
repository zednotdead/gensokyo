#!/usr/bin/env bash

PROJECT_ROOT=$(readlink -e "$(dirname $0)/../..")
TALOS_MEDIA_PATH="$PROJECT_ROOT/terraform/infra/talos"
# renovate: datasource=docker depName=ghcr.io/siderolabs/installer
TALOS_VERSION="v1.8.0"

if [[ ! -d $TALOS_MEDIA_PATH ]] then
    mkdir $TALOS_MEDIA_PATH
fi

curl -L "https://factory.talos.dev/image/900748ce495285fc709caacfff7df8d547014ad94d7e4f130c4d6d56fe933e26/$TALOS_VERSION/nocloud-amd64.raw.xz" | xz -d > "$TALOS_MEDIA_PATH/nocloud-amd64.raw"
