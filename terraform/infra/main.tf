terraform {
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = "0.84.1"
    }
    local = {
      source  = "hashicorp/local"
      version = "2.5.3"
    }
  }
}

provider "local" {}

locals {
  ssh_path = "~/.ssh/id_ed25519"
}

provider "proxmox" {
  endpoint = "https://10.0.1.1:8006/"
  insecure = true

  ssh {
    agent       = false
    username    = "root"
    private_key = file(local.ssh_path)
  }
}

locals {
  config = yamldecode(file("../../nodes.yaml"))
  hosts  = local.config.nodes
}

resource "proxmox_virtual_environment_file" "talos_iso" {
  for_each = {
    for index, node in local.hosts :
    node.name => node
  }
  content_type = "iso"
  datastore_id = "local"
  node_name    = each.value.node_name
  source_file {
    path      = "./talos/nocloud-amd64.raw"
    file_name = "nocloud-amd64.img"
  }
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
    cores = 4
  }

  disk {
    datastore_id = each.value.node_name == "asterix" ? "data-nvme" : "local-lvm"
    file_format  = "raw"
    interface    = "scsi0"
    size         = 40
    file_id      = resource.proxmox_virtual_environment_file.talos_iso[each.value.name].id
    discard      = "on"
  }

  disk {
    interface    = "scsi1"
    file_format  = "raw"
    size         = each.value.node_name == "reimu" ? 50 : 150
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
    mac_address = upper(each.value.mac_addr)
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
