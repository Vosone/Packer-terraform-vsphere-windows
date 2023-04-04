# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

source "vsphere-iso" "this" {
  vcenter_server    = var.vsphere_server
  username          = var.vsphere_user
  password          = var.vsphere_password
  datacenter        = var.datacenter
  cluster           = var.cluster
  insecure_connection  = true
  communicator = "winrm"
  winrm_username = "Administrator"
  winrm_password = "mypassword"
  
  convert_to_template = true

  vm_name = "Windows Server Terra"
  guest_os_type = "windows9Server64Guest"

  CPUs =             2
  RAM =              4096
  RAM_reserve_all = true
  

  disk_controller_type =  ["lsilogic-sas"]

  datastore = var.datastore

  storage {
    disk_size =        48384
    disk_thin_provisioned = true
  }

  shutdown_command = "shutdown /s /t 5"

  iso_paths = [
     "[datastore1] Source/17763.3650.221105-1748.rs5_release_svc_refresh_SERVER_EVAL_x64FRE_en-us.iso",
     "[] /vmimages/tools-isoimages/windows.iso"
  ]

  network_adapters {
    network =  var.network_name
    network_card = "vmxnet3"
  }


  floppy_files = [
     "autounattend.xml",
     "scripts/disable-network-discovery.cmd",
     "scripts/disable-server-manager.ps1",
     "scripts/enable-rdp.cmd",
     "scripts/enable-winrm.ps1",
     "scripts/install-vm-tools.cmd",
     "scripts/set-temp.ps1"
  ]
}

build {
  sources  = [
    "source.vsphere-iso.this"
  ]

  provisioner "windows-shell" {
    inline  = ["ipconfig /all"]
  }
}
