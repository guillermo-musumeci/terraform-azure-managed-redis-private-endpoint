#############
## Network ##
#############

## Create Resource Group ##
resource "azurerm_resource_group" "rg" {
  name     = "kopicloud-pg-rg"
  location = var.location
  tags     = var.tags
}

## Create the VNET ##
resource "azurerm_virtual_network" "vnet" {
  name                = "kopicloud-vnet"
  address_space       = [var.vnet_address_space]
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  tags                = var.tags
}

## Create the Subnet for Private Endpoint ##
resource "azurerm_subnet" "subnet" {
  name                 = "kopicloud-subnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [var.subnet_address_space]

  private_endpoint_network_policies = "Enabled"
}

## Create the Subnet for Private Endpoint ##
resource "azurerm_subnet" "pe" {
  name                 = "kopicloud-pe-subnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [var.subnet_pe_address_space]

  private_endpoint_network_policies = "Enabled"
}

## Create NSG ##
resource "azurerm_network_security_group" "redis" {
  name                = "kopicloud-redis-nsg"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  tags                = var.tags

  security_rule {
    name                       = "HTTPS"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "0.0.0.0/0"
    destination_address_prefix = "*"
  }
  
  security_rule {
    name                       = "HTTP"
    priority                   = 110
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "0.0.0.0/0"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "Redis-Managed"
    priority                   = 120
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "10000"
    source_address_prefix      = "0.0.0.0/0"
    destination_address_prefix = "*"
  }
}

# Attach NSG to Subnet ##
resource "azurerm_subnet_network_security_group_association" "subnet" {
  subnet_id                 = azurerm_subnet.subnet.id
  network_security_group_id = azurerm_network_security_group.redis.id
}

## Attach NSG to PE Subnet ##
resource "azurerm_subnet_network_security_group_association" "pe" {
  subnet_id                 = azurerm_subnet.pe.id
  network_security_group_id = azurerm_network_security_group.redis.id
}
