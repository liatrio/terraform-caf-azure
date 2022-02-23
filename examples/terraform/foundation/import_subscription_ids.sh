#!/bin/bash

terraform output -state ../subscription/terraform.tfstate -json | jq 'with_entries(.value |= .value)' > subscription.auto.tfvars.json
