#####################################
## Azure Managed Redis - Resources ##
#####################################

resource "azurerm_managed_redis" "managed_redis" {
  name                = "kopicloud-managed-redis"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  sku_name = var.managed_redis_sku_name
  
  high_availability_enabled = var.managed_redis_high_availability

  default_database {
    access_keys_authentication_enabled = var.managed_redis_access_keys_authentication_enabled
    
    client_protocol   = var.managed_redis_client_protocol
    clustering_policy = var.managed_redis_clustering_policy
    eviction_policy   = var.managed_redis_eviction_policy

    # Enable modules if specified
    dynamic "module" {
      for_each = var.managed_redis_modules
      content {
        name = module.value
      }
    }
  }

  identity {
    type = "SystemAssigned"
  }

  public_network_access = var.managed_redis_public_network_access
  
  tags = var.tags
}
