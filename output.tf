output "rg_names" {
  description = ""
   value = [for rg_name in azurerm_resource_group.rg: rg_name.name]
}
 
