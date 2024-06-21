output "aks_identity" {
  value = azurerm_kubernetes_cluster.aks.identity[0].principal_id
}

output "ingress_application_gateway_identity" {
  value = azurerm_kubernetes_cluster.aks.ingress_application_gateway[0].ingress_application_gateway_identity[0].object_id
}