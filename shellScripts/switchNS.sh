#!/bin/bash

kubectl get ns

echo "Enter the namespace you want to switch"
read NS

kubectl config set-context  --current --namespace "$NS"

echo "Switched to $NS namespace"

echo "List deployments..................."
kubectl get deploy

echo "List services"
kubectl get svc
