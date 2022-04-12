# Shared Services

The goal of Shared Services is to create the infrastrusture necessary for hosting a hub of reusable workloads.

Shared Services is split into two stages: core and applications.

# Core

The core components are the AKS cluster itself, along with the required resources to operate it.

- Resource Group
- AKS Cluster
- Virtual Network
- Privatelink DNS Zone for Kubernetes
- Virtual Network connection to a pre-existing Virtual Hub
- AAD Managed Identities
- KeyVault
- Public DNS
- Split-horizon DNS (public and private DNS zone)
  - This is used for internal workloads that require public and private facing versions of the same domain. Cert-manager issuers utilize the public domain to perform a DNS-01 challenge in order to generate a certificate for the private domain.

# Applications

The application components are the deployed workloads that facilitate use of an AKS cluster.
- toolchain
  - Cert Manager
  - Ingress Controller
  - External DNS
- github-runners
  - github-runners
  - github-runners controller
- monitoring
  - kube-prometheus-stack
- kube-system
  - AAD-pod-identity

# Use case

The intended use of this module is to create a hub for reusable workloads.

An example workflow would contain the following</br></br>
![Landing Zone](../../images/shared-services.png "Landing Zone")
