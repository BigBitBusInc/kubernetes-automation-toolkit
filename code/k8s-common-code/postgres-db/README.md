# Postgres Helm Installation

We use the single-pod [Bitnami Postgresql Helm Chart](https://github.com/bitnami/charts/tree/master/bitnami/postgresql) to install a Postgres database. the `pg-values.yaml` file contains several configurable parameters for the Helm chart, you can read the comments in the file or look at [this documentation](https://github.com/bitnami/charts/blob/master/bitnami/postgresql/README.md) for the details of the options. The `pg-values.yaml` file sets up a database, user, and the password for accessing the database. 

Once you are satisfied with the values, install the Helm chart, like so:

```bash
cd bigbitbus-kat-main/code/k8s-common-code/postgres-db # This directory 
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update
# For microk8s
helm upgrade --install pgdb bitnami/postgresql -f pg-values.yaml --namespace pg --create-namespace 

# OR, for minikube
helm upgrade --install pgdb bitnami/postgresql -f pg-values.yaml --namespace pg --create-namespace --set persistence.storageClass="standard"
```
## Cleanup 
```
# Delete the Postgres database
helm delete pgdb --namespace pg

```

Deleting the Postgres database Helm chart does not delete the persistent volume (storage). To remove the storage permanently:

```
kubectl -n pg get pvc
kubectl -n pg delete pvc <pvc-name-from-above-command>

# Delete the namespace if you wish
kubectl delete namespace pg
```