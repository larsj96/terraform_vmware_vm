

# # Windows DNS records
# resource "dns_a_record_set" "windows-dns-forward" {
#   for_each = var.windows_vms

#   zone      = "nilsen-tech.com."
#   name      = each.key
#   addresses = [each.value.network_interface.ipv4_address]
#   ttl       = 60
# }


# # DNS records for linux - on bind
# resource "dns_a_record_set" "linux-dns-forward" {
#   for_each = vsphere_virtual_machine.linux_vms

#   zone      = "home.nilsen-tech.com."
#   name      = each.value.name
#   addresses = [each.value.default_ip_address]
#   ttl       = 60
# }


# https://floating.io/2019/04/iaas-terraform-and-vsphere/ for reverse lookup .. ? 
