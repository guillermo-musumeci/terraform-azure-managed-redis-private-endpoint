  ## Define Terraform Provider ##
terraform {
  required_version = ">= 1.14"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 4.5"
    }
  }
}

## Configure the Azure Provider ##
provider "azurerm" { 
  features {}  
  environment     = "public"
  subscription_id = var.azure_subscription_id
  client_id       = var.azure_client_id
  client_secret   = var.azure_client_secret
  tenant_id       = var.azure_tenant_id
}
