data "vsphere_datacenter" "datacenter" {
  name = "datacenter"
}



data "tfe_outputs" "Homelabb-Fortigate" {

  organization = "lanilsen"
  workspace    = "fortigate"
}

locals {
  vlans = data.tfe_outputs.Homelabb-Fortigate.nonsensitive_values
}


data "vsphere_host" "hp2" {
  name          = "hp2.mgmt.nilsen-tech.com"
  datacenter_id = data.vsphere_datacenter.datacenter.id
}


data "vsphere_host" "hp3" {
  name          = "hp3.mgmt.nilsen-tech.com"
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

data "vsphere_datastore" "nvme_hp2" {
  name          = "nvme_hp2"
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

data "vsphere_datastore" "nvme_hp3" {
  name          = "nvme_hp3"
  datacenter_id = data.vsphere_datacenter.datacenter.id
}



data "vsphere_compute_cluster" "compute_cluster" {
  name          = "hp"
  datacenter_id = data.vsphere_datacenter.datacenter.id
}



data "vsphere_network" "networks" {
  for_each = data.tfe_outputs.Homelabb-Fortigate.nonsensitive_values.networks.networks.subnets.fortigate_onprem_

  name          = replace("${each.key}", "fortigate_onprem_", "")
  datacenter_id = data.vsphere_datacenter.datacenter.id

}



data "vsphere_virtual_machine" "windowstemplate" {
  name          = "win2022std"
  datacenter_id = data.vsphere_datacenter.datacenter.id
}