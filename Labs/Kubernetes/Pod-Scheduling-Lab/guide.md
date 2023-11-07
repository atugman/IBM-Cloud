Kubernetes Pod Scheduling: Labels, Taints, and Node Affinities
========

## Introduction

### Considerations & Prerequisites
- Kubernetes cluster with 3 worker nodes, each with 4x16 CPU/RAM
  - Other cluster configurations will work, although your precise results may differ
- kubectl access to the Kubernetes cluster, with the ability to deploy pods into the default namespace
  - Other namespaces could be used with minor modifications
- Consider using a basic test cluster dedicated to these exercises
  - By design, this lab will have an impact on the scheduling of pods in the cluster
- Basic terminal skills will be helpful, although not required

### Notes
- This guide was written on IBM Cloud Kubernetes Service (IKS), but will work with little to no modification regardless of where your cluster is hosted
- There's a simple terraform provided for IKS (link/directory structure below) that will spin up a cluster configured for these exercises, you'll just need an IBM Cloud API key

### File Structure

- Root directory: https://github.com/atugman/IBM-Cloud/tree/main/Labs/Kubernetes/Pod-Scheduling-Lab
- **guide.md** - lab instructions
  - > If you're reading this in the IBM Cloud communities, you can disregard guide.md as it's a mirror image of this blog.
- Pod and Deployment Manifests
  - ```/affinity_exercises``` - with-affinity.yaml, without-affinity.yaml
  - ```/taints_exercises``` - pod1.yaml, pod2.yaml, pod3.yaml
- ```/terraform/main.tf``` - a simple terraform for an IKS cluster
- ```pull_pod_status.py``` - Python program that we'll use to expedite troubleshooting

You can use ```git clone``` to copy the full repository to your local machine. The repo contains various other lab files. After cloning, feel free to remove the excess files with a few simple commands similar to:

```
git clone https://github.com/atugman/IBM-Cloud.git
cp -r ./IBM-Cloud/Labs/Kubernetes/Pod-Scheduling-Lab .
rm -r ./IBM-Cloud
```

Or, instead of the last line above, remove the originally cloned repo for your machine manually.

## Labels and Taints

### Validate your Node Labels

If you used the provided terraform to create your IKS cluster, your nodes will already be labeled properly for these exercises.

If you did *not* use to the terraform, let's quickly label your nodes. First, use ```kubectl get nodes``` to identify the names of the 3 nodes you'll be using for these exercises. Then, run the following commands, supplying your node names where indicated below.

```
kubectl label nodes <your-first-node-name> label1=value1
kubectl label nodes <your-second-node-name> label2=value2
kubectl label nodes <your-third-node-name> label3=value3
```

Now, whether you used the terraform or not, you can run the following commands to validate your labels. Each command should output a single, unique node. Your first node will be labeled ```label1:value1```, and so on.

```
kubectl get nodes -l label1
kubectl get nodes -l label2
kubectl get nodes -l label3
```

Optionally, you can use ```kubectl describe node <node-name>``` to explore the labels (and many other details) of each node.

Let's define a few environmental variables to simplify the ensuing exercises. Run the following commands, supplying your node names:

```
export node1=name_of_node_1
export node2=name_of_node_2
export node3=name_of_node_3
```

Run the following commands to validate each of your environmental variables contains the correct node name.

```
echo $node1
echo $node2
echo $node3
```

For example, the output of ```echo $node1``` should match the value of the "NAME" listed as output of ```kubectl get nodes -l label1```, and likewise for for the second and third nodes.

> Remember: **Make sure you're working in a test cluster,** particularly if you're a bit new to these concepts! Several of the exercises throughout this guide could have an impact on other pods in the cluster, so it's important to make sure this cluster (or *minimally* these 3 nodes) are not slated to host any important applications.

### Deploy Pods with Node Selectors

Now we're ready to get started! Let's deploy a few pods, each with a unique node selector. Take a moment to review the contents of the 3 .yaml files in the /taints_exercises directory. Each file is nearly identical, with the exception of the last two lines (excluding the comments in pod2.yaml). Our 3 pods are designed to run on our 3 nodes, one pod per node.

Deploy all three pods by running the following commands from your terminal. These commands assume you're currently in the root directory of the project (./Pod-Scheduling-Lab).

```
cd taints_exercises
kubectl apply -f .
```

You should quickly see the output:

```
pod/pod1 created
pod/pod2 created
pod/pod3 created
```

Run the following command to learn more about our pods, including which node they've been scheduled to:

```
kubectl get pods -o wide
```

Each pod should have a unique node listed, indicating each one abided by our node selectors and is running on the requested node.

### Taint Your Nodes

Taint your nodes with the following commands, supplying the names of your second and third nodes. Remember, your second node has the label ```label2:value2``` and your third node should have the label ```label3:value3```. You can rerun these commands as needed to recall which nodes is which: ```kubectl get nodes -l label2``` and ```kubectl get nodes -l label3```. In short, taints are designed to *repel* pods. We'll continue discussing taints further throughout these exercises.

*Taint your nodes:*
```
kubectl taint nodes <node2> taint1=taint_value_1:NoExecute
kubectl taint nodes <node3> taint2=taint_value_2:NoSchedule
```

Rerun the following command, and observe the output:

```
kubectl get pods -o wide
```

How many pods are still running out of the original 3? Let's discuss an important distinction between the two commands that we just ran.

> Notice the ```NoSchedule``` at the end of the second command (that we ran against node3). If we were to deploy pod3 now, it would not have been scheduled to node3, despite the node selector matching the node label. This is the core functionality of a taint - to repel pods, regardless of other circumstances (generally speaking). However, pod3 is *still* running on node3 despite the node taint.
> Now, notice the ```NoExecute``` at the end of the first command (ran against node2). This option is still designed to repel pods, but also **evicts** any pods on the node that don't tolerate the node taint. For this reason, you should still see pod1 and pod3 running in the cluster, but not pod2, as it was evicted (and will now be repelled if we try to redeploy the pod as-is).

So, what are our options to schedule pods to these tainted nodes? How can we use these nodes effectively knowing they are tainted? Let's start with the first question to better understand taints.

Since pod2 has already been evicted, let's start by redeploying it without changing any of its configurations.

```
kubectl apply -f pod2.yaml
```

Now, pod2 should be in a pending state. We'll investigate this further momentarily. For the sake of the exercise, let's go ahead and manually delete and redeploy pod3. This is our version of evicting the pod and testing to see if it will deploy to node3 after applying the node taint.

```
kubectl delete -f pod3.yaml
kubectl apply -f pod3.yaml
```

As described above, pod3 should now also be in a pending state. Let's investigate both pod2 and pod3 now.

### Troubleshooting Your Pods

Your best friend in troubleshooting pods and deployments is the ```kubectl describe``` command.

Now, in this exercise, it would be perfectly suitable to run ```kubectl describe pod pod2``` and ```kubectl describe pod pod3```, two simple commands providing us with the information that we need to understand why our pods have not been scheduled.

However, over time, and with a larger volume of pods, it'll likely make sense to find a more programmatic troubleshooting method. Let's explore a simple technique for this now, using Python's ```kubernetes``` software package.

### Troubleshooting Pending Pods with Python

From your terminal, run the following command (unless you already have the Python ```kubernetes``` package installed):

```pip install kubernetes```

Take a moment to explore the contents of the ```pull_pod_status.py``` file, located in the root directory.

```python
from kubernetes import client, config

def get_pending_pods():
    try:
        config.load_kube_config()

        v1 = client.CoreV1Api()
        response = v1.list_namespaced_pod(namespace="default", watch=False)
        
        for pod in response.items:
            if pod.status.phase == "Pending":

                print("\nPod:",pod.metadata.name,"\n",
                      "- Namespace:",pod.metadata.namespace,"\n",
                      "- Status:",pod.status.phase,"\n",
                      "- Reason:",pod.status.conditions[0].reason,"\n",
                      "- Message:",pod.status.conditions[0].message)

    except Exception as e:
        print("Error:", e)

if __name__ == "__main__":
    get_pending_pods()
```

The program is actually quite simple. After importing the kubernetes library, the program calls a function named get_pending_pods, that does exactly that. Our Python program loads our kubeconfig file, pulls information about our cluster, then calls the Kubernetes API of our cluster. It pulls information about all pods in the ```default``` namespace, then iterates over each pod, checking for pods in a pending state. It then prints relevant information about each pod, including some helpful troubleshooting information, to the console.

Let's execute our Python program by running the following commands from our root directory. 

Use ```cd ..``` to move up one level in your directory (back to the root), then run:

```python pull_pod_status.py```

> Note: depending on your local Python installation, it may be helpful to run ```python3 pull_pod_status.py```.

> Some tips if you run into any issues relating to the program not locating the ```kubernetes``` package:
> - Check for any error messages from the install command
> - Quit and relaunch your terminal
> - Otherwise, open a local editor, such as VS Code, and make sure you're using the proper Python interpreter
> For any further issues, as discussed previously, feel free to run ```kubectl describe pod pod2``` and ```kubectl describe pod pod3``` as an alternative to running the Python program.

The output of the program should have yielded a message similar to the block below, with information on both pod2 and pod3 (I've trimmed mine below only to show pod2).

```
Pod: pod2 
 - Namespace: default 
 - Status: Pending 
 - Reason: Unschedulable 
 - Message: 0/3 nodes are available: 1 node(s) didn't match Pod's node affinity/selector, 1 node(s) had untolerated taint {taint1: taint_value_1}, 1 node(s) had untolerated taint {taint2: taint_value_2}. preemption: 0/3 nodes are available: 3 Preemption is not helpful for scheduling..
```

The 'message' for both pods should be identical. At the moment, they're in the same situation: node1 does not match either pods' node selector, and the other two nodes are tainted. Neither pod tolerates either node taint.

Even though the issue for both pods is exactly the same, let's evaluate two separate methods to fix the issue and allow the Kubernetes scheduler to schedule the pods.

### Remediating Pending Pods via Tolerations

We know that pod2 cannot be scheduled to node2 because of the node taint. We also know that the labels of node2 *do* match the node selector of pod2. Now, we know this because we're in a lab exercise. Typically there'd be a few more steps involved, namely tracking down the nodes with the node taints, and validating their node labels.

But for now, let's focus on fixing the issue via tolerations. Recall that node taints are designed to *repel* pods, which is why our pods are in a pending state. If we want our node taint to repel all pods *with the exception of* certain pods, we can add a toleration to our pod spec.

Remove the comments from ```pod2.yaml```, and save the file. Take note of the toleration we've now added to the pod spec.

Rerun ```kubectl apply -f pod2.yaml``` from your terminal (make sure you're back in the ```taints_exercises``` folder, or supply a relative path in the command).

After you see the ```pod/pod2 configured``` message, rerun ```kubectl get pods -o wide```, and pod2 should now be running on node2.

Tolerations are a great way to make sure specific pods can run on our tainted nodes. Now, for pod3, let's see what happens when we remove the node taint from node3, knowing that our node labels and selectors match.

Run the following command to remove the taint from node3 (be sure to include the "-" at the end).

```
kubectl taint nodes $node3 taint2=taint_value_2:NoSchedule-
```

After one last ```kubectl get pods -o wide``` command, you'll find that pod3 is running on node3.

Now, before we move on, if you're wondering: "why should *removing* a taint be considered a valid 'troubleshooting' approach to enabling our pending pods to be scheduled?" then you're not crazy. If it seems a bit counterintuitive, it is. Sure, removing the node taint resolves the issue. By why taint the node in the first place then, right? Correct. I've noticed many cases with teams in the past overusing node taints actually becomes a bit more confusing and cumbersome. So my proposed "troubleshooting" technique of removing the node taint actually points to the need to rethink our pod scheduling strategy altogether. Perhaps there is a better solution for scheduling pods to the appropriate nodes! Let's explore this further in the next section.

Before we move onto the next set of exercises, let's remove the taint from node2 and delete the pods used in this exercise by running the following commands from the root directory: 

```
kubectl taint nodes $node2 taint1=taint_value_1:NoExecute-
kubectl delete -f ./taints_exercises/.
```

## Node Affinity

Let's take a look at another approach to scheduling pods in Kubernetes: node affinities.

Let's start by reviewing the ```without-affinity.yaml``` file in the ```/affinity_exercises``` directory. You may notice that this file is pretty similar to our pod manifests from the previous exercise, with a few alterations. 
- ```without-affinity.yaml``` is a deployment manifest, with 8 pod replicas. 
- Therefore, in this example, instead of scheduling 3 pods to 3 nodes, we're looking to schedule all 8 pods of our deployment to node2, since it matches the node selector label declared in the pod template of our deployment spec (line 16): ```label2: value2```
- Lastly, note that each of our 8 pods will be requesting .4 vCPU, and 1 GB of RAM.

Let's first create this deployment using node selectors, just like the previous exercise. Run the following command from the ```/affinity_exercises``` directory to create the deployment:

```
kubectl apply -f without-affinity.yaml
```

Then run our handy command to retrieve information about our newly deployed pods:

```
kubectl get pods -o wide
```

How many of our pods (whose names start with ```without-affinity-*```) are running on node2? You should see 5 of these pods running on node2, although the exact number may differ slightly depending on your cluster (more on this below). If for some reason you don't see any pending pods, increase the replica count in without-affinity.yaml and reconfigure the deployment (run ```kubectl apply -f without-affinity.yaml``` again).

Let's ask our friendly Python program for more information about our the pending pods. Remember that, due to some hardcoding, it will pull information about all pending pods in the default namespace. Run the following command (with the leading ```../``` assuming you're still in the ```/affinity_exercises``` directory).

```python ../pull_pod_status.py```

> Note: the Python program can easily be updated to pull information about pods in other states, pods in other namespaces, or pretty much any other information you'd like to pull from the cluster.

For each pod in a pending state, you should see a message similar to:

```
 - Message: 0/3 nodes are available: 1 Insufficient cpu, 2 node(s) didn't match Pod's node affinity/selector. preemption: 0/3 nodes are available: 1 No preemption victims found for incoming pod, 2 Preemption is not helpful for scheduling..
```

The rationale behind the note: "*2 node(s) didn't match Pod's node affinity/selector*" is similar to the previous exercises - neither node1 nor node3 match our node selectors.

But the part of the message unique to this exercise is: "**1 Insufficient cpu**," meaning node2 does not have enough cpu to run the pod in question.

Recall that each of our nodes have 4x16 CPU/RAM, but we must keep in mind *allocatable resources.* Simply put, nodes in a Kubernetes cluster cannot allocate all resources (4x16 CPU/RAM in this case) solely to pods. Allocatable resources refer to the amount of CPU/RAM left for pods after system resources. The amount of allocatable CPU on your node may differ slightly based on a number of factors, which is why you may see more or less than 5 running pods.

Ultimately, node2 should not be able to accommodate all pods in the deployment at this stage.

We're likely not thinking of all of this as we're writing our pod specs. We're thinking about our application and the resources it needs. We've probably run some extensive testing on our application and know what it needs and how it performs. And perhaps we know that our application will perform better on node2 (or other nodes in the cluster that also match our node selector) as higher performing nodes with the latest processors are labeled as such (in this fictitious scenario).

In most common use cases, leaving 3 of 8 pods in a pending state is not ideal. This could leave our application in an underperforming state. So what options do we have?

One option is to spin up another node that matches our node selector, or replace node2 with a larger node. But maybe our operations team isn't able to accommodate these requests at the moment - let's suppose this isn't a production application where we could justify the additional compute resources. Let's say we're rigorously developing and testing a new application, and our application and software tests run in our Kubernetes cluster.

We know that neither of the other two nodes are tainted, so there's no need to add a toleration to enable our pods to run on those nodes. 

We can't simply add an additional node selector label. Let's assume for a moment that we tried this, and that our new spec looked like this (trimmed below):

```yaml
    spec:
      nodeSelector:
        label2: value2
        label3: value3 # <-- Added label for node3
```

You're welcome to give this a try yourself as well - feel free to add this line to ```without-affinity.yaml``` and redeploy to observe the results.

In this scenario, there would have to be a node in the cluster with *both* labels in order for the Kubernetes scheduler to schedule the pod. We know that that isn't the case in our test cluster, so this isn't an option either.

And lastly, simply changing out one label for another isn't an option, as we know our application runs best on nodes with the label ```label2: value2```.

Node affinity is a fantastic approach that I've seen a number of teams use in the past, and it accommodates this exact use case: ensuring sure all 8 pods get scheduled without making any changes to the infrastructure (given we have insufficient infrastructure to run our application exactly how we'd like to at the moment). After all, maybe our application testing suite takes slightly longer to run on node1 and node3 because they don't have the latest generation of processors, but we're eager to get to market with our new product and we need the tests to run right away.

So how can we configure our deployment to *preferably* run on node2, but run on *other nodes* in the cluster as needed? Node affinities provide this exact flexibility. Instead of the rigid node selectors we've used up to this point - the functionality that required pod1 to run on node1 (and so on), and the functionality that required our latest deployment (without-affinity.yaml) to run on node2 - node affinities will allow us to define our preference of node labels while affording our pods the flexibility to run on other nodes if there aren't any other options.

Let's delete the previous deployment, and deploy ```with-affinity.yaml```. From ```/affinity_exercises```, run:

```
kubectl delete -f without-affinity.yaml
kubectl apply -f with-affinity.yaml
```

One last time, let's run our favorite command:

```
kubectl get pods -o wide
```

How many pods are in a pending state now? 

How many pods are running on node2 vs node1 and node3?

You should see all 8 pods running, and likely 5 of them running on node2! Our application is as happy as it can be under the given circumstances - all pods in our deployment are running, and as many as possible are running on our highest performing node, node2!

## Conclusion & Cleanup

At your leisure, run the following command to delete the deployment:

```
kubectl apply -f with-affinity.yaml
```

If you used the provided terraform to create an IKS cluster, and the IKS cluster was used solely by you for this exercise, you can run the following command to destroy the cluster:

```
terraform destroy
```

If you didn't destroy your cluster and plan on keeping these 3 worker nodes around for other purposes, I'll assume you'd like to remove the meaningless labels we applied for these exercise. You can do so by running the following commands (notice the "-" at the end of each command):

```
kubectl label nodes $node1 label1-
kubectl label nodes $node2 label2-
kubectl label nodes $node3 label3-
```