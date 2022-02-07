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
}

/** Public IP */
resource "azurerm_public_ip" "public_ip" {
  for_each = var.public_ip

  name                = local.public_ip[each.key].name == "" ? each.key : local.public_ip[each.key].name
  location            = local.public_ip[each.key].location
  resource_group_name = local.public_ip[each.key].resource_group_name
  allocation_method   = local.public_ip[each.key].allocation_method
  sku                 = local.public_ip[each.key].sku

  tags = local.public_ip[each.key].tags
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
resource "azurerm_network_interface_security_group_association" "network_interface_security_group_association" {
  for_each = var.network_interface_security_group_association

  network_interface_id      = local.network_security_group[each.key].network_interface_id
  network_security_group_id = local.network_security_group[each.key].network_security_group_id
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
