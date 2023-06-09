

# Fetch Network config (port group & vlan) from VMWARE_MGMT project / state, see data.tf

locals {
  fortigate = {
    fortigate = data.tfe_outputs.Homelabb-Fortigate.nonsensitive_values.networks.networks.subnets.fortigate_onprem_
  }

  fortigate_block = {
    for name, cidr_block in data.tfe_outputs.Homelabb-Fortigate.nonsensitive_values.networks.networks.subnets.fortigate_onprem_ : name => {
      name       = replace("${name}", "fortigate_onprem_", "") # replace("${each.key}", "fortigate_onprem_", "")
      cidr_block = cidr_block
    }
  }
}




locals {
  linux_vms = {
    intlb1 = {
      "num_cpus"  = "2"
      "memory"    = "8192"
      "portgroup" = "${local.fortigate_block.fortigate_onprem_internal_lb.name}"
      "disksize"  = 60
    }

        terraformtest1 = {
      "num_cpus"  = "2"
      "memory"    = "8192"
      "portgroup" = "${local.fortigate_block.fortigate_onprem_internal_lb.name}"
      "disksize"  = 60
    }

  }






  linux_vms_lindelabb = {

    martin123 = {
      "num_cpus"  = "2"
      "memory"    = "8192"
      "portgroup" = "${local.fortigate_block.fortigate_onprem_lindelab.name}"
      "disksize"  = 60
    }
    vpn01 = {
      "num_cpus"  = "2"
      "memory"    = "8192"
      "portgroup" = "${local.fortigate_block.fortigate_onprem_lindelab.name}"
      "disksize"  = 60
    }

  }



}



resource "vsphere_virtual_machine" "linux_vms" {
  for_each = local.linux_vms

  name         = each.key
  datastore_id = data.vsphere_datastore.nvme_hp3.id

  resource_pool_id = data.vsphere_compute_cluster.compute_cluster.resource_pool_id
  host_system_id   = data.vsphere_host.hp3.id

  datacenter_id = data.vsphere_datacenter.datacenter.id

  wait_for_guest_net_timeout = 0
  wait_for_guest_ip_timeout  = 0


  num_cpus = each.value.num_cpus
  memory   = each.value.memory

  network_interface {
    network_id = data.vsphere_network.networks["fortigate_onprem_${each.value.portgroup}"].id
  }
  cdrom {
    client_device = true
  }
  ovf_deploy {
    remote_ovf_url    = "https://cloud-images.ubuntu.com/focal/current/focal-server-cloudimg-amd64.ova"
    disk_provisioning = "thin"
  }

  disk {
    size             = each.value.disksize
    label            = "${each.key}.cmdk"
    thin_provisioned = true
  }
  vapp {
    properties = {
      hostname = "${each.key}"
      password = "vagrant"
      #  public-keys = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCz/JZYBglJD0gw7t+0dABSpnwNFxel+o0DjdHsxQki/mKXvSe9Ah/udCLXI1KZFLxoFHOJkcglFYBG3ht2LO2WfGKTbrTMVi8L7ly4ZuNvNACeMxPbxULKLLa4VCJdYgeM7BNk6N5VCzQbfexw7ULVoRhRfnawp9Y4DDZ1GaGW4bA3L+9KFPkLgIv6hn/tJGUdZDfyc60RaTArEcOeKbwxB2Ds5Y8fiVFrXCBV9UE6nr5OYqXftd6Y9Z5W4C69Qekus4IHNlktF1ofu4bZl2YlYC2MlhcRsU0txVnby3z0JqnfjpdrrO/hszKookivv+apMzdZq8on3ubg544wfv8zlbO/4nnM5oUmw2zD1BSOXsnsmg4CwRPAR/Znn2hu5YYQVWF0xegDSqMslBVu2vKIbgZa8gzJtYi+9/zeYBj9pW+/VfP3pjwZh9dqeTbz13KtMiOHuB2MNEp+eOUw+yvGhp2BbjWFaX0Xy+X5Q8V9TkbzqiDSqY7aUCdHOou1Xlc= ljn@DESKTOP-DFCHU80"
      user-data = base64encode(file("cloud-init.yml"))
    }
  }

  lifecycle {
    ignore_changes = [
      disk,
      guest_ip_addresses,
      ovf_deploy,
      vmware_tools_status
    ]
  }
}




resource "vsphere_virtual_machine" "linux_vms_lindelabb" {
  for_each = local.linux_vms_lindelabb

  name         = each.key
  datastore_id = data.vsphere_datastore.nvme_hp3.id

  resource_pool_id = data.vsphere_compute_cluster.compute_cluster.resource_pool_id
  host_system_id   = data.vsphere_host.hp3.id

    datacenter_id = data.vsphere_datacenter.datacenter.id


  wait_for_guest_net_timeout = 0
  wait_for_guest_ip_timeout  = 0


  num_cpus = each.value.num_cpus
  memory   = each.value.memory

  network_interface {
    network_id = data.vsphere_network.networks["fortigate_onprem_${each.value.portgroup}"].id
  }
  cdrom {
    client_device = true
  }
  ovf_deploy {
    remote_ovf_url    = "https://cloud-images.ubuntu.com/focal/current/focal-server-cloudimg-amd64.ova"
    disk_provisioning = "thin"
  }

  disk {
    size             = each.value.disksize
    label            = "${each.key}.cmdk"
    thin_provisioned = true
  }
  vapp {
    properties = {
      hostname = "${each.key}"
      password = "vagrant"
      #  public-keys = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCz/JZYBglJD0gw7t+0dABSpnwNFxel+o0DjdHsxQki/mKXvSe9Ah/udCLXI1KZFLxoFHOJkcglFYBG3ht2LO2WfGKTbrTMVi8L7ly4ZuNvNACeMxPbxULKLLa4VCJdYgeM7BNk6N5VCzQbfexw7ULVoRhRfnawp9Y4DDZ1GaGW4bA3L+9KFPkLgIv6hn/tJGUdZDfyc60RaTArEcOeKbwxB2Ds5Y8fiVFrXCBV9UE6nr5OYqXftd6Y9Z5W4C69Qekus4IHNlktF1ofu4bZl2YlYC2MlhcRsU0txVnby3z0JqnfjpdrrO/hszKookivv+apMzdZq8on3ubg544wfv8zlbO/4nnM5oUmw2zD1BSOXsnsmg4CwRPAR/Znn2hu5YYQVWF0xegDSqMslBVu2vKIbgZa8gzJtYi+9/zeYBj9pW+/VfP3pjwZh9dqeTbz13KtMiOHuB2MNEp+eOUw+yvGhp2BbjWFaX0Xy+X5Q8V9TkbzqiDSqY7aUCdHOou1Xlc= ljn@DESKTOP-DFCHU80"
      user-data = base64encode(file("lindelab_cloud-init.yml"))
    }
  }

  lifecycle {
    ignore_changes = [
      disk,
      guest_ip_addresses,
      ovf_deploy,
      vmware_tools_status
    ]
  }
}