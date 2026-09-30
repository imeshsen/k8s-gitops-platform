#!/bin/bash

for app in backend frontend
do
  echo "deploying $app..........."
  helm upgrade --install $app ../helm/app \
    -f ../helm/values-$app.yaml \
    --namespace k8s \
    --create-namespace
done
