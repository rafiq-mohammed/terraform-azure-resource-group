provider "azurerm" {
  features {}
}
resource "azurerm_resource_group" "rg" {
    for_each            = var.rg_array
    name                = each.key
    location            = each.value   
}