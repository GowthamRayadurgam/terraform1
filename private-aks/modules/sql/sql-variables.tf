variable "mssql_name" {
  
}

variable "resource_group_name" {
  
}

variable "location" {
  
}

variable "administrator_login_password" {
  sensitive = true
}


variable "db_sku" {
  default = "GP_S_Gen5_2"
}

variable "DB_max_size" {
  default = 4
}