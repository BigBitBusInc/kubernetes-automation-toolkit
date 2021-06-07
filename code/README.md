# What is in Here?

  1. [app-code](./app-code): Application code for the API and frontend, currently Python Django and Vuejs respectively; Helm charts to deploy these components is included with this application code.
  
  2. [k8s-common-code](./k8s-common-code): Kubernetes manifests to deploy the Kubernetes dashboard, Prometheus/Grafana monitoring and the Postgres database.
  
  3. [local-kubernetes-cluster-installation](./local-kubernetes-cluster-installation): Scripts to install the entire KAT example.

  4. [Locust API load generator](./locust-loadgen-api): A helm chart that will install the [Locust load generator](https://locust.io/) that can send requests to the todo api. Look at the [Values file](./locust-loadgen-api/values.yaml), the [locust file](./locust-loadgen-api/tasks/locustfile.py) as well as [Locust documentation](https://docs.locust.io/en/stable/).

## Locust API Load Generator

Note we don't install the Locust helm chart be default. In order to install it, adjust the [Values file](./locust-loadgen-api/values.yaml) and then install it via Helm in a separate namespace.

```
kubectl create ns locust
helm -n locust install locust ./locust-loadgen-api -f ./locust-loadgen-api/values.yaml
```

Then you need to find the locust master pod-name and port-forward it so you can get access to the Locust GUI (See [this documentation](https://kubernetes.io/docs/tasks/access-application-cluster/port-forward-access-application-cluster/) on port-forwarding).

After you have forwarded the port 8089 to your PC you can access the Locust GUI at `http://localhost:8089` and run a load-generator. You may want to experiment with more number of Locust worker nodes (as set in the [Values file](./locust-loadgen-api/values.yaml)) if you want to generate more load. Read the [Locust documentation](https://docs.locust.io/en/stable/) to learn more.