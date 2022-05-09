# Terraform example

This folder contains example Terraform modules for deploying Azure CAF. Each module is a separate layer that must be applied in order.

These modules deploy the CAF foundation, a single shared services toolchain and an AKS landing zone as an example of how to get started with CAF. A complete stack would include staging and main shared services toolchains and multiple landing zones.

## Get Started

### 1. **Subscriptions**

The subscription module creates the subscriptions needed for the CAF foundation, shared services and landing zone. It outputs subscriptions IDs which need to be set as variable inputs in the subsequent modules.

To create the subscription you must be owner or contributor of a billing account and supply billing account details via Terraform variables.

*In the examples/terraform/1-subscription folder...*

Create `billing.auto.tfvars` with the following variables:
```
billing_account_name = "XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX:XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX_XXXX-XX-XX"
billing_profile_name = "XXXX-XXXX-XXX-XXX"
invoice_section_name = "XXXX-XXXX-XXX-XXX"
```

Then create the subscriptions
```bash
terraform apply
```

### 2. **Foundation**

*In the examples/terraform/2-foundation-core folder...*

Import the subscription IDs from the subscription module Terraform state into Terraform variables for this module
```bash
./import_subscription_ids.sh
```

There should now be a `subscription.auto.tfvars.json` file which looks like:
```
{
  "connectivity_subscription_id": "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx",
  "identity_subscription_id": "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx",
  "management_subscription_id": "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx",
  "shared_services_subscription_id": "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
}
```

Deploy foundation
```
terraform apply
```

### 3. **Shared Services**

*In the examples/terraform/3-foundation-shared-services-core folder...*

Import the subscription IDs from the subscription module Terraform state into Terraform variables for this module
```bash
./import_subscription_ids.sh
```

Deploy shared services core
```
terraform apply
```

*In the examples/terraform/4-foundation-shared-services-app folder...*

### 4. **Landing Zone**

WIP.
