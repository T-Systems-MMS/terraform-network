variable "resource_name" {
  type = any
  default = {
    virtual_network = {}
    subnet          = {}
  }
  description = "Azure Network"
}
variable "location" {
  type        = string
  description = "location where the resource should be created"
}
variable "resource_group_name" {
  type        = string
  description = "resource_group whitin the resource should be created"
}
variable "tags" {
  type        = any
  default     = {}
  description = "mapping of tags to assign, default settings are defined within locals and merged with var settings"
}
# resource definition
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

# resource configuration
variable "network_interface_config" {
  type        = any
  default     = {}
  description = "resource configuration, default settings are defined within locals and merged with var settings"
}

locals {
  default = {
    tags = {}
    # resource definition
    virtual_network = {}
    subnet = {
      service_endpoints                              = []
      enforce_private_link_endpoint_network_policies = false
      enforce_private_link_service_network_policies  = false
    }
    public_ip = {
      allocation_method = "Static"
      sku               = "Basic"
    }
    network_interface = {
      dns_servers                   = []
      enable_accelerated_networking = false
      enable_ip_forwarding          = false
      internal_dns_name_labe        = ""
    }
    network_security_group = {
      security_rule = {
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_address_prefix      = "*"
        source_port_range          = "*"
        destination_address_prefix = "*"
      }
    }
    network_interface_security_group_association = {}
    private_endpoint = {
      private_dns_zone_group     = {}
      private_service_connection = {}
    }
    # resource definition
    network_interface_config = {
      ip_configuration = {
        primary                       = true
        private_ip_address_allocation = "Static"
        private_ip_address_version    = "IPv4"
        public_ip_address_id          = ""
      }
    }
  }

  # merge custom and default values
  tags = merge(local.default.tags, var.tags)

  # deep merge over merged config and use defaults if no variable is set
  virtual_network = {
    # get all config
    for config in keys(var.virtual_network) :
    config => merge(local.default.virtual_network, var.virtual_network[config])
  }
  subnet = {
    # get all config
    for config in keys(var.subnet) :
    config => merge(local.default.subnet, var.subnet[config])
  }
  public_ip = {
    # get all config
    for config in keys(var.public_ip) :
    config => merge(local.default.public_ip, var.public_ip[config])
  }
  network_interface = {
    # get all config
    for config in keys(var.network_interface) :
    config => merge(local.default.network_interface, var.network_interface[config])
  }
  network_interface_config = {
    # get all config
    for instance in keys(var.network_interface_config) :
    instance => {
      for config in keys(local.default.network_interface_config) :
      config => {
        for config_instance in keys(var.network_interface_config[instance][config]) :
        config_instance => merge(local.default.network_interface_config[config], var.network_interface_config[instance][config][config_instance])
      }
    }
  }
  network_security_group = {
    # get all config
    for instance in keys(var.network_security_group) :
    instance => {
      for config in keys(local.default.network_security_group) :
      config => {
        for config_instance in keys(var.network_security_group[instance][config]) :
        config_instance => merge(local.default.network_security_group[config], var.network_security_group[instance][config][config_instance])
      }
    }
  }
  network_interface_security_group_association = {
    # get all config
    for config in keys(var.network_interface_security_group_association) :
    config => merge(local.default.network_interface_security_group_association, var.network_interface_security_group_association[config])
  }
  private_endpoint = {
    # get all config
    for config in keys(var.private_endpoint) :
    config => merge(local.default.private_endpoint, var.private_endpoint[config])
  }
}
