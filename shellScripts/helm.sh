#!/bin/bash

for chart in backend frontend
do
  echo "deploying $chart..........."
  helm upgrade --install $chart ../helm/$chart \
    --namespace k8s \
    --create-namespace
done
