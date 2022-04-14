# Deploy Landing Zones using Terragrunt

## Folder structure

To be able to properly use our Terragrunt files, we suggest setting up your folder structure like so:

```
root
├── shared-services
│   ├── staging (change 'staging' for the environment of your choice)
│   │   ├── subscriptions
│   │   │   ├── terragrunt.hcl
│   │   ├── core
│   │   │   ├── terragrunt.hcl
├── common_vars.yaml
```
A custom structure could be defined, but that would force modifying lines where paths are defined, for example:

```hcl
# file: core/terragrunt.hcl
# lines: 5-7

dependency "subscription" {
  config_path = "<path_to_dependency>"
}
```

# Sample Files

* [staging/subscriptions/terragrunt.hcl](./staging/subscription/terragrunt.hcl)
* [staging/core/terragrunt.hcl](./staging/core/terragrunt.hcl)

# Required inputs

These links reference the Terraform modules' `README.md` files at the "Required Inputs" section.

* subscriptions (WIP)
* [core](https://github.com/liatrio/terraform-caf-azure/blob/main/foundation/shared-services/core/README.md)

# Deploying the Liatrio-CAF shared-services resources

**You will need to modify `../common_vars.yaml` to use your own infrastructure values**

1. Deploy the `subscriptions` resources. `cd subscriptions; terragrunt apply`
2. Deploy the `core` resources. `cd core; terragrunt apply`