provider "vsphere" {
  #allow_unverified_ssl = var.allow_unverified_ssl
  allow_unverified_ssl = true
}

provider "tfe" {
  # Add any required provider arguments here
}
