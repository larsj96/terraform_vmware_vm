data "vsphere_datacenter" "datacenter" {
  name = "datacenter"
}



data "terraform_remote_state" "Homelabb-Fortigate" {
  backend = "http"

  config = { # this is the state for FORTIGATE project
    address = "http://10.0.0.130/api/v4/projects/2/terraform/state/main" # TF_HTTP_ADDRESS env variable
    username = "terraform"
  #  password = "XXXXXXXX"
  }
}

locals {
  vlans = data.terraform_remote_state.Homelabb-Fortigate.outputs
}


data "vsphere_host" "hp3" {
  name          = "hp3.mgmt.nilsen-tech.com"
  datacenter_id = data.vsphere_datacenter.datacenter.id
}


data "vsphere_datastore" "datastore1" {
  name          = "nvme_hp3"
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

data "vsphere_resource_pool" "pool" {
  # Resources is the invisible pool of the ESXI host
  name = "hp3.mgmt.nilsen-tech.com/Resources"
  #check to use moid if issues
  datacenter_id = data.vsphere_datacenter.datacenter.id
}


data "vsphere_network" "networks" {
  for_each = data.terraform_remote_state.Homelabb-Fortigate.outputs.networks.networks.subnets.fortigate_onprem_

  name          = replace("${each.key}", "fortigate_onprem_", "")
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

