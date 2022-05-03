# Liatrio's CAF Glossary

Getting started with the Cloud and all its terms can be daunting. That's why we decided to create this glossary to help you wrap your head around all the different topics at hand.

---

## Subscriptions

Several subscriptions are required for the CAF foundation as well as shared services and landing zones. Each top level Terraform module needs azurerm Terraform providers configured with the needed subscriptions. See the [examples](./examples/) folder for examples configuring the providers using Terraform and Terragrunt.

- **Foundation**: Requires subscriptions for connectivity, identity, management resources
- **Shared Services**: Each shared services environment requires its own subscriptions
- **Landing Zones**: Each landing zone requires its own subscription

Creation of subscriptions is not handled as part of the main CAF Terraform modules. This is done to allow them to be managed by an external process and to avoid requiring extra billing permissions to apply the CAF modules.

There are also several extra Terraform modules included in this repo which can manage the creation of subscriptions if the extra billing permissions are not a concern and you would like to manage them as part of the same process.

**Terraform Modules**:

- [subscriptions/foundation](./subscriptions/foundation): Creates connectivity, identity and management subscriptions
- [subscriptions/landing-zone](./subscriptions/landing-zone): Creates a subscription which can be used for Landing Zones or Shared Services Environments

---

## Foundation Deployment

The framework foundation sets up the required resources to support shared services and landing zones. It uses management groups to start off with a structured approach to organizing resources and creates policies to ensure best practices continue to be observed as resources are added.

### Foundation Core

This Terraform module manages areas of concern including management groups, **Connectivity**, **Identity**, and **Management**. **Connectivity** concerns management of the networking required for our hub and spoke model to connect shared services resources to our landing zones; **Identity** concerns managing authentication and authorization services. **Management** concerns managing logging, monitoring and billing services. The management groups are deployed according the Microsoft Azure CAF designs.

**Terraform Module**: [foundation/core](./foundation/core/)

### Shared Services

Shared services are similar to landing zones in that they create an environment to run applications in, however they have special significance in our framework and therefore are managed separately. Shared services manage tools and services to deploy and be used by workloads in our landing zones. They represent the center of our hub and spoke networking model.

Each shared services environment is deployed separately after foundation core. Any number of shared services environment can be created but we recommend one staging environment to test changes to the shared tools and services and one production environment which supports production landing zone workloads.

Shared services deploy an AKS cluster and software delivery toolchain and configures the environment to be used as a shared hub for our landing zones.

**Terraform Modules**: [foundation/shared-services](./foundation/shared-services/)

---

## Landing Zones Deployment

Landing Zones are the infrastructure needed to support a specific type or category of workloads. They can be as small as a project or as large as an environment depending on the type of workload and the structure of the organization. For example a landing zone may be an entire AKS cluster for running production workloads or a testing environment for staging an product deployed via Virtual Machine Scale Sets.

### Landing Zone Core

There are several landing zone types to support different workload requirements.

**Terraform Modules**:

- AKS [landing-zones/aks](./landing-zones/aks/)

---

## Azure Policy and Policy Set Deployment

There are several default Policy Sets (Initiatives) assigned to the Management groups defined in [foundation/core](./foundation/core/).

Any dynamically created management groups can have Custom or Built-in Policy sets applied by specificing the Set ids in either tfvars or terragrunt.

The Policy Sets utilized in this framework are created via a separate repo that has a GitHub Action for creating and updating Policies and Policy Sets. For more information check out the [liatrio/azure-policies](https://github.com/liatrio/azure-policies) repo.