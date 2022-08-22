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
variable "subnet_network_security_group_association" {
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
variable "virtual_network_gateway" {
  type        = any
  default     = {}
  description = "resource definition, default settings are defined within locals and merged with var settings"
}
variable "virtual_network_gateway_connection" {
  type        = any
  default     = {}
  description = "resource definition, default settings are defined within locals and merged with var settings"
}
variable "local_network_gateway" {
  type        = any
  default     = {}
  description = "resource definition, default settings are defined within locals and merged with var settings"
}
variable "virtual_network_peering" {
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
      delegation                                     = {}
    }
    public_ip = {
      name                    = ""
      allocation_method       = "Static"
      zones                   = [1, 2, 3]
      domain_name_label       = null
      edge_zone               = null
      idle_timeout_in_minutes = null
      ip_tags                 = {}
      ip_version              = null
      public_ip_prefix_id     = null
      reverse_fqdn            = null
      sku                     = "Basic"
      sku_tier                = null
      tags                    = {}
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
    subnet_network_security_group_association    = {}
    network_interface_security_group_association = {}
    private_endpoint = {
      name = ""
      private_dns_zone_group = {
        name                 = "private-dns-zone-group"
        private_dns_zone_ids = null
      }
      private_service_connection = {
        name                              = "private-service-connection"
        is_manual_connection              = false
        private_connection_resource_id    = null
        private_connection_resource_alias = null
        subresource_names                 = null
        request_message                   = null
      }
      tags = {}
    }
    virtual_network_gateway = {
      name                             = ""
      vpn_type                         = ""
      enable_bgp                       = false
      active_active                    = false
      private_ip_address_enabled       = false
      default_local_network_gateway_id = ""
      generation                       = "None"
      ip_configuration = {
        name                          = ""
        private_ip_address_allocation = "Dynamic"
      }
      vpn_client_configuration = {}
      tags                     = {}
    }
    virtual_network_gateway_connection = {
      name                               = ""
      authorization_key                  = ""
      dpd_timeout_seconds                = 0
      express_route_circuit_id           = ""
      peer_virtual_network_gateway_id    = ""
      local_azure_ip_address_enabled     = false
      local_network_gateway_id           = ""
      routing_weight                     = 10
      shared_key                         = ""
      connection_mode                    = "Default"
      connection_protocol                = "IKEv2"
      enable_bgp                         = false
      express_route_gateway_bypass       = false
      use_policy_based_traffic_selectors = false
      traffic_selector_policy            = {}
      ipsec_policy                       = {}
      tags                               = {}
    }
    local_network_gateway = {
      name            = ""
      address_space   = []
      gateway_address = ""
      bgp_settings    = {}
      tags            = {}
    }
    virtual_network_peering = {
      name                         = ""
      allow_virtual_network_access = false
      allow_forwarded_traffic      = false
      allow_gateway_transit        = false
      use_remote_gateways          = false
    }
  }

  # compare and merge custom and default values
  subnet_values = {
    for subnet in keys(var.subnet) :
    subnet => merge(local.default.subnet, var.subnet[subnet])
  }
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
  virtual_network_gateway_values = {
    for virtual_network_gateway in keys(var.virtual_network_gateway) :
    virtual_network_gateway => merge(local.default.virtual_network_gateway, var.virtual_network_gateway[virtual_network_gateway])
  }
  virtual_network_gateway_connection_values = {
    for virtual_network_gateway_connection in keys(var.virtual_network_gateway_connection) :
    virtual_network_gateway_connection => merge(local.default.virtual_network_gateway_connection, var.virtual_network_gateway_connection[virtual_network_gateway_connection])
  }

  # merge all custom and default values
  virtual_network = {
    for virtual_network in keys(var.virtual_network) :
    virtual_network => merge(local.default.virtual_network, var.virtual_network[virtual_network])
  }
  subnet = {
    for subnet in keys(var.subnet) :
    subnet => merge(
      local.subnet_values[subnet],
      {
        for config in ["delegation"] :
        config => {
          for key in keys(local.subnet_values[subnet][config]) :
          key => merge(local.default.subnet[config], local.subnet_values[subnet][config][key])
        }
      }
    )
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
        config => {
          for key in keys(local.network_interface_values[network_interface][config]) :
          key => merge(local.default.network_interface[config], local.network_interface_values[network_interface][config][key])
        }
      }
    )
  }
  network_security_group = {
    for network_security_group in keys(var.network_security_group) :
    network_security_group => merge(
      local.network_security_group_values[network_security_group],
      {
        for config in ["security_rule"] :
        config => {
          for key in keys(local.network_security_group_values[network_security_group][config]) :
          key => merge(local.default.network_security_group[config], local.network_security_group_values[network_security_group][config][key])
        }
      }
    )
  }
  subnet_network_security_group_association = {
    for subnet_network_security_group_association in keys(var.subnet_network_security_group_association) :
    subnet_network_security_group_association => merge(local.default.subnet_network_security_group_association, var.subnet_network_security_group_association[subnet_network_security_group_association])
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
  virtual_network_gateway = {
    for virtual_network_gateway in keys(var.virtual_network_gateway) :
    virtual_network_gateway => merge(
      local.virtual_network_gateway_values[virtual_network_gateway],
      {
        for config in ["ip_configuration", "vpn_client_configuration"] :
        config => {
          for key in keys(local.virtual_network_gateway_values[virtual_network_gateway][config]) :
          key => merge(local.default.virtual_network_gateway[config], local.virtual_network_gateway_values[virtual_network_gateway][config][key])
        }
      }
    )
  }
  virtual_network_gateway_connection = {
    for virtual_network_gateway_connection in keys(var.virtual_network_gateway_connection) :
    virtual_network_gateway_connection => merge(
      local.virtual_network_gateway_connection_values[virtual_network_gateway_connection],
      {
        for config in ["traffic_selector_policy", "ipsec_policy"] :
        config => merge(local.default.virtual_network_gateway_connection[config], local.virtual_network_gateway_connection_values[virtual_network_gateway_connection][config])
      }
    )
  }
  local_network_gateway = {
    for local_network_gateway in keys(var.local_network_gateway) :
    local_network_gateway => merge(local.default.local_network_gateway, var.local_network_gateway[local_network_gateway])
  }
  virtual_network_peering = {
    for virtual_network_peering in keys(var.virtual_network_peering) :
    virtual_network_peering => merge(local.default.virtual_network_peering, var.virtual_network_peering[virtual_network_peering])
  }
}
