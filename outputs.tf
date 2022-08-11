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
      address_prefixes     = azurerm_subnet.subnet[subnet].address_prefixes
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
      id = azurerm_network_interface.network_interface[network_interface].id
    }
  }
}
output "network_security_group" {
  description = "azurerm_network_security_group results"
  value = {
    for network_security_group in keys(azurerm_network_security_group.network_security_group) :
    network_security_group => {
      id = azurerm_network_security_group.network_security_group[network_security_group].id
    }
  }
}
output "virtual_network_gateway" {
  description = "azurerm_virtual_network_gateway results"
  value = {
    for virtual_network_gateway in keys(azurerm_virtual_network_gateway.virtual_network_gateway) :
    virtual_network_gateway => {
      id = azurerm_virtual_network_gateway.virtual_network_gateway[virtual_network_gateway].id
    }
  }
}
output "local_network_gateway" {
  description = "azurerm_local_network_gateway results"
  value = {
    for local_network_gateway in keys(azurerm_local_network_gateway.local_network_gateway) :
    local_network_gateway => {
      id = azurerm_local_network_gateway.local_network_gateway[local_network_gateway].id
    }
  }
}
