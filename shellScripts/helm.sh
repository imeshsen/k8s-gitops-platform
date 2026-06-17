#!/bin/bash


for chart in backend frontend
do

echo "deploying $chart..........."
helm install $chart  ../helm/$chart/

done
