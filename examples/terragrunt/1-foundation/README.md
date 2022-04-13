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


# Deploying the Liatrio-CAF foundation resources

**You will need to modify `../common_vars.yaml` to use your own infrastructure values**

1. Deploy the `subscriptions` resources. `cd subscriptions; terragrunt apply`
2. Deploy the `active-directory` resources. `cd active-directory; terragrunt apply`
3. Deploy the `core` resources. `cd core; terragrunt apply`

