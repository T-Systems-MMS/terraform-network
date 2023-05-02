module "network" {
  source = "registry.terraform.io/T-Systems-MMS/network/azurerm"
  virtual_network = {
    env = {
      name                = "service-env-vn"
      location            = "westeurope"
      resource_group_name = "service-env-rg"
      address_space       = ["192.30.100.0/23"]
      tags = {
        service = "service_name"
      }
    }
  }
  subnet = {
    aks = {
      name                                      = "service-aks-sub"
      resource_group_name                       = "service-env-rg"
      virtual_network_name                      = module.network.virtual_network.env.name
      address_prefixes                          = ["192.30.100.0/24"]
      private_endpoint_network_policies_enabled = true
      service_endpoints                         = ["Microsoft.AzureCosmosDB"]
    }
  }
}
