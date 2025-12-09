############################################
## Azure Managed Redis - Private Endpoint ##
############################################

## Create Private DNS Zone Virtual Network Link ##
resource "azurerm_private_dns_zone_virtual_network_link" "managed_redis" {
  name                  = "${azurerm_managed_redis.managed_redis.name}-vlink"
  resource_group_name   = azurerm_private_dns_zone.managed_redis.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.managed_redis.name
  virtual_network_id    = azurerm_virtual_network.vnet.id
  tags                  = var.tags

  depends_on = [ 
    azurerm_managed_redis.managed_redis,
    azurerm_virtual_network.vnet,
    azurerm_private_dns_zone.managed_redis
  ]
}

## Create the Private Endpoint ##
resource "azurerm_private_endpoint" "managed_redis" {
  name                = "${azurerm_managed_redis.managed_redis.name}-pe"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  subnet_id           = azurerm_subnet.pe.id
  tags                = var.tags

  private_service_connection {
    name                           = "${azurerm_managed_redis.managed_redis.name}-psc"
    is_manual_connection           = false
    private_connection_resource_id = azurerm_managed_redis.managed_redis.id
    subresource_names              = ["redisEnterprise"]
  }

  private_dns_zone_group {
    name                 = "default"
    private_dns_zone_ids = [azurerm_private_dns_zone.managed_redis.id]
  }

  depends_on = [ 
    azurerm_managed_redis.managed_redis,
    azurerm_virtual_network.vnet,
    azurerm_private_dns_zone.managed_redis
  ]
}
