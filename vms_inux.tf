

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

    # docker1 = {
    #   "num_cpus"  = "4"
    #   "memory"    = "32192"
    #   "portgroup" = "${local.fortigate_block.fortigate_onprem_k8s.name}"
    #   "disksize"  = 60
    # }

    # k8s_master1 = {
    #   "num_cpus"  = "4"
    #   "memory"    = "32192"
    #   "portgroup" = "${local.fortigate_block.fortigate_onprem_k8s.name}"
    #   "disksize"  = 60
    # }

    # k8s_worker1 = {
    #   "num_cpus"  = "4"
    #   "memory"    = "32192"
    #   "portgroup" = "${local.fortigate_block.fortigate_onprem_k8s.name}"
    #   "disksize"  = 60
    # }
    # k8s_worker2 = {
    #   "num_cpus"  = "4"
    #   "memory"    = "32192"
    #   "portgroup" = "${local.fortigate_block.fortigate_onprem_k8s.name}"
    #   "disksize"  = 60
    # }

    # gitlab1 = {
    #   "num_cpus"  = "2"
    #   "memory"    = "8192"
    #   "portgroup" = "${local.fortigate_block.fortigate_onprem_gitlab.name}"
    #   "disksize"  = 60
    # }

    #   gitlabrunner1 = {
    #   "num_cpus"  = "2"
    #   "memory"    = "8192"
    #   "portgroup" = "${local.fortigate_block.fortigate_onprem_bastion.name}"
    #   "disksize"  = 60
    # }

    #   secunion1 = {
    #   "num_cpus"  = "4"
    #   "memory"    = "32192"
    #   "portgroup" = "${local.fortigate_block.fortigate_onprem_bastion.name}"
    #   "disksize"  = 60
    # }
    #   plex1 = {
    #   "num_cpus"  = "8"
    #   "memory"    = "32192"
    #   "portgroup" = "${local.fortigate_block.fortigate_onprem_plex.name}"
    #   "disksize"  = 60
    # }

    #   intlb1 = {
    #   "num_cpus"  = "2"
    #   "memory"    = "8192"
    #   "portgroup" = "${local.fortigate_block.fortigate_onprem_internal_lb.name}"
    #   "disksize"  = 60
    # }
    #   extlb1 = {
    #   "num_cpus"  = "2"
    #   "memory"    = "8192"
    #   "portgroup" = "${local.fortigate_block.fortigate_onprem_external_lb.name}"
    #   "disksize"  = 60
    # }

    #   openvpn1 = {
    #   "num_cpus"  = "2"
    #   "memory"    = "8192"
    #   "portgroup" = "${local.fortigate_block.fortigate_onprem_sslvpn.name}"
    #   "disksize"  = 60
    # }
  }
}








# resource "vsphere_virtual_machine" "linux_vms" {
#   for_each = local.linux_vms

#   name             = each.key
#   resource_pool_id = data.vsphere_resource_pool.pool.id
#   datastore_id     = data.vsphere_datastore.datastore1.id
#   datacenter_id    = data.vsphere_datacenter.datacenter.id
#   host_system_id   = data.vsphere_host.hp3.id

#   wait_for_guest_net_timeout = 0
#   wait_for_guest_ip_timeout  = 0


#   num_cpus = each.value.num_cpus
#   memory   = each.value.memory

#   network_interface {
#     network_id = data.vsphere_network.networks["fortigate_onprem_${each.value.portgroup}"].id
#   }
#   cdrom {
#     client_device = true
#   }
#   ovf_deploy {
#     remote_ovf_url    = "https://cloud-images.ubuntu.com/focal/current/focal-server-cloudimg-amd64.ova"
#     disk_provisioning = "thin"
#   }

#   disk {
#     size             = each.value.disksize
#     label            = "${each.key}.cmdk"
#     thin_provisioned = true
#   }
#   vapp {
#     properties = {
#       hostname = "${each.key}"
#       password = "vagrant"
#       #  public-keys = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCz/JZYBglJD0gw7t+0dABSpnwNFxel+o0DjdHsxQki/mKXvSe9Ah/udCLXI1KZFLxoFHOJkcglFYBG3ht2LO2WfGKTbrTMVi8L7ly4ZuNvNACeMxPbxULKLLa4VCJdYgeM7BNk6N5VCzQbfexw7ULVoRhRfnawp9Y4DDZ1GaGW4bA3L+9KFPkLgIv6hn/tJGUdZDfyc60RaTArEcOeKbwxB2Ds5Y8fiVFrXCBV9UE6nr5OYqXftd6Y9Z5W4C69Qekus4IHNlktF1ofu4bZl2YlYC2MlhcRsU0txVnby3z0JqnfjpdrrO/hszKookivv+apMzdZq8on3ubg544wfv8zlbO/4nnM5oUmw2zD1BSOXsnsmg4CwRPAR/Znn2hu5YYQVWF0xegDSqMslBVu2vKIbgZa8gzJtYi+9/zeYBj9pW+/VfP3pjwZh9dqeTbz13KtMiOHuB2MNEp+eOUw+yvGhp2BbjWFaX0Xy+X5Q8V9TkbzqiDSqY7aUCdHOou1Xlc= ljn@DESKTOP-DFCHU80"
#       user-data = base64encode(file("cloud-init.yml"))
#     }
#   }

#   lifecycle {
#     ignore_changes = [
#       disk,
#       guest_ip_addresses,
#       ovf_deploy,
#       vmware_tools_status
#     ]
#   }
# }






# resource "vsphere_virtual_machine" "linux_vm" {
#   for_each         = var.linux_vms
#   name             = each.key
#   resource_pool_id = data.vsphere_compute_cluster.compute_cluster.resource_pool_id
#   # datastore_id     = data.vsphere_datastore.datastore.id

#   datastore_cluster_id = data.vsphere_datastore_cluster.datastore_cluster.id

#   num_cpus = each.value.num_cpus
#   memory   = each.value.memory

#   guest_id  = data.vsphere_virtual_machine.linuxtemplate[each.key].guest_id
#   scsi_type = data.vsphere_virtual_machine.linuxtemplate[each.key].scsi_type

#   network_interface {
#     network_id   = data.vsphere_network.linux_network[each.key].id
#     adapter_type = data.vsphere_virtual_machine.linuxtemplate[each.key].network_interface_types[0]
#   }

#   disk {
#     label            = "disk0"
#     size             = data.vsphere_virtual_machine.linuxtemplate[each.key].disks.0.size
#     thin_provisioned = data.vsphere_virtual_machine.linuxtemplate[each.key].disks.0.thin_provisioned

#   }
#   clone {
#     template_uuid = data.vsphere_virtual_machine.linuxtemplate[each.key].id
#     customize {
#       linux_options {
#         host_name = each.key
#         domain    = "nilsen-tech.com"
#       }
#       network_interface {
#         ipv4_address = each.value.network_interface.ipv4_address
#         ipv4_netmask = each.value.network_interface.ipv4_netmask
#       }
#       ipv4_gateway = each.value.network_interface.ipv4_gateway
#       # dns_server_list = [each.value.network_interface.ipv4_dns_servers]
#       dns_server_list = [each.value.network_interface.ipv4_dns_servers]

#     }
#   }

#   lifecycle {
#     ignore_changes = [disk]
#   }

# }
