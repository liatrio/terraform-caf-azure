# Deploy Landing Zones using Terragrunt

## Folder structure

```
├── foundation
│   ├── subscriptions
│   │   ├── terragrunt.hcl
│   ├── active-directory
│   │   ├── terragrunt.hcl
│   ├── core
│   │   ├── terragrunt.hcl
```

# Sample Files

* [subscriptions/terragrunt.hcl](./subscriptions/terragrunt.hcl)
* [active-directory/terragrunt.hcl](./active-directory/terragrunt.hcl)
* [core/terragrunt.hcl](./core/terragrunt.hcl)

# Required inputs

These links reference the Terraform modules' `README.md` files at the "Required Inputs" section.

* [subscriptions](https://github.com/liatrio/terraform-caf-azure/tree/main/subscriptions/foundation#variables)
* [active-directory](../../../foundation/active-directory/variables.tf)
* [core](https://github.com/liatrio/terraform-caf-azure/tree/main/foundation/core#inputs-required)

# Deploying the Liatrio-CAF foundation resources

**You will need to modify `../common_vars.yaml` to use your own infrastructure values**

1. Deploy the `subscriptions` resources. `cd subscriptions; terragrunt apply`
2. Deploy the `active-directory` resources. `cd active-directory; terragrunt apply`
3. Deploy the `core` resources. `cd core; terragrunt apply`

