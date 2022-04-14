# Overview

## Note
* These sample files are only deploying one `shared-services` as well as one `landing-zones`. In a real-world environment, one would most likely have more than that due to different existing environments. Nonetheless, these samples should help quickstart your Azure journey.
* All the required inputs are documented and referenced in each module's `README.md` file.

---

## Folder structure

To be able to properly use our Terragrunt files, we suggest setting up your folder structure like so:

```
root
├── foundations
│   ├── subscriptions
│   │   ├── terragrunt.hcl
│   ├── active-directory
│   │   ├── terragrunt.hcl
│   ├── core
│   │   ├── terragrunt.hcl
├── shared-services
│   ├── staging (change 'staging' for the environment of your choice)
│   │   ├── subscriptions
│   │   │   ├── terragrunt.hcl
│   │   ├── core
│   │   │   ├── terragrunt.hcl
├── landing-zones
│   ├── aks-lz-dev (change 'dev' for the environment of your choice)
│   │   ├── subscriptions
│   │   │   ├── terragrunt.hcl
│   │   ├── core
│   │   │   ├── terragrunt.hcl
├── common_vars.yaml
├── terragrunt.hcl
```
A custom structure could be defined, but that would force modifying lines where paths are defined, for example:

```hcl
# file: landing-zones/core/terragrunt.hcl
# lines: 5-7

dependency "subscription" {
  config_path = "<path_to_dependency>"
}
```

## How are states handled?

The `.tfstate` file is defined in the root `terragrunt.hcl`. In this perticular block of code:

```hcl
# This defines what storage account to use and what to name the '.tfstate' file.
# file: ./terragrunt.hcl
# lines: 15-22

config = {
  resource_group_name  = "resource_group_name"
  storage_account_name = "storage_account_name"
  container_name       = "container_name"
  key                  = "${path_relative_to_include()}/terraform.tfstate"
  tenant_id            = local.common_vars.tenant_id
  subscription_id      = local.common_vars.terraform_state_subscription_id
}
```
Within that file, you can also note a `skip=true` as the first line of code. It is simply due to [this](https://terragrunt.gruntwork.io/docs/reference/config-blocks-and-attributes/#skip).

## Deploying Liatrio CAF

1. [Deploy](./1-foundation/README.md) the `foundations` resources
2. [Deploy](./2-shared-services/README.md) the `shared-services` resources
3. [Deploy](./3-landing-zones/README.md) the `landing-zones` resources