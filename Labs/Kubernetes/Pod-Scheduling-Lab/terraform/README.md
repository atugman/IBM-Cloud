## Simple IKS Cluster - Pod Scheduling Lab

This cluster is designed to be used with this lab guide: https://github.com/atugman/IBM-Cloud/tree/main/Labs/Kubernetes/Pod-Scheduling-Lab/guide.md. 

Note that deploying a cloud-based Kubernetes cluster (even a simple one like this) will take a while, up to 45 minutes. It's recommended to deploy your cluster prior to the time allocated to conducting the lab exercises.

## Usage

From the ```./Pod-Scheduling-Lab/terraform``` directory, run the following commands individually.

```terraform init```

```export TF_VAR_api_key=your_ibm_cloud_api_key```

```terraform plan```

```terraform apply```

## Resources Deployed

- VPC with 1 subnet
- Public Gateway, attached to the subnet
  - Provides outbound connectivity for cluster nodes
- IKS cluster with:
  - The default worker pool, and two additional worker pools (3 total)
  - 3 total worker nodes, one in each worker pool
    - Each worker node is labeled as described in the lab guide