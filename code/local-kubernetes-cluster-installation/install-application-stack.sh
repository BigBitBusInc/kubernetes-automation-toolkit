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

# This script needs to run as the root user.

# There are two command line arguments (both optional) but quite important to understand
# $1 is the RELEASENAME you want to install from github
# $2 is the USER for whom to install this.

# Please make sure the user matches the one for which you installed and configured Kubernetes


DEFAULTRELEASENAME="candair-0.3" # Change this as required with new tags (before you tag!!!)
date
echo "Starting BigBitBus Kubernetes Automation Toolkit (KAT) cluster application installations"

if [ ! -z $1 ] 
then 
    export RELEASENAME=$1
else
    export RELEASENAME=$DEFAULTRELEASENAME
fi

echo "Installing KAT release $RELEASENAME."

export RELEASEDIRNAME="kubernetes-automation-toolkit-"$RELEASENAME

if [ ! -z $2 ] 
then 
    export INSTALLUSER=$2
else
    export INSTALLUSER=$(ls /home/* -d | head -n 1 | cut -d/ -f3)
fi
echo "Targeting user $INSTALLUSER for application-code installation"
export KUBECONFIG=/home/$INSTALLUSER/.kube/config
kubectl config set-context microk8s
cd /home/$INSTALLUSER
# Pull zipped files
rm -rf $RELEASEDIRNAME # Clean out any old run
rm $RELEASENAME.zip
wget https://github.com/BigBitBusInc/kubernetes-automation-toolkit/archive/$RELEASENAME.zip
unzip $RELEASENAME.zip


# Postgres
cd /home/$INSTALLUSER/$RELEASEDIRNAME/code/k8s-common-code/postgres-db/
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update
helm upgrade --install pgdb bitnami/postgresql -f pg-values.yaml --namespace pg --create-namespace 

# Monitoring
cd /home/$INSTALLUSER/$RELEASEDIRNAME/code/k8s-common-code/monitoring/
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo add stable https://charts.helm.sh/stable
helm repo update
helm  upgrade --install monitoring-stack prometheus-community/kube-prometheus-stack -f ./prometheus-grafana-monitoring-stack-values.yaml --namespace monitoring --create-namespace 

# K8s Dashboard
cd /home/$INSTALLUSER/$RELEASEDIRNAME/code/k8s-common-code/k8sdashboard/
helm repo add kubernetes-dashboard https://kubernetes.github.io/dashboard/
helm repo update
helm upgrade --install k8sdashboard kubernetes-dashboard/kubernetes-dashboard  -f ./dashboard-values.yaml --namespace dashboard --create-namespace 

# Backend
kubectl create namespace be
cd /home/$INSTALLUSER/$RELEASEDIRNAME/code/app-code/api/todo-python-django/
skaffold run --default-repo localhost:32000

# Frontend 
kubectl create namespace fe
cd /home/$INSTALLUSER/$RELEASEDIRNAME/code/app-code/frontend/todo-vuejs/
skaffold run --default-repo localhost:32000

chown -R $INSTALLUSER:$INSTALLUSER /home/$INSTALLUSER/$RELEASEDIRNAME/
cd /home/$INSTALLUSER
rm $RELEASENAME.zip
# Print what was deployed for later debugging
kubectl get all --all-namespaces
echo "Ended BigBitBus Kubernetes Automation Toolkit (KAT) application installation script"
