/**
 * # netwrok
 *
 * This module manages Azure Network Configuration.
 *
*/

/** Virtuell Network */
resource "azurerm_virtual_network" "virtual_network" {
  for_each = var.resource_name.virtual_network

  name                = each.value
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space       = local.virtual_network.address_space[each.key]

  tags = {
    for tag in keys(local.tags) :
    tag => local.tags[tag]
  }
}

/** Subnet */
resource "azurerm_subnet" "subnet" {
  for_each = var.resource_name.subnet

  name                 = each.value
  resource_group_name  = var.resource_group_name
  virtual_network_name = local.subnet[each.key].virtual_network_name != "" ? local.subnet[each.key].virtual_network_name : azurerm_virtual_network.virtual_network[each.key].name
  address_prefixes     = local.subnet[each.key].address_prefixes
  service_endpoints    = local.subnet[each.key].service_endpoints

  enforce_private_link_endpoint_network_policies = local.subnet[each.key].enforce_private_link_endpoint_network_policies
  enforce_private_link_service_network_policies  = local.subnet[each.key].enforce_private_link_service_network_policies
}

/** Public IP */
resource "azurerm_public_ip" "public_ip" {
  for_each = var.public_ip

  name                = each.key
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = local.public_ip[each.key].allocation_method
  sku                 = local.public_ip[each.key].sku

  tags = {
    for tag in keys(local.tags) :
    tag => local.tags[tag]
  }
}

/** Network Interface */
resource "azurerm_network_interface" "network_interface" {
  for_each = var.network_interface

  name                = each.key
  location            = var.location
  resource_group_name = var.resource_group_name

  dns_servers                   = local.network_interface[each.key].dns_servers
  enable_accelerated_networking = local.network_interface[each.key].enable_accelerated_networking
  enable_ip_forwarding          = local.network_interface[each.key].enable_ip_forwarding

  dynamic "ip_configuration" {
    for_each = local.network_interface_config[each.key].ip_configuration
    content {
      name                          = ip_configuration.key
      primary                       = local.network_interface_config[each.key].ip_configuration[ip_configuration.key].primary
      subnet_id                     = local.network_interface_config[each.key].ip_configuration[ip_configuration.key].subnet_id
      private_ip_address_allocation = local.network_interface_config[each.key].ip_configuration[ip_configuration.key].private_ip_address_allocation
      private_ip_address            = local.network_interface_config[each.key].ip_configuration[ip_configuration.key].private_ip_address
      private_ip_address_version    = local.network_interface_config[each.key].ip_configuration[ip_configuration.key].private_ip_address_version
      public_ip_address_id          = local.network_interface_config[each.key].ip_configuration[ip_configuration.key].public_ip_address_id
    }
  }

  tags = {
    for tag in keys(local.tags) :
    tag => local.tags[tag]
  }
}

/** Network Security Group */
resource "azurerm_network_security_group" "network_security_group" {
  for_each = var.network_security_group

  name                = each.key
  location            = var.location
  resource_group_name = var.resource_group_name

  dynamic "security_rule" {
    for_each = local.network_security_group[each.key].security_rule
    content {
      name                       = security_rule.key
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

  tags = {
    for tag in keys(local.tags) :
    tag => local.tags[tag]
  }
}

/** Network Security Group Association */
resource "azurerm_network_interface_security_group_association" "network_interface_security_group_association" {
  for_each = var.network_interface_security_group_association

  network_interface_id      = azurerm_network_interface.network_interface[local.network_interface_security_group_association[each.key].network_interface].id
  network_security_group_id = azurerm_network_security_group.network_security_group[local.network_interface_security_group_association[each.key].network_security_group].id
}

/** Private Endpoint */
resource "azurerm_private_endpoint" "private_endpoint" {
  for_each = var.private_endpoint

  name                = each.key
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = local.private_endpoint[each.key].subnet_id

  dynamic "private_dns_zone_group" {
    for_each = local.private_endpoint[each.key].private_dns_zone_group

    content {
      name                 = private_dns_zone_group.key
      private_dns_zone_ids = local.private_endpoint[each.key].private_dns_zone_group[private_dns_zone_group.key].private_dns_zone_ids
    }
  }

  dynamic "private_service_connection" {
    for_each = local.private_endpoint[each.key].private_service_connection

    content {
      name                           = private_service_connection.key
      is_manual_connection           = local.private_endpoint[each.key].private_service_connection[private_service_connection.key].is_manual_connection
      private_connection_resource_id = local.private_endpoint[each.key].private_service_connection[private_service_connection.key].private_connection_resource_id
      subresource_names              = local.private_endpoint[each.key].private_service_connection[private_service_connection.key].subresource_names
    }
  }

  tags = {
    for tag in keys(local.tags) :
    tag => local.tags[tag]
  }
}
