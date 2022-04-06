terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.0.0"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg-aula" {
  name     = "aularesource"
  location = "brazilsouth"
}

resource "azurerm_storage_account" "storage-aula" {
  name                     = "stoaccaula"
  resource_group_name      = azurerm_resource_group.rg-aula.name
  location                 = azurerm_resource_group.rg-aula.location
  account_tier             = "Standard"
  account_replication_type = "GRS"

}

resource "null_resource" "server-aula" {
 
  connection {
    type = "ssh"
    host = data.azurerm_public_ip.ip-aula-data.ip_address
    user = var.user
    password = var.password
  }

  provisioner "remote-exec" {

    inline = [
      "sudo apt update",
      "sudo apt install -y apache2",
    ]
  }

  depends_on = [
  azurerm_linux_virtual_machine.vm-aula
]

}