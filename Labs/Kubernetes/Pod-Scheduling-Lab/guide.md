Kubernetes Pod Scheduling
========

## Introduction

- *Update
- Need kubectl access to a Kubernetes cluster, with the ability to deploy pods
- Would highly advise using a test cluster dedicated to these exercises. Even though we'll be using worker pools, this lab (by design) will have an impact on the scheduling of pods in the cluster.
- Exercises will use the 'default' namespace
- Your cluster should have 3 worker nodes, each with 4x16 CPU/Memory
- Written on IBM Cloud Kubernetes Service, but should work regardless of where your cluster is hosted
- Terraform provided for IKS
- Intro exercise - image deploy IKS

## File Structure

- Root directory: https://github.com/atugman/IBM-Cloud/tree/main/Labs/Kubernetes/Pod-Scheduling-Lab
- guide.md - lab instructions. If you're reading this on the IBM Cloud communities page, you can disregard guide.md as it's a mirror image of this blog.
- Pod and Deployment specs
  - /specs_affinity_exercises
    - with-affinity.yaml & without-affinity.yaml
  - /specs_taints_exercises
    - pod1.yaml, pod2.yaml, & pod3.yaml
- /terraform/main.tf - a simple terraform for an IKS cluster
- pull_pod_status.py - python program that we'll use to expedite troubleshooting

You can use ```git clone``` to copy the full repository to your local machine. The repo contains various other lab files. After cloning, feel free to remove the excess files with a few simple commands similar to:

```
    git clone https://github.com/atugman/IBM-Cloud.git
cp -r ./IBM-Cloud/Labs/Kubernetes/Pod-Scheduling-Lab .
rm -r ./IBM-Cloud # or remove the originally cloned repo manually
```

## Labels and Taints

#### Validate your Node Labels

If you used the provided terraform to create your IKS cluster, your nodes will already be labeled properly for these exercises.

If you did *not* use to the terraform, let's quickly label your nodes. First, use ```kubectl get nodes``` to identify the names of the 3 nodes you'll be using for these exercises. 

```
kubectl label nodes <your-first-node> label1=value1
kubectl label nodes <your-second-node> label2=value2
kubectl label nodes <your-third-node> label3=value3
```

If you did use the terraform, you can run the following commands to validate your labels. Each command should output a single, unique node.

```
kubectl get nodes -l label1
kubectl get nodes -l label2
kubectl get nodes -l label3
```

Optionally, you can use ```kubectl describe node <node-name>``` to explore the labels (and many other details) of each node.

To reiterate, your first node will be labeled ```label1:value1```, and so on.

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

#### Deploy Pods with Node Selectors

Next, let's deploy a few pods, each with a unique node selector. Take a moment to review the contents of the 3 .yaml files in the /specs_taints_exercises directory. Each file is nearly identical, with the exception of the last two lines (excluding the comments in pod2.yaml). Our 3 pods are designed to run on our 3 nodes, one pod per node.

Deploy all three pods by running the following commands from your terminal. These commands assume you're currently in the root directory of the project (./Pod-Scheduling-Lab).

```
cd specs_taints_exercises
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

#### Taint Your Nodes

Taint your nodes with the following commands, supplying the names of your second and third nodes. Remember, your second node has the label ```label2:value2``` and your third node should have the label ```label3:value3```. You can rerun these commands as needed to recall which nodes is which: ```kubectl get nodes -l label2``` and ```kubectl get nodes -l label3```.

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
> Now, notice the ```NoExecute``` at the end of the first command (ran against node2). This option is still designed to repel pods, but also evicts any pods on the node that don't tolerate the node taint. For this reason, you should still see pod1 and pod3 running in the cluster, but not pod2, as it was evicted (and will not be repelled).

So, what are our options to schedule pods to these tainted nodes? How effectively can we use these nodes knowing they are tainted? Let's start with the first question to better understand taints.

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

#### Troubleshooting Your Pods

Your best friend in troubleshooting pods and deployments is the ```kubectl describe``` command.

Now, in this exercise, it would be perfectly suitable to run ```kubectl describe pod pod2``` and ```kubectl describe pod pod3```, two simple commands providing us with the information that we need to understand why our pods have not been scheduled.