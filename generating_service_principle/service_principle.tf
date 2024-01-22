
resource "azurerm_resource_group" "Gowtham"{
    name = "Gowtham_RSG"
    location = "eastus"
}

# data "azuread_client_config" "current" {}

resource "azuread_application" "AD-application" {
  display_name = "AD-application"
#  owners       = [data.azuread_client_config.current.object_id]
}

resource "azuread_service_principal" "SP-terraform" {
  application_id               = azuread_application.AD-application.application_id
  app_role_assignment_required = true
#  owners                       = [data.azuread_client_config.current.object_id]
}

data "azurerm_role_definition" "contributor"{
    name = "contributor"
}

/*
resource "azurerm_role_assignment" "SP-role" {
  scope              = azurerm_resource_group.Gowtham.id
  role_definition_id = data.azurerm_role_definition.contributor.id
  principal_id       = azuread_service_principal.SP-terraform.id
}
*/