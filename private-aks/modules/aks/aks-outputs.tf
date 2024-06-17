output "aks_identity" {
  value = azurerm_kubernetes_cluster.aks.identity[0].principal_id
}