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


echo "Starting BigBitBus Kubernetes Automation Toolkit (KAT) installation script"

if [ ! -z $1 ] 
then 
    export INSTALLUSER=$1
else
    export INSTALLUSER=$(ls /home/* -d | head -n 1 | cut -d/ -f3)
fi
echo "Targeting user $INSTALLUSER for this installation"
export DEBIAN_FRONTEND=noninteractive

#First, patch this computer
apt update -y && apt full-upgrade -y && apt autoremove -y && apt clean -y &&  apt autoclean -y

# Note here - we pegged the Kubernetes version here
snap install microk8s --classic --channel=1.19/stable
snap install docker
snap install kubectl --classic
snap install helm --classic
curl -Lo skaffold https://storage.googleapis.com/skaffold/releases/latest/skaffold-linux-amd64 && \
install skaffold /usr/local/bin/
export PATH=$PATH:/snap/bin
cd /home/$INSTALLUSER
export SCRHOME="`pwd`"
cd $SCRHOME
mkdir .kube
cd .kube
microk8s config > config

cd $SCRHOME
chown -R $INSTALLUSER:$INSTALLUSER .kube/
chmod 600 .kube/config

cd $SCRHOME
export KUBECONFIG=$SCRHOME/.kube/config:$SCRHOME/.kube/microk8s
kubectl config set-context microk8s

microk8s.enable dns
microk8s.enable storage
microk8s.enable registry
microk8s.enable ingress
microk8s.enable rbac
sleep 30
apt-get install -y fail2ban vim
apt-get install postgresql-client -y
apt-get install unzip

# Install k9s for debugging (optional)
wget https://github.com/derailed/k9s/releases/download/v0.24.1/k9s_Linux_x86_64.tar.gz -O /tmp/k9s.tar.gz
tar -xvzf /tmp/k9s.tar.gz -C /tmp
mv /tmp/k9s /usr/local/bin

# Add hosts entry
echo "127.0.0.1 klocalhost" >> /etc/hosts

# Pull zipped files
cd $SCRHOME
wget https://www.dropbox.com/s/3rng7ke6ii2hl40/bigbitbus-kat-main.zip
unzip bigbitbus-kat-main.zip


# Postgres
cd $SCRHOME/bigbitbus-kat-main/code/k8s-common-code/postgres-db/
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update
helm upgrade --install pgdb bitnami/postgresql -f pg-values.yaml --namespace pg --create-namespace 

# Monitoring
cd $SCRHOME/bigbitbus-kat-main/code/k8s-common-code/monitoring/
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo add stable https://charts.helm.sh/stable
helm repo update
helm  upgrade --install monitoring-stack prometheus-community/kube-prometheus-stack -f ./prometheus-grafana-monitoring-stack-values.yaml --namespace monitoring --create-namespace 

# K8s Dashboard
cd $SCRHOME/bigbitbus-kat-main/code/k8s-common-code/k8sdashboard/
helm repo add kubernetes-dashboard https://kubernetes.github.io/dashboard/
helm repo update
helm upgrade --install k8sdashboard kubernetes-dashboard/kubernetes-dashboard  -f ./dashboard-values.yaml --namespace dashboard --create-namespace 

# Backend
kubectl create namespace be
cd $SCRHOME/bigbitbus-kat-main/code/app-code/api/todo-python-django/
skaffold run --default-repo localhost:32000

# Frontend 
kubectl create namespace fe
cd $SCRHOME/bigbitbus-kat-main/code/app-code/frontend/todo-vuejs/
skaffold run --default-repo localhost:32000

cd $SCRHOME
chown -R $INSTALLUSER:$INSTALLUSER bigbitbus-kat-main/
rm bigbitbus-kat-main.zip

echo "Ended BigBitBus Kubernetes Automation Toolkit (KAT) installation script"
