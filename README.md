# Liatrio Cloud Adoption Framework (CAF) for Azure

[![release](https://img.shields.io/github/v/release/liatrio/terraform-caf-azure?sort=semver)](https://github.com/liatrio/terraform-caf-azure/tags)
[![build](https://img.shields.io/github/workflow/status/liatrio/terraform-caf-azure/Terraform%20Code%20Quality)](https://github.com/liatrio/terraform-caf-azure/actions/workflows/terraform-validate.yml)
[![Contributor Covenant](https://img.shields.io/badge/Contributor%20Covenant-2.1-4baaaa.svg)](code_of_conduct.md)

# Overview

This is Liatrio’s implementation of a [Cloud Adoption Framework (CAF) on Azure](https://docs.microsoft.com/en-us/azure/cloud-adoption-framework/) using Terraform to build a foundation for deploying workload [landing zones](https://docs.microsoft.com/en-us/azure/cloud-adoption-framework/ready/landing-zone/). This repo is composed of several Terraform modules designed to make getting started with Azure using best practices easier.
## Architecture
* [Architecture diagram](./images/caf-architecture.png)
  * Represents everything that is created through Liatrio's CAF, as well as how the resources interact with one another.
* [Project structure diagram](./images/LiatrioCAFAzure.png)
  * Represents a simplified view of how our general `terraform` modules are structured and how that translates in terms of `subscriptions` on Azure

# Getting Started
A great place to get started with Liatrio's Azure CAF is with the `examples/`. Here at Liatrio, we love using `terragrunt` to deploy our infrastructure. However, we also support using `terraform` as a standalone.

## terragrunt
If you choose to go the `terragrunt` route. We provide the following sections as well as sample `terragrunt.hcl` files in our `examples/` folder:

* [Folder structure](./examples/terragrunt/README.md#folder-structure)
* [How are states handled?](./examples/terragrunt/README.md#how-are-states-handled)
* [Deploying Liatrio CAF](./examples/terragrunt/README.md#deploying-liatrio-caf)
## terraform
As with the `terragrunt` examples, the `terraform` ones will show you how to deploy the following things through sample files. The `examples/terraform`'s readme will go through the following sections:

* [Getting started](./examples/terraform/README.md#get-started)
* [Deploying subscriptions](./examples/terraform/README.md#1-subscriptions)
* [Deploying foundation](./examples/terraform/README.md#2-foundation)
* [Deploying shared-services](./examples/terraform/README.md#3-shared-services)

# Glossary

Liatrio provides a [CAF Glossary](./GLOSSARY.md). Very helpful when just getting started with Azure (or the Cloud). Our Glossary provides definitions as well as a reference to the `terraform` modules representing those terms.

# Contributing
Whether it's a bug report or code, any contribution is appreciated. To learn about coding conventions, general strucutre of the project, or how to get started, please refer to our [CONTRIBUTING.md](./CONTRIBUTING.md) file.

# Code of Conduct
Please refer to our [CODE_OF_CONDUCT.md](./CODE_OF_CONDUCT.md) file.