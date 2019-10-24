output "vnet_peer_1_id" {
  description = "The id of the newly created virtual network peering in on first virtual netowork. "
  value       = "${azurerm_virtual_network_peering.vnet_peer_1.id}"
}

output "vnet_peer_2_id" {
  description = "The id of the newly created virtual network peering in on second virtual netowork within the same subscription. "
  value       = "${element(list(azurerm_virtual_network_peering.vnet_peer_2.*.id), 0)}"
}

output "vnet_peer_2_sub2_id" {
  description = "The id of the newly created virtual network peering in on second virtual netowork in a cross-subscription configuration. "
  value       = "${element(list(azurerm_virtual_network_peering.vnet_peer_2_sub2.*.id), 0)}"
}
