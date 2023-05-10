module "network" {
  source = "registry.terraform.io/telekom-mms/network/azurerm"
  virtual_network = {
    vn-db-mms = {
      location            = "westeurope"
      resource_group_name = "rg-mms-github"
      address_space       = ["172.0.0.0/28"]
      subnet = {
        snet-mysql-mms = {
          address_prefix = "172.0.0.0/29"
        }
        snet-psql-mms = {
          address_prefix = "172.0.0.8/29"
        }
      }
      tags = {
        project     = "mms-github"
        environment = terraform.workspace
        managed-by  = "terraform"
      }
    }
    vn-app-mms = {
      location            = "westeurope"
      resource_group_name = "rg-mms-github"
      address_space       = ["173.0.0.0/28"]
      tags = {
        project     = "mms-github"
        environment = terraform.workspace
        managed-by  = "terraform"
      }
    }
    vn-mgmt-mms = {
      location            = "westeurope"
      resource_group_name = "rg-mms-github"
      address_space       = ["174.0.0.0/28"]
      tags = {
        project     = "mms-github"
        environment = terraform.workspace
        managed-by  = "terraform"
      }
    }
  }
  subnet = {
    snet-app-mms = {
      resource_group_name  = module.network.virtual_network["vn-app-mms"].resource_group_name
      address_prefixes     = ["173.0.0.0/29"]
      virtual_network_name = module.network.virtual_network["vn-app-mms"].name
      service_endpoints    = ["Microsoft.Sql"]
    }
    GatewaySubnet = {
      resource_group_name  = module.network.virtual_network["vn-mgmt-mms"].resource_group_name
      address_prefixes     = ["174.0.0.0/29"]
      virtual_network_name = module.network.virtual_network["vn-mgmt-mms"].name
    }
  }
  public_ip = {
    pip-vpn-mms = {
      location            = "westeurope"
      resource_group_name = "rg-mms-github"
      tags = {
        project     = "mms-github"
        environment = terraform.workspace
        managed-by  = "terraform"
      }
    }
  }
  network_interface = {
    nic-app-mms = {
      location            = module.network.virtual_network["vn-app-mms"].location
      resource_group_name = module.network.virtual_network["vn-app-mms"].resource_group_name
      ip_configuration = {
        nic-app-mms-01 = {
          subnet_id          = module.network.subnet["snet-app-mms"].id
          private_ip_address = "173.0.0.5"
        }
      }
      tags = {
        project     = "mms-github"
        environment = terraform.workspace
        managed-by  = "terraform"
      }
    }
  }
  network_security_group = {
    nsg-app-mms = {
      location            = module.network.virtual_network["vn-app-mms"].location
      resource_group_name = module.network.virtual_network["vn-app-mms"].resource_group_name
      security_rule = {
        nsgsr-app-default = {}
      }
      tags = {
        project     = "mms-github"
        environment = terraform.workspace
        managed-by  = "terraform"
      }
    }
  }
  subnet_network_security_group_association = {
    snet-app-mms = {
      network_security_group_id = module.network.network_security_group["nsg-app-mms"].id
      subnet_id                 = module.network.subnet["snet-app-mms"].id
    }
  }
  network_interface_security_group_association = {
    nic-app-mms = {
      network_interface_id      = module.network.network_interface["nic-app-mms"].id
      network_security_group_id = module.network.network_security_group["nsg-app-mms"].id
    }
  }
  local_network_gateway = {
    lgw-mms = {
      location            = module.network.virtual_network["vn-mgmt-mms"].location
      resource_group_name = module.network.virtual_network["vn-mgmt-mms"].resource_group_name
      address_space       = ["192.0.0.0/28"]
      gateway_fqdn        = "gateway.mms.com"
    }
  }
  virtual_network_gateway = {
    vgw-mms = {
      location            = module.network.virtual_network["vn-mgmt-mms"].location
      resource_group_name = module.network.virtual_network["vn-mgmt-mms"].resource_group_name
      ip_configuration = {
        mms = {
          subnet_id            = module.network.subnet["GatewaySubnet"].id
          public_ip_address_id = module.network.public_ip["pip-vpn-mms"].id
        }
      }
      tags = {
        project     = "mms-github"
        environment = terraform.workspace
        managed-by  = "terraform"
      }
    }
  }
  virtual_network_gateway_connection = {
    vgwcn-mms = {
      location                   = module.network.virtual_network["vn-mgmt-mms"].location
      resource_group_name        = module.network.virtual_network["vn-mgmt-mms"].resource_group_name
      type                       = "IPsec"
      virtual_network_gateway_id = module.network.virtual_network_gateway["vgw-mms"].id
      tags = {
        project     = "mms-github"
        environment = terraform.workspace
        managed-by  = "terraform"
      }
    }
  }
  virtual_network_peering = {
    peer-mms = {
      resource_group_name       = module.network.virtual_network["vn-mgmt-mms"].resource_group_name
      virtual_network_name      = module.network.virtual_network["vn-mgmt-mms"].name
      remote_virtual_network_id = module.network.virtual_network["vn-db-mms"].id
      tags = {
        project     = "mms-github"
        environment = terraform.workspace
        managed-by  = "terraform"
      }
    }
  }
}
