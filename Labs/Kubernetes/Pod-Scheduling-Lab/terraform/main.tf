terraform {
  required_providers {
    ibm = {
      source = "IBM-Cloud/ibm"
      version = ">= 1.12.0"
    }
  }
}

// Configure the IBM Provider
provider "ibm" {
  region = "us-south"
  ibmcloud_api_key = var.api_key
}

// Run line below in local terminal, supplying IBM Cloud API key
// export TF_VAR_api_key=your_api_key

variable "api_key" {}

data "ibm_resource_group" "resource_group" {
  name = "Default"
}

// Network

resource "ibm_is_vpc" "vpc1" {
  name = "myvpc"
}

resource "ibm_is_subnet" "subnet1" {
  name                     = "mysubnet1"
  vpc                      = ibm_is_vpc.vpc1.id
  zone                     = "us-south-1"
  total_ipv4_address_count = 256
}

resource "ibm_is_public_gateway" "k8s-gw" {
  name = "k8s-gateway"
  resource_group = data.ibm_resource_group.resource_group.id
  vpc  = ibm_is_vpc.vpc1.id
  zone = "us-south-1"
}

resource "ibm_is_subnet_public_gateway_attachment" "k8s-gw-attachment" {
  subnet                = ibm_is_subnet.subnet1.id
  public_gateway         = ibm_is_public_gateway.k8s-gw.id
}

// Cluster

resource "ibm_container_vpc_cluster" "cluster" {
  name              = "mycluster"
  vpc_id            = ibm_is_vpc.vpc1.id
  flavor            = "bx2.4x16" # "bx2.2x8" # "u3c.2x4" <-- older gen, forces replacement
  worker_count      = 1
  resource_group_id = data.ibm_resource_group.resource_group.id
  zones {
    subnet_id = ibm_is_subnet.subnet1.id
    name      = "us-south-1"
  }
  worker_labels = {
    label1="value1"
  }
}

// Worker Pools

resource "ibm_container_vpc_worker_pool" "worker_pool_1" {
  cluster           = ibm_container_vpc_cluster.cluster.id
  worker_pool_name  = "worker_pool_1"
  flavor            = "bx2.4x16"
  vpc_id            = ibm_is_vpc.vpc1.id
  worker_count      = 1
  resource_group_id = data.ibm_resource_group.resource_group.id
  zones {
    name      = "us-south-1"
    subnet_id = ibm_is_subnet.subnet1.id
  }
  labels = {
    label2:"value2"
  }
}

resource "ibm_container_vpc_worker_pool" "worker_pool_2" {
  cluster           = ibm_container_vpc_cluster.cluster.id
  worker_pool_name  = "worker_pool_2"
  flavor            = "bx2.4x16"
  vpc_id            = ibm_is_vpc.vpc1.id
  worker_count      = 1
  resource_group_id = data.ibm_resource_group.resource_group.id
  zones {
    name      = "us-south-1"
    subnet_id = ibm_is_subnet.subnet1.id
  }
  labels = {
    label3:"value3"
  }
}