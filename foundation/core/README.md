# Core CAF Foundation module

This Terraform module deploys the core foundation for Liatrio's Cloud Adoption Framework. It provides the necessary connectivity, identity, policy, and management resources needed to deploy shared services and landing zone modules.

This module requires three subscriptions (connectivity, identity and management) be created _before_ applying the module. The [subscriptions/foundation](../../subscriptions/foundation/) module is provided to manage the subscriptions via Terraform or they can be managed by another process. An azurerm provider must be defined for each subscription and passed into the module. See [examples/terraform/foundation](../../examples/terraform/foundation/) for an example configuring the providers and passing them to the module.

This module also requires that Custom Policies and Policy Sets have been deployed to this tenant, as described in [liatrio/azure-policies](https://github.com/liatrio/azure-policies)

## Resources Created

This module creates the following resources.

### Management Groups

This list of management groups allows hierarchically assigned role based access control.

```yaml
azurerm_management_group.connectivity
azurerm_management_group.decommissioned
azurerm_management_group.dynamic["corp"]
azurerm_management_group.dynamic["online"]
azurerm_management_group.foundation
azurerm_management_group.identity
azurerm_management_group.landing_zones
azurerm_management_group.management
azurerm_management_group.platform
azurerm_management_group.sandboxes
azurerm_management_group.shared_svc
```

  ![Management Groups](../../images/management-groups.png "Management Groups")

### Networking

Several particular network resources are configured, allowing communication within your landing zone(s) and to your connected networks.
#### Core Network components

The VWAN managed Hub and Spoke setup is used.

```yaml
azurerm_network_security_group.connectivity_security_group
azurerm_resource_group.caf_connectivity
azurerm_virtual_hub.caf_hub
azurerm_virtual_hub_connection.connectivity_hub_connection
azurerm_virtual_network.connectivity_vnet
azurerm_virtual_wan.caf_vwan

```

  ![](../../images/vwan-topology.svg)

#### Public DNS Zone

```yaml
module.public_dns
  azurerm_dns_zone.public_dns_zone
```

#### Private DNS Zones


```yaml
module.azure_paas_private_dns["container_registry"].azurerm_private_dns_zone.private_dns_zone
module.azure_paas_private_dns["container_registry"].azurerm_private_dns_zone_virtual_network_link.private_dns_zone_link
module.azure_paas_private_dns["key_vault"].azurerm_private_dns_zone.private_dns_zone
module.azure_paas_private_dns["key_vault"].azurerm_private_dns_zone_virtual_network_link.private_dns_zone_link
module.azure_paas_private_dns["kubernetes_cluster"].azurerm_private_dns_zone.private_dns_zone
module.azure_paas_private_dns["kubernetes_cluster"].azurerm_private_dns_zone_virtual_network_link.private_dns_zone_link
module.azure_paas_private_dns["mysql"].azurerm_private_dns_zone.private_dns_zone
module.azure_paas_private_dns["mysql"].azurerm_private_dns_zone_virtual_network_link.private_dns_zone_link

```

#### Self Managed Private DNS resolver

```yaml
module.vpn_dns_resolver
  azurerm_container_group.coredns
  azurerm_network_profile.coredns_network_profile
  azurerm_subnet.coredns_subnet

```

#### Optional Point to Site User VPN
```yaml
azurerm_point_to_site_vpn_gateway.hub_vpn_gateway
azurerm_vpn_server_configuration.vpn_server_config
```
  ![]()

### Policy

Policy configuration is known to Terraform via this module, but not fully managed here. Instead, policy-as-code is managed via 

```yaml
module.connectivity-policy-sets.module.policy_assignment[0].azurerm_management_group_policy_assignment.policy_set_assignment
module.connectivity-policy-sets.module.policy_assignment[0].random_id.policy_association_name
module.foundation-policy-sets.module.policy_assignment[0].azurerm_management_group_policy_assignment.policy_set_assignment
module.foundation-policy-sets.module.policy_assignment[0].random_id.policy_association_name
module.landing_zones-policy-sets.module.policy_assignment[0].azurerm_management_group_policy_assignment.policy_set_assignment
module.landing_zones-policy-sets.module.policy_assignment[0].random_id.policy_association_name
module.policy-sets-dynamic-mgs["corp"].module.policy_assignment[0].azurerm_management_group_policy_assignment.policy_set_assignment
module.policy-sets-dynamic-mgs["corp"].module.policy_assignment[0].random_id.policy_association_name
module.shared_svc-policy-sets.module.policy_assignment[0].azurerm_management_group_policy_assignment.policy_set_assignment
module.shared_svc-policy-sets.module.policy_assignment[0].random_id.policy_association_name
```
  ![]()
