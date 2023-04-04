# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

provider "vsphere" {
  vsphere_server = var.vsphere_server
  user           = var.vsphere_user
  password       = var.vsphere_password

  # If you have a self-signed cert
  allow_unverified_ssl = true
}

data "vsphere_datacenter" "dc" {
  name = var.datacenter
}

data "vsphere_compute_cluster" "cluster" {
  name          = var.cluster
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_datastore" "datastore" {
  name          = var.datastore
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_network" "network" {
  name          = var.network_name
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_virtual_machine" "windows" {
  name          = "/${var.datacenter}/vm/${var.windows_name}"
  datacenter_id = data.vsphere_datacenter.dc.id
}

resource "vsphere_virtual_machine" "WinTerra" {
  name             = "WinTerra-terraform"
  resource_pool_id = data.vsphere_compute_cluster.cluster.resource_pool_id
  datastore_id     = data.vsphere_datastore.datastore.id

  num_cpus = 4
  memory   = 8192

  network_interface {
    network_id = data.vsphere_network.network.id
  }

  scsi_type = "${data.vsphere_virtual_machine.windows.scsi_type}"

  wait_for_guest_net_timeout = -1
  wait_for_guest_ip_timeout  = -1

  disk {
    label            = "disk0"
    thin_provisioned = true
    size             = 48
  }

  guest_id = "windows9Server64Guest"

  clone {
    template_uuid = data.vsphere_virtual_machine.windows.id
  }
}

#output "vm_ip" {
#  value = vsphere_virtual_machine.WinTerra.guest_ip_addresses
#}
