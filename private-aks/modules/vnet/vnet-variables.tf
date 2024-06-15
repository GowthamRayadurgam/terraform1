variable "vnet_name" {
  
}

variable "location" {
  
}

variable "resource_group_name" {
  
}

variable "address_space" {
  
}

variable "subnets" {
  type = list(object({
    name = string
    address_prefixes = list(string)
    private_endpoint_network_policies_enabled = bool
    private_link_service_network_policies_enabled = bool
  }))
}