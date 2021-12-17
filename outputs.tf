output "virtual_network" {
  description = "azurerm_virtual_network results"
  value = {
    for virtual_network in keys(azurerm_virtual_network.virtual_network) :
    virtual_network => {
      id   = azurerm_virtual_network.virtual_network[virtual_network].id
      name = azurerm_virtual_network.virtual_network[virtual_network].name
    }
  }
}
output "subnet" {
  description = "azurerm_subnet results"
  value = {
    for subnet in keys(azurerm_subnet.subnet) :
    subnet => {
      id                   = azurerm_subnet.subnet[subnet].id
      name                 = azurerm_subnet.subnet[subnet].name
      virtual_network_name = azurerm_subnet.subnet[subnet].virtual_network_name
    }
  }
}
output "public_ip" {
  description = "azurerm_public_ip results"
  value = {
    for public_ip in keys(azurerm_public_ip.public_ip) :
    public_ip => {
      id         = azurerm_public_ip.public_ip[public_ip].id
      ip_address = azurerm_public_ip.public_ip[public_ip].ip_address
    }
  }
}
output "network_interface" {
  description = "azurerm_network_interface results"
  value = {
    for network_interface in keys(azurerm_network_interface.network_interface) :
    network_interface => {
      id         = azurerm_network_interface.network_interface[network_interface].id
    }
  }
}
