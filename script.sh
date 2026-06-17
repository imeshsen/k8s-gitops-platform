#!/bin/bash

kubectl get ns

echo "Enter the namespace you want to switch"
read NS

kubectl config set-context  --current --namespace "$NS"

echo "Switched to $NS namespace"
