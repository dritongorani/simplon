#!/bin/bash

###################### Helm, grafana, prometheuse, loki #########################
helm repo add grafana https://grafana.github.io/helm-charts
helm repo update
helm upgrade --install loki grafana/loki-stack --namespace monitoring --set grafana.enabled=true --create-namespace 
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts --namespace monitoring
helm repo update
helm install my-prometheuss --namespace monitoring prometheus-community/prometheus --version 24.4.0
sleep 10
kubectl get secret --namespace monitoring loki-grafana -o jsonpath="{.data.admin-password}" | base64 --decode ; echo 
# kubectl port-forward --namespace monitoring service/loki-grafana 3000:80
echo "Helm, grafana, prometheuse, loki have been installed"
sleep 5
kubectl create ns randomlogger
kubectl apply -f ./chantex.yaml 
#Add a dashboard nr: 1860 nodexporter
# Cluster monitoring: 315
# Pod monitoring: 15661
# pod memory 747
## loki log dashboard: 13639