# Shared Services

The goal of Shared Services is to create the infrastrusture necessary for hosting a toolchain hub available to Landing-Zones. 

Shared Services is split into two stages: core and applications.

# Core

The core components are the AKS cluster itself, along with the required resources to operate it.

- Resource Group
- AKS Cluster
- Virtual Network
- Privatelink DNS Zone for Kubernetes
- Virtual Network connection to a pre-existing Virtual Hub
- Managed Identities
- Public DNS
- Split Horizon DNS for interal workloads
- KeyVault

# Applications

The application components are the deployed workloads that facilitate use of an AKS cluster.

- toolchain - namespace
  - Cert Manager
  - Ingress Controller
  - External DNS
- github-runners - namespace
  - github-runners
  - github-runners-controller
- monitoring - namespace
  - Kube-prometheus-stack

# Use case

The intended use of this module is to create a hub for common globally accessible workloads.

An example workflow would contain the following</br></br>
![Landing Zone](../../images/aks-lz.png "Landing Zone")
