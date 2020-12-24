<center>
<img src="documentation/images/kubernetes-application.svg"  alt="BigBitBus KAT components" width="400"/>
</center>

**Components of the BigBitBus KAT application code. Click on the diagram to enlarge, or follow [this link](documentation/) for detailed documentation**

# Introduction

Welcome to the BigBitBus Kubernetes Automation Toolkit (KAT).

KAT is a set of software code and documentation to help understand the big picture of how a web application is developed for and deployed into a Kubernetes environment. We also provide a  few [Docker Compose](https://docs.docker.com/compose/) "alternatives" in our code directories so developers can compare and contrast a Docker workflow with a Kubernetes workflow. 

**TL;DR** If you want to directly deploy the KAT web application in a Kubernetes cluster on your PC, head over to our [quickstart](./documentation/quickstart-vagrant.md).

Most components of the Kubernates cloud native ecosystem are extremely well documented, but its hard to find end-to-end examples that illustrate how these components work together in the context of an application. The main idea is to show you the breadth of several cloud-native technologies working together to support an application deployed on Kubernetes. We provide links to high quality documentation for deep dives on the concepts our examples illustrate. Our examples will show you how it all comes together so you can get  productive, fast. You can then choose to learn more about specific parts of the cloud native stack as your situation demands.

From here, we recommend you start with a [review of some Kubernetes and related concepts](./documentation/) we have put together. Or, if you want to directly go to the code and examples you can navigate the folders in the repository, the table below will launch you right in.


# What is where?

| Category | File or Directory  | Description |
|---|---|---|
| Documentation | [documentation/README.md](./documentation/) | Start here for an overview and links to other documents |
| Todo Django API | [code/app-code/api/todo-python-django](code/app-code/api/todo-python-django) | Django Python todo backend; includes Helm chart deployed using Skaffold |
| Postgresql DB | [code/k8s-common-code/postgres-db](code/k8s-common-code/postgres-db) | Installing and configuring Postgresql database into the Kubernetes cluster using Helm charts |
| Vuejs Todo Single Page Application | [code/app-code/frontend/todo-vuejs](code/app-code/frontend/todo-vuejs) | Todo application implemented in Vuejs; includes Helm chart deployed using Skaffold |
| Monitoring | [code/k8s-common-code/monitoring](code/k8s-common-code/monitoring) |Installing and configuring monitoring with Prometheus and Grafana into the Kubernetes cluster using standard Helm charts created by the Prometheus community |
| Kubernetes Dashboard | [code/k8s-common-code/k8sdashboard](code/k8s-common-code/k8sdashboard) | Deploying the Kubernetes dashboard, a browser-based GUI view of the Kubernetes cluster |

# License

All code and configuration in the BigBitBus KAT repository (code files contained in this directory and all subdirectories) is licensed under the [Apache 2.0 License](http://www.apache.org/licenses/LICENSE-2.0).

All documentation, media and images in the BigBitBus KAT repository (non-code files contained in this directory and all subdirectories) are licensed under the [CC BY-NC License](https://creativecommons.org/licenses/by-nc/4.0/).

Please click the license links for details.





