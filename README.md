# Liatrio Cloud Adoption Framework for Azure

Liatrio’s implementation of a [Cloud Adoption Framework on Azure](https://docs.microsoft.com/en-us/azure/cloud-adoption-framework/) using Terraform to build a foundation for deploying workload landing zones. This repo is composed of several Terraform modules designed to make getting started with Azure using best practices easier.

## Foundation Deployment

The framework foundation sets up the required resources to support shared services and landing zones which are deployed on top of the foundation. It uses management groups to start off with a structured approach to organizing resources and creates policies to ensure best practices continue to be observed as resources are added.

### Subscriptions

Subscriptions must be created before deploying the core foundation module. This is intentential to allow the rest of the foundation to be managed without requiring billing permissions. The subscriptions can be manually created or there is an included Terraform module for automating their management.

**Terraform Module**: [subscriptions/foundation](./subscriptions/foundation)

*Required Subscriptions*
Connectivity
Identity
Management

### Foundation Core

This Terraform module manages areas of concern using three sub modules. Connectivity for managing the networking required for our hub and spoke model to connect shared services resources to our landing zones; Identity to manage authentication and authorization services and Management to manage logging, monitoring and billing services.

**Terraform Module**: [foundation](./foundation)

## Shared Services Deployment

Shared service environments are specialized landing zones to deploy tools to support workloads and run pipelines shared across multiple landing zones. They can be managed independently of the framework foundation and a foundation can support any number of shared service environments but we generally recommend one staging and one production shared services environment.

### Subscription

Each shared service environment requires its own subscription which must be created before the environment. There is an included Terraform module for automating creation of the subscription.

**Terraform Module**: [subscriptions\landing-zone](./subscriptions\landing-zone)

### Shared Service Core

Deploys an AKS cluster and software delivery toolchain and configures the environment to be used as a shared hub for our landing zones.

**Terraform Module**: [shared-services](./shared-services)

## Landing Zones Deployment

Landing Zones are the infrastructure needed to support a specific type or category of workloads. They can be as small as a project or as large as an environment depending on the type of workload and the structure of the organization. For example a landing zone may be an entire AKS cluster for running production workloads or a testing environment for staging an product deployed via Virtual Machine Scale Sets.

### Subscription

Each landing zone requires its own subscription which must be created beforehand. There is an included Terraform module for automating creating of the subscription.

**Terraform Module**: [subscriptions\landing-zone](./subscriptions\landing-zone)

### Landing Zone Core

There are several landing zone types to support different workload requirements. 

**Terraform Module**: [landing-zones/LANDING-ZONE-TYPE](./landing-zones)

