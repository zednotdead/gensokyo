#!/usr/bin/env bash

PROJECT_ROOT=$(readlink -e "$(dirname $0)/../..")
TALOS_MEDIA_PATH="$PROJECT_ROOT/infra/talos"

if [[ ! -d $TALOS_MEDIA_PATH ]] then
    mkdir $TALOS_MEDIA_PATH
fi

curl -L "https://github.com/siderolabs/talos/releases/download/v1.7.5/nocloud-amd64.raw.xz" | xz -d > "$TALOS_MEDIA_PATH/nocloud-amd64.raw"
