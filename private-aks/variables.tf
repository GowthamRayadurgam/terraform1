variable "resource_group_name" {
  description = "Name of the Resource Group"
  default     = "private_aks_rsg"
}

variable "location" {
  description = "location of the Resources"
  default     = "north europe"
}

variable "hub_address_space" {
  default = ["10.1.0.0/16"]
}

variable "app_GW_nic_prefix" {
  default = ["10.1.0.0/27"]
}

variable "app_GW_backend_prefix" {
  default = ["10.1.33.0/28"]
}

variable "bastion_subnet" {
  default = ["10.1.1.0/25"]
}

variable "FW_address_prefix" {
  default = ["10.1.2.0/25"]
}

variable "Hub_vnet_name" {
  default = "Hub-Vnet"
}

variable "spoke_vnet_name" {
  default = "Spoke_Vnet"
}

variable "spoke_address_space" {
  default = ["10.2.0.0/16"]
}

variable "nodepool_prefix" {
  default = ["10.2.0.0/24"]
}

variable "vmsubnet_prefix" {
  default = ["10.2.1.0/24"]
}

variable "vm_subnet" {
  default = "vm_subnet"
}

variable "nic_name" {
  default = "vm-nic"
}

variable "vm_name" {
  default = "terraform"
}

variable "vm_size" {
  default = "Standard_B1s"
}

variable "vm_os_disk_image" {
  type        = map(string)
  description = "Specifies the os disk image of the virtual machine"
  default = {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
}

/* variable "subnet_id" {
} */

variable "aks_name" {
  default = "terraform-aks"
}

variable "administrator_login_password" {
  default = "s6SLq2CVzkL7fML"
  sensitive = true
}
