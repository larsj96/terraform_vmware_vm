terraform {

  cloud {
    organization = "lanilsen"

    workspaces {
      name = "vmware_vm"
    }
  }
}