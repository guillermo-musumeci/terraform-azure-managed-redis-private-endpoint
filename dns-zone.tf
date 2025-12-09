###########################
## DNS Zones - Resources ##
###########################

## Create the Resource Group for DNS Zone ##
resource "azurerm_resource_group" "dns_zone" {
  name     = "kopicloud-dns-rg"
  location = var.location
}

## Create the Private DNS Zone ##
resource "azurerm_private_dns_zone" "managed_redis" {
  name                = "privatelink.redis.azure.com"
  resource_group_name = azurerm_resource_group.dns_zone.name
}
