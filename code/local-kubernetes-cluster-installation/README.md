# What is in Here

The bash scripts in this folder install Microk8s on an Ubuntu 20.04 server and then install the sample KAT application into the server.

You can execute these scripts on any Ubuntu 20.04 VM. These scripts are invoked in the [Vagrantfile](../../Vagrantfile) and the [Cloud VM installer](../../documentation/cloudvm.md).

If you already have a Kubernetes cluster, then only run the [install-application-stack.s](./install-application-stack.sh) (you may need to tweak it a bit for your Kubernetes setup).
