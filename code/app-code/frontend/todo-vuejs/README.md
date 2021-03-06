# Vuejs Todo Frontend

The Vuejs todo implements the front-end for a to-do list using [Vuejs](https://vuejs.org/). Vue.js is an open-source Javascript framework that focuses on building UIs. It incorporates the reactive aspect of web design in which connects the Javascript to the HTML component of the code. If data change happens within the Javascript component, the UI (HTML/CSS) would automatically re-render.


## Notable Code

This is a table of notable links to code in this repository as well as external links in case you wish to learn about these topics.
| Category | File or Directory  | Description | Notes and External Links |
|---|---|---|---|
| Vue code | [src/App.vue](src/App.vue) |  Core Vuejs code. Here we see the basic HTML/CSS components stored within `<template>` tags and the Javascript component stored within the `<script>` tags.   |  Learn more about [Vuejs](https://vuejs.org/) |
| Docker | [Dockerfile](Dockerfile)  | Docker file to create docker image.   | Get started with [Docker](https://docs.docker.com/get-started/) |
| Kubernetes | [kubecode/bigbitbus-vue-fe/](kubecode/bigbitbus-vue-fe/) | A custom Helm chart to deploy application into a Kubernetes cluster | [Helm](https://helm.sh/docs/topics/charts/), a software packaging system for Kubernetes |
| Kubernetes | [kubecode/bigbitbus-vue-fe/values.yaml](kubecode/bigbitbus-vue-fe/values.yaml) | The values file is a method to set parameters in the Vue frontend application Helm chart, for example the replica count | More about Helm [values](https://helm.sh/docs/chart_template_guide/values_files/) |
| Skaffold | [skaffold.yml](skaffold.yaml) | This Skaffold file contains instructions on how to deploy the application into Kubernetes | [Skaffold](https://skaffold.dev/) handles the workflow for building, pushing and deploying your application |



## Installation

We assume you have access to a reasonable local computer with a broadband internet connection capable of downloading multiple gigabytes of data (mostly for Docker images).
### Pre-requisite Software


1. [Install Docker](https://docs.docker.com/get-docker/) and [Docker-compose](https://docs.docker.com/compose/install/) on your computer.
2. [Install Kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/), the Kubernetes command line interface client, on your computer.
3. [Install Helm](https://helm.sh/docs/intro/install/) package manager client on your computer (version 3 or greater).
4. [Install Skaffold](https://skaffold.dev/docs/install/) on your computer.

For this frontend to work you will need the [backend todo API](../../api/todo-python-django/) server to be available for this code to function. You will need to set the correct backend server and port in the [.env](./.env) file there for the `VUE_APP_DJANGO_ENDPOINT` environment variable.

### Development on your Local PC
Developers may want to iterate through their code as they develop software on their local PC.

For this frontend to work we need the API server to be online and listening at port 80. This [document](../../../app-code/api/todo-python-django/) describes running the django API on the local PC directly or inside a docker container via docker-compose. Make a note of the API endpoint (e.g. localhost:8000), and export it in your terminal like so

```
export VUE_APP_DJANGO_ENDPOINT=localhost:8000
```
or, you can edit this in the `.env` file present in this directory.

Next, you can run

```
npm install
npm run serve
```

Then access the frontend at [http://localhost:8080/frontend/](http://localhost:8080/frontend/)


### Run in Kubernetes

You first need to follow the steps in [this document](../../../app-code/api/todo-python-django/) to get Kubernetes and the Django API running.

Next, install the Vuejs helm chart, like so:

```bash
kubectl create namespace fe
cd kubernetes-automation-toolkit/code/app-code/frontend/todo-vuejs/  # this directory
# For microk8s
skaffold run --default-repo localhost:32000


You can always make code changes to the frontend and then run the skaffold `run` command again to deploy the changes into the Kubernetes cluster. Learn more about other [skaffold developer and operations workflows](https://skaffold.dev/docs/workflows/).

**Side note:** If you are looking to create a Helm chart for your own project we recommend starting from the boiler-plate code generated by [`helm create`](https://helm.sh/docs/helm/helm_create/). This command will create a basic layout that you can then adapt to your application.

## Pitfalls, Common Mistakes
1. Is your [.env](./.env) file's `VUE_APP_DJANGO_ENDPOINT` variable pointing to the correct Django todo API server? Point your browser at http://host:[port]/djangoapi/apis/v1/ and check if you can browse the API, add a todo item, list items etc.



## Clean-up

You can "delete" any Helm chart from the cluster:

```
# Get a list of installed helm charts in all namespaces
helm ls --all-namespaces

# Delete the frontend todo API
helm delete fe --namespace fe

## Further Reading

* The CSS used in this implementation is based on [this project](https://github.com/Klerith/TODO-CSS-Template)

## Contributors

* Sachin Agarwal <sachin@bigbitbus.com>
* Simon Yan <simon@bigbitbus.com>

