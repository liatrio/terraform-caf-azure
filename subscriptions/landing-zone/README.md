# Landing Zone Subscription

This Terraform module creates subscriptions required for each [landing zone](./landing-zones) (or shared service) module. It requires additional permissions to manage Azure billing resources as well as details for a Microsoft Customer Agreement (MCA) billing account. This module is provided to illustrate how to setup the requirements for the Liatrio Cloud Adoption Framework and to facilitate fully automated deployments of the foundation module but the subscriptions can also be created outside of Terraform and supplied to the foundation module.

## Variables

 - name: subscription name
 - billing_account_name: MCA billing account name
 - billing_profile_name: The billing profile name in the MCA billing account
 - invoice_section_name: The invoice section name in the MCA billing account

## Outputs

 - subscription_id
