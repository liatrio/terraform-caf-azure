# Deploy Landing Zones using Terragrunt

## Folder structure

To be able to properly use our Terragrunt files, we suggest setting up your folder structure like so:

```
.
├── landing-zones
│   ├── aks-lz-dev (change 'dev' for the environment of your choice)
│   │   ├── subscriptions
│   │   │   ├── terragrunt.hcl
│   │   ├── core
│   │   │   ├── terragrunt.hcl
│   |   ├── common_vars.yaml
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

* [subscriptions/terragrunt.hcl](./1-subscriptions/terragrunt.hcl)
* [core/terragrunt.hcl](./2-core/terragrunt.hcl)

# Step-by-step

## Deploying aks-lz-dev

_Disclaimer_: Deploying the Kubernetes cluster may take well above 50 minutes.

__You will need the 'Billing Contributor' in the tenant you're trying to use__

1. Create the subscription for the landing zone `cd <repo_root>/landing-zones/aks-lz-dev/subscription; terragrunt apply`
    * You will need to change the following variables:
      * `common_vars.yaml/tenant_id`
      * `common_vars.yaml/tfstate_subscription_id`
      * `common_vars.yaml/connectivity_subscription_id`
      * `common_vars.yaml/pay-as-you-go_subscription_id`
      * `common_vars.yaml/shared_services_staging_subscription_id`
      * `common_vars.yaml/prefix`
      * `common_vars.yaml/billing_account_name`
      * `common_vars.yaml/billing_profile_name`
      * `common_vars.yaml/invoice_section_name`  
        
2. Deploy the `core` module `cd <repo_root>/landing-zones/aks-lz-dev/core; terragrunt apply`
    * You will need to do the following things:
        * Change `common_vars.yaml/connectivity_resource_group_name`
        * Reauthenticate to your Azure account (`az logout` -> `az login`)
          * This will ensure that your account can interact with the newly created subscription. Otherwise you might hit a `Terraform` error saying your subscription could not be found.
        * The `apply` might timeout. Meaning you might need to import tfstates to your state file to verify that everything was created properly.
          * For more information on `terragrunt import`, please refer to correct resource's documentation page (for [example](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/kubernetes_cluster#import)).