variable "virtual_network" {
  type        = any
  default     = {}
  description = "Resource definition, default settings are defined within locals and merged with var settings. For more information look at [Outputs](#Outputs)."
}
variable "subnet" {
  type        = any
  default     = {}
  description = "Resource definition, default settings are defined within locals and merged with var settings. For more information look at [Outputs](#Outputs)."
}
variable "public_ip" {
  type        = any
  default     = {}
  description = "Resource definition, default settings are defined within locals and merged with var settings. For more information look at [Outputs](#Outputs)."
}
variable "network_interface" {
  type        = any
  default     = {}
  description = "Resource definition, default settings are defined within locals and merged with var settings. For more information look at [Outputs](#Outputs)."
}
variable "network_security_group" {
  type        = any
  default     = {}
  description = "Resource definition, default settings are defined within locals and merged with var settings. For more information look at [Outputs](#Outputs)."
}
variable "subnet_network_security_group_association" {
  type        = any
  default     = {}
  description = "Resource definition, default settings are defined within locals and merged with var settings. For more information look at [Outputs](#Outputs)."
}
variable "network_interface_security_group_association" {
  type        = any
  default     = {}
  description = "Resource definition, default settings are defined within locals and merged with var settings. For more information look at [Outputs](#Outputs)."
}
variable "local_network_gateway" {
  type        = any
  default     = {}
  description = "Resource definition, default settings are defined within locals and merged with var settings. For more information look at [Outputs](#Outputs)."
}
variable "virtual_network_gateway" {
  type        = any
  default     = {}
  description = "Resource definition, default settings are defined within locals and merged with var settings. For more information look at [Outputs](#Outputs)."
}
variable "private_endpoint" {
  type        = any
  default     = {}
  description = "Resource definition, default settings are defined within locals and merged with var settings. For more information look at [Outputs](#Outputs)."
}
variable "virtual_network_gateway_connection" {
  type        = any
  default     = {}
  description = "Resource definition, default settings are defined within locals and merged with var settings. For more information look at [Outputs](#Outputs)."
}
variable "virtual_network_peering" {
  type        = any
  default     = {}
  description = "Resource definition, default settings are defined within locals and merged with var settings. For more information look at [Outputs](#Outputs)."
}

locals {
  default = {
    // resource definition
    virtual_network = {
      name                    = ""
      bgp_community           = null
      dns_servers             = null
      edge_zone               = null
      flow_timeout_in_minutes = null
      ddos_protection_plan    = {}
      subnet = {
        name           = ""
        security_group = null
      }
      tags = {}
    }
    subnet = {
      name                                          = ""
      private_endpoint_network_policies_enabled     = null
      private_link_service_network_policies_enabled = null
      service_endpoints                             = null
      service_endpoint_policy_ids                   = null
      delegation = {
        name = ""
        service_delegation = {
          name    = ""
          actions = null
        }
      }
    }
    public_ip = {
      name                    = ""
      allocation_method       = "Dynamic"
      zones                   = null
      ddos_protection_mode    = null
      ddos_protection_plan_id = null
      domain_name_label       = null
      edge_zone               = null
      idle_timeout_in_minutes = null
      ip_tags                 = null
      ip_version              = "IPv4"
      public_ip_prefix_id     = null
      reverse_fqdn            = null
      sku                     = null
      sku_tier                = null
      tags                    = {}
    }
    network_interface = {
      name                          = ""
      dns_servers                   = null
      edge_zone                     = null
      enable_ip_forwarding          = null
      enable_accelerated_networking = null
      internal_dns_name_label       = null
      ip_configuration = {
        name                                               = ""
        gateway_load_balancer_frontend_ip_configuration_id = null
        subnet_id                                          = null
        private_ip_address                                 = null
        private_ip_address_version                         = null
        private_ip_address_allocation                      = "Static"
        public_ip_address_id                               = null
        primary                                            = null
      }
      tags = {}
    }
    network_security_group = {
      name = ""
      security_rule = {
        name                                       = ""
        description                                = null
        protocol                                   = "*"
        source_port_range                          = "*"
        source_port_ranges                         = null
        destination_port_range                     = "*"
        destination_port_ranges                    = null
        source_address_prefix                      = "*"
        source_address_prefixes                    = null
        source_application_security_group_ids      = null
        destination_address_prefix                 = "*"
        destination_address_prefixes               = null
        destination_application_security_group_ids = null
        access                                     = "Deny"
        direction                                  = "Inbound"
      }
      tags = {}
    }
    subnet_network_security_group_association    = {}
    network_interface_security_group_association = {}
    local_network_gateway = {
      name            = ""
      address_space   = null
      gateway_address = null
      gateway_fqdn    = null
      bgp_settings = {
        peer_weight = null
      }
      tags = {}
    }
    virtual_network_gateway = {
      name                             = ""
      sku                              = "Basic"
      type                             = "Vpn"
      active_active                    = null
      default_local_network_gateway_id = null
      edge_zone                        = null
      enable_bgp                       = null
      generation                       = null
      private_ip_address_enabled       = null
      vpn_type                         = null
      ip_configuration = {
        name                          = ""
        private_ip_address_allocation = null
      }
      bgp_settings = {
        asn         = null
        peer_weight = null
        peering_addresses = {
          ip_configuration_name = null
          apipa_addresses       = null
        }
      }
      custom_route = {
        address_prefixes = null
      }
      vpn_client_configuration = {
        address_space         = ""
        aad_tenant            = null
        aad_audience          = null
        aad_issuer            = null
        radius_server_address = null
        radius_server_secret  = null
        vpn_client_protocols  = null
        vpn_auth_types        = null
        root_certificate      = {}
        revoked_certificate   = {}
      }
      tags = {}
    }
    private_endpoint = {
      name                          = ""
      custom_network_interface_name = null
      private_dns_zone_group        = {}
      private_service_connection = {
        name                              = ""
        is_manual_connection              = true
        private_connection_resource_id    = null
        private_connection_resource_alias = null
        subresource_names                 = null
        request_message                   = "private_endpoint request"
      }
      ip_configuration = {
        name             = ""
        subresource_name = null
        member_name      = null
      }
      tags = {}
    }
    virtual_network_gateway_connection = {
      name                               = ""
      authorization_key                  = null
      dpd_timeout_seconds                = null
      express_route_circuit_id           = null
      peer_virtual_network_gateway_id    = null
      local_azure_ip_address_enabled     = null
      local_network_gateway_id           = null
      routing_weight                     = null
      shared_key                         = null
      connection_mode                    = null
      connection_protocol                = null
      enable_bgp                         = null
      express_route_gateway_bypass       = null
      egress_nat_rule_ids                = null
      ingress_nat_rule_ids               = null
      use_policy_based_traffic_selectors = null
      custom_bgp_addresses               = {}
      ipsec_policy = {
        sa_datasize = null
        sa_lifetime = null
      }
      traffic_selector_policy = {}
      tags                    = {}
    }
    virtual_network_peering = {
      name                         = ""
      allow_virtual_network_access = null
      allow_forwarded_traffic      = null
      allow_gateway_transit        = null
      use_remote_gateways          = null
      triggers                     = null
    }
  }

  // compare and merge custom and default values
  virtual_network_values = {
    for virtual_network in keys(var.virtual_network) :
    virtual_network => merge(local.default.virtual_network, var.virtual_network[virtual_network])
  }
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
  local_network_gateway_values = {
    for local_network_gateway in keys(var.local_network_gateway) :
    local_network_gateway => merge(local.default.local_network_gateway, var.local_network_gateway[local_network_gateway])
  }
  virtual_network_gateway_values = {
    for virtual_network_gateway in keys(var.virtual_network_gateway) :
    virtual_network_gateway => merge(local.default.virtual_network_gateway, var.virtual_network_gateway[virtual_network_gateway])
  }
  private_endpoint_values = {
    for private_endpoint in keys(var.private_endpoint) :
    private_endpoint => merge(local.default.private_endpoint, var.private_endpoint[private_endpoint])
  }
  virtual_network_gateway_connection_values = {
    for virtual_network_gateway_connection in keys(var.virtual_network_gateway_connection) :
    virtual_network_gateway_connection => merge(local.default.virtual_network_gateway_connection, var.virtual_network_gateway_connection[virtual_network_gateway_connection])
  }

  // deep merge of all custom and default values
  virtual_network = {
    for virtual_network in keys(var.virtual_network) :
    virtual_network => merge(
      local.virtual_network_values[virtual_network],
      {
        for config in ["subnet"] :
        config => keys(local.virtual_network_values[virtual_network][config]) == keys(local.default.virtual_network[config]) ? {} : {
          for key in keys(local.virtual_network_values[virtual_network][config]) :
          key => merge(local.default.virtual_network[config], local.virtual_network_values[virtual_network][config][key])
        }
      }
    )
  }
  subnet = {
    for subnet in keys(var.subnet) :
    subnet => merge(
      local.subnet_values[subnet],
      {
        for config in ["delegation"] :
        config => keys(local.subnet_values[subnet][config]) == keys(local.default.subnet[config]) ? {} : {
          for key in keys(local.subnet_values[subnet][config]) :
          key => merge(
            merge(local.default.subnet[config], local.subnet_values[subnet][config][key]),
            {
              for subconfig in ["service_delegation"] :
              subconfig => merge(local.default.subnet[config][subconfig], local.subnet_values[subnet][config][key][subconfig])
            }
          )
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
        config => keys(local.network_interface_values[network_interface][config]) == keys(local.default.network_interface[config]) ? {} : {
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
  local_network_gateway = {
    for local_network_gateway in keys(var.local_network_gateway) :
    local_network_gateway => merge(
      local.local_network_gateway_values[local_network_gateway],
      {
        for config in ["bgp_settings"] :
        config => merge(local.default.local_network_gateway[config], local.local_network_gateway_values[local_network_gateway][config])
      }
    )
  }
  virtual_network_gateway = {
    for virtual_network_gateway in keys(var.virtual_network_gateway) :
    virtual_network_gateway => merge(
      local.virtual_network_gateway_values[virtual_network_gateway],
      {
        for config in ["bgp_settings", "custom_route", "vpn_client_configuration"] :
        config => merge(local.default.virtual_network_gateway[config], local.virtual_network_gateway_values[virtual_network_gateway][config])
      },
      {
        for config in ["ip_configuration"] :
        config => {
          for key in keys(local.virtual_network_gateway_values[virtual_network_gateway][config]) :
          key => merge(local.default.virtual_network_gateway[config], local.virtual_network_gateway_values[virtual_network_gateway][config][key])
        }
      }
    )
  }
  private_endpoint = {
    for private_endpoint in keys(var.private_endpoint) :
    private_endpoint => merge(
      local.private_endpoint_values[private_endpoint],
      {
        for config in ["private_dns_zone_group", "private_service_connection"] :
        config => merge(local.default.private_endpoint[config], local.private_endpoint_values[private_endpoint][config])
      },
      {
        for config in ["ip_configuration"] :
        config => keys(local.private_endpoint_values[private_endpoint][config]) == keys(local.default.private_endpoint[config]) ? {} : {
          for key in keys(local.private_endpoint_values[private_endpoint][config]) :
          key => merge(local.default.private_endpoint[config], local.private_endpoint_values[private_endpoint][config][key])
        }
      }
    )
  }
  virtual_network_gateway_connection = {
    for virtual_network_gateway_connection in keys(var.virtual_network_gateway_connection) :
    virtual_network_gateway_connection => merge(
      local.virtual_network_gateway_connection_values[virtual_network_gateway_connection],
      {
        for config in ["custom_bgp_addresses", "ipsec_policy"] :
        config => merge(local.default.virtual_network_gateway_connection[config], local.virtual_network_gateway_connection_values[virtual_network_gateway_connection][config])
      },
      {
        for config in ["traffic_selector_policy"] :
        config => keys(local.virtual_network_gateway_connection_values[virtual_network_gateway_connection][config]) == keys(local.default.virtual_network_gateway_connection[config]) ? {} : {
          for key in keys(local.virtual_network_gateway_connection_values[virtual_network_gateway_connection][config]) :
          key => merge(local.default.virtual_network_gateway_connection[config], local.virtual_network_gateway_connection_values[virtual_network_gateway_connection][config][key])
        }
      }
    )
  }
  virtual_network_peering = {
    for virtual_network_peering in keys(var.virtual_network_peering) :
    virtual_network_peering => merge(local.default.virtual_network_peering, var.virtual_network_peering[virtual_network_peering])
  }
}
