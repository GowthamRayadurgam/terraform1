variable "client_id" {
  sensitive   = true
  description = "Client ID for App Registration of service principle"
  type        = string
}

variable "client_secret" {
  description = "Client secret for App Registration of service principle"
  sensitive   = true
  type        = string
}

variable "tenant_id" {
  type = string
}

variable "subscription_id" {
  type = string
}

variable "address_space-1" {
  type = list(string)
}

variable "address_prefixes" {
  type = list(string)
}

variable "location" {
  description = "name of Location"
  type        = string
  default     = "southindia"
}

variable "resource_group" {
  default = "rsg-1"
  type    = string
}

variable "address_space-2" {
}
variable "address_prefixes-2" {

}