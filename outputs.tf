output "networks_from_fortigate_tf" {
  value = local.vlans.networks.networks.subnets.fortigate_onprem_
}

output "all_ips" {
  value = { for vm in keys(vsphere_virtual_machine.linux_vms) : vm => vsphere_virtual_machine.linux_vms[vm].default_ip_address }
}