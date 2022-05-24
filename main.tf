/**
 * # network
 *
 * This module manages Azure Network Configuration.
 *
*/

/** Virtuell Network */
resource "azurerm_virtual_network" "virtual_network" {
  for_each = var.virtual_network

  name                = local.virtual_network[each.key].name == "" ? each.key : local.virtual_network[each.key].name
  location            = local.virtual_network[each.key].location
  resource_group_name = local.virtual_network[each.key].resource_group_name
  address_space       = local.virtual_network[each.key].address_space

  tags = local.virtual_network[each.key].tags
}

/** Subnet */
resource "azurerm_subnet" "subnet" {
  for_each = var.subnet

  name                 = local.subnet[each.key].name == "" ? each.key : local.subnet[each.key].name
  resource_group_name  = local.subnet[each.key].resource_group_name
  virtual_network_name = local.subnet[each.key].virtual_network_name
  address_prefixes     = local.subnet[each.key].address_prefixes
  service_endpoints    = local.subnet[each.key].service_endpoints

  enforce_private_link_endpoint_network_policies = local.subnet[each.key].enforce_private_link_endpoint_network_policies
  enforce_private_link_service_network_policies  = local.subnet[each.key].enforce_private_link_service_network_policies

  dynamic "delegation" {
    for_each = local.subnet[each.key].delegation
    content {
      name = local.subnet[each.key].delegation[delegation.key].name == "" ? delegation.key : local.subnet[each.key].delegation[delegation.key].name
      dynamic "service_delegation" {
        for_each = local.subnet[each.key].delegation[delegation.key].service_delegation
        content {
          name    = local.subnet[each.key].delegation[delegation.key].service_delegation[service_delegation.key].name
          actions = local.subnet[each.key].delegation[delegation.key].service_delegation[service_delegation.key].actions
        }
      }
    }
  }
}

/** Public IP */
resource "azurerm_public_ip" "public_ip" {
  for_each = var.public_ip

  name                    = local.public_ip[each.key].name == "" ? each.key : local.public_ip[each.key].name
  location                = local.public_ip[each.key].location
  resource_group_name     = local.public_ip[each.key].resource_group_name
  allocation_method       = local.public_ip[each.key].allocation_method
  zones                   = local.public_ip[each.key].zones
  domain_name_label       = local.public_ip[each.key].domain_name_label
  edge_zone               = local.public_ip[each.key].edge_zone
  idle_timeout_in_minutes = local.public_ip[each.key].idle_timeout_in_minutes
  ip_tags                 = local.public_ip[each.key].ip_tags
  ip_version              = local.public_ip[each.key].ip_version
  public_ip_prefix_id     = local.public_ip[each.key].public_ip_prefix_id
  reverse_fqdn            = local.public_ip[each.key].reverse_fqdn
  sku                     = local.public_ip[each.key].sku
  sku_tier                = local.public_ip[each.key].sku_tier
  tags                    = local.public_ip[each.key].tags
}

/** Network Interface */
resource "azurerm_network_interface" "network_interface" {
  for_each = var.network_interface

  name                = local.network_interface[each.key].name == "" ? each.key : local.network_interface[each.key].name
  location            = local.network_interface[each.key].location
  resource_group_name = local.network_interface[each.key].resource_group_name

  dns_servers                   = local.network_interface[each.key].dns_servers
  enable_accelerated_networking = local.network_interface[each.key].enable_accelerated_networking
  enable_ip_forwarding          = local.network_interface[each.key].enable_ip_forwarding

  dynamic "ip_configuration" {
    for_each = local.network_interface[each.key].ip_configuration
    content {
      name                          = local.network_interface[each.key].ip_configuration[ip_configuration.key].name == "" ? ip_configuration.key : local.network_interface[each.key].ip_configuration[ip_configuration.key].name
      primary                       = local.network_interface[each.key].ip_configuration[ip_configuration.key].primary
      subnet_id                     = local.network_interface[each.key].ip_configuration[ip_configuration.key].subnet_id
      private_ip_address_allocation = local.network_interface[each.key].ip_configuration[ip_configuration.key].private_ip_address_allocation
      private_ip_address            = local.network_interface[each.key].ip_configuration[ip_configuration.key].private_ip_address
      private_ip_address_version    = local.network_interface[each.key].ip_configuration[ip_configuration.key].private_ip_address_version
      public_ip_address_id          = local.network_interface[each.key].ip_configuration[ip_configuration.key].public_ip_address_id
    }
  }

  tags = local.network_interface[each.key].tags
}

/** Network Security Group */
resource "azurerm_network_security_group" "network_security_group" {
  for_each = var.network_security_group

  name                = local.network_security_group[each.key].name == "" ? each.key : local.network_security_group[each.key].name
  location            = local.network_security_group[each.key].location
  resource_group_name = local.network_security_group[each.key].resource_group_name

  dynamic "security_rule" {
    for_each = local.network_security_group[each.key].security_rule
    content {
      name                       = local.network_security_group[each.key].security_rule[security_rule.key].name == "" ? security_rule.key : local.network_security_group[each.key].security_rule[security_rule.key].name
      direction                  = local.network_security_group[each.key].security_rule[security_rule.key].direction
      access                     = local.network_security_group[each.key].security_rule[security_rule.key].access
      protocol                   = local.network_security_group[each.key].security_rule[security_rule.key].protocol
      priority                   = local.network_security_group[each.key].security_rule[security_rule.key].priority
      source_address_prefix      = local.network_security_group[each.key].security_rule[security_rule.key].source_address_prefix
      source_port_range          = local.network_security_group[each.key].security_rule[security_rule.key].source_port_range
      destination_address_prefix = local.network_security_group[each.key].security_rule[security_rule.key].destination_address_prefix
      destination_port_range     = local.network_security_group[each.key].security_rule[security_rule.key].destination_port_range
    }
  }

  tags = local.network_security_group[each.key].tags
}

/** Network Security Group Association */
resource "azurerm_subnet_network_security_group_association" "subnet_network_security_group_association" {
  for_each = var.subnet_network_security_group_association

  subnet_id                 = local.subnet_network_security_group_association[each.key].subnet_id
  network_security_group_id = local.subnet_network_security_group_association[each.key].network_security_group_id
}
resource "azurerm_network_interface_security_group_association" "network_interface_security_group_association" {
  for_each = var.network_interface_security_group_association

  network_interface_id      = local.network_interface_security_group_association[each.key].network_interface_id
  network_security_group_id = local.network_interface_security_group_association[each.key].network_security_group_id
}

/** Private Endpoint */
resource "azurerm_private_endpoint" "private_endpoint" {
  for_each = var.private_endpoint

  name                = local.private_endpoint[each.key].name == "" ? each.key : local.private_endpoint[each.key].name
  location            = local.private_endpoint[each.key].location
  resource_group_name = local.private_endpoint[each.key].resource_group_name
  subnet_id           = local.private_endpoint[each.key].subnet_id

  dynamic "private_dns_zone_group" {
    for_each = local.private_endpoint[each.key].private_dns_zone_group

    content {
      name                 = local.private_endpoint[each.key].private_dns_zone_group[private_dns_zone_group.key].name == "" ? private_dns_zone_group.key : local.private_dns_zone_group[each.key].private_dns_zone_group[private_dns_zone_group.key].name
      private_dns_zone_ids = local.private_endpoint[each.key].private_dns_zone_group[private_dns_zone_group.key].private_dns_zone_ids
    }
  }

  dynamic "private_service_connection" {
    for_each = local.private_endpoint[each.key].private_service_connection

    content {
      name                           = local.private_endpoint[each.key].private_service_connection[private_service_connection.key].name == "" ? private_service_connection.key : local.private_service_connection[each.key].private_service_connection[private_service_connection.key].name
      is_manual_connection           = local.private_endpoint[each.key].private_service_connection[private_service_connection.key].is_manual_connection
      private_connection_resource_id = local.private_endpoint[each.key].private_service_connection[private_service_connection.key].private_connection_resource_id
      subresource_names              = local.private_endpoint[each.key].private_service_connection[private_service_connection.key].subresource_names
    }
  }

  tags = local.private_endpoint[each.key].tags
}

/** Virtuell Network Gateway */
resource "azurerm_virtual_network_gateway" "virtual_network_gateway" {
  for_each = var.virtual_network_gateway

  name                             = local.virtual_network_gateway[each.key].name == "" ? each.key : local.virtual_network_gateway[each.key].name
  location                         = local.virtual_network_gateway[each.key].location
  resource_group_name              = local.virtual_network_gateway[each.key].resource_group_name
  type                             = local.virtual_network_gateway[each.key].type
  vpn_type                         = local.virtual_network_gateway[each.key].vpn_type
  enable_bgp                       = local.virtual_network_gateway[each.key].enable_bgp
  active_active                    = local.virtual_network_gateway[each.key].active_active
  private_ip_address_enabled       = local.virtual_network_gateway[each.key].private_ip_address_enabled
  default_local_network_gateway_id = local.virtual_network_gateway[each.key].default_local_network_gateway_id
  sku                              = local.virtual_network_gateway[each.key].sku
  generation                       = local.virtual_network_gateway[each.key].generation

  dynamic "ip_configuration" {
    for_each = local.virtual_network_gateway[each.key].ip_configuration

    content {
      name                          = local.virtual_network_gateway[each.key].ip_configuration[ip_configuration.key].name == "" ? ip_configuration.key : local.virtual_network_gateway[each.key].ip_configuration[ip_configuration.key].name
      private_ip_address_allocation = local.virtual_network_gateway[each.key].ip_configuration[ip_configuration.key].private_ip_address_allocation
      subnet_id                     = local.virtual_network_gateway[each.key].ip_configuration[ip_configuration.key].subnet_id
      public_ip_address_id          = local.virtual_network_gateway[each.key].ip_configuration[ip_configuration.key].public_ip_address_id
    }
  }
  // dynamic "vpn_client_configuration" {
  //   for_each = local.virtual_network_gateway[each.key].vpn_client_configuration != {} ? [1] : []

  //   content {}
  // }
  tags = local.virtual_network_gateway[each.key].tags
}

/** Network Gateway Connection */
resource "azurerm_virtual_network_gateway_connection" "virtual_network_gateway_connection" {
  for_each = var.virtual_network_gateway_connection

  name                       = local.virtual_network_gateway_connection[each.key].name == "" ? each.key : local.virtual_network_gateway_connection[each.key].name
  location                   = local.virtual_network_gateway_connection[each.key].location
  resource_group_name        = local.virtual_network_gateway_connection[each.key].resource_group_name
  type                       = local.virtual_network_gateway_connection[each.key].type
  virtual_network_gateway_id = local.virtual_network_gateway_connection[each.key].virtual_network_gateway_id
  // authorization_key = local.virtual_network_gateway_connection[each.key].authorization_key
  dpd_timeout_seconds                = local.virtual_network_gateway_connection[each.key].dpd_timeout_seconds
  express_route_circuit_id           = local.virtual_network_gateway_connection[each.key].express_route_circuit_id
  peer_virtual_network_gateway_id    = local.virtual_network_gateway_connection[each.key].peer_virtual_network_gateway_id
  local_azure_ip_address_enabled     = local.virtual_network_gateway_connection[each.key].local_azure_ip_address_enabled
  local_network_gateway_id           = local.virtual_network_gateway_connection[each.key].local_network_gateway_id
  routing_weight                     = local.virtual_network_gateway_connection[each.key].routing_weight
  shared_key                         = local.virtual_network_gateway_connection[each.key].shared_key
  connection_mode                    = local.virtual_network_gateway_connection[each.key].connection_mode
  connection_protocol                = local.virtual_network_gateway_connection[each.key].connection_protocol
  enable_bgp                         = local.virtual_network_gateway_connection[each.key].enable_bgp
  express_route_gateway_bypass       = local.virtual_network_gateway_connection[each.key].express_route_gateway_bypass
  use_policy_based_traffic_selectors = local.virtual_network_gateway_connection[each.key].use_policy_based_traffic_selectors

  dynamic "traffic_selector_policy" {
    for_each = local.virtual_network_gateway_connection[each.key].traffic_selector_policy != {} ? [1] : []

    content {
      local_address_cidrs  = local.virtual_network_gateway_connection[each.key].traffic_selector_policy.local_address_cidrs
      remote_address_cidrs = local.virtual_network_gateway_connection[each.key].traffic_selector_policy.remote_address_cidrs
    }
  }

  dynamic "ipsec_policy" {
    for_each = local.virtual_network_gateway_connection[each.key].ipsec_policy != {} ? [1] : []

    content {
      dh_group         = local.virtual_network_gateway_connection[each.key].ipsec_policy.dh_group
      ike_encryption   = local.virtual_network_gateway_connection[each.key].ipsec_policy.ike_encryption
      ike_integrity    = local.virtual_network_gateway_connection[each.key].ipsec_policy.ike_integrity
      ipsec_encryption = local.virtual_network_gateway_connection[each.key].ipsec_policy.ipsec_encryption
      ipsec_integrity  = local.virtual_network_gateway_connection[each.key].ipsec_policy.ipsec_integrity
      pfs_group        = local.virtual_network_gateway_connection[each.key].ipsec_policy.pfs_group
      sa_datasize      = local.virtual_network_gateway_connection[each.key].ipsec_policy.sa_datasize
      sa_lifetime      = local.virtual_network_gateway_connection[each.key].ipsec_policy.sa_lifetime
    }
  }
  tags = local.virtual_network_gateway_connection[each.key].tags
}

/** local Network Gateway Connection */
resource "azurerm_local_network_gateway" "local_network_gateway" {
  for_each = var.local_network_gateway

  name                = local.local_network_gateway[each.key].name == "" ? each.key : local.local_network_gateway[each.key].name
  location            = local.local_network_gateway[each.key].location
  resource_group_name = local.local_network_gateway[each.key].resource_group_name
  address_space       = local.local_network_gateway[each.key].address_space
  gateway_address     = local.local_network_gateway[each.key].gateway_address

  dynamic "bgp_settings" {
    for_each = local.local_network_gateway[each.key].bgp_settings != {} ? [1] : []

    content {
      asn                 = local.local_network_gateway[each.key].bgp_settings.asn
      bgp_peering_address = local.local_network_gateway[each.key].bgp_settings.bgp_peering_address
      peer_weight         = local.local_network_gateway[each.key].bgp_settings.peer_weight
    }
  }

  tags = local.local_network_gateway[each.key].tags
}

/** Virtual Network Peering */
resource "azurerm_virtual_network_peering" "virtual_network_peering" {
  for_each = var.virtual_network_peering

  name                         = local.virtual_network_peering[each.key].name == "" ? each.key : local.virtual_network_peering[each.key].name
  resource_group_name          = local.virtual_network_peering[each.key].resource_group_name
  virtual_network_name         = local.virtual_network_peering[each.key].virtual_network_name
  remote_virtual_network_id    = local.virtual_network_peering[each.key].remote_virtual_network_id
  allow_virtual_network_access = local.virtual_network_peering[each.key].allow_virtual_network_access
  allow_forwarded_traffic      = local.virtual_network_peering[each.key].allow_forwarded_traffic
  allow_gateway_transit        = local.virtual_network_peering[each.key].allow_gateway_transit
  use_remote_gateways          = local.virtual_network_peering[each.key].use_remote_gateways
}
