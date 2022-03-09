#!/usr/bin/env bash

set -e

rootModules=$(find . ! -path "*/modules/*" -name "main.tf" | sed 's:[^/]*$::')

for rootModule in ${rootModules}; do
  printf "\nValidating root module %s\n\n" ${rootModule}

  pushd "${rootModule}" &> /dev/null || exit

  if [ ! -f ".terraform.lock.hcl" ]; then
    echo "Terraform lockfile doesn't exist in the root module ${rootModule}. Please create one using \"terraform init -backend=false\""
    exit 1
  fi

  terraform init -backend=false
  terraform validate

  popd &> /dev/null || exit
done;
