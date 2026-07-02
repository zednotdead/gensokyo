terraform {
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = "0.103.0"
    }
    local = {
      source  = "hashicorp/local"
      version = "2.5.3"
    }
  }
}

variable "talos_url" {
  type = string
  description = "Talos URL generated with talhelper"
}

provider "local" {}

locals {
  ssh_path = "~/.ssh/id_ed25519"
}

provider "proxmox" {
  endpoint = "https://10.0.1.2:8006/"
  username = "root@pam"
  insecure = true

  ssh {
    agent       = true
    username    = "root"
    private_key = file(local.ssh_path)
  }
}

locals {
  hosts = [
    # { node_name = "asterix", vmid = 9001, mac_address = "bc:24:11:c4:51:d9", name = "talos-01", address = "10.0.10.1", memory = 24 * 1024 },
    { node_name = "marisa", vmid = 9001, mac_address = "02:f9:53:56:3e:a8", name = "talos-01", address = "10.0.10.1", memory = 32 * 1024 },
    { node_name = "reimu", vmid = 9002, mac_address = "bc:24:11:52:a9:e5", name = "talos-02", address = "10.0.10.2", memory = 24 * 1024, gpu_address = "0000:09:00.0" },
  ]
}

resource "proxmox_download_file" "talos_iso" {
  for_each = {
    for index, node in local.hosts :
    node.name => node
  }
  content_type = "iso"
  datastore_id = "local"
  node_name    = each.value.node_name

  url = var.talos_url
  overwrite = false
  decompression_algorithm = "zst"

  file_name = "nocloud-amd64.img"
}

resource "proxmox_virtual_environment_vm" "talos_vm" {
  for_each = {
    for index, node in local.hosts :
    node.name => node
  }
  vm_id     = each.value.vmid
  name      = each.value.name
  node_name = each.value.node_name
  machine   = "q35"
  bios      = "seabios"
  tags      = ["kubernetes", "talos"]

  initialization {
    user_account {
      username = "admin"
      keys     = [trimspace(file(format("%s.pub", local.ssh_path)))]
    }

    ip_config {
      ipv4 {
        address = format("%s/16", each.value.address)
        gateway = "10.0.0.1"
      }
    }
  }

  memory {
    dedicated = each.value.memory
  }

  cpu {
    type  = "host"
    cores = each.value.node_name == "reimu" ? 8 : each.value.node_name == "marisa" ? 24 : 4
  }

  disk {
    datastore_id = each.value.node_name == "asterix" ? "data-nvme" : "local-lvm"
    file_format  = "raw"
    interface    = "scsi0"
    size         = 60
    file_id      = resource.proxmox_download_file.talos_iso[each.value.name].id
    discard      = "on"
  }

  disk {
    interface    = "scsi1"
    file_format  = "raw"
    size         = each.value.node_name == "reimu" ? 80 : 150
    datastore_id = each.value.node_name == "asterix" ? "data-nvme" : each.value.node_name == "marisa" ? "bulk-data" : "local-lvm"
  }
  #
  # efi_disk {
  #   datastore_id = each.value.node_name == "asterix" ? "data-nvme" : "local-lvm"
  #   type         = "4m"
  #   file_format  = "raw"
  # }
  #
  network_device {
    bridge      = "vmbr0"
    mac_address = upper(each.value.mac_address)
  }

  dynamic "hostpci" {
    for_each = try(each.value.gpu_address, null) == null ? [] : [each.value.node_name]
    content {
      pcie   = true
      device = "hostpci0"
      id     = each.value.gpu_address
    }
  }
}
