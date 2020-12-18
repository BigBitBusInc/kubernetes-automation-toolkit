#!/bin/sh
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

DEBIAN_FRONTEND=noninteractive
export DEBIAN_FRONTEND=noninteractive

#First, patch this ubuntu computer
apt update -y && apt full-upgrade -y && apt autoremove -y && apt clean -y &&  apt autoclean -y

snap install docker
snap install kubectl --classic
snap install helm --classic
curl -Lo skaffold https://storage.googleapis.com/skaffold/releases/latest/skaffold-linux-amd64 && \
install skaffold /usr/local/bin/
export PATH=$PATH:/snap/bin
# Install minikube
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
sudo install minikube-linux-amd64 /usr/local/bin/minikube


cd /home
cd $(ls -d */|head -n 1)
export SCRHOME="`pwd`"
cd $SCRHOME
mkdir .kube
cd .kube

cd $SCRHOME
chown -R devuser:devuser .kube/
chmod 600 .kube/config

cd $SCRHOME
export KUBECONFIG=$SCRHOME/.kube/config:$SCRHOME/.kube/microk8s
kubectl config set-context microk8s


apt-get install -y fail2ban vim
apt-get install postgresql-client -y
apt-get install unzip

# Pull zipped files
cd $SCRHOME
wget https://www.dropbox.com/s/3rng7ke6ii2hl40/bigbitbus-kat-main.zip
unzip bigbitbus-kat-main.zip


# Postgres
kubectl create namespace pg
cd $SCRHOME/bigbitbus-kat-main/code/k8s-common-code/postgres-db/
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update
helm install -n pg pgdb bitnami/postgresql -f pg-values.yaml --set persistence.storageClass="standard"

# Monitoring
kubectl create namespace monitoring
cd $SCRHOME/bigbitbus-kat-main/code/k8s-common-code/monitoring/
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo add stable https://charts.helm.sh/stable
helm repo update
helm -n monitoring install monitoring-stack prometheus-community/kube-prometheus-stack -f ./prometheus-grafana-monitoring-stack-values.yaml  --set prometheus.prometheusSpec.storageSpec.volumeClaimTemplate.spec.storageClassName=standard

# K8s Dashboard
kubectl create namespace dashboard
cd $SCRHOME/bigbitbus-kat-main/code/k8s-common-code/k8sdashboard/
helm repo add kubernetes-dashboard https://kubernetes.github.io/dashboard/
helm repo update
helm install -n dashboard k8sdashboard kubernetes-dashboard/kubernetes-dashboard  -f ./dashboard-values.yaml

# Backend
kubectl create namespace be
cd $SCRHOME/bigbitbus-kat-main/code/app-code/api/todo-python-django/
skaffold run --default-repo localhost:5000

# Frontend 
kubectl create namespace fe
cd $SCRHOME/bigbitbus-kat-main/code/app-code/frontend/todo-vuejs/
skaffold run --default-repo localhost:5000

cd $SCRHOME
chown -R devuser:devuser bigbitbus-kat-main/
rm bigbitbus-kat-main.zip

