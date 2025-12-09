#####################################
## Azure Managed Redis - Variables ##
#####################################

## Managed Redis SKU ##
variable "managed_redis_sku_name" {
  description = "The SKU of the Managed Redis"
  type        = string
  default     = "Balanced_B0" // Balanced_B3 is required for geo replication
  
  validation {
    condition = contains([
      # Enterprise SKUs
      "Enterprise_E1", "Enterprise_E5", "Enterprise_E10", "Enterprise_E20",
      "Enterprise_E50", "Enterprise_E100", "Enterprise_E200", "Enterprise_E400",
      # Enterprise Flash SKUs
      "EnterpriseFlash_F300", "EnterpriseFlash_F700", "EnterpriseFlash_F1500",
      # Balanced SKUs
      "Balanced_B0", "Balanced_B1", "Balanced_B3", "Balanced_B5", "Balanced_B10",
      "Balanced_B20", "Balanced_B50", "Balanced_B100", "Balanced_B150",
      "Balanced_B250", "Balanced_B350", "Balanced_B500", "Balanced_B700", "Balanced_B1000",
      # Memory Optimized SKUs
      "MemoryOptimized_M10", "MemoryOptimized_M20", "MemoryOptimized_M50",
      "MemoryOptimized_M100", "MemoryOptimized_M150", "MemoryOptimized_M250",
      "MemoryOptimized_M350", "MemoryOptimized_M500", "MemoryOptimized_M700",
      "MemoryOptimized_M1000", "MemoryOptimized_M1500", "MemoryOptimized_M2000",
      # Compute Optimized SKUs
      "ComputeOptimized_X3", "ComputeOptimized_X5", "ComputeOptimized_X10",
      "ComputeOptimized_X20", "ComputeOptimized_X50", "ComputeOptimized_X100",
      "ComputeOptimized_X150", "ComputeOptimized_X250", "ComputeOptimized_X350",
      "ComputeOptimized_X500", "ComputeOptimized_X700",
      # Flash Optimized SKUs
      "FlashOptimized_A250", "FlashOptimized_A500", "FlashOptimized_A700",
      "FlashOptimized_A1000", "FlashOptimized_A1500", "FlashOptimized_A2000",
      "FlashOptimized_A4500"
    ], var.managed_redis_sku_name)
    error_message = "SKU must be a valid Azure Managed Redis SKU"
  }
}

## Managed Redis Modules ##
variable "managed_redis_modules" {
  description = "List of Redis modules to enable"
  type        = list(string)
  default     = ["RedisJSON", "RediSearch"]
  
  validation {
    condition = alltrue([
      for module in var.managed_redis_modules : contains([
        "RedisJSON", "RediSearch", "RedisBloom", "RedisTimeSeries", "RediSearch"
      ], module)
    ])
    error_message = "All modules must be valid Managed Redis modules: RedisJSON, RediSearch, RedisBloom, RedisTimeSeries"
  }
}

## Managed Redis High Availability ##
variable "managed_redis_high_availability" {
  description = "Enable high availability for the Managed Redis"
  type        = bool
  default     = false
}

## Managed Redis Eviction Policy ##
variable "managed_redis_eviction_policy" {
  description = "Managed Redis eviction policy for the database"
  type        = string
  default     = "NoEviction"
  
  validation {
    condition = contains([
      "NoEviction", "AllKeysLRU", "AllKeysRandom", "VolatileLRU",
      "VolatileRandom", "VolatileTTL", "AllKeysLFU", "VolatileLFU"
    ], var.managed_redis_eviction_policy)
    error_message = "Eviction policy must be a valid Managed Redis eviction policy"
  }
}

## Managed Redis Client Protocol ##
variable "managed_redis_client_protocol" {
  description = "Client protocol for the Redis database"
  type        = string
  default     = "Encrypted"

  validation {
    condition     = contains(["Encrypted", "Plaintext"], var.managed_redis_client_protocol)
    error_message = "Client protocol must be either 'Encrypted' or 'Plaintext'"
  }
}

## Managed Redis Clustering Policy ##
variable "managed_redis_clustering_policy" {
  description = "Clustering policy for the Redis database. Options are EnterpriseCluster: Single endpoint with proxy routing (required for RediSearch), OSSCluster: Redis Cluster API with direct shard connections (best performance), NoCluster: True non-clustered mode, no sharding (≤25 GB only)"
  type        = string
  default     = "EnterpriseCluster"

  validation {
    condition     = contains(["EnterpriseCluster", "OSSCluster", "NoCluster"], var.managed_redis_clustering_policy)
    error_message = "Clustering policy must be 'EnterpriseCluster', 'OSSCluster', or 'NoCluster'"
  }
}

## Managed Redis Access Keys Authentication ##
variable "managed_redis_access_keys_authentication_enabled" {
  description = "Enable access keys authentication"
  type        = bool
  default     = true
}

## Managed Redis Access Public Network Access ##
variable "managed_redis_public_network_access" {
  description = "Public network access (Disabled for Private Endpoint, Enabled for public access)"
  type        = string
  default     = "Disabled"
}

## Managed Redis Database Name ##
variable "managed_redis_database_name" {
  description = "Name of the Redis database within the cluster"
  type        = string
  default     = "default"
}
