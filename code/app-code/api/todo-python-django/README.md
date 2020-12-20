# Python Django Rest Framework Todo API

The Python Django Todo API implements a RESTFul HTTP API for a to-do list. It is derived from [this tutorial](https://learndjango.com/tutorials/django-rest-framework-tutorial-todo-api).

In the discussion below we assume you will be choosing Microk8s or Minikube for installing the software on your local PC or a virtual machine.

__We recommend using Microk8s if you are running the Ubuntu Linux Operating system on your host, otherwise use Minikube for other OSes (such as Apple). We also strongly discourage users from trying to install Minikube/helm/kubectl/skaffold on a Windows computer; you are much better off connecting via SSH to a virtual machine using Ubuntu Linux and deploying all these tools there. Believe us, we have tried and failed and spent hours debugging Windows specific issues when trying to get productive as developers on Windows; our humble advice from experience is to create a Ubuntu VM in the cloud or your Windows machine (a 2-core, 4GB VM will suffice), and use the excellent remote SSH connectivity tools in VS-Code to control and Interact with the VM, as explained in our documentation [here](../../../documentation/windows-setup)__.

## Notable Code

This is a table of notable links to code in this repository as well as external links in case you wish to learn about these topics.
| Category | File or Directory  | Description | Notes and External Links |
|---|---|---|---|
| Django | [apis/](apis/) |  Django REST framework application written in Python  |  Learn more about [Django](https://www.djangoproject.com/) and the [Django Rest Framework](https://www.django-rest-framework.org/)|
| Docker | [Dockerfile](Dockerfile)  | Docker file to create docker image.   | Get started with [Docker](https://docs.docker.com/get-started/) |
| Django | [apis/todo/models.py](apis/todo/models.py) | Object relational model (ORM)  for the to-do list API | All about Django ORM [models](https://docs.djangoproject.com/en/3.1/topics/db/models/) |
| Kubernetes | [kubecode/bigbitbus-dj-py-api/](kubecode/bigbitbus-dj-py-api/) | A custom Helm chart to deploy application into a Kubernetes cluster | [Helm](https://helm.sh/docs/topics/charts/), a software packaging system for Kubernetes |
| Kubernetes| [kubecode/bigbitbus-dj-py-api/values.yaml](kubecode/bigbitbus-dj-py-api/values.yaml) | The values file is a method to set parameters in the todo-api application Helm chart | More about Helm [values](https://helm.sh/docs/chart_template_guide/values_files/) |
| Skaffold | [skaffold.yml](skaffold.yml) | This Skaffold file contains instructions on how to deploy the application into Kubernetes | [Skaffold](https://skaffold.dev/) handles the workflow for building, pushing and deploying your application |



## Installation

We assume you have access to a reasonable local computer with a broadband internet connection capable of downloading multiple gigabytes of data (mostly for Docker images).
### Pre-requisite Software


1. [Install Docker](https://docs.docker.com/get-docker/) and [Docker-compose](https://docs.docker.com/compose/install/) on your computer.
2. [Install Kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/), the Kubernetes command line interface client, on your computer.
3. [Install Helm](https://helm.sh/docs/intro/install/) package manager client on your computer (version 3 or greater).
4. [Install Skaffold](https://skaffold.dev/docs/install/) on your computer.

**Note: If running on a Windows machine: Use a text editor (ex. VSCode) to change the EOL sequence of the start.sh file from CRLF to LF.**

### Development on your Local PC
Developers may want to iterate through their code as they develop software on their local PC. We will run the to-do Django code on our PC for debugging and connect to a postgres database running on a container.

Open a terminal and create a virtual environment for Python (Assuming you have already installed Python 3.8 or later on your PC):

```
python3 -m venv .venv
```

Activate this environment
```
source .venv/bin/activate

# If on Windows
.venv\Scripts\activate.bat
```

Install the Python requirements:

```
pip install -r requirements.txt
```

Tell the Django application about the postgres container through environment variables . Export these environment variables on your local PC.

```
export POSTGRES_PORT=5432
export POSTGRES_PASSWORD=B1gB1tBu5
export POSTGRES_DB=todo-postgres-database
export POSTGRES_USER=postgres
export POSTGRES_HOST=localhost

# If on Windows
SET POSTGRES_PORT=5432
SET POSTGRES_PASSWORD=B1gB1tBu5
SET POSTGRES_DB=todo-postgres-database
SET POSTGRES_USER=postgres
SET POSTGRES_HOST=localhost
```

Create the Postgres docker container.

```
docker-compose up -d postgresdb
```

Run the Django API server

```
python manage.py collectstatic
python manage.py migrate
python manage.py runserver 0.0.0.0:8002

```

The API will now be available at `http://localhost:8002/djangoapi/apis/v1/`

Now you can develop the application and Django will "hot-reload" as you change code; this saves a lot of developer time because you do not have to re-build the image to test it every time.
### Run pre-baked image on your Local PC with Docker-compose

Once we are satisfied that the application has been developed to our satisfaction we should test its pre-baked image locally. The pre-baked immutable image is what gets passed from development to qa and finally to production without being changed, so its quite useful to be able to quickly spin up the pre-baked image on our local PC via docker-compose.

We can use `docker-compose` to run the todo API and the Postgres database on our local PC, like so:

```
# Open a terminal and run these commands
docker-compose build # Build the Docker image with the latest code in this repository
docker-compose up

```
Now you can open a web browser and point it to `http://localhost:8000/djangoapi/apis/v1/` to browse and interact with the todo API backend.

Note we selected port 8000 for this case (not 8002) so you can have both the development and the pre-baked software running in the image on the same machine (albeit interacting with the same database). Make a note that when you try to point the Todo [frontend](../../frontend/todo-vuejs) you will need to set the correct backend server and port in the [.env](../../frontend/todo-vuejs/.env) file there for the `VUE_APP_DJANGO_ENDPOINT` variable.
### Run in Kubernetes

Finally, we are ready to deploy to Kubernetes!

This discussion assumes that you have a your `kubectl` command-line client configured and pointing to the correct Kubernetes cluster (click [Minikube](https://minikube.sigs.k8s.io/docs/start/) or Microk8s ([Ubuntu](https://ubuntu.com/tutorials/install-a-local-kubernetes-with-microk8s#2-deploying-microk8s), [Windows/Mac](https://microk8s.io/docs/install-alternatives)) to learn how to install these one-node Kubernetes clusters on your local PC or a VM). Learn more about setting the Kubectl context [here](https://kubernetes.io/docs/tasks/access-application-cluster/configure-access-multiple-clusters/).

Verify that kubectl is correctly configured

For Microk8s running this command should give you an output similar to this

```
kubectl get no
NAME                 STATUS   ROLES    AGE   VERSION
<YOUR PC NAME>   Ready    <none>   58d   v1.19.3-34+a56971609ff35a

```

For Minikube
```
kubectl get no
NAME                 STATUS   ROLES    AGE   VERSION
minikube   Ready    <none>   58d   v1.19.3-34+a56971609ff35a

```

If this doesn't work, try to debug the local Kubernetes cluster installation befre proceeding.

#### Addons for local Kubernetes via Microk8s or Minikube

We need to enable some additional add-ons for our local Kubernetes installation. Run these commands.

```
# For Microk8s enable these addons
microk8s.enable dns
microk8s.enable storage
microk8s.enable registry
microk8s.enable ingress
microk8s.enable rbac

# For Minikube enable these addons
minikube addons enable registry
minikube addons enable ingress
```
#### Postgres Database

Create the postgres database via a standard Helm chart; run the following commands in a terminal window. It is vital that you only run the microk8s or minikube commands depending on which Kubernetes cluster you have on your PC.

```
kubectl create namespace pg
cd kubernetes-automation-toolkit/code/k8s-common-code/postgres-db/ # relative to the root directory of this git repository
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update

# For microk8s
helm install -n pg pgdb bitnami/postgresql -f pg-values.yaml

# OR, for minikube
helm install -n pg pgdb bitnami/postgresql -f pg-values.yaml --set persistence.storageClass="standard"
```

Useful tip: If you mistakenly run the command for microk8s instead of minikube, please delete the helm deployment and the persistent volume claim before re-trying with the correct minikube command; something like
```
helm delete -n pg pgdb
kubectl -n pg delete pvc data-pgdb-postgresql-0

```

#### Backend todo API

Then, install the to-do API
```
# Backend
kubectl create namespace be
cd kubernetes-automation-toolkit/code/app-code/api/todo-python-django/

# For microk8s
skaffold run --default-repo localhost:32000

# OR, for minikube
skaffold run --default-repo localhost:5000
```

You can always make code changes to the frontend and then run the skaffold `run` command again to deploy the changes into the Kubernetes cluster. Learn more about other [skaffold developer and operations workflows](https://skaffold.dev/docs/workflows/).


We have just used Skaffold to deploy the Helm chart of our to-do API into the Kubernetes cluster.

**Side note:** If you are looking to create a Helm chart for your own project we recommend starting from the boiler-plate code generated by [`helm create`](https://helm.sh/docs/helm/helm_create/). This command will create a basic layout that you can then adapt to your application.
## Usage

Once the the backend is installed, we can use the ingress to access the application

Point your browser at http://host:[port]/djangoapi/apis/v1/ and check if you can browse the API and add/remove/list items etc.

### Minikube

For Minikube, first find the IP address assigned to the ingress
Run
```
kubectl get ingress --all-namespaces
```

This should yield an output like this:
```
NAMESPACE   NAME                                 CLASS    HOSTS        ADDRESS      PORTS   AGE
be          django-backend-bigbitbus-dj-py-api   <none>   klocalhost   172.17.0.2   80      2m22s
```

Edit the `/etc/hosts` or `c:\Windows\System32\Drivers\etc\hosts` (Windows) file on your PC and add the IP address and the hostname, for example:

```
172.17.0.2 klocalhost
```
### Microk8s

Edit the `/etc/hosts` or `c:\Windows\System32\Drivers\etc\hosts` (Windows) file on your PC and add this line to the bottom of that file:

```
127.0.0.1 klocalhost
```

Notice that for Microk8s we point `klocalhost` to `127.0.0.1`. This is because unlike Minikube, Microk8s is not running within a Virtual machine.


Now you can point your web browser to `http://klocalhost/djangoapi/api/v1/` to browse the API.

## Pitfalls, Common Mistakes
1. Make sure you only run the commands for the Kubernetes cluster you installed on your PC (Minikube or Microk8s); Mixing the two commands can cause the deployments to fail.
2.

## Clean-up

You can "delete" any Helm chart from the cluster:

```
# Get a list of installed helm charts in all namespaces
helm ls --all-namespaces

# Delete the backend todo API
helm delete be --namespace be



# Delete the Postgres database
helm delete pgdb --namespace pg

```

Deleting the Postgres database Helm chart does not delete the persistent volume (storage). To remove the storage permanently.

```
kubectl -n pg get pvc
kubectl -n pg delete pvc <pvc-name-from-above-command>

# Delete the namespace if you wish
kubectl delete namespace pg

```

### Delete the Kubernetes Cluster

To delete the entire Kubernetes cluster delete the minikube or microk8s installation from your PC, like so:


For microk8s, simply uninstall microk8s for the best cleanup. There are some other options to [reset the cluster](https://microk8s.io/docs/commands#heading--microk8s-reset) in case you don't want to completely remove it.

For minikube, `minikube delete` should suffice.


## Further Reading

* The todo Django Python code is derived from the tutorial at [https://learndjango.com/tutorials/django-rest-framework-tutorial-todo-api](https://learndjango.com/tutorials/django-rest-framework-tutorial-todo-api).


## Contributors

* Sachin Agarwal <sachin@bigbitbus.com>
* Simon Yan <simon@bigbitbus.com>

