terraform {
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = "0.51.1"
    }
    local = {
      source  = "hashicorp/local"
      version = "2.5.1"
    }
  }
}

provider "local" {}

locals {
  ssh_path = "~/.ssh/id_ed25519"
}

provider "proxmox" {
  endpoint = "https://192.168.1.50:8006/"
  insecure = true

  ssh {
    agent       = false
    username    = "root"
    private_key = file(local.ssh_path)
  }
}

locals {
  config = yamldecode(file("../config.yaml"))
  hosts  = local.config.bootstrap_node_inventory
}


resource "proxmox_virtual_environment_file" "talos_iso" {
  for_each = {
    for index, node in local.hosts :
    node.node_name => node
  }
  content_type = "iso"
  datastore_id = "local"
  node_name    = each.value.node_name
  # url          = "https://github.com/siderolabs/talos/releases/download/v1.7.0-beta.0/nocloud-amd64.raw.xz"
  source_file {
    path      = "./talos/nocloud-amd64.raw"
    file_name = "nocloud-amd64.img"
  }
}

resource "proxmox_virtual_environment_vm" "talos_vm" {
  for_each = {
    for index, node in local.hosts :
    node.node_name => node
  }
  vm_id     = each.value.vmid
  name      = each.value.name
  node_name = each.value.node_name
  tags      = ["kubernetes", "talos"]

  initialization {
    user_account {
      username = "admin"
      keys     = [trimspace(file(format("%s.pub", local.ssh_path)))]
    }

    ip_config {
      ipv4 {
        address = format("%s/24", each.value.address)
        gateway = "192.168.1.1"
      }
    }
  }

  memory {
    dedicated = 8192
  }

  cpu {
    type  = "host"
    cores = 4
  }

  disk {
    interface    = "scsi0"
    size         = 40
    datastore_id = each.value.node_name == "asterix" ? "data-nvme" : "local-lvm"
    file_id      = resource.proxmox_virtual_environment_file.talos_iso[each.value.node_name].id
    discard      = "on"
  }

  disk {
    interface    = "scsi1"
    file_format  = "raw"
    size         = 100
    datastore_id = each.value.node_name == "asterix" ? "data-nvme" : "local-lvm"
  }

  network_device {
    bridge = "vmbr0"
    mac_address = each.value.talos_nic
  }
}
