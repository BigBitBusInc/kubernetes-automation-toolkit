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


echo "Starting BigBitBus Kubernetes Automation Toolkit (KAT) Minokube installation script"


if [ ! -z $2 ] 
then 
    export INSTALLUSER=$2
else
    export INSTALLUSER=$(ls /home/* -d | head -n 1 | cut -d/ -f3)
fi
echo "Targeting user $INSTALLUSER for Minikube installation"
export DEBIAN_FRONTEND=noninteractive


# First, patch this computer
apt update -y && apt full-upgrade -y && apt autoremove -y && apt clean -y &&  apt autoclean -y

# A few basics
apt-get install -y fail2ban vim
apt-get install unzip

# Install minikube
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
sudo install minikube-linux-amd64 /usr/local/bin/minikube


snap install docker --channel=19.03
snap install kubectl --classic --channel=1.19
snap install helm --classic --channel=3.4.2
cd /tmp
curl -Lo skaffold https://storage.googleapis.com/skaffold/releases/latest/skaffold-linux-amd64 && \
install skaffold /usr/local/bin/
export PATH=$PATH:/snap/bin

# Install k9s for debugging (optional)
wget https://github.com/derailed/k9s/releases/download/v0.24.1/k9s_Linux_x86_64.tar.gz -O /tmp/k9s.tar.gz
tar -xvzf /tmp/k9s.tar.gz -C /tmp
mv /tmp/k9s /usr/local/bin

mkdir -p /home/$INSTALLUSER/.kube
cp /root/.kube/config /home/$INSTALLUSER/.kube/config
chown -R $INSTALLUSER:$INSTALLUSER /home/$INSTALLUSER/.kube/
chmod 600 /home/$INSTALLUSER/.kube/config
minikube addons enable registry
minikube addons enable ingress
echo "127.0.0.1  klocalhost" >> /etc/hosts
sleep 60 # Sometimes these plugins need a little time to stabilize
kubectl get all --all-namespaces # Debug output
echo "Done installing Minikube"
