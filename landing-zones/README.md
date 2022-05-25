# Azure CAF Landing Zones

This folder contains Terraform modules for individual landing zones. Each landing zone represents the resource needed to run and manage a workload. Landing zones may encompass and entire environment, such as an AKS cluster, or it might be more specific, such as a VM scale set for a product.

Each landing zone module should have a dedicated subscription which must be create before applying the module (see [subscriptions/landing-zone](../subscriptions/landing-zone/)).

**Landing Zones**

- [AKS cluster](./aks/)
- [Starter](./starter/)
