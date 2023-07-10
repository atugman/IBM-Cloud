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

locals {
  public_key    = file(pathexpand(var.public_key_file))
}

resource "ibm_is_security_group" "example" {
  name = "lb-demo-security-group"
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
  remote    = var.user_ip_addr
  tcp {
    port_min = 22
    port_max = 22
  }
}

resource "ibm_is_security_group_rule" "example3" {
  group     = ibm_is_security_group.example.id
  direction = "outbound"
  remote    = "0.0.0.0/0"
}

resource "ibm_is_security_group_rule" "example4" {
  group     = ibm_is_security_group.example.id
  direction = "inbound"
  remote    = "0.0.0.0/0"
  icmp {
    type = 8
  }
}

resource "ibm_is_security_group_rule" "example5" {
  group     = ibm_is_security_group.example.id
  direction = "inbound"
  remote    = ibm_is_security_group.example.id
}

resource "ibm_is_vpc" "example" {
  name = "lb-demo-vpc"
}

resource "ibm_is_public_gateway" "example" {
  name = "lb-demo-gateway"
  resource_group = ibm_resource_group.example.id
  vpc  = ibm_is_vpc.example.id
  zone = "us-south-2"
}

resource "ibm_is_subnet" "example" {
  name            = "lb-demo-subnet"
  vpc             = ibm_is_vpc.example.id
  zone            = "us-south-2"
  ipv4_cidr_block = "10.240.64.0/28"
}

resource "ibm_is_subnet_public_gateway_attachment" "example" {
  subnet                = ibm_is_subnet.example.id
  public_gateway         = ibm_is_public_gateway.example.id
}

resource "ibm_is_ssh_key" "shared_ssh_key" {
  name       = "terraform-test-key"
  public_key = local.public_key
}

resource "ibm_resource_group" "example" {
  name = "example-resource-group"
}

resource "ibm_is_instance_template" "example" {
  name    = "lb-demo"
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
    bash ./IBM-Cloud/Labs/ALB-Lab/terraform/lb-user-data-tf.sh
    EOUD
}

resource "ibm_is_lb" "example" {
  name    = "lb-demo"
  security_groups = [ibm_is_security_group.example.id]
  subnets = [ibm_is_subnet.example.id]
}

resource "ibm_is_lb_listener" "example" {
  lb                         = ibm_is_lb.example.id
  port                       = "80"
  protocol                   = "http"
  default_pool = ibm_is_lb_pool.example.id
}

resource "ibm_is_lb_pool" "example" {
  name           = "demo-pool"
  lb             = ibm_is_lb.example.id
  algorithm      = "round_robin"
  protocol       = "http"
  health_delay   = 5
  health_retries = 2
  health_timeout = 2
  health_type    = "http"
  proxy_protocol = "disabled"
  health_monitor_url = "/"
}

resource "ibm_is_instance_group" "example" {
  name              = "lb-demo"
  instance_template = ibm_is_instance_template.example.id
  instance_count    = 3
  subnets           = [ibm_is_subnet.example.id]
  load_balancer     = ibm_is_lb.example.id
  load_balancer_pool = ibm_is_lb_pool.example.pool_id
  application_port  = 80

  timeouts {
    create = "15m"
    delete = "15m"
    update = "10m"
  }
}

resource "ibm_is_instance_group_manager" "example" {
  name                 = "example-ig-manager"
  aggregation_window   = 90
  instance_group       = ibm_is_instance_group.example.id
  cooldown             = 120
  manager_type         = "autoscale"
  enable_manager       = true
  max_membership_count = 6
  min_membership_count = 3
}