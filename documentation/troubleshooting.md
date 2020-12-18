# Troubleshooting 

Things.Will.Break.

The bad news is Kubernetes and the associated cloud-native projects are incredibly complex systems. They are also very dynamic with quarterly releases and changing dependencies. Things can suddenly stop working without an apparent cause.

The good news is that there are a whole lot of resources to help you navigate the inevitable failures you can expect. Moreover, given the popularity of these systems, chances are that someone else has already encountered the bug or regression you are seeing and there is a publicly-readable resolution documented on the Internet.

The official Kubernetes documentation has some excellent [documentation](https://kubernetes.io/docs/tasks/debug-application-cluster/troubleshooting/) on troubleshooting. You may find though that your issue is not directly a Kubernetes issue, but instead a problem with an extension or even the way your code interacts with the system.

## Approaching the Problem

### 1. Identifying what is broken in your setup.

You may not have the knowledge to find the root cause of a failure or bug, but you will need to collect enough information about your situation to make an educated guess about where things are breaking. For Kubernetes there are two rich sources of information to start with:

  1. **Pod logs** 
   ```bash
   kubectl get pods [--namespace <ns-name>]
   # After you have identified which pod you think is broken
   kubectl logs <pod-name> [--namespace <ns-name>]
   ```
  2. **Describe Objects**
   ```bash
   kubectl describe pod <pod-name>  # the describe verb works for most Kubernetes object types - services, secrets, replica-sets, deployments etc.
   ```
  3. **Get everything in the cluster**
   ```bash
   kubectl get all --all-namespaces
   ```

Remember that the issue may not be limited to your application only - there may be problems with Kubernetes systems pods in the `kube-system` namespace for example.


### 2. Searching Forums for Solutions

There is a very good chance that others before you have encountered the issue you are facing. We find that even pasting relevant error log snippets into a search engine can yield useful discussions and resolutions to many problems. Github issues and Stack Overflow are great places to find disussions of many issues related to cloud native technology. We recommend spending enough time researching your issue because (1) You may just find the solution and fix your problem this way (2) asking questions without proper context and supporting information in forums can have long turn-arounds - if they are answered at all!. (3) You will save the precious time of community volunteers and helpers.

### 3. Finding the correct forum to post your question and findings

If everything else fails then you should take all the information you have gathered and try to engage the open-source community behind the component that you think is broken.

There are at least 3 places to look for help

1. The Github issues of the project where you feel the bug exists.
2. Some projects have slack channels where you **may** find people willing to help. For example, the main Kubernetes project's slack channel is https://slack.k8s.io/[https://slack.k8s.io/].
3. Stack overflow, Reddit groups etc.

Please spend a lot of time and effort describing your problem and pasting enough logs and context so people can help you quickly.

Also, make sure you close the issue once its resolved, along with a note on how you got things to work for your setup so others can benefit!

Here is an example of an issue we faced with Microk8s and how the [Github issue](https://github.com/ubuntu/microk8s/issues/1829) in that project helped us find a solution.


