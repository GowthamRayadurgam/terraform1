variable "resource_group_name" {
}


# https://learn.microsoft.com/en-us/azure/private-link/private-endpoint-dns#virtual-network-and-on-premises-workloads-using-a-dns-forwarder 
#-- must follow above naming conventions for pvt dns zone name

variable "pvt_dns_zone_name" {
  default = "privatelink.database.windows.net"
}

variable "pvt_dns_vnet_link_name" {
  default = "pvt_dns_vnet_link"
}

variable "pvt_dns_vnet_id" {
  
}

variable "pe_name" {
}

variable "location" {
}

variable "pe_subnet_id" {
}

variable "private_connection_resource_id" {
}