resource "azurerm_kubernetes_cluster" "aks" {
  name = var.aks_name
  resource_group_name = var.resource_group_name
  location = var.location
  kubernetes_version = var.aks_version
  private_cluster_enabled = true
  private_dns_zone_id = "System"
  azure_policy_enabled = var.aks_azure_policy_enabled
  dns_prefix = var.aks_dns_prefix
  sku_tier = "Free"

# copy script from local to remote VM using terraform file provisioner, execute the script to generate ssh-keygen -- use scp to copy
# public key from remote to local and use file function to read the public key in aks key_data 
/*  linux_profile {
    admin_username = "aks-admin"
    ssh_key {
      key_data = file("./id_rsa_aks.pub" )
    }
  }
 */ 


  identity {
    type = "SystemAssigned"
  }

  ingress_application_gateway {
    gateway_id = var.
  }


  default_node_pool {
    name = "system"
    vm_size = var.default_nodepool_vm_size
    node_count = var.default_node_pool_node_count
    max_pods = "30"
    max_count = var.default_node_pool_max_count
    enable_auto_scaling = true
    type = "VirtualMachineScaleSets"
    os_disk_type = var.default_node_pool_os_disk_type
    os_disk_size_gb = var.default_node_pool_os_disk_size_gb
    vnet_subnet_id = var.default_node_pool_vnet_subnet_id
    os_sku = var.default_node_pool_os_sku
  }

  network_profile {
    network_plugin = var.aks_network_plugin
    network_policy = var.aks_network_policy
    dns_service_ip = var.aks_dns_service_ip
    service_cidr = var.aks_service_cidr
    load_balancer_sku = "Standard"
    outbound_type = var.aks_outbound_type
  }

  key_vault_secrets_provider {
    secret_rotation_enabled = true
  }

  
}