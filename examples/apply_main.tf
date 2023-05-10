module "network" {
  source = "registry.terraform.io/telekom-mms/network/azurerm"
  virtual_network = {
    vn-app-mms = {
      location            = "westeurope"
      resource_group_name = "rg-mms-github"
      address_space       = ["173.0.0.0/28"]
    }
  }
  subnet = {
    snet-app-mms = {
      resource_group_name  = module.network.virtual_network["vn-app-mms"].resource_group_name
      address_prefixes     = ["173.0.0.0/29"]
      virtual_network_name = module.network.virtual_network["vn-app-mms"].name
    }
  }
  public_ip = {
    pip-vpn-mms = {
      location            = "westeurope"
      resource_group_name = "rg-mms-github"
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
    }
  }
}
