# Starter Landing Zone

The goal of this landing zone is to create the basic infrastructure necessary
for deploying VMs, App Services, AKS Clusters, etc.

The module creates the following resources in the landing zone:

- Resource Group
- Virtual Network
- Privatelink DNS Zone
- Virtual Network connection to a pre-existing Virtual Hub
- Key Vault

# Use case

The intended use of this module is to create a basic landing ready to accept
vm or app service workloads, but it is not limited to only those workloads.

This landing zone will need more application specific infrastructure deployed
into it before it is ready for normal deployment workflows.
