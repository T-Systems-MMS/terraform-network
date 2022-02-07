variable "virtual_network" {
  type        = any
  default     = {}
  description = "resource definition, default settings are defined within locals and merged with var settings"
}
variable "subnet" {
  type        = any
  default     = {}
  description = "resource definition, default settings are defined within locals and merged with var settings"
}
variable "public_ip" {
  type        = any
  default     = {}
  description = "resource definition, default settings are defined within locals and merged with var settings"
}
variable "network_interface" {
  type        = any
  default     = {}
  description = "resource definition, default settings are defined within locals and merged with var settings"
}
variable "network_security_group" {
  type        = any
  default     = {}
  description = "resource definition, default settings are defined within locals and merged with var settings"
}
variable "network_interface_security_group_association" {
  type        = any
  default     = {}
  description = "resource definition, default settings are defined within locals and merged with var settings"
}
variable "private_endpoint" {
  type        = any
  default     = {}
  description = "resource definition, default settings are defined within locals and merged with var settings"
}

locals {
  default = {
    # resource definition
    virtual_network = {
      name = ""
      tags = {}
    }
    subnet = {
      name                                           = ""
      service_endpoints                              = []
      enforce_private_link_endpoint_network_policies = false
      enforce_private_link_service_network_policies  = false
    }
    public_ip = {
      name              = ""
      allocation_method = "Static"
      sku               = "Basic"
      tags              = {}
    }
    network_interface = {
      name                          = ""
      dns_servers                   = []
      enable_accelerated_networking = false
      enable_ip_forwarding          = false
      internal_dns_name_labe        = ""
      ip_configuration = {
        name                          = ""
        primary                       = true
        private_ip_address_allocation = "Static"
        private_ip_address_version    = "IPv4"
        public_ip_address_id          = ""
      }
      tags = {}
    }
    network_security_group = {
      name = ""
      security_rule = {
        name                       = ""
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_address_prefix      = "*"
        source_port_range          = "*"
        destination_address_prefix = "*"
      }
      tags = {}
    }
    network_interface_security_group_association = {}
    private_endpoint = {
      name = ""
      private_dns_zone_group = {
        name = ""
      }
      private_service_connection = {
        name = ""
      }
      tags = {}
    }
  }

  # compare and merge custom and default values
  network_interface_values = {
    for network_interface in keys(var.network_interface) :
    network_interface => merge(local.default.network_interface, var.network_interface[network_interface])
  }
  network_security_group_values = {
    for network_security_group in keys(var.network_security_group) :
    network_security_group => merge(local.default.network_security_group, var.network_security_group[network_security_group])
  }
  private_endpoint_values = {
    for private_endpoint in keys(var.private_endpoint) :
    private_endpoint => merge(local.default.private_endpoint, var.private_endpoint[private_endpoint])
  }
  # merge all custom and default values
  virtual_network = {
    for virtual_network in keys(var.virtual_network) :
    virtual_network => merge(local.default.virtual_network, var.virtual_network[virtual_network])
  }
  subnet = {
    for subnet in keys(var.subnet) :
    subnet => merge(local.default.subnet, var.subnet[subnet])
  }
  public_ip = {
    for public_ip in keys(var.public_ip) :
    public_ip => merge(local.default.public_ip, var.public_ip[public_ip])
  }
  network_interface = {
    for network_interface in keys(var.network_interface) :
    network_interface => merge(
      local.network_interface_values[network_interface],
      {
        for config in ["ip_configuration"] :
        config => merge(local.default.network_interface[config], local.network_interface_values[network_interface][config])
      }
    )
  }
  network_security_group = {
    for network_security_group in keys(var.network_security_group) :
    network_security_group => merge(
      local.network_security_group_values[network_security_group],
      {
        for config in ["security_rule"] :
        config => merge(local.default.network_security_group[config], local.network_security_group_values[network_security_group][config])
      }
    )
  }
  network_interface_security_group_association = {
    for network_interface_security_group_association in keys(var.network_interface_security_group_association) :
    network_interface_security_group_association => merge(local.default.network_interface_security_group_association, var.network_interface_security_group_association[network_interface_security_group_association])
  }
  private_endpoint = {
    for private_endpoint in keys(var.private_endpoint) :
    private_endpoint => merge(
      local.private_endpoint_values[private_endpoint],
      {
        for config in ["private_dns_zone_group", "private_service_connection"] :
        config => merge(local.default.private_endpoint[config], local.private_endpoint_values[private_endpoint][config])
      }
    )
  }
}
