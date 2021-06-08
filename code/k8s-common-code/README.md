This directory contains code to install some of the common supporting elements needed to run the BigBitBus KAT example. Here is a list of sub-directories along with what they contain.

| Name         | Description                                                                                                                                      |
| ------------ | ------------------------------------------------------------------------------------------------------------------------------------------------ |
| [k8sdashboard](k8sdashboard/) | Helm values file and instructions on how to install the Kubernetes dashboard via its standard Helm chart                                         |
| [monitoring](monitoring/)   | Helm values file and instuctions on how to install the Prometheus operator, which also installs Grafana via the Prometheus operator's Helm chart |
| [postgres-db](postgres-db/)  | Helm values file and instructions on how to install Postgres database via its Helm chart. This is a pre-requisite for the Django API server. |                                                        |
| [locust-loadgen-api](locust-loadgen-api/)  | Helm chart for starting up a Locust.io load generator cluster to load-test the todo API. |      

**We assume that `helm` is installed and `kubectl` is configured to connect to the cluster into which we want to install these components.**
