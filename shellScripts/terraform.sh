#!/bin/bash

echo "Validating terraform config"
terraform -chdir=../terraform validate

echo "Formatting terraform config"
terraform -chdir=../terraform fmt

echo "Initializing"
terraform -chdir=../terraform init


echo "Preview changes terraform config"
terraform -chdir=../terraform plan

echo "Applying the changes"
terraform -chdir=../terraform apply
