variable "resource_group_name" {
  
}

variable "location" {
  
}

variable "sku_name" {
  default = "standard"
}

variable "tenant_id" {
}

variable "kv_name" {
  default = "kv"
}

variable "object_id" {
}

variable "key_permissions" {
  default = "Get"
}

variable "secret_permissions" {
    default = "Get"
}

variable "certificate_permissions" {
  default = "Get"
}

variable "storage_permissions" {
  default = "Get"
}

variable "certificate_passwd" {
}

variable "certificate_path" {
  
}

variable "cert_name" {
  
}