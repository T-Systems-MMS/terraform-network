output "virtual_network" {
  description = "Outputs all attributes of resource_type."
  value = {
    for virtual_network in keys(azurerm_virtual_network.virtual_network) :
    virtual_network => {
      for key, value in azurerm_virtual_network.virtual_network[virtual_network] :
      key => value
    }
  }
}

output "subnet" {
  description = "Outputs all attributes of resource_type."
  value = {
    for subnet in keys(azurerm_subnet.subnet) :
    subnet => {
      for key, value in azurerm_subnet.subnet[subnet] :
      key => value
    }
  }
}

output "public_ip" {
  description = "Outputs all attributes of resource_type."
  value = {
    for public_ip in keys(azurerm_public_ip.public_ip) :
    public_ip => {
      for key, value in azurerm_public_ip.public_ip[public_ip] :
      key => value
    }
  }
}

output "network_interface" {
  description = "Outputs all attributes of resource_type."
  value = {
    for network_interface in keys(azurerm_network_interface.network_interface) :
    network_interface => {
      for key, value in azurerm_network_interface.network_interface[network_interface] :
      key => value
    }
  }
}

output "network_security_group" {
  description = "Outputs all attributes of resource_type."
  value = {
    for network_security_group in keys(azurerm_network_security_group.network_security_group) :
    network_security_group => {
      for key, value in azurerm_network_security_group.network_security_group[network_security_group] :
      key => value
    }
  }
}

output "subnet_network_security_group_association" {
  description = "Outputs all attributes of resource_type."
  value = {
    for subnet_network_security_group_association in keys(azurerm_subnet_network_security_group_association.subnet_network_security_group_association) :
    subnet_network_security_group_association => {
      for key, value in azurerm_subnet_network_security_group_association.subnet_network_security_group_association[subnet_network_security_group_association] :
      key => value
    }
  }
}

output "network_interface_security_group_association" {
  description = "Outputs all attributes of resource_type."
  value = {
    for network_interface_security_group_association in keys(azurerm_network_interface_security_group_association.network_interface_security_group_association) :
    network_interface_security_group_association => {
      for key, value in azurerm_network_interface_security_group_association.network_interface_security_group_association[network_interface_security_group_association] :
      key => value
    }
  }
}

output "local_network_gateway" {
  description = "Outputs all attributes of resource_type."
  value = {
    for local_network_gateway in keys(azurerm_local_network_gateway.local_network_gateway) :
    local_network_gateway => {
      for key, value in azurerm_local_network_gateway.local_network_gateway[local_network_gateway] :
      key => value
    }
  }
}

output "virtual_network_gateway" {
  description = "Outputs all attributes of resource_type."
  value = {
    for virtual_network_gateway in keys(azurerm_virtual_network_gateway.virtual_network_gateway) :
    virtual_network_gateway => {
      for key, value in azurerm_virtual_network_gateway.virtual_network_gateway[virtual_network_gateway] :
      key => value
    }
  }
}

output "private_endpoint" {
  description = "Outputs all attributes of resource_type."
  value = {
    for private_endpoint in keys(azurerm_private_endpoint.private_endpoint) :
    private_endpoint => {
      for key, value in azurerm_private_endpoint.private_endpoint[private_endpoint] :
      key => value
    }
  }
}

output "virtual_network_gateway_connection" {
  description = "Outputs all attributes of resource_type."
  value = {
    for virtual_network_gateway_connection in keys(azurerm_virtual_network_gateway_connection.virtual_network_gateway_connection) :
    virtual_network_gateway_connection => {
      for key, value in azurerm_virtual_network_gateway_connection.virtual_network_gateway_connection[virtual_network_gateway_connection] :
      key => value
    }
  }
}

output "virtual_network_peering" {
  description = "Outputs all attributes of resource_type."
  value = {
    for virtual_network_peering in keys(azurerm_virtual_network_peering.virtual_network_peering) :
    virtual_network_peering => {
      for key, value in azurerm_virtual_network_peering.virtual_network_peering[virtual_network_peering] :
      key => value
    }
  }
}

output "application_gateway" {
  description = "Outputs all attributes of resource_type."
  value = {
    for application_gateway in keys(azurerm_application_gateway.application_gateway) :
    application_gateway => {
      for key, value in azurerm_application_gateway.application_gateway[application_gateway] :
      key => value
    }
  }
}

output "variables" {
  description = "Displays all configurable variables passed by the module. __default__ = predefined values per module. __merged__ = result of merging the default values and custom values passed to the module"
  value = {
    default = {
      for variable in keys(local.default) :
      variable => local.default[variable]
    }
    merged = {
      virtual_network = {
        for key in keys(var.virtual_network) :
        key => local.virtual_network[key]
      }
      subnet = {
        for key in keys(var.subnet) :
        key => local.subnet[key]
      }
      public_ip = {
        for key in keys(var.public_ip) :
        key => local.public_ip[key]
      }
      network_interface = {
        for key in keys(var.network_interface) :
        key => local.network_interface[key]
      }
      network_security_group = {
        for key in keys(var.network_security_group) :
        key => local.network_security_group[key]
      }
      subnet_network_security_group_association = {
        for key in keys(var.subnet_network_security_group_association) :
        key => local.subnet_network_security_group_association[key]
      }
      network_interface_security_group_association = {
        for key in keys(var.network_interface_security_group_association) :
        key => local.network_interface_security_group_association[key]
      }
      local_network_gateway = {
        for key in keys(var.local_network_gateway) :
        key => local.local_network_gateway[key]
      }
      virtual_network_gateway = {
        for key in keys(var.virtual_network_gateway) :
        key => local.virtual_network_gateway[key]
      }
      private_endpoint = {
        for key in keys(var.private_endpoint) :
        key => local.private_endpoint[key]
      }
      virtual_network_gateway_connection = {
        for key in keys(var.virtual_network_gateway_connection) :
        key => local.virtual_network_gateway_connection[key]
      }
      virtual_network_peering = {
        for key in keys(var.virtual_network_peering) :
        key => local.virtual_network_peering[key]
      }
      application_gateway = {
        for key in keys(var.application_gateway) :
        key => local.application_gateway[key]
      }
    }
  }
}
