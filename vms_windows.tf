locals {
  windows_vms = {
    win-nessus01 = {
      "num_cpus"  = "8"
      "memory"    = "64192"
      "portgroup" = "${local.fortigate_block.fortigate_onprem_nessus.name}"
      "disksize"  = 60
    }

    win-veeam01 = {
      "num_cpus"  = "4"
      "memory"    = "32192"
      "portgroup" = "${local.fortigate_block.fortigate_onprem_bastion.name}"
      "disksize"  = 80
    }

      win-dc01 = {
      "num_cpus"  = "4"
      "memory"    = "32192"
      "portgroup" = "${local.fortigate_block.fortigate_onprem_ad.name}"
      "disksize"  = 60
    }
       win-exchange01 = {
      "num_cpus"  = "4"
      "memory"    = "32192"
      "portgroup" = "${local.fortigate_block.fortigate_onprem_exchange.name}"
      "disksize"  = 60
    }

    win-winbast01 = {
      "num_cpus"  = "4"
      "memory"    = "32192"
      "portgroup" = "${local.fortigate_block.fortigate_onprem_bastion.name}"
      "disksize"  = 60
    }




  }
}





output "vm_windows" {
  value = local.windows_vms
}



resource "vsphere_virtual_machine" "windows_vm" {
  for_each = local.windows_vms

  name             = each.key
  resource_pool_id = data.vsphere_compute_cluster.compute_cluster.resource_pool_id
  datastore_id     = data.vsphere_datastore.nvme_hp2.id


  wait_for_guest_net_timeout = 0
  wait_for_guest_ip_timeout  = 0


  num_cpus = each.value.num_cpus
  memory   = each.value.memory

  network_interface {
     network_id = data.vsphere_network.networks["fortigate_onprem_${each.value.portgroup}"].id
    adapter_type = "vmxnet3"
  }


  cpu_hot_add_enabled    = "true"
  cpu_hot_remove_enabled = "true"
  memory_hot_add_enabled = "true"

  guest_id  = data.vsphere_virtual_machine.windowstemplate.guest_id
  scsi_type = data.vsphere_virtual_machine.windowstemplate.scsi_type


  firmware = "efi"

  disk {
    label            = "disk0"
    size             = data.vsphere_virtual_machine.windowstemplate.disks.0.size
    eagerly_scrub    = data.vsphere_virtual_machine.windowstemplate.disks.0.eagerly_scrub
    thin_provisioned = data.vsphere_virtual_machine.windowstemplate.disks.0.thin_provisioned
  }

  clone {
    template_uuid = data.vsphere_virtual_machine.windowstemplate.id
    customize {
      windows_options {
        computer_name = each.key
        # admin_password = var.admin_password
      }
      network_interface {
      }
    }
  }
}