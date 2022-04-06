resource "azurerm_network_interface" "net-in-aula" {
  name                = "example-nic"
  location            = azurerm_resource_group.rg-aula.location
  resource_group_name = azurerm_resource_group.rg-aula.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.sub-aula.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.ip-aula.id 
  }
}

resource "azurerm_network_interface_security_group_association" "sga-aula" {
  network_interface_id = azurerm_network_interface.net-in-aula.id           
  network_security_group_id = azurerm_network_security_group.net-sec-group-aula.id
}

resource "azurerm_linux_virtual_machine" "vm-aula" {
  name                = "vmaula"
  resource_group_name = azurerm_resource_group.rg-aula.name
  location            = azurerm_resource_group.rg-aula.location
  size                = "Standard_D2as_v4"
  admin_username      = var.user
  admin_password      = var.password
  disable_password_authentication = false
  network_interface_ids = [
    azurerm_network_interface.net-in-aula.id,
  ]

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }
  
  os_disk {
    name = "disk"
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
  }

  boot_diagnostics {
    storage_account_uri = azurerm_storage_account.storage-aula.primary_blob_endpoint
  }

}

data "azurerm_public_ip" "ip-aula-data"{
    name = azurerm_public_ip.ip-aula.name
    resource_group_name = azurerm_resource_group.rg-aula.name
 }