resource "azurerm_virtual_network" "vnet-aula" {
  name                = "aula-network"
  location            = azurerm_resource_group.rg-aula.location
  resource_group_name = azurerm_resource_group.rg-aula.name
  address_space       = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "sub-aula" {
  name                 = "subnet-aula"
  resource_group_name  = azurerm_resource_group.rg-aula.name
  virtual_network_name = azurerm_virtual_network.vnet-aula.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_public_ip" "ip-aula" {
  name                    = "ip-public-aula"
  location                = azurerm_resource_group.rg-aula.location
  resource_group_name     = azurerm_resource_group.rg-aula.name
  allocation_method       = "Static"
}

resource "azurerm_network_security_group" "net-sec-group-aula" {
  name                = "security-group-aula"
  location            = azurerm_resource_group.rg-aula.location
  resource_group_name = azurerm_resource_group.rg-aula.name

  security_rule {
    name                       = "SSH"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

 security_rule {
    name                       = "web"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

}
