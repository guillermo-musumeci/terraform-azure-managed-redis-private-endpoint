################################
## Authentication - Variables ##
################################

variable "azure_subscription_id" {
  type        = string
  description = "Azure Subscription ID"
}

variable "azure_client_id" {
  type        = string
  description = "Azure Client ID"
}

variable "azure_client_secret" {
  type        = string
  description = "Azure Client Secret"
}

variable "azure_tenant_id" {
  type        = string
  description = "Azure Tenant ID"
}

#########################
## Network - Variables ##
#########################

## Azure Region ##
variable "location" {
  type        = string
  description = "The region in which resources should be deployed"
  default     = "westeurope"
}

## Tags ##
variable "tags" {
  type        = map(string)
  description = "The collection of tags to be applied to all resources"
  default     = {}
}

variable "vnet_address_space" {
  type        = string
  description = "VNET CIDR Block"
}

variable "subnet_address_space" {
  type        = string
  description = "Subnet CIDR"
}

variable "subnet_pe_address_space" {
  type        = string
  description = "Private Endpoint Subnet CIDR"
}
