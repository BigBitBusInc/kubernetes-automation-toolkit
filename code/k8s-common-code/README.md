This directory contains code to install some of the common supporting elements needed to run the BigBitBus KAT example. Here is a list of sub-directories along with what they contain.

| Name         | Description                                                                                                                                      |
| ------------ | ------------------------------------------------------------------------------------------------------------------------------------------------ |
| [k8sdashboard](k8sdashboard/) | Helm values file and instructions on how to install the Kubernetes dashboard via its standard Helm chart                                         |
| [monitoring](monitoring/)   | Helm values file and instuctions on how to install the Prometheus operator, which also installs Grafana via the Prometheus operator's Helm chart |
| [postgres-db](postgres-db/)  | Helm values file and instructions on how to install Postgres database via its Helm chart. This is a pre-requisite for the Django API server. |                                                        |
| [locust-loadgen-api](locust-loadgen-api/)  | Helm chart for starting up a Locust.io load generator cluster to load-test the todo API. |      

**We assume that `helm` is installed and `kubectl` is configured to connect to the cluster into which we want to install these components.**


## Note about the Locust API Load Generator

[Locust API load generator](./locust-loadgen-api): A helm chart that will install the [Locust load generator](https://locust.io/) that can send requests to the todo api. Look at the [Values file](./locust-loadgen-api/values.yaml), the [locust file](./locust-loadgen-api/tasks/locustfile.py) as well as [Locust documentation](https://docs.locust.io/en/stable/).


Note we don't install the Locust helm chart by default via our [installation scripts](../../local-kubernetes-cluster-installation). In order to install the load generator, adjust the [Values file](./locust-loadgen-api/values.yaml) and then install it via Helm in a separate namespace, like so:

```
kubectl create ns locust
helm -n locust install locust ./locust-loadgen-api -f ./locust-loadgen-api/values.yaml
```

Then you need to find the locust master pod-name and port-forward it so you can get access to the Locust GUI (See [this documentation](https://kubernetes.io/docs/tasks/access-application-cluster/port-forward-access-application-cluster/) on port-forwarding).

After you have forwarded the port 8089 to your PC you can access the Locust GUI at `http://localhost:8089` and run a load-generator. You may want to experiment with more number of Locust worker nodes (as set in the [Values file](./locust-loadgen-api/values.yaml)) if you want to generate more load. Read the [Locust documentation](https://docs.locust.io/en/stable/) to learn more.
