# BigBitBus KAT Documentation

**TABLE OF CONTENTS**

- [BigBitBus KAT Documentation](#bigbitbus-kat-documentation)
- [What is in the repository?](#what-is-in-the-repository)
  - [Containers](#containers)
  - [Kubernetes](#kubernetes)
    - [Pods](#pods)
    - [Application Deployments](#application-deployments)
    - [Helm](#helm)
    - [Skaffold](#skaffold)
  - [The KAT Application Example](#the-kat-application-example)
    - [Helpful Hints](#helpful-hints)
  - [Glossary](#glossary)

Welcome to the BigBitbus Kubernetes Automation Toolkit (KAT).

KAT is a series of examples of how an application can be developed and deployed into Kubernetes. The examples in this repository include the application code, Helm charts that deploy the application in Kubernetes, monitoring for observability, ingress (how requests are routed into the application), and considerations around how to store application data within a Kubernetes cluster.

Developing applications for Kubernetes needs some additional work because along with the application code, infrastructure-as-code is also part of the deliverable. For example, Helm packages to deploy the application, integrations with cloud-native monitoring solutions, configuring Kubernetes load-balancing and application request routing, managing secrets and environment variables, building rules for auto-scaling and resource management and software-defined-storage.

The documentation and code in this repository will shine light on different layers of the stack and hopefully impart enough context to navigate Kubernetes successfully as a developer, a devops engineer, or just someone who wants to learn about the "Kubernetes way" of doing things. We provide links to high quality documentation for deeper dives on the concepts our examples illustrate. Our examples will show you how it all comes together so you can get productive, fast. You can then choose to learn more about specific parts of the stack as your situation demands.

# What is in the repository?

Here are some of the highlights of the KAT

1. A single-page-application written in Vuejs that lets users create a To-do list. We use a the To-do list as our web application example. 
2. A To-do backend API written in the Django Rest Framework in Python.
3. The To-do list items is stored in a Postgresql database deployed on Kubernetes on a persistent volume disk.
4. The application can be deployed on any Kubernetes cluster. KAT includes scripts for creating a Microk8s Kubernetes cluster on a single node (for example, your local PC or a virtual machine).
5. We show how Skaffold is used to invoke the helm charts that deploy the application into the Kubernetes cluster.
6. Monitoring is provided through a prometheus server and grafana dashboards.
7. A Kubernetes dashboard is available to visually browse the Kubernetes cluster at any time.
8. An Nginx Ingress resource is setup to route application, monitoring and dashboard requests.

We have documented several aspects of the setup. Here is where everything is:
| Category | File or Directory  | Description |
|---|---|---|
| Documentation | [README.md](./documentation/) | This document. Start here for an overview and links to other documents |
| To-do Django API | [../code/app-code/api/To-do-python-django](../code/app-code/api/To-do-python-django) | Django Python To-do backend and a detailed readme file; includes Helm chart deployed using Skaffold |
| Postgresql DB | [../code/k8s-common-code/postgres-db](../code/k8s-common-code/postgres-db) | Installing and configuring Postgresql database into the Kubernetes cluster using Helm charts |
| Vuejs To-do Single Page Application | [../code/app-code/frontend/To-do-vuejs](../code/app-code/frontend/To-do-vuejs) | To-do application implemented in Vuejs and a readme file; includes Helm chart deployed using Skaffold |
| Monitoring | [../code/k8s-common-code/monitoring](../code/k8s-common-code/monitoring) |Installing and configuring monitoring with Prometheus and Grafana into the Kubernetes cluster using standard Helm charts created by the Prometheus community |
| Kubernetes Dashboard | [../code/k8s-common-code/k8sdashboard](../code/k8s-common-code/k8sdashboard) | Running the Kubernetes dashboard |


Here is the directory tree of this repository:

```
.
├── code
│   ├── app-code
│   │   ├── api
│   │   │   └── To-do-python-django
│   │   │       ├── apis
│   │   │       │   └── migrations
│   │   │       ├── config
│   │   │       ├── kubecode
│   │   │       │   └── bigbitbus-dj-py-api
│   │   │       │       └── templates
│   │   │       └── To-dos
│   │   │           └── migrations
│   │   └── frontend
│   │       └── To-do-vuejs
│   │           ├── dist
│   │           │   └── js
│   │           ├── kubecode
│   │           │   └── bigbitbus-vue-fe
│   │           │       └── templates
│   │           ├── public
│   │           └── src
│   │               ├── assets
│   │               └── components
│   ├── k8s-common-code
│   │   ├── k8sdashboard
│   │   ├── monitoring
│   │   └── postgres-db
│   └── local-kubernetes-cluster-installation
└── documentation
    └── images

```


For the beginner, we provide short explanations of important Kubernetes concepts below. Many of these concepts are large multi-year open-source projects in their own right with hundreds of contributors and hundreds of thousands of lines of code and copius documentation. So our treatment of these topics is fleeting at best, but we do strive to provide you with links to official documentation and a few other curated resources to learn more in depth if you need to.

## Containers
![Container build and run](images/Slide5.PNG)**Fig. 1: Building container images and running containers**

Containers are like boxes you install your application code into, and then seal the box so the contents cannot be changed. You take your application's code and all its dependencies and pack them up into a container image. This container image is then "shipped" from a developer's laptop or a build system into QA, then staging and then right up to production without change (container images are immutable, although you can inject environment variables and disk mount points into a running container). When it’s time to "run" the application, these container images become running containers - a process running on the host computer that are isolated from other containers as well as the host computer itself. Container processes can also be resource-limited in how much CPU or memory they use so that a single container cannot starve the entire host of CPU or memory. Isolation and resource-limiting is achieved by invoking the container process in Linux namespaces and through a clever use of cgroups.

Fig. 1 shows how a container is built. We start with a base container (for example, the Python:3 container in our [API Dockerfile](../code/app-code/api/To-do-python-django/Dockerfile)) and add our application code and install any libraries/dependencies into it. Then we build the immutable binary container image and push it into a container registry. A container registry is a modified file server that can host and serve these container image files.

When it is time to run the container this binary image is pulled from the registry by the container runtime (for example, Docker) and started; data volumes and configuration/environment variables are sometimes added into the container.


![Bare-metal server, virtual machines, containers](images/Slide4.PNG)**Fig 2: Difference between bare metal servers, virtual machines and containers**

Compared to a virtual machine, container images are smaller because they do not contain code to run their own kernel. Instead they invoke system calls on the host kernel when they need kernel functionality - such as say, writing a file to disk. The smaller container footprint also means that they can be started and stopped much faster than a virtual machine.
One key operational advantage of containers is that they discourage code and configuration drift because they are immutable. With VMs and bare-metal servers a user can log into the VM, make a change and then forget adding the change to the code or configuration repository. But with containers making such a change is not practical because containers routinely re-start and return to the original "immutable" state of the container image. So changes can only be made via building and redeploying a newer image from the code/configuration repository.

Here are some further links to learn more about containers:

1. [Docker: What is a Container?](https://www.docker.com/resources/what-container)
2. [Redhat blog: Kernel versus User space](https://www.redhat.com/en/blog/architecting-containers-part-1-why-understanding-user-space-vs-kernel-space-matters) in the context of containers.


Now that we know how useful containers are, we want to run these in production - meaning not just on our local PC as a docker container, but across multiple nodes (hosts) as we start building highly available applications with many containers spread across multiple hosts. This is where Kubernetes comes in.

![Beyond a single container](images/Slide6.PNG)**Fig. 3: Kubernetes will orchestrate containers across multiple hosts, providing high availability and scalability for a correctly-architected application.**
## Kubernetes

Kubernetes is a system to orchestrate containers (pods) on multiple hosts (nodes). 'Orchestrate' in this context includes scheduling, running/maintaining the containers, setting up networking between containers and with the external world, managing service discovery (DNS), environment variables, secrets, storage, resource and admission control, and a whole lot of other aspects of running a highly reliable, secure application in production.

<!-- ![Kubernetes - key functionality](images/Slide7.PNG) -->

From an end user perspective, Kubernetes allows users to define the end-state of their applications by making HTTP API calls to the Kubernetes master API server. Users can specify the parameters of different Kubernetes objects such as pods, services, configuration maps, secrets, etc. Instead of sending API requests directly, users usually define their Kubernetes objects in Kubernetes manifest files written in yaml. The `kubectl` client can take these files and convert them into API calls which the Kubernetes API server understands. The API server in turn stores this incoming desired end-state into an `etcd` database.

 Once the user's desired end-state is available in `etcd`, Kubernetes controllers will strive to achieve that end state for each object. This model is highly asynchronous and distributed. Objects are independently spun up from other objects. Kubernetes controllers keep watch of the cluster state for changes and attempt to maintain the end state as defined in the `etcd` database. For example, if one of the nodes in the Kubernetes cluster fails, then Kubernetes will try to recreate its pods elsewhere to maintain the number of replicas defined in replica-set objects. Similarly, if the user changes this object by sending a PUT request and now there is a new end-state, then Kubernetes will try to achieve this new end state.

Take a step back and try to imagine this is happening for every object in the cluster. In addition to core Kubernetes constructs like pods, Kubernetes also defines standard interface extensions for storage and networks. This means that vendors have the opportunity to control the end-state of an application by creating compliant drivers for their storage and networking products. Kubernetes also has a modular architecture that allows extending the Kubernetes API and functionality via [custom resource definitions (CRDs)](https://kubernetes.io/docs/concepts/extend-kubernetes/api-extension/custom-resources/) and [operators](https://kubernetes.io/docs/concepts/extend-kubernetes/operator/).

### Pods

In Kubernetes, pods encapsulate containers. Many times a pod will just be a running container and if you are beginning your Kubernetes journey then think of a pod and container as interchangeable terms for the most part. A pod runs within a worker "Node" in a Kubernetes cluster. Pods can sometimes contain multiple containers and share data volumes, network interfaces as well as the port-range between the multiple containers. One of the key architectural differences between pods and say, virtual machines running the application is that pods are dispensible and should be treated as ephemeral. For example,they can be restarted or rescheduled by Kubernetes on any node unless a user [explicitly constrains](https://kubernetes.io/docs/concepts/scheduling-eviction/taint-and-toleration/) the Kubernetes scheduler not to do so.
![A Kubernetes pod](images/Slide10.PNG)**Fig. 4: A Kubernetes Pod**

Fig. 4 shows a Kubernetes pod. A pod runs within a worker node. It may have multiple containers that share the same network and volumes. Data volumes are usually provided through remote storage (Ceph/EBS volumes etc.) so that when a pod is re-provisioned on another node the same storage volume can be attached to it. Pods cannot span nodes.

### Application Deployments
Although you can run your application as a single pod within Kubernetes, ideally you would want to deploy your application so that there are multiple pods running the same application code on different nodes. This helps with reliability (when a pod/node fails) and scalability (multiple pods serving the application).

A set of identical pods is called a replica-set. The Kubernetes replica-set controller constantly checks if the number of running replicas is equal to the user-defined manifest for this replica set; if not then the Kubernetes scheduler will start new pods to reconcile the difference. This "reconciliation loop" to achieve the desired state, as illustrated in Fig. 5, is at the heart of how Kubernetes works. Similar reconciliation controllers are continiously monitoring the `etcd` database for changes to other Kubernetes objects as well, and will strive toward moving the cluster toward the desired state.

![Replicaset](images/Slide11.PNG)**Fig 5: Replica-sets of Pods**


Kubernetes provides users with the ability to deploy newer versions of their code - for example a developer can deploy a newer container image containing more recent code. A [deployment](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/) object is created which has the ability to roll-back in case the new version has a regression. In the figure below developers are creating new code and storing it in [Git](https://git-scm.com/). When it is time to release the code, an immutable container image is built and stored in the container image registry from the code release candidate. This image is used to deploy the code into QA, staging and finally production.


![Deployment](images/Slide12.PNG) **Fig 6: Developer workflow and how it maps into Kubernetes Deployments**

Kubernetes stores a history (previous versions of the application) of replica sets which can be rolled-back as needed using a single command. This is very powerful and gives developers the confidence to iterate quickly and ship faster.

Fig 6 illustrates these concepts. Developers use source code management (for example Git) to  tag different software release versions. These software code releases will be inserted into container images and stored as an immutable image in a container registry as we saw in Fig.1. There may be intermediate steps of running quality-assurance integration tests against these release candidates. Next, the developer or operations engineer will update the deployment definition in production by changing its container image version to the new version (container images are usually tagged for identifying versions, git commit hashes are good tag-ids). They apply the changed Kubernetes yaml manifest using the `kubectl` tool to the API server which in turn changes the `etcd` definition of the deployment object.

 Kubernetes deployment controllers notice the changed image tag and create a new replica-set for this image. Once the replica-set is 'populated' and pods are successfully deployed, the older replica-set is deleted and its pods destroyed. The "definitions" of the older replicaset and pods are preserved, so that a user may roll-back to an earlier version if they so desire.

Finally, we come to the question of service discovery. Pods are ephemeral in Kubernetes, and so are their IP addresses, and these should not be directly addressed by other microservices or external clients. Instead, [services](https://kubernetes.io/docs/concepts/services-networking/service/) are created to provide stable endpoints. Services have two important capabilities:
  1. Kubernetes services have well-defined fixed IPs, and  Kubernetes can run an internal DNS service for service discovery. 
   
  2. Services can load-balance traffic across different pods. This is key to scaling applications by running more pods in Kubernetes and having the service automatically load-balance requests across all the pods.

![Services](images/Slide14.PNG)**Fig 6: Kubernetes Services**

Fig 6. shows that unlike pods, services provide stable endpoints. There are different types of services in Kubernetes, such as Cluster-IP, Load balancer, Nodeport or external name. We encourage readers to spend time with the [official services documentation](https://kubernetes.io/docs/concepts/services-networking/service/) as this is vital to get your application architecture right.

### Helm

When we want to install a software or application in Kubernetes it usually needs to create multiple Kubernetes objects. For example:
  - Pods running the code or binary application
  - Services that allow the application's components to communicate with each other or to users
  - Environment variables and secrets for the application
  - Kubernetes constructs like deployments or replicasets that define the scope and size of an application
  - ...and many more

Helm charts contain templated Kubernetes manifests (yaml files) that can be populated with values a user chooses to craft her/his Kubernetes deployment of the application. For example, one user may want to create 2 replicas of a Pod whereas another may want to create 10 replicas, or perhaps one user may want to use one container image version of the software versus another who wants to use another version.

A `values.yaml` file,  specified when installing a Helm chart, specifies these parameters and its values get substituted in the template to create Kubernetes manifests. The convention of supplying a generic "works-out-of-the-box" `values.yaml` file with the Helm chart's source code helps users get started while creating their own customizations; there are sane defaults in good Helm charts, so users only need to change values they care about.

These Kubernetes manifests are then applied to the Kubernetes cluster (meaning, they are `translated` into json and posted to the Kubernetes API server, which then acts upon the configuration defined by the manifests).

Helm charts are like "software packages'', usually created by the creator or someone knowledgeable about the application. They are created by writing up the Kubernetes manifest and then "templating out" any relevant parameters in a `values.yaml` file. When the end user wants to use this Helm chart, their Helm client downloads it from a repository and the user simply substitutes an appropriate `values.yaml` file to adapt the Kubernetes manifests being generated by the chart to her/his needs. 

Perhaps you want to write our own Helm chart for your own application or for some open-source software you know. Start [here](https://v2.helm.sh/docs/developing_charts/) to learn more about how to set up boilerplate code to get started. Our To-do application's frontend and backend each have their own custom Helmcharts.

### Skaffold

[Skaffold](https://skaffold.dev/) is an command line build tool for developers for Kubernetes applications developed by Google. It aims to handle the workflow for building, pushing, and deploying an application. This enables developers to focus more on developing instead of building and deploying. Skaffold deployments are based around a [skaffold.yaml](../code/app-code/api/To-do-python-django/skaffold.yml) file which contains information such as the docker image to use when building the container, path to the application, target environment to deploy it into etc. Running this file will allow skaffold to watch a local application directory for changes in which upon change, will automatically build, push and deploy to a local or remote Kubernetes cluster.

For our To-do example, skaffold allows us to deploy the Django backend and Vue.js frontend. A quick `skaffold run` builds the container images, pushes them into a registry, invokes Helm to deploy the code changes within the Kubernetes cluster and can also track development changes to redeploy when needed.

## The KAT Application Example

Now that we have a high level idea of some of the features of Kubernetes, lets visualize what the KAT project code will build inside our Kubernetes cluster. The figure below visually depicts our Kubernetes cluster (installed with Microk8s) with our To-do application and monitoring deployed within. We have labelled the components inside the image and here is a summary of each:

![Visual depiction](images/kubernetes-application.svg)

**Fig. 7: KAT To-do Application Stack and Supporting Services in Kubernetes**

| Label | Description | Exploratory commands | Link to Code|
| ----- | ----------- | ------------ | ----- |
| 1(a) | The backend To-do API Kubernetes service. This is load-balancing all requests coming to the `/djangoapi/` endpoint to two backend pods in this picture. This service is of type ClusterIP.  | `kubectl -n be describe service` | [API service template in Helm chart](../code/app-code/api/To-do-python-django/kubecode/bigbitbus-dj-py-api/templates/service.yaml) |
| 1(b) | The backend To-do API deployment has created a replicaset which in turn has defined two pods for the Django API. | `kubectl -n be get po -o wide` | [API deployment template in Helm chart](../code/app-code/api/To-do-python-django/kubecode/bigbitbus-dj-py-api/templates/deployment.yaml) |
| 2(a) | The To-do database service. Note this is an "interal" ClusterIP service and that the Django API pods 1(b) connect to this service exposing port 5432. | `kubectl -n pg describe svc` | [Postgres helm chart](https://github.com/bitnami/charts/tree/master/bitnami/postgresql/), [KAT postgres values file](../code/k8s-common-code/postgres-db/pg-values.yaml) |
| 2(b) | The postgres database pod. This pod creates uses a persistent volume to persist the database. | `kubectl -n pg describe po` | [Postgres helm chart](https://github.com/bitnami/charts/tree/master/bitnami/postgresql/), [KAT postgres values file](../code/k8s-common-code/postgres-db/pg-values.yaml) |
| 3(a) | The frontend Vuejs single-page application To-do service, This is setup to load-balance requests on the `/frontend/` endpoint to two frontend pods serving the Vuejs files in this picture. The service is of type ClusterIP. | `kubectl -n fe describe svc`  | [Frontend service template](..code/app-code/frontend/To-do-vuejs/kubecode/bigbitbus-vue-fe/templates/service.yaml) used to render a Kubernetes yaml manifest based on the values passed into helm. |
| 3(b) | The frontend pods - these are nginx pods that serve up the Vuejs code files. This is a stateless application since its not connected to the backend API; the client loads up the application on their browser and then directly talks to the backend API at `/djangoapi/` | `kubectl -n fe describe deploy`; `kubectl -n fe get po -o wide` | [Frontend service template](..code/app-code/frontend/To-do-vuejs/kubecode/bigbitbus-vue-fe/templates/service.yaml) used to render a Kubernetes yaml manifest based on the values passed into helm. |
| 4(a) | The Kubernetes dashboard service; this forwards requests coming to `/dashboard/` into the dashboard pod. | `kubectl -n dashboard describe svc`; `kubectl -n dashboard describe endpoints` | [Dashboard helm chart](https://github.com/kubernetes/dashboard/tree/master/aio/deploy/helm-chart/kubernetes-dashboard); [KAT Dashboard values file](../code/k8s-common-code/k8sdashboard/dashboard-values.yaml) |
| 4(b) | The Kubernetes dashboard pod, notice its not replicated - so its not a highly available server | `kubectl -n dashboard describe po` |  [Dashboard helm chart](https://github.com/kubernetes/dashboard/tree/master/aio/deploy/helm-chart/kubernetes-dashboard); [KAT Dashboard values file](../code/k8s-common-code/k8sdashboard/dashboard-values.yaml) |
| 5(a) | The Grafana dashboard service. | `kubectl -n monitoring describe service grafana` | [The Prometheus  stack Helm chart](https://github.com/prometheus-community/helm-charts/tree/main/charts/kube-prometheus-stack), [KAT prometheus stack values file for Helm](../code/k8s-common-code/monitoring/prometheus-grafana-monitoring-stack-values.yaml). |
| 5(b) | The Grafana pod | `kubectl -n monitoring describe po grafana` | [The Prometheus  stack Helm chart](https://github.com/prometheus-community/helm-charts/tree/main/charts/kube-prometheus-stack), [KAT prometheus stack values file for Helm](../code/k8s-common-code/monitoring/prometheus-grafana-monitoring-stack-values.yaml). |
| 6(a) | The Prometheus time-series metrics server service, note its not exposed externally via the Ingress but is an internal service consumed by Grafana. | `kubectl -n monitoring describe pod prometheus-server` | [The Prometheus  stack Helm chart](https://github.com/prometheus-community/helm-charts/tree/main/charts/kube-prometheus-stack), [KAT prometheus stack values file for Helm](../code/k8s-common-code/monitoring/prometheus-grafana-monitoring-stack-values.yaml). |
| 6(b) | The prometheus server pod, note it uses a persistent volume to store the metrics | `kubectl -n monitoring get po -o wide`; `kubectl get pv`; `kubectl -n monitoring get pvc` | [The Prometheus  stack Helm chart](https://github.com/prometheus-community/helm-charts/tree/main/charts/kube-prometheus-stack), [KAT prometheus stack values file for Helm](../code/k8s-common-code/monitoring/prometheus-grafana-monitoring-stack-values.yaml). |
| 7 | The ingress. This is where all HTTP requests enter the Kubernetes cluster and are appropriately routed into `/frontend`, `/djangoapi`, `/dashboard/` or `/monitoring-grafana`. This is also where you would terminate SSL in production and/or interface with your cloud provider's load balancer, so ingress is usually a very important aspect of any application setup in Kubernetes. | `kubectl get ingress --all-namespaces -o wide` |  [Nginx Ingress documentation](https://kubernetes.github.io/ingress-nginx/) |

### Helpful Hints

  **Kubernetes Command Line** Also study the complete `kubectl` [cheat-sheet](https://kubernetes.io/docs/reference/kubectl/cheatsheet/).
  ```bash
  # Get all namespaces; we create the be, fe, pg and monitoring namespaces in the KAT example
  kubectl get namespaces

  # Get all objects in the Kubernetes cluster
  kubectl get all --all-namespaces

  # Get all objects in a particular namespace ('be' in this example)
  kubectl -n be get all

  # Get all pods in the monitoring namespace 
  kubectl -n monitoring get pods

  # Get all services in the fe namespace
  kubectl -n fe get svc

  ```
  
  You can get details about a specific pod like so:
  
  ```bash
  # First use `kubectl get pod` and get the name of the pod you want details about 
  # lets say its called mypod-xszdf-asd3rd

  kubectl describe pod mypod-xszdf-asd3rd # Lot of rich information here
  kubectl logs mypod-xszdf-asd3rd # Notice we did'nt use the pod keyword here
  ```

Here are links to some useful documentation of different tools that are used in the KAT example.

| Tool | Useful Documentation |
| ---- | ---------- |
| Microk8s Kubernetes Cluster | [Microk8s](https://microk8s.io/docs/commands) |
| Kubectl Kubernetes Command Line Tool | [Kubectl](https://kubernetes.io/docs/reference/kubectl/cheatsheet/) |
| K9s Terminal Based Kubernetes UI | [k9s](https://k9scli.io/) |
| Helm Kubernetes Package Manager | [Helm](https://helm.sh/docs/intro/using_helm/) |
| Skaffold Kubernetes Develop/Deploy Tool | [Skaffold](https://skaffold.dev/docs/workflows/) |
| Vagrant virtual machine workflow automation | [Vagrant](https://gist.github.com/wpscholar/a49594e2e2b918f4d0c4) |
   







<hr>


Its time to head over to the code and documentation for the individual components! Or, if you want to deploy everything and see how the whole example works, head over to our [quickstart with Vagrant](./quickstart-vagrant.md).

## Glossary

| Term | Description | Link/further Reading |
| --- | --- | ---- |
| Django | Python-based free and open-source web framework | [Official Django documentation](https://www.djangoproject.com/), [Example To-do API backend written in Django](../code/app-code/api/To-do-python-django/) |
| Helm | A package manager for Kubernetes | [Official Helm documentation](https://helm.sh/), [Example of a Helm chart in this repository](../code/app-code/api/To-do-python-django/kubecode/bigbitbus-dj-py-api/) |
| Kubernetes | An open-source container-orchestration system for automating computer application deployment, scaling, and management | [Kubernetes](https://kubernetes.io/) |
| Microk8s | A lightweight, production-ready Kubernetes distribution | [Microk8s](https://microk8s.io/) |
| PostgresSQL | An open-source relational database management system | [PostgreSQL](https://www.postgresql.org/), [Example Postgres setup in Kubernetes](../code/k8s-common-code/postgres-db/) |
| Prometheus and Grafana | Time series database and metrics querying system and UI | [Official Prometheus documentation](https://prometheus.io/), [Example Prometheus stack setup](../code/k8s-common-code/monitoring/) |
| Skaffold | A build and deploy tool for Kubernetes | [Official Skaffold documentation](https://skaffold.dev/), [Example of a Skaffold definition file in yaml](../code/app-code/api/To-do-python-django/skaffold.yml) |
| Vue |   An open-source front end JavaScript framework for building user interfaces and single-page applications |  [Official Vue documentation](https://vuejs.org/), [Example To-do frontend written in Vue](../code/app-code/frontend/To-do-vuejs/) |
