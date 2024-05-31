variable "subscription_id" {
}

variable "client_id" {
}

variable "client_secret" {
}

variable "tenant_id" {
}

/*
variable "rsg-name" {
}

variable "rsg-location" {
}
*/
variable "CIDR1" {
}

variable "vnet1" {

}

variable "subnet1-address" {

}

variable "vmname" {

}

variable "users" {
  type        = map(string)
  description = "Provide Map of users as mail-ID = User_name"
}

variable "username" {

}

variable "frontend-port" {

}

variable "backend-port" {

}

variable "nat-frontend-port" {

}

variable "nat-backend-port" {

}

variable "resource_groups" {
  type = map(object({
    location = string
  }))
}


variable "virtual_networks" {
  type = map(map(object({
    address_space = list(string)
    subnets       = map(object({
      address_prefix = string
    }))
  })))
}