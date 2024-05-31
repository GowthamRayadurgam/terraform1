subscription_id = "6a02c723-570d-4206-ba27-b7b09bfeeb35"
client_id       = "107ea390-d996-40b7-a339-72dd4c714ba5"
client_secret   = "Gnh8Q~GgxSd.iYkbxV7_X6k3Oti6cyesIFS6UcQP"
tenant_id       = "44637267-515d-4b7d-af99-89581adde1b8"
#rsg-location    = "west europe"
#rsg-name        = "rsg1"
vnet1           = "vnet1"
CIDR1           = "10.0.0.0/16"
subnet1-address = "10.0.0.0/24"
users = {
  "gowtham@gmail.com" = "Gowtham"
  "sai@gmail.com"     = "Sai"
  "charan@gmail.com"  = "Charan"
}

vmname            = "Gowtham-Vm"
username          = "Gowtham"
frontend-port     = "80"
backend-port      = "80"
nat-backend-port  = "3389"
nat-frontend-port = "3389"

resource_groups ={
  "rsg1" = {location = "west europe" }
  "rsg2" = {location = "north europe"}
}


virtual_networks = {
  "rsg1" = {
      "VNET1" = {
        address_space = ["10.0.0.0/16"]
        subnets = {
          "subnet1" = { address_prefix = "10.0.1.0/24" }
          "subnet2" = { address_prefix = "10.0.2.0/24" } 
        } 
      }
    }
}
