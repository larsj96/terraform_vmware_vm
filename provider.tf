provider "vsphere" {
  user           = var.vsphere_user
  password       = var.vsphere_password
  vsphere_server = var.vsphere_server

  # If you have a self-signed cert

  #allow_unverified_ssl = var.allow_unverified_ssl
  allow_unverified_ssl = true
}



# # BIDN DNS
#  provider "dns" {
#    update {
#      server        = "10.0.0.67"
#    #  port          = "5353"
#      key_name      = "terraform."
#      key_algorithm = "hmac-md5"
#      key_secret    = "XXXXXXXXXXX="
#    }
#  }


#  provider "dns" {
#   update {
#     server        = "10.0.0.66"
#     key_name      = "home.nilsen-tech.com."
#     key_algorithm = "hmac-md5"
#     key_secret    = "XXXXXXXXXXX="
#   }

#   alias = "pdns"
# }