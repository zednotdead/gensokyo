#!/usr/bin/env bash

if [[ ! -f /usr/sbin/pveum ]] then
    echo "pveum does not exist"
    exit 1
fi

pveum role add TerraformProv -privs "Datastore.AllocateSpace Datastore.Allocate Datastore.Audit Datastore.AllocateTemplate Pool.Allocate Sys.Audit Sys.Console Sys.Modify VM.Allocate VM.Audit VM.Clone VM.Config.CDROM VM.Config.Cloudinit VM.Config.CPU VM.Config.Disk VM.Config.HWType VM.Config.Memory VM.Config.Network VM.Config.Options VM.Migrate VM.Monitor VM.PowerMgmt SDN.Use"
pveum user add $1 --password $2
pveum aclmod / -user $1 -role TerraformProv
