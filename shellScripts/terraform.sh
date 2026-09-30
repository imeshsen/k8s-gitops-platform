#!/bin/bash
set -e

TF_DIR=../terraform/environments/minikube
VAR_FILE=minikube.tfvars

echo "Initializing"
terraform -chdir=$TF_DIR init

echo "Formatting terraform config"
terraform -chdir=$TF_DIR fmt -recursive

echo "Validating terraform config"
terraform -chdir=$TF_DIR validate

echo "Preview changes terraform config"
terraform -chdir=$TF_DIR plan -var-file=$VAR_FILE

echo "Applying the changes"
terraform -chdir=$TF_DIR apply -var-file=$VAR_FILE
