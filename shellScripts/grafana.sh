#!/bin/bash

echo "helm list -n monitoring--------------------------"
helm list -n monitoring

echo "Enter your grafana chart name"
read chart

echo "Your username is admin. Password is............................."
kubectl get secret --namespace monitoring $chart -o jsonpath="{.data.admin-password}" | base64 --decode ; echo

echo "You can deploy grafana dashboard by kubectl -n monitoring port-forward svc/grafana 8081:80 --address 0.0.0.0"
