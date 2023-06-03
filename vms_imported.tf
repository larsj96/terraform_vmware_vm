# resource "vsphere_virtual_machine" "gitlabrunner1" {
#     resource_pool_id = data.vsphere_compute_cluster.compute_cluster.resource_pool_id
# }



#  # vsphere_virtual_machine.gitlab1:
#  resource "vsphere_virtual_machine" "gitlab1" {
#     resource_pool_id = data.vsphere_compute_cluster.compute_cluster.resource_pool_id
#  }


# # vsphere_virtual_machine.extlb1:
# resource "vsphere_virtual_machine" "extlb1" {
#     resource_pool_id = data.vsphere_compute_cluster.compute_cluster.resource_pool_id
# }