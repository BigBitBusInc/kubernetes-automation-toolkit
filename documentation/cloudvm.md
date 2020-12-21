# Using a Cloud Virtual Machine

If you have access to a cloud provider or if you can sign up for one then its very straightforward to create a Ubuntu Linux virtual machine with a ssh server and public IP.

We will leave it to you to get a VM in the cloud provider of your choice with these features:

  1. A VM with at least 2 cores CPU and 4GB of RAM
  2. Ubuntu Linux 20.04 Focal operating system and a username/SSH private key to log into the VM.
  3. Openssh server running on the VM
  4. A public IP with firewall access to port 22 (SSH)

If you prefer running the VM on your own PC, read about the [Vagrant option](./quickstart-vagrant.md).

## Installation
1. Log into the VM and run these commands (as root):

```bash
RELEASENAME="main"
date
echo "Installing $RELEASENAME BitBitBus KAT into VM, install logs available at /var/log/"
echo "Step 1: Microk8s and infrastructure components"
curl -L -s https://raw.githubusercontent.com/BigBitBusInc/kubernetes-automation-toolkit/$RELEASENAME/code/local-kubernetes-cluster-installation/install-microk8s-on-ubuntu.sh | bash | tee /var/log/bigbitbus-microk8s-install.log
echo "Step 2: Application code"
curl -L -s https://raw.githubusercontent.com/BigBitBusInc/kubernetes-automation-toolkit/$RELEASENAME/code/local-kubernetes-cluster-installation/install-application-stack.sh | bash -s $RELEASENAME | tee /var/log/bigbitbus-kat-application-code-install.log
echo "Kubeconfig (don't print/share this in production!)"
microk8s config
```

2. Logout and SSH port-forward localhost:8080 from your host into the VM's localhost:80.

For example (Mac, Linux) 
```
ssh -i private_key_file theuser@publicip -L 8080:localhost:80 -N
```

For Windows, see [this file](windows-setup.md) on how to setup Putty for port forwarding.

 You can now open a web-browser and reach these end-points
  - Todo application Vuejs Frontend [http://localhost:8080/frontend/](http://localhost:8080/frontend/)
  - Todo application browsable API [http://localhost:8080/djangoapi/api/v1](http://localhost:8080/djangoapi/api/v1)
  - Kubernetes Dashboard [http://localhost:8080/dashboard/](http://localhost:8080/dashboard/)
  - Grafana Monitoring [http://localhost:8080/monitoring-grafana/](http://localhost:8080/monitoring-grafana/)


3. Get the ssh-configuration snippet for your cloud VM and add it to your `~/.ssh/config` file (learn more about ssh config files [here](https://linuxize.com/post/using-the-ssh-config-file/)).
   
Confirm that you can now log into the Vagrant VM by simply typing `ssh vmname-in-ssh-config` on the commandline.

4. Once you are logged into the VM there are many things to do
  - Launch [k9s from the terminal](https://k9scli.io/) and surf your Kubernetes cluster and all its objects.
  - If you prefer using the official Kubernetes CLI  then  read the `kubectl` cheat-sheet [here](https://kubernetes.io/docs/reference/kubectl/cheatsheet/).

5. Head over to our [documentation](./README.md) to learn the concepts and start understanding the code behind the components..

***The next steps are optional but very useful if you are planning to get productive as a developer***

6.  We assume you use the [Microsoft VS Code Editor](https://code.visualstudio.com/Download) in this tutorial, please install the [Remote - SSH plugin](https://code.visualstudio.com/docs/remote/ssh). This will allow us to browse and control the Vagrant VM via SSH.

7. Open VS Code and configure it to connect remotely to the Vagrant VM. Load up the KAT code in the home directory of the Vagrant user. Tweak it, break it, fix it and choose whether this way of development will work for you!


 