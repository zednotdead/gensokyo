#!/usr/bin/env bash

PROJECT_ROOT=$(readlink -e "$(dirname $0)/../..")
TALOS_MEDIA_PATH="$PROJECT_ROOT/infra/talos"

if [[ ! -d $TALOS_MEDIA_PATH ]] then
    mkdir $TALOS_MEDIA_PATH
fi

wget "https://github.com/siderolabs/talos/releases/download/v1.6.7/nocloud-amd64.raw.xz" -c \
    -O "$TALOS_MEDIA_PATH/nocloud-amd64.raw.xz"

if [[ ! -f "$TALOS_MEDIA_PATH/nocloud-amd64.raw.xz" ]] then
    echo "Could not get the Talos install media - it probably failed to download."
    exit 1
fi

xz -d -c "$TALOS_MEDIA_PATH/nocloud-amd64.raw.xz" > "$TALOS_MEDIA_PATH/nocloud-amd64.raw"
