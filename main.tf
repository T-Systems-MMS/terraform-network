/**
* # network
*
* This module manages the hashicorp/azurerm network resources.
* For more information see https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs > network
*
*/

resource "azurerm_virtual_network" "virtual_network" {
  for_each = var.virtual_network

  name                = local.virtual_network[each.key].name == "" ? each.key : local.virtual_network[each.key].name
  location            = local.virtual_network[each.key].location
  resource_group_name = local.virtual_network[each.key].resource_group_name
  address_space       = local.virtual_network[each.key].address_space

  bgp_community           = local.virtual_network[each.key].bgp_community
  dns_servers             = local.virtual_network[each.key].dns_servers
  edge_zone               = local.virtual_network[each.key].edge_zone
  flow_timeout_in_minutes = local.virtual_network[each.key].flow_timeout_in_minutes

  dynamic "ddos_protection_plan" {
    for_each = local.virtual_network[each.key].ddos_protection_plan != {} ? [1] : []

    content {
      id     = local.virtual_network[each.key].ddos_protection_plan.id
      enable = local.virtual_network[each.key].ddos_protection_plan.enable
    }
  }

  dynamic "subnet" {
    for_each = local.virtual_network[each.key].subnet

    content {
      name           = local.virtual_network[each.key].subnet[subnet.key].name == "" ? subnet.key : local.virtual_network[each.key].subnet[subnet.key].name
      address_prefix = local.virtual_network[each.key].subnet[subnet.key].address_prefix
      security_group = local.virtual_network[each.key].subnet[subnet.key].security_group
    }
  }

  tags = local.virtual_network[each.key].tags
}

resource "azurerm_subnet" "subnet" {
  #ts:skip=AC_AZURE_0356 terrascan - network security group has to be done separate
  for_each = var.subnet

  name                                          = local.subnet[each.key].name == "" ? each.key : local.subnet[each.key].name
  resource_group_name                           = local.subnet[each.key].resource_group_name
  virtual_network_name                          = local.subnet[each.key].virtual_network_name
  address_prefixes                              = local.subnet[each.key].address_prefixes
  private_endpoint_network_policies_enabled     = local.subnet[each.key].private_endpoint_network_policies_enabled
  private_link_service_network_policies_enabled = local.subnet[each.key].private_link_service_network_policies_enabled
  service_endpoints                             = local.subnet[each.key].service_endpoints
  service_endpoint_policy_ids                   = local.subnet[each.key].service_endpoint_policy_ids


  dynamic "delegation" {
    for_each = local.subnet[each.key].delegation

    content {
      name = local.subnet[each.key].delegation[delegation.key].name == "" ? delegation.key : local.subnet[each.key].delegation[delegation.key].name

      service_delegation {
        name    = local.subnet[each.key].delegation[delegation.key].service_delegation.name
        actions = local.subnet[each.key].delegation[delegation.key].service_delegation.actions
      }
    }
  }
}

resource "azurerm_public_ip" "public_ip" {
  for_each = var.public_ip

  name                    = local.public_ip[each.key].name == "" ? each.key : local.public_ip[each.key].name
  location                = local.public_ip[each.key].location
  resource_group_name     = local.public_ip[each.key].resource_group_name
  allocation_method       = local.public_ip[each.key].allocation_method
  zones                   = local.public_ip[each.key].zones
  ddos_protection_mode    = local.public_ip[each.key].ddos_protection_mode
  ddos_protection_plan_id = local.public_ip[each.key].ddos_protection_plan_id
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

resource "azurerm_network_interface" "network_interface" {
  for_each = var.network_interface

  name                = local.network_interface[each.key].name == "" ? each.key : local.network_interface[each.key].name
  location            = local.network_interface[each.key].location
  resource_group_name = local.network_interface[each.key].resource_group_name

  dns_servers                   = local.network_interface[each.key].dns_servers
  edge_zone                     = local.network_interface[each.key].edge_zone
  enable_ip_forwarding          = local.network_interface[each.key].enable_ip_forwarding
  enable_accelerated_networking = local.network_interface[each.key].enable_accelerated_networking
  internal_dns_name_label       = local.network_interface[each.key].internal_dns_name_label

  dynamic "ip_configuration" {
    for_each = local.network_interface[each.key].ip_configuration

    content {
      name                                               = local.network_interface[each.key].ip_configuration[ip_configuration.key].name == "" ? ip_configuration.key : local.network_interface[each.key].ip_configuration[ip_configuration.key].name
      gateway_load_balancer_frontend_ip_configuration_id = local.network_interface[each.key].ip_configuration[ip_configuration.key].gateway_load_balancer_frontend_ip_configuration_id
      subnet_id                                          = local.network_interface[each.key].ip_configuration[ip_configuration.key].subnet_id
      private_ip_address                                 = local.network_interface[each.key].ip_configuration[ip_configuration.key].private_ip_address
      private_ip_address_version                         = local.network_interface[each.key].ip_configuration[ip_configuration.key].private_ip_address_version
      private_ip_address_allocation                      = local.network_interface[each.key].ip_configuration[ip_configuration.key].private_ip_address_allocation
      public_ip_address_id                               = local.network_interface[each.key].ip_configuration[ip_configuration.key].public_ip_address_id
      // must be true for the first when multiple ip_configuration are specified
      primary = index(keys(local.network_interface[each.key].ip_configuration), ip_configuration.key) == 0 ? true : false
    }
  }

  tags = local.network_interface[each.key].tags
}

resource "azurerm_network_security_group" "network_security_group" {
  for_each = var.network_security_group

  name                = local.network_security_group[each.key].name == "" ? each.key : local.network_security_group[each.key].name
  location            = local.network_security_group[each.key].location
  resource_group_name = local.network_security_group[each.key].resource_group_name

  dynamic "security_rule" {
    for_each = local.network_security_group[each.key].security_rule

    content {
      name                                       = local.network_security_group[each.key].security_rule[security_rule.key].name == "" ? security_rule.key : local.network_security_group[each.key].security_rule[security_rule.key].name
      description                                = local.network_security_group[each.key].security_rule[security_rule.key].description
      protocol                                   = local.network_security_group[each.key].security_rule[security_rule.key].protocol
      source_port_range                          = local.network_security_group[each.key].security_rule[security_rule.key].source_port_ranges != null ? null : local.network_security_group[each.key].security_rule[security_rule.key].source_port_range
      source_port_ranges                         = local.network_security_group[each.key].security_rule[security_rule.key].source_port_ranges
      destination_port_range                     = local.network_security_group[each.key].security_rule[security_rule.key].destination_port_ranges != null ? null : local.network_security_group[each.key].security_rule[security_rule.key].destination_port_range
      destination_port_ranges                    = local.network_security_group[each.key].security_rule[security_rule.key].destination_port_ranges
      source_address_prefix                      = local.network_security_group[each.key].security_rule[security_rule.key].source_address_prefixes != null ? null : local.network_security_group[each.key].security_rule[security_rule.key].source_address_prefix
      source_address_prefixes                    = local.network_security_group[each.key].security_rule[security_rule.key].source_address_prefixes
      source_application_security_group_ids      = local.network_security_group[each.key].security_rule[security_rule.key].source_application_security_group_ids
      destination_address_prefix                 = local.network_security_group[each.key].security_rule[security_rule.key].destination_address_prefixes != null ? null : local.network_security_group[each.key].security_rule[security_rule.key].destination_address_prefix
      destination_address_prefixes               = local.network_security_group[each.key].security_rule[security_rule.key].destination_address_prefixes
      destination_application_security_group_ids = local.network_security_group[each.key].security_rule[security_rule.key].destination_application_security_group_ids
      access                                     = local.network_security_group[each.key].security_rule[security_rule.key].access
      // first rule should start with highest priority
      priority  = index(keys(local.network_security_group[each.key].security_rule), security_rule.key) == 0 ? 100 : local.network_security_group[each.key].security_rule[security_rule.key].priority
      direction = local.network_security_group[each.key].security_rule[security_rule.key].direction
    }
  }

  tags = local.network_security_group[each.key].tags
}

resource "azurerm_subnet_network_security_group_association" "subnet_network_security_group_association" {
  for_each = var.subnet_network_security_group_association

  network_security_group_id = local.subnet_network_security_group_association[each.key].network_security_group_id
  subnet_id                 = local.subnet_network_security_group_association[each.key].subnet_id
}

resource "azurerm_network_interface_security_group_association" "network_interface_security_group_association" {
  for_each = var.network_interface_security_group_association

  network_interface_id      = local.network_interface_security_group_association[each.key].network_interface_id
  network_security_group_id = local.network_interface_security_group_association[each.key].network_security_group_id
}

resource "azurerm_local_network_gateway" "local_network_gateway" {
  for_each = var.local_network_gateway

  name                = local.local_network_gateway[each.key].name == "" ? each.key : local.local_network_gateway[each.key].name
  location            = local.local_network_gateway[each.key].location
  resource_group_name = local.local_network_gateway[each.key].resource_group_name
  address_space       = local.local_network_gateway[each.key].address_space
  gateway_address     = local.local_network_gateway[each.key].gateway_address
  gateway_fqdn        = local.local_network_gateway[each.key].gateway_fqdn

  dynamic "bgp_settings" {
    for_each = length(compact(values(local.local_network_gateway[each.key].bgp_settings))) > 0 ? [0] : []

    content {
      asn                 = local.local_network_gateway[each.key].bgp_settings.asn
      bgp_peering_address = local.local_network_gateway[each.key].bgp_settings.bgp_peering_address
      peer_weight         = local.local_network_gateway[each.key].bgp_settings.peer_weight
    }
  }

  tags = local.local_network_gateway[each.key].tags
}

resource "azurerm_virtual_network_gateway" "virtual_network_gateway" {
  for_each = var.virtual_network_gateway

  name                             = local.virtual_network_gateway[each.key].name == "" ? each.key : local.virtual_network_gateway[each.key].name
  location                         = local.virtual_network_gateway[each.key].location
  resource_group_name              = local.virtual_network_gateway[each.key].resource_group_name
  sku                              = local.virtual_network_gateway[each.key].sku
  type                             = local.virtual_network_gateway[each.key].type
  active_active                    = local.virtual_network_gateway[each.key].active_active
  default_local_network_gateway_id = local.virtual_network_gateway[each.key].default_local_network_gateway_id
  edge_zone                        = local.virtual_network_gateway[each.key].edge_zone
  enable_bgp                       = local.virtual_network_gateway[each.key].enable_bgp
  generation                       = local.virtual_network_gateway[each.key].generation
  private_ip_address_enabled       = local.virtual_network_gateway[each.key].private_ip_address_enabled
  vpn_type                         = local.virtual_network_gateway[each.key].vpn_type

  dynamic "ip_configuration" {
    for_each = local.virtual_network_gateway[each.key].ip_configuration

    content {
      name                          = local.virtual_network_gateway[each.key].ip_configuration[ip_configuration.key].name == "" ? ip_configuration.key : local.virtual_network_gateway[each.key].ip_configuration[ip_configuration.key].name
      private_ip_address_allocation = local.virtual_network_gateway[each.key].ip_configuration[ip_configuration.key].private_ip_address_allocation
      subnet_id                     = local.virtual_network_gateway[each.key].ip_configuration[ip_configuration.key].subnet_id
      public_ip_address_id          = local.virtual_network_gateway[each.key].ip_configuration[ip_configuration.key].public_ip_address_id
    }
  }

  dynamic "bgp_settings" {
    for_each = length(compact(
      concat(
        [local.virtual_network_gateway[each.key].bgp_settings.asn, local.virtual_network_gateway[each.key].bgp_settings.peer_weight],
        values(local.virtual_network_gateway[each.key].bgp_settings.peering_addresses)
    ))) > 0 ? [0] : []

    content {
      asn         = local.virtual_network_gateway[each.key].bgp_settings.asn
      peer_weight = local.virtual_network_gateway[each.key].bgp_settings.peer_weight
      peering_addresses {
        ip_configuration_name = local.virtual_network_gateway[each.key].bgp_settings.peering_addresses.ip_configuration_name
        apipa_addresses       = local.virtual_network_gateway[each.key].bgp_settings.peering_addresses.apipa_addresses
      }
    }
  }

  dynamic "custom_route" {
    for_each = length(compact(values(local.virtual_network_gateway[each.key].custom_route))) > 0 ? [0] : []

    content {
      address_prefixes = local.virtual_network_gateway[each.key].custom_route.address_prefixes
    }
  }

  dynamic "vpn_client_configuration" {
    for_each = local.virtual_network_gateway[each.key].vpn_client_configuration.address_space == "" ? [] : [0]

    content {
      address_space         = local.virtual_network_gateway[each.key].vpn_client_configuration.address_space
      aad_tenant            = local.virtual_network_gateway[each.key].vpn_client_configuration.aad_tenant
      aad_audience          = local.virtual_network_gateway[each.key].vpn_client_configuration.aad_audience
      aad_issuer            = local.virtual_network_gateway[each.key].vpn_client_configuration.aad_issuer
      radius_server_address = local.virtual_network_gateway[each.key].vpn_client_configuration.radius_server_address
      radius_server_secret  = local.virtual_network_gateway[each.key].vpn_client_configuration.radius_server_secret
      vpn_client_protocols  = local.virtual_network_gateway[each.key].vpn_client_configuration.vpn_client_protocols
      vpn_auth_types        = local.virtual_network_gateway[each.key].vpn_client_configuration.vpn_auth_types

      dynamic "root_certificate" {
        for_each = local.virtual_network_gateway[each.key].vpn_client_configuration.root_certificate

        content {
          name             = local.virtual_network_gateway[each.key].vpn_client_configuration.root_certificate[root_certificate.key].name == "" ? root_certificate.key : local.virtual_network_gateway[each.key].vpn_client_configuration.root_certificate[root_certificate.key].name
          public_cert_data = local.virtual_network_gateway[each.key].vpn_client_configuration.root_certificate[root_certificate.key].public_cert_data
        }
      }
      dynamic "revoked_certificate" {
        for_each = local.virtual_network_gateway[each.key].vpn_client_configuration.revoked_certificate

        content {
          name       = local.virtual_network_gateway[each.key].vpn_client_configuration.revoked_certificate[revoked_certificate.key].name == "" ? revoked_certificate.key : local.virtual_network_gateway[each.key].vpn_client_configuration.revoked_certificate[revoked_certificate.key].name
          thumbprint = local.virtual_network_gateway[each.key].vpn_client_configuration.revoked_certificate[revoked_certificate.key].thumbprint
        }
      }
    }
  }

  tags = local.virtual_network_gateway[each.key].tags
}

resource "azurerm_private_endpoint" "private_endpoint" {
  for_each = var.private_endpoint

  name                          = local.private_endpoint[each.key].name == "" ? each.key : local.private_endpoint[each.key].name
  location                      = local.private_endpoint[each.key].location
  resource_group_name           = local.private_endpoint[each.key].resource_group_name
  subnet_id                     = local.private_endpoint[each.key].subnet_id
  custom_network_interface_name = local.private_endpoint[each.key].custom_network_interface_name

  dynamic "private_dns_zone_group" {
    for_each = local.private_endpoint[each.key].private_dns_zone_group == {} ? [] : [0]

    content {
      name                 = local.private_endpoint[each.key].private_dns_zone_group.name
      private_dns_zone_ids = local.private_endpoint[each.key].private_dns_zone_group.private_dns_zone_ids
    }
  }

  private_service_connection {
    name                              = local.private_endpoint[each.key].private_service_connection.name == "" ? each.key : local.private_endpoint[each.key].private_service_connection.name
    is_manual_connection              = local.private_endpoint[each.key].private_service_connection.is_manual_connection
    private_connection_resource_id    = local.private_endpoint[each.key].private_service_connection.private_connection_resource_id
    private_connection_resource_alias = local.private_endpoint[each.key].private_service_connection.private_connection_resource_alias
    subresource_names                 = local.private_endpoint[each.key].private_service_connection.subresource_names
    request_message                   = local.private_endpoint[each.key].private_service_connection.request_message
  }

  dynamic "ip_configuration" {
    for_each = local.private_endpoint[each.key].ip_configuration

    content {
      name               = local.private_endpoint[each.key].ip_configuration[ip_configuration.key].name == "" ? ip_configuration.key : local.private_endpoint[each.key].ip_configuration[ip_configuration.key].name
      private_ip_address = local.private_endpoint[each.key].ip_configuration[ip_configuration.key].private_ip_address
      subresource_name   = local.private_endpoint[each.key].ip_configuration[ip_configuration.key].subresource_name
      member_name        = local.private_endpoint[each.key].ip_configuration[ip_configuration.key].member_name
    }
  }

  tags = local.private_endpoint[each.key].tags
}

resource "azurerm_virtual_network_gateway_connection" "virtual_network_gateway_connection" {
  for_each = var.virtual_network_gateway_connection

  name                               = local.virtual_network_gateway_connection[each.key].name == "" ? each.key : local.virtual_network_gateway_connection[each.key].name
  location                           = local.virtual_network_gateway_connection[each.key].location
  resource_group_name                = local.virtual_network_gateway_connection[each.key].resource_group_name
  type                               = local.virtual_network_gateway_connection[each.key].type
  virtual_network_gateway_id         = local.virtual_network_gateway_connection[each.key].virtual_network_gateway_id
  authorization_key                  = local.virtual_network_gateway_connection[each.key].authorization_key
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
  egress_nat_rule_ids                = local.virtual_network_gateway_connection[each.key].egress_nat_rule_ids
  ingress_nat_rule_ids               = local.virtual_network_gateway_connection[each.key].ingress_nat_rule_ids
  use_policy_based_traffic_selectors = local.virtual_network_gateway_connection[each.key].use_policy_based_traffic_selectors

  dynamic "custom_bgp_addresses" {
    for_each = local.virtual_network_gateway_connection[each.key].custom_bgp_addresses == {} ? [] : [0]

    content {
      primary   = local.virtual_network_gateway_connection[each.key].custom_bgp_addresses.primary
      secondary = local.virtual_network_gateway_connection[each.key].custom_bgp_addresses.secondary
    }
  }

  dynamic "ipsec_policy" {
    for_each = length(compact(values(local.virtual_network_gateway_connection[each.key].ipsec_policy))) > 0 ? [0] : []

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

  dynamic "traffic_selector_policy" {
    for_each = local.virtual_network_gateway_connection[each.key].traffic_selector_policy == {} ? [] : [0]

    content {
      local_address_cidrs  = local.virtual_network_gateway_connection[each.key].traffic_selector_policy[traffic_selector_policy.key].local_address_cidrs
      remote_address_cidrs = local.virtual_network_gateway_connection[each.key].traffic_selector_policy[traffic_selector_policy.key].remote_address_cidrs
    }
  }

  tags = local.virtual_network_gateway_connection[each.key].tags
}

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
  triggers                     = local.virtual_network_peering[each.key].triggers
}

resource "azurerm_application_gateway" "application_gateway" {
  for_each = var.application_gateway

  name                              = local.application_gateway[each.key].name == "" ? each.key : local.application_gateway[each.key].name
  resource_group_name               = local.application_gateway[each.key].resource_group_name
  location                          = local.application_gateway[each.key].location
  fips_enabled                      = local.application_gateway[each.key].fips_enabled
  zones                             = local.application_gateway[each.key].zones
  enable_http2                      = local.application_gateway[each.key].enable_http2
  force_firewall_policy_association = local.application_gateway[each.key].force_firewall_policy_association
  firewall_policy_id                = local.application_gateway[each.key].firewall_policy_id

  dynamic "backend_address_pool" {
    for_each = local.application_gateway[each.key].backend_address_pool

    content {
      name         = local.application_gateway[each.key].backend_address_pool[backend_address_pool.key].name == "" ? backend_address_pool.key : local.application_gateway[each.key].backend_address_pool[backend_address_pool.key].name
      fqdns        = local.application_gateway[each.key].backend_address_pool[backend_address_pool.key].fqdns
      ip_addresses = local.application_gateway[each.key].backend_address_pool[backend_address_pool.key].ip_addresses
    }
  }

  dynamic "backend_http_settings" {
    for_each = local.application_gateway[each.key].backend_http_settings

    content {
      name                                = local.application_gateway[each.key].backend_http_settings[backend_http_settings.key].name == "" ? backend_http_settings.key : local.application_gateway[each.key].backend_http_settings[backend_http_settings.key].name
      cookie_based_affinity               = local.application_gateway[each.key].backend_http_settings[backend_http_settings.key].cookie_based_affinity
      affinity_cookie_name                = local.application_gateway[each.key].backend_http_settings[backend_http_settings.key].affinity_cookie_name
      path                                = local.application_gateway[each.key].backend_http_settings[backend_http_settings.key].path
      port                                = local.application_gateway[each.key].backend_http_settings[backend_http_settings.key].port
      probe_name                          = local.application_gateway[each.key].backend_http_settings[backend_http_settings.key].probe_name
      protocol                            = local.application_gateway[each.key].backend_http_settings[backend_http_settings.key].protocol
      request_timeout                     = local.application_gateway[each.key].backend_http_settings[backend_http_settings.key].request_timeout
      host_name                           = local.application_gateway[each.key].backend_http_settings[backend_http_settings.key].host_name
      pick_host_name_from_backend_address = local.application_gateway[each.key].backend_http_settings[backend_http_settings.key].pick_host_name_from_backend_address
      trusted_root_certificate_names      = local.application_gateway[each.key].backend_http_settings[backend_http_settings.key].trusted_root_certificate_names

      dynamic "authentication_certificate" {
        for_each = local.application_gateway[each.key].backend_http_settings[backend_http_settings.key].authentication_certificate

        content {
          name = local.application_gateway[each.key].backend_http_settings[backend_http_settings.key].authentication_certificate[authentication_certificate.key].name == "" ? authentication_certificate.key : local.application_gateway[each.key].backend_http_settings[backend_http_settings.key].authentication_certificate[authentication_certificate.key].name
        }
      }

      dynamic "connection_draining" {
        for_each = local.application_gateway[each.key].backend_http_settings[backend_http_settings.key].connection_draining == {} ? [] : [0]

        content {
          enabled           = local.application_gateway[each.key].backend_http_settings[backend_http_settings.key].connection_draining.enabled
          drain_timeout_sec = local.application_gateway[each.key].backend_http_settings[backend_http_settings.key].connection_draining.drain_timeout_sec
        }
      }
    }
  }

  dynamic "frontend_ip_configuration" {
    for_each = local.application_gateway[each.key].frontend_ip_configuration

    content {
      name                            = local.application_gateway[each.key].frontend_ip_configuration[frontend_ip_configuration.key].name == "" ? frontend_ip_configuration.key : local.application_gateway[each.key].frontend_ip_configuration[frontend_ip_configuration.key].name
      subnet_id                       = local.application_gateway[each.key].frontend_ip_configuration[frontend_ip_configuration.key].subnet_id
      private_ip_address              = local.application_gateway[each.key].frontend_ip_configuration[frontend_ip_configuration.key].private_ip_address
      public_ip_address_id            = local.application_gateway[each.key].frontend_ip_configuration[frontend_ip_configuration.key].public_ip_address_id
      private_ip_address_allocation   = local.application_gateway[each.key].frontend_ip_configuration[frontend_ip_configuration.key].private_ip_address_allocation
      private_link_configuration_name = local.application_gateway[each.key].frontend_ip_configuration[frontend_ip_configuration.key].private_link_configuration_name
    }
  }

  dynamic "frontend_port" {
    for_each = local.application_gateway[each.key].frontend_port

    content {
      name = local.application_gateway[each.key].frontend_port[frontend_port.key].name == "" ? frontend_port.key : local.application_gateway[each.key].frontend_port[frontend_port.key].name
      port = local.application_gateway[each.key].frontend_port[frontend_port.key].port
    }
  }

  dynamic "gateway_ip_configuration" {
    for_each = local.application_gateway[each.key].gateway_ip_configuration

    content {
      name      = local.application_gateway[each.key].gateway_ip_configuration[gateway_ip_configuration.key].name == "" ? gateway_ip_configuration.key : local.application_gateway[each.key].gateway_ip_configuration[gateway_ip_configuration.key].name
      subnet_id = local.application_gateway[each.key].gateway_ip_configuration[gateway_ip_configuration.key].subnet_id
    }
  }

  dynamic "http_listener" {
    for_each = local.application_gateway[each.key].http_listener

    content {
      name                           = local.application_gateway[each.key].http_listener[http_listener.key].name == "" ? http_listener.key : local.application_gateway[each.key].http_listener[http_listener.key].name
      frontend_ip_configuration_name = local.application_gateway[each.key].http_listener[http_listener.key].frontend_ip_configuration_name
      frontend_port_name             = local.application_gateway[each.key].http_listener[http_listener.key].frontend_port_name
      host_name                      = local.application_gateway[each.key].http_listener[http_listener.key].host_name
      host_names                     = local.application_gateway[each.key].http_listener[http_listener.key].host_names
      protocol                       = local.application_gateway[each.key].http_listener[http_listener.key].protocol
      require_sni                    = local.application_gateway[each.key].http_listener[http_listener.key].require_sni
      ssl_certificate_name           = local.application_gateway[each.key].http_listener[http_listener.key].ssl_certificate_name
      firewall_policy_id             = local.application_gateway[each.key].http_listener[http_listener.key].firewall_policy_id
      ssl_profile_name               = local.application_gateway[each.key].http_listener[http_listener.key].ssl_profile_name

      dynamic "custom_error_configuration" {
        for_each = local.application_gateway[each.key].http_listener[http_listener.key].custom_error_configuration

        content {
          status_code           = local.application_gateway[each.key].http_listener[http_listener.key].custom_error_configuration[custom_error_configuration.key].status_code
          custom_error_page_url = local.application_gateway[each.key].http_listener[http_listener.key].custom_error_configuration[custom_error_configuration.key].custom_error_page_url
        }
      }
    }
  }

  dynamic "request_routing_rule" {
    for_each = local.application_gateway[each.key].request_routing_rule

    content {
      name                        = local.application_gateway[each.key].request_routing_rule[request_routing_rule.key].name == "" ? request_routing_rule.key : local.application_gateway[each.key].request_routing_rule[request_routing_rule.key].name
      rule_type                   = local.application_gateway[each.key].request_routing_rule[request_routing_rule.key].rule_type
      http_listener_name          = local.application_gateway[each.key].request_routing_rule[request_routing_rule.key].http_listener_name
      backend_address_pool_name   = local.application_gateway[each.key].request_routing_rule[request_routing_rule.key].backend_address_pool_name
      backend_http_settings_name  = local.application_gateway[each.key].request_routing_rule[request_routing_rule.key].backend_http_settings_name
      redirect_configuration_name = local.application_gateway[each.key].request_routing_rule[request_routing_rule.key].redirect_configuration_name
      rewrite_rule_set_name       = local.application_gateway[each.key].request_routing_rule[request_routing_rule.key].rewrite_rule_set_name
      url_path_map_name           = local.application_gateway[each.key].request_routing_rule[request_routing_rule.key].url_path_map_name
      priority                    = local.application_gateway[each.key].request_routing_rule[request_routing_rule.key].priority
    }
  }

  sku {
    name     = local.application_gateway[each.key].sku.name
    tier     = local.application_gateway[each.key].sku.tier
    capacity = local.application_gateway[each.key].sku.capacity
  }

  dynamic "global" {
    for_each = local.application_gateway[each.key].global == {} ? [] : [0]

    content {
      request_buffering_enabled  = local.application_gateway[each.key].global.request_buffering_enabled
      response_buffering_enabled = local.application_gateway[each.key].global.response_buffering_enabled
    }
  }

  dynamic "identity" {
    for_each = local.application_gateway[each.key].identity == null ? [] : [0]

    content {
      type         = local.application_gateway[each.key].identity.type
      identity_ids = local.application_gateway[each.key].identity.identity_ids
    }
  }

  dynamic "private_link_configuration" {
    for_each = local.application_gateway[each.key].private_link_configuration

    content {
      name = local.application_gateway[each.key].private_link_configuration[private_link_configuration.key].name == "" ? private_link_configuration.key : local.application_gateway[each.key].private_link_configuration[private_link_configuration.key].name

      dynamic "ip_configuration" {
        for_each = local.application_gateway[each.key].private_link_configuration[private_link_configuration.key].ip_configuration

        content {
          name                          = local.application_gateway[each.key].private_link_configuration[private_link_configuration.key].ip_configuration[ip_configuration.key].name == "" ? ip_configuration.key : local.application_gateway[each.key].private_link_configuration[private_link_configuration.key].ip_configuration[ip_configuration.key].name
          subnet_id                     = local.application_gateway[each.key].private_link_configuration[private_link_configuration.key].ip_configuration[ip_configuration.key].subnet_id
          private_ip_address_allocation = local.application_gateway[each.key].private_link_configuration[private_link_configuration.key].ip_configuration[ip_configuration.key].private_ip_address_allocation
          primary                       = local.application_gateway[each.key].private_link_configuration[private_link_configuration.key].ip_configuration[ip_configuration.key].primary
          private_ip_address            = local.application_gateway[each.key].private_link_configuration[private_link_configuration.key].ip_configuration[ip_configuration.key].private_ip_address
        }
      }
    }
  }

  dynamic "trusted_client_certificate" {
    for_each = local.application_gateway[each.key].trusted_client_certificate

    content {
      name = local.application_gateway[each.key].trusted_client_certificate[trusted_client_certificate.key].name == "" ? trusted_client_certificate.key : local.application_gateway[each.key].trusted_client_certificate[trusted_client_certificate.key].name
      data = local.application_gateway[each.key].trusted_client_certificate[trusted_client_certificate.key].data
    }
  }

  dynamic "ssl_profile" {
    for_each = local.application_gateway[each.key].ssl_profile

    content {
      name                                 = local.application_gateway[each.key].ssl_profile[ssl_profile.key].name == "" ? ssl_profile.key : local.application_gateway[each.key].ssl_profile[ssl_profile.key].name
      trusted_client_certificate_names     = local.application_gateway[each.key].ssl_profile[ssl_profile.key].trusted_client_certificate_names
      verify_client_cert_issuer_dn         = local.application_gateway[each.key].ssl_profile[ssl_profile.key].verify_client_cert_issuer_dn
      verify_client_certificate_revocation = local.application_gateway[each.key].ssl_profile[ssl_profile.key].verify_client_certificate_revocation

      dynamic "ssl_policy" {
        for_each = length(compact(flatten(values(local.application_gateway[each.key].ssl_profile[ssl_profile.key].ssl_policy)))) > 0 ? [0] : []

        content {
          disabled_protocols   = local.application_gateway[each.key].ssl_profile[ssl_profile.key].ssl_policy.disabled_protocols
          policy_type          = local.application_gateway[each.key].ssl_profile[ssl_profile.key].ssl_policy.policy_type
          policy_name          = local.application_gateway[each.key].ssl_profile[ssl_profile.key].ssl_policy.policy_name
          cipher_suites        = local.application_gateway[each.key].ssl_profile[ssl_profile.key].ssl_policy.cipher_suites
          min_protocol_version = local.application_gateway[each.key].ssl_profile[ssl_profile.key].ssl_policy.min_protocol_version
        }
      }
    }
  }

  dynamic "authentication_certificate" {
    for_each = local.application_gateway[each.key].authentication_certificate

    content {
      name = local.application_gateway[each.key].authentication_certificate[authentication_certificate.key].name == "" ? authentication_certificate.key : local.application_gateway[each.key].authentication_certificate[authentication_certificate.key].name
      data = local.application_gateway[each.key].authentication_certificate[authentication_certificate.key].data
    }
  }

  dynamic "trusted_root_certificate" {
    for_each = local.application_gateway[each.key].trusted_root_certificate

    content {
      name                = local.application_gateway[each.key].trusted_root_certificate[trusted_root_certificate.key].name == "" ? trusted_root_certificate.key : local.application_gateway[each.key].trusted_root_certificate[trusted_root_certificate.key].name
      data                = local.application_gateway[each.key].trusted_root_certificate[trusted_root_certificate.key].data
      key_vault_secret_id = local.application_gateway[each.key].trusted_root_certificate[trusted_root_certificate.key].key_vault_secret_id
    }
  }

  dynamic "ssl_policy" {
    for_each = length(compact(flatten(values(local.application_gateway[each.key].ssl_policy)))) > 0 ? [0] : []

    content {
      disabled_protocols   = local.application_gateway[each.key].ssl_policy.disabled_protocols
      policy_type          = local.application_gateway[each.key].ssl_policy.policy_type
      policy_name          = local.application_gateway[each.key].ssl_policy.policy_name
      cipher_suites        = local.application_gateway[each.key].ssl_policy.cipher_suites
      min_protocol_version = local.application_gateway[each.key].ssl_policy.min_protocol_version
    }
  }

  dynamic "probe" {
    for_each = local.application_gateway[each.key].probe

    content {
      name                                      = local.application_gateway[each.key].probe[probe.key].name == "" ? probe.key : local.application_gateway[each.key].probe[probe.key].name
      host                                      = local.application_gateway[each.key].probe[probe.key].host
      interval                                  = local.application_gateway[each.key].probe[probe.key].interval
      protocol                                  = local.application_gateway[each.key].probe[probe.key].protocol
      path                                      = local.application_gateway[each.key].probe[probe.key].path
      timeout                                   = local.application_gateway[each.key].probe[probe.key].timeout
      unhealthy_threshold                       = local.application_gateway[each.key].probe[probe.key].unhealthy_threshold
      port                                      = local.application_gateway[each.key].probe[probe.key].port
      pick_host_name_from_backend_http_settings = local.application_gateway[each.key].probe[probe.key].pick_host_name_from_backend_http_settings
      minimum_servers                           = local.application_gateway[each.key].probe[probe.key].minimum_servers

      dynamic "match" {
        for_each = length(compact(flatten(values(local.application_gateway[each.key].probe[probe.key].match)))) > 0 ? [0] : []

        content {
          body        = local.application_gateway[each.key].probe[probe.key].match.body
          status_code = local.application_gateway[each.key].probe[probe.key].match.status_code
        }
      }
    }
  }

  dynamic "ssl_certificate" {
    for_each = local.application_gateway[each.key].ssl_certificate

    content {
      name                = local.application_gateway[each.key].ssl_certificate[ssl_certificate.key].name == "" ? ssl_certificate.key : local.application_gateway[each.key].ssl_certificate[ssl_certificate.key].name
      data                = local.application_gateway[each.key].ssl_certificate[ssl_certificate.key].data
      password            = local.application_gateway[each.key].ssl_certificate[ssl_certificate.key].password
      key_vault_secret_id = local.application_gateway[each.key].ssl_certificate[ssl_certificate.key].key_vault_secret_id
    }
  }

  dynamic "url_path_map" {
    for_each = local.application_gateway[each.key].url_path_map

    content {
      name                                = local.application_gateway[each.key].url_path_map[url_path_map.key].name == "" ? url_path_map.key : local.application_gateway[each.key].url_path_map[url_path_map.key].name
      default_backend_address_pool_name   = local.application_gateway[each.key].url_path_map[url_path_map.key].default_backend_address_pool_name
      default_backend_http_settings_name  = local.application_gateway[each.key].url_path_map[url_path_map.key].default_backend_http_settings_name
      default_redirect_configuration_name = local.application_gateway[each.key].url_path_map[url_path_map.key].default_redirect_configuration_name
      default_rewrite_rule_set_name       = local.application_gateway[each.key].url_path_map[url_path_map.key].default_rewrite_rule_set_name

      dynamic "path_rule" {
        for_each = local.application_gateway[each.key].url_path_map[url_path_map.key].path_rule

        content {
          name                        = local.application_gateway[each.key].url_path_map[url_path_map.key].path_rule[path_rule.key].name == "" ? path_rule.key : local.application_gateway[each.key].url_path_map[url_path_map.key].path_rule[path_rule.key].name
          paths                       = local.application_gateway[each.key].url_path_map[url_path_map.key].path_rule[path_rule.key].paths
          backend_address_pool_name   = local.application_gateway[each.key].url_path_map[url_path_map.key].path_rule[path_rule.key].backend_address_pool_name
          backend_http_settings_name  = local.application_gateway[each.key].url_path_map[url_path_map.key].path_rule[path_rule.key].backend_http_settings_name
          redirect_configuration_name = local.application_gateway[each.key].url_path_map[url_path_map.key].path_rule[path_rule.key].redirect_configuration_name
          rewrite_rule_set_name       = local.application_gateway[each.key].url_path_map[url_path_map.key].path_rule[path_rule.key].rewrite_rule_set_name
          firewall_policy_id          = local.application_gateway[each.key].url_path_map[url_path_map.key].path_rule[path_rule.key].firewall_policy_id
        }
      }
    }
  }

  dynamic "waf_configuration" {
    for_each = local.application_gateway[each.key].waf_configuration == null ? [] : [0]

    content {
      enabled                  = local.application_gateway[each.key].waf_configuration.enabled
      firewall_mode            = local.application_gateway[each.key].waf_configuration.firewall_mode
      rule_set_type            = local.application_gateway[each.key].waf_configuration.rule_set_type
      rule_set_version         = local.application_gateway[each.key].waf_configuration.rule_set_version
      file_upload_limit_mb     = local.application_gateway[each.key].waf_configuration.file_upload_limit_mb
      request_body_check       = local.application_gateway[each.key].waf_configuration.request_body_check
      max_request_body_size_kb = local.application_gateway[each.key].waf_configuration.max_request_body_size_kb
      # dynamic "disabled_rule_group" {}
      # dynamic "exclusion" {}
    }
  }

  dynamic "custom_error_configuration" {
    for_each = local.application_gateway[each.key].custom_error_configuration

    content {
      status_code           = local.application_gateway[each.key].custom_error_configuration[custom_error_configuration.key].status_code
      custom_error_page_url = local.application_gateway[each.key].custom_error_configuration[custom_error_configuration.key].custom_error_page_url
    }
  }

  dynamic "redirect_configuration" {
    for_each = local.application_gateway[each.key].redirect_configuration

    content {
      name                 = local.application_gateway[each.key].redirect_configuration[redirect_configuration.key].name == "" ? redirect_configuration.key : local.application_gateway[each.key].redirect_configuration[redirect_configuration.key].name
      redirect_type        = local.application_gateway[each.key].redirect_configuration[redirect_configuration.key].redirect_type
      target_listener_name = local.application_gateway[each.key].redirect_configuration[redirect_configuration.key].target_listener_name
      target_url           = local.application_gateway[each.key].redirect_configuration[redirect_configuration.key].target_url
      include_path         = local.application_gateway[each.key].redirect_configuration[redirect_configuration.key].include_path
      include_query_string = local.application_gateway[each.key].redirect_configuration[redirect_configuration.key].include_query_string
    }
  }

  dynamic "autoscale_configuration" {
    for_each = length(compact(values(local.application_gateway[each.key].autoscale_configuration))) > 0 ? [0] : []

    content {
      min_capacity = local.application_gateway[each.key].autoscale_configuration.min_capacity
      max_capacity = local.application_gateway[each.key].autoscale_configuration.max_capacity
    }
  }

  dynamic "rewrite_rule_set" {
    for_each = local.application_gateway[each.key].rewrite_rule_set

    content {
      name = local.application_gateway[each.key].rewrite_rule_set[rewrite_rule_set.key].name == "" ? rewrite_rule_set.key : local.application_gateway[each.key].rewrite_rule_set[rewrite_rule_set.key].name

      dynamic "rewrite_rule" {
        for_each = local.application_gateway[each.key].rewrite_rule_set[rewrite_rule_set.key].rewrite_rule

        content {
          name          = local.application_gateway[each.key].rewrite_rule_set[rewrite_rule_set.key].rewrite_rule[rewrite_rule.key].name == "" ? rewrite_rule.key : local.application_gateway[each.key].rewrite_rule_set[rewrite_rule_set.key].rewrite_rule[rewrite_rule.key].name
          rule_sequence = local.application_gateway[each.key].rewrite_rule_set[rewrite_rule_set.key].rewrite_rule[rewrite_rule.key].rule_sequence

          dynamic "condition" {
            for_each = local.application_gateway[each.key].rewrite_rule_set[rewrite_rule_set.key].rewrite_rule[rewrite_rule.key].condition

            content {
              variable    = local.application_gateway[each.key].rewrite_rule_set[rewrite_rule_set.key].rewrite_rule[rewrite_rule.key].condition[condition.key].variable
              pattern     = local.application_gateway[each.key].rewrite_rule_set[rewrite_rule_set.key].rewrite_rule[rewrite_rule.key].condition[condition.key].pattern
              ignore_case = local.application_gateway[each.key].rewrite_rule_set[rewrite_rule_set.key].rewrite_rule[rewrite_rule.key].condition[condition.key].ignore_case
              negate      = local.application_gateway[each.key].rewrite_rule_set[rewrite_rule_set.key].rewrite_rule[rewrite_rule.key].condition[condition.key].negate
            }
          }

          dynamic "request_header_configuration" {
            for_each = local.application_gateway[each.key].rewrite_rule_set[rewrite_rule_set.key].rewrite_rule[rewrite_rule.key].request_header_configuration

            content {
              header_name  = local.application_gateway[each.key].rewrite_rule_set[rewrite_rule_set.key].rewrite_rule[rewrite_rule.key].request_header_configuration[request_header_configuration.key].header_name
              header_value = local.application_gateway[each.key].rewrite_rule_set[rewrite_rule_set.key].rewrite_rule[rewrite_rule.key].request_header_configuration[request_header_configuration.key].header_value
            }
          }

          dynamic "response_header_configuration" {
            for_each = local.application_gateway[each.key].rewrite_rule_set[rewrite_rule_set.key].rewrite_rule[rewrite_rule.key].response_header_configuration

            content {
              header_name  = local.application_gateway[each.key].rewrite_rule_set[rewrite_rule_set.key].rewrite_rule[rewrite_rule.key].response_header_configuration[request_header_configuration.key].header_name
              header_value = local.application_gateway[each.key].rewrite_rule_set[rewrite_rule_set.key].rewrite_rule[rewrite_rule.key].response_header_configuration[request_header_configuration.key].header_value
            }
          }

          dynamic "url" {
            for_each = local.application_gateway[each.key].rewrite_rule_set[rewrite_rule_set.key].rewrite_rule[rewrite_rule.key].url == null ? [] : [0]

            content {
              path         = local.application_gateway[each.key].rewrite_rule_set[rewrite_rule_set.key].rewrite_rule[rewrite_rule.key].url.path
              query_string = local.application_gateway[each.key].rewrite_rule_set[rewrite_rule_set.key].rewrite_rule[rewrite_rule.key].url.query_string
              components   = local.application_gateway[each.key].rewrite_rule_set[rewrite_rule_set.key].rewrite_rule[rewrite_rule.key].url.components
              reroute      = local.application_gateway[each.key].rewrite_rule_set[rewrite_rule_set.key].rewrite_rule[rewrite_rule.key].url.reroute
            }
          }
        }
      }
    }
  }

  tags = local.application_gateway[each.key].tags
}
