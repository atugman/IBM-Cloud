terraform {
  required_providers {
    ibm = {
      source = "IBM-Cloud/ibm"
      version = ">= 1.12.0"
    }
  }
}

# Configure the IBM Provider
provider "ibm" {
  region = "us-south"
  ibmcloud_api_key = var.api_key
}

# Variables
# export TF_VAR_api_key=YOUR_IBM_CLOUD_API_KEY
variable "api_key" {}

variable "public_key_file"  {
    default = "~/.ssh/id_rsa.pub" 
}

locals {
  public_key    = file(pathexpand(var.public_key_file))
}

# Resources

resource "ibm_is_security_group" "example" {
  name = "tf-basics-security-group"
  vpc  = ibm_is_vpc.example.id
}

resource "ibm_is_security_group_rule" "example" {
  group     = ibm_is_security_group.example.id
  direction = "inbound"
  remote    = "0.0.0.0/0"
  tcp {
    port_min = 80
    port_max = 80
  }
}

resource "ibm_is_security_group_rule" "example1" {
  group     = ibm_is_security_group.example.id
  direction = "inbound"
  remote    = "0.0.0.0/0"
  tcp {
    port_min = 8080
    port_max = 8080
  }
}

resource "ibm_is_security_group_rule" "example2" {
  group     = ibm_is_security_group.example.id
  direction = "inbound"
  remote    = ibm_is_security_group.example.id
}

resource "ibm_is_vpc" "example" {
  name = "tf-basics-vpc"
}

resource "ibm_is_subnet" "example" {
  name            = "tf-basics-subnet"
  vpc             = ibm_is_vpc.example.id
  zone            = "us-south-2"
  ipv4_cidr_block = "10.240.64.0/24"
}

resource "ibm_is_ssh_key" "shared_ssh_key" {
  name       = "terraform-test-key"
  public_key = local.public_key
}

resource "ibm_resource_group" "example" {
  name = "example-resource-group"
}

resource "ibm_is_instance_template" "example" {
  name    = "tf-basics"
  image = "r006-b5427052-bf0d-400a-a55c-e70894560b96"
  profile = "bx2-2x8"
  keys = [ ibm_is_ssh_key.shared_ssh_key.id ]

  primary_network_interface {
    subnet            = ibm_is_subnet.example.id
    allow_ip_spoofing = false
    security_groups = [ ibm_is_security_group.example.id ]
  }

  vpc  = ibm_is_vpc.example.id
  zone = "us-south-2"

  boot_volume {
    name                             = "example-boot-volume"
    delete_volume_on_instance_delete = true
  }

  user_data      = <<-EOUD
    #!/bin/bash
    git clone https://github.com/atugman/IBM-Cloud.git
    EOUD
}