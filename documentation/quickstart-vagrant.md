# Quickstart with Vagrant on your PC

Follow these steps to quickly deploy the KAT example. You will need a PC with at least 4 cores and 8 GB of RAM  to run KAT locally in a VM that [Hashicorp's Vagrant](https://www.vagrantup.com/downloads) will setup on your PC; if you don't have such a machine then please  use a cloud provider to rent a VM. We provide instructions for this alternative approach [here](./cloudvm.md).

1. Clone this repository: `git clone https://github.com/BigBitBusInc/kubernetes-automation-toolkit.git`

2. Install `Vagrant` for your OS (Vagrant supports Windows, Linux and MacOS); you may also need to install the hypervisor software and a vagrant plugin for this hypervisor on your platform; you should also find this information on the Vagrant installation page for your OS. [Follow guidelines](../documentation/vagrant-setup.md) to setup Vagrant on your respective OS. [This link](https://gist.github.com/wpscholar/a49594e2e2b918f4d0c4) lists some useful Vagrant commands.

3. Navigate to the root directory of the KAT repository and enter this command in a terminal
```bash
cd kubernetes-automation-toolkit
vagrant up
```

Please be patient, even on a fast Internet connection remember we are downloading and installing over 2GB of OS, Kubernetes, docker images etc. Vagrant's output will include the `kubeconfig` for the Kubernetes cluster created within the VM, you can use the security token in this output to connect to the [Kubernetes dashboard](../k8s-common-code/k8sdashboard/).

3.   You can now open a web-browser and reach these end-points
  - Todo application Vuejs Frontend [http://localhost:8080/frontend/](http://localhost:8080/frontend/) [Learn more](../code/app-code/frontend/todo-vuejs/)
  - Todo application browsable API [http://localhost:8080/djangoapi/api/v1/](http://localhost:8080/djangoapi/api/v1) [Learn more](../code/app-code/api/todo-python-django/)
  - Kubernetes Dashboard [http://localhost:8080/dashboard/](http://localhost:8080/dashboard/) [Learn more](../code/k8s-common-code/k8sdashboard/) (Access token is printed in the Vagrant output as mentioned above).
  - Grafana Monitoring [http://localhost:8080/monitoring-grafana/](http://localhost:8080/monitoring-grafana/) [Learn more](../code/k8s-common-code/monitoring/) (default credentials: admin/promoperator)


4. Get the ssh-configuration snippet for your Vagrant VM and add it to your `~/.ssh/config` file; these commands will do this:
```bash
#For Linux, Mac you could run
vagrant ssh-config >> ~/.ssh/config

# For Windows
vagrant ssh-config >> ~\.ssh\config
```
Confirm that you can now log into the Vagrant VM by simply typing `vagrant ssh` on the commandline while in the same directory as the Vagrantfile that created the VM - in our case this is the root directory of the KAT repository.

5. Once you are logged into the VM there are many things to do
  - Launch [k9s from the terminal](https://k9scli.io/) and surf your Kubernetes cluster and all its objects.
  - If you prefer using the official Kubernetes CLI  then  read the `kubectl` cheat-sheet [here](https://kubernetes.io/docs/reference/kubectl/cheatsheet/).

6. Head over to our [documentation](./README.md) to learn the concepts and start understanding the code behind the components..


***The next steps are optional but very useful if you are planning to get productive as a developer***

7.  We assume you use the [Microsoft VS Code Editor](https://code.visualstudio.com/Download) in this tutorial, please install the [Remote - SSH plugin](https://code.visualstudio.com/docs/remote/ssh). This will allow us to browse and control the Vagrant VM via SSH.

8. Open VS Code and configure it to connect remotely to the Vagrant VM. Load up the KAT code in the home directory of the Vagrant user. Tweak it, break it, fix it and choose whether this way of development will work for you!

### Pitfalls and Troubleshooting
  1. If you run `vagrant suspend` and then `vagrant reload` between putting your PC to sleep then you may find that Microk8s does not start within the VM. Log into the VM and type `microk8s start` to get back on track.
  2. You can also setup port-forwarding using ssh; along the lines of 
   ```bash
   ssh vagrant-vm-name-in-ssh-config -L 8080:localhost:80 -N
   ```
   
   For Windows you can look at some of the screenshots in [this file](windows-setup.md) to get an idea of how to set ssh port-forwarding  with [Putty](https://www.putty.org/).


Here are links to some useful documentation of different tools that are used in the KAT example.

| Tool | Useful Documentation |
| ---- | ---------- |
| Microk8s Kubernetes Cluster | [Microk8s](https://microk8s.io/docs/commands) |
| Kubectl Kubernetes Command Line Tool | [Kubectl](https://kubernetes.io/docs/reference/kubectl/cheatsheet/) |
| K9s Terminal Based Kubernetes UI | [k9s](https://k9scli.io/) |
| Helm Kubernetes Package Manager | [Helm](https://helm.sh/docs/intro/using_helm/) |
| Skaffold Kubernetes Develop/Deploy Tool | [Skaffold](https://skaffold.dev/docs/workflows/) |
| Vagrant virtual machine workflow automation | [Vagrant](https://gist.github.com/wpscholar/a49594e2e2b918f4d0c4) |
   

   
   
## Cleanup

To destroy the Vagrant VM, open a terminal and go to the kubernetes-automation-toolkit (root directory of the git repository where the Vagrantfile lives) and simply type

```
vagrant destroy
```
