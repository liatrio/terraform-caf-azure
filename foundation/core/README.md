# Core CAF Foundation module

This Terraform module deploys the core foundation for Liatrio's Cloud Adoption Framework. It provides the necessary connectivity, identity and management resources needed to deploy shared services and landing zone modules.

This module requires three subscriptions (connectivity, identity and management) be created before applying the module. The [subscriptions/foundation](../../subscriptions/foundation/) module is provided to manage the subscriptions via Terraform or then can be managed by another process. An azurerm provider must be defined for each subscription and passed into the module. See [examples/terraform/foundation](../../examples/terraform/foundation/) for an example configuring the providers and passing them to the module.


