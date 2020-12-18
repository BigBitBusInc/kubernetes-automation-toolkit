# Monitoring via Prometheus and Grafana

Observability in BigBitBus KAT is implemented using the Prometheus+Grafana stack. [Prometheus](https://prometheus.io/) collects metrics and also provides alerting capabilities. [Grafana](https://grafana.com/) is used for metric visualization dashboards.

The Prometheus open-source community has released the [kube-prometheus-stack helm chart](https://github.com/prometheus-community/helm-charts/tree/main/charts/kube-prometheus-stack), a collection of Kubernetes manifests, Grafana dashboards, and Prometheus rules combined with documentation and scripts to provide easy to operate end-to-end Kubernetes cluster monitoring with Prometheus using the Prometheus Operator.

Here are the commands to install the prometheus stack.

```bash
cd bigbitbus-kat-main/code/k8s-common-code/monitoring/ # This directory
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo add stable https://charts.helm.sh/stable
helm repo update
helm  upgrade --install monitoring-stack prometheus-community/kube-prometheus-stack -f ./prometheus-grafana-monitoring-stack-values.yaml --namespace monitoring --create-namespace 
```