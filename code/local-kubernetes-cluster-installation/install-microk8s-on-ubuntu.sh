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
# $1 is the KUBERNETES VERSION
# $2 is the USER for whom to install this.

DEFAULTKUBERNETESVERSION="1.19"
date
echo "Starting BigBitBus Kubernetes Automation Toolkit (KAT) Microk8s installation script"
if [ ! -z $1 ] 
then 
    export KUBEVERSION=$1
else
    export KUBEVERSION=$DEFAULTKUBERNETESVERSION
fi

echo "Installing Kubernetes version " $KUBEVERSION

if [ ! -z $2 ] 
then 
    export INSTALLUSER=$2
else
    export INSTALLUSER=$(ls /home/* -d | head -n 1 | cut -d/ -f3)
fi
echo "Targeting user $INSTALLUSER for Microk8s installation"
export DEBIAN_FRONTEND=noninteractive


# First, patch this computer
apt update -y && apt full-upgrade -y && apt autoremove -y && apt clean -y &&  apt autoclean -y

# A few basics
apt-get install -y fail2ban vim
apt-get install unzip

# Note - we pegged the Kubernetes version here
snap install microk8s --classic --channel=1.19
curl -fsSL https://get.docker.com -o get-docker.sh
sh get-docker.sh
snap install kubectl --classic --channel=1.19
snap install helm --classic --channel=3.4
sleep 60 # Sometimes microk8s needs time to stabilize
cd /tmp
curl -Lo skaffold https://storage.googleapis.com/skaffold/releases/latest/skaffold-linux-amd64 && \
install skaffold /usr/local/bin/
export PATH=$PATH:/snap/bin

# Install k9s for debugging (optional)
wget https://github.com/derailed/k9s/releases/download/v0.24.1/k9s_Linux_x86_64.tar.gz -O /tmp/k9s.tar.gz
tar -xvzf /tmp/k9s.tar.gz -C /tmp
mv /tmp/k9s /usr/local/bin

mkdir -p /home/$INSTALLUSER/.kube
microk8s config > /root/.kube/config # Will need this for installing application
microk8s config > /home/$INSTALLUSER/.kube/config
chown -R $INSTALLUSER:$INSTALLUSER /home/$INSTALLUSER/.kube/
usermod -a -G microk8s $INSTALLUSER
chmod 600 /home/$INSTALLUSER/.kube/config
microk8s.enable rbac
microk8s.enable dns
microk8s.enable storage
microk8s.enable registry
microk8s.enable ingress
kubectl get all --all-namespaces # Debug output
sleep 60 # Sometimes these plugins need a little time to stabilize
echo "Printing kubeconfig (don't do this in production)"
microk8s inspect
microk8s config
echo "Done installing microk8s"