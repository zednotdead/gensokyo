#!/usr/bin/env bash

PROJECT_ROOT=$(readlink -e "$(dirname $0)/../..")
TALOS_MEDIA_PATH="$PROJECT_ROOT/infra/talos"

if [[ ! -d $TALOS_MEDIA_PATH ]] then
    mkdir $TALOS_MEDIA_PATH
fi

curl "https://factory.talos.dev/image/ebdfa27a8d6272acf806ac6a5c968c3c284a47ce880273cecb19442c11bf0474/v1.7.0-beta.1/metal-amd64.raw.xz" | xz -d > "$TALOS_MEDIA_PATH/nocloud-amd64.raw"
