# Deploy Landing Zones using Terragrunt

## Folder structure

To be able to properly use our Terragrunt files, we suggest setting up your folder structure like so:

```
├── landing-zones
│   ├── aks-lz-dev (change 'dev' for the environment of your choice)
│   │   ├── subscriptions
│   │   │   ├── terragrunt.hcl
│   │   ├── core
│   │   │   ├── terragrunt.hcl
```

# Sample Files

* [subscriptions/terragrunt.hcl](./subscriptions/terragrunt.hcl)
* [core/terragrunt.hcl](./core/terragrunt.hcl)

# Required inputs

These links reference the Terraform modules' `README.md` files at the "Required Inputs" section.

* [subscription](../../../subscriptions/landing-zone/README.md)
* [core](../../../landing-zones/aks/core/variables.tf)

# Deploying the Liatrio-CAF landing-zone resources

**You will need to modify `../common_vars.yaml` to use your own infrastructure values**

1. Deploy the `subscriptions` resources. `cd subscriptions; terragrunt apply`
2. Deploy the `core` resources. `cd core; terragrunt apply`