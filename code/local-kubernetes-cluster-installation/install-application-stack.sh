#!/bin/bash
# Copyright 2020 BigBitBus
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.


echo "Starting BigBitBus Kubernetes Automation Toolkit (KAT) cluster application installations"

if [ ! -z $1 ] 
then 
    export INSTALLUSER=$1
else
    export INSTALLUSER=$(ls /home/* -d | head -n 1 | cut -d/ -f3)
fi
echo "Targeting user $INSTALLUSER for application-code installation"
export KUBECONFIG=/home/$INSTALLUSER/.kube/config
kubectl config set-context microk8s
cd /home/$INSTALLUSER
# Pull zipped files
rm -rf bigbitbus-kat-main # Clean out any old run
rm bigbitbus-kat-main.zip
wget https://www.dropbox.com/s/3rng7ke6ii2hl40/bigbitbus-kat-main.zip
unzip bigbitbus-kat-main.zip


# Postgres
cd /home/$INSTALLUSER/bigbitbus-kat-main/code/k8s-common-code/postgres-db/
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update
helm upgrade --install pgdb bitnami/postgresql -f pg-values.yaml --namespace pg --create-namespace 

# Monitoring
cd /home/$INSTALLUSER/bigbitbus-kat-main/code/k8s-common-code/monitoring/
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo add stable https://charts.helm.sh/stable
helm repo update
helm  upgrade --install monitoring-stack prometheus-community/kube-prometheus-stack -f ./prometheus-grafana-monitoring-stack-values.yaml --namespace monitoring --create-namespace 

# K8s Dashboard
cd /home/$INSTALLUSER/bigbitbus-kat-main/code/k8s-common-code/k8sdashboard/
helm repo add kubernetes-dashboard https://kubernetes.github.io/dashboard/
helm repo update
helm upgrade --install k8sdashboard kubernetes-dashboard/kubernetes-dashboard  -f ./dashboard-values.yaml --namespace dashboard --create-namespace 

# Backend
kubectl create namespace be
cd /home/$INSTALLUSER/bigbitbus-kat-main/code/app-code/api/todo-python-django/
skaffold run --default-repo localhost:32000

# Frontend 
kubectl create namespace fe
cd /home/$INSTALLUSER/bigbitbus-kat-main/code/app-code/frontend/todo-vuejs/
skaffold run --default-repo localhost:32000

chown -R $INSTALLUSER:$INSTALLUSER /home/$INSTALLUSER/bigbitbus-kat-main/
cd /home/$INSTALLUSER
rm bigbitbus-kat-main.zip
# Print what was deployed for later debugging
kubectl get all --all-namespaces
echo "Ended BigBitBus Kubernetes Automation Toolkit (KAT) application installation script"
