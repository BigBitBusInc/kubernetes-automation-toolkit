### Install Dependencies 

```
snap install microk8s --classic
snap install docker
snap install kubectl --classic
snap install helm --classic
wget -c https://golang.org/dl/go1.15.5.linux-amd64.tar.gz
tar -C /usr/local -xzf go1.15.6.linux-amd64.tar.gz
export PATH=$PATH:/snap/bin
```

### Enable Microk8s Add-ons

```
microk8s.enable dns
microk8s.enable storage
microk8s.enable registry
microk8s enable ingress
microk8s enable rbac
```

### Update Microk8s config
```
cd /home/devuser
sudo mkdir .kube
cd .kube
sudo microk8s config > config

export KUBECONFIG=/home/devuser/.kube/config:/home/devuser/.kube/microk8s
sudo kubectl config set-context microk8s
```

### MongoDB
```
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update
helm install my-release bitnami/mongodb
```

### Golang and React files and update MongoDB connection string 
```
git clone https://github.com/BigBitBusInc/kubernetes-automation-toolkit.git
export MONGODB_ROOT_PASSWORD=$(kubectl get secret --namespace default my-release-mongodb -o jsonpath="{.data.mongodb-root-password}" | base64 --decode)
echo $MONGODB_ROOT_PASSWORD
```
Copy this password and navigate to kubernetes-automation-toolkit/code/app-code/api/todo-golang/middleware
```
cd kubernetes-automation-toolkit/code/app-code/api/todo-golang/middleware
vi middleware.go
```
Change the connection string to the copied password
const connectionString = "mongodb://root:[mongodb password]@my-release-mongodb.default.svc.cluster.local:27017/?connect=direct"


### Set up Golang server
```
cd kubernetes-automation-toolkit/code/app-code/api/todo-golang
docker build -t localhost:32000/golang-docker:latest .
docker push localhost:32000/golang-docker:latest
kubectl create -f k8s-pod.yaml
```

### Set up React webpage
```
cd kubernetes-automation-toolkit/code/app-code/frontend/todo-react/client
docker build -t localhost:32000/react-fe:latest .
docker push localhost:32000/react-fe:latest
kubectl create -f k8s-pod.yaml
```

### Port-forward services
```
kubectl port-forward service/go-be-service 30007:8080
kubectl port-forward service/react-fe-service 30008:3000
```
