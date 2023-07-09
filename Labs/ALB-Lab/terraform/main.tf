# ~~ Work in progress ~~ #

# TODO: Associate public gw w/ subnet (currently done manually)
# TODO: Speed up user data execution + troubleshooting / edge cases
# TODO: remove cd /root from user data?
# TODO: Larger subnet (if needed)
# TODO: Code cleanup

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

##


locals {
  public_key    = file(pathexpand(var.public_key_file))
  user_data_file= file(pathexpand(var.user_data_file))
}

resource "ibm_is_security_group" "example" {
  name = "example-security-group"
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

resource "ibm_is_security_group_rule" "example2" {
  group     = ibm_is_security_group.example.id
  direction = "inbound"
  remote    = var.user_ip_addr #"127.0.0.1" # user ip
  tcp {
    port_min = 22
    port_max = 22
  }
}

resource "ibm_is_security_group_rule" "example3" {
  group     = ibm_is_security_group.example.id
  direction = "outbound"
  remote    = "0.0.0.0/0"
  tcp {
  }
}

resource "ibm_is_vpc" "example" {
  name = "example-vpc"
  #default_security_group = ibm_is_security_group.example.id
}

resource "ibm_is_public_gateway" "example" {
  name = "example-gateway"
  resource_group = ibm_resource_group.example.id
  vpc  = ibm_is_vpc.example.id
  zone = "us-south-2"
}

resource "ibm_is_subnet" "example" {
  name            = "example-subnet"
  vpc             = ibm_is_vpc.example.id
  zone            = "us-south-2"
  ipv4_cidr_block = "10.240.64.0/28"
  #public_gateway = true
}

resource "ibm_is_ssh_key" "shared_ssh_key" {
  name       = "terraform-test-key"
  public_key = local.public_key
}

resource "ibm_resource_group" "example" {
  name = "example-resource-group"
}

resource "ibm_is_instance_template" "example" {
  name    = "example-template"
  image = "r006-b5427052-bf0d-400a-a55c-e70894560b96"
  profile = "bx2-2x8"
  keys = [ ibm_is_ssh_key.shared_ssh_key.id ]

  primary_network_interface {

    subnet            = ibm_is_subnet.example.id
    allow_ip_spoofing = true
    security_groups = [ ibm_is_security_group.example.id ]
  }

  vpc  = ibm_is_vpc.example.id
  zone = "us-south-2"

  boot_volume {
    name                             = "example-boot-volume"
    delete_volume_on_instance_delete = true
  }

  /*
  volume_attachments {
    delete_volume_on_instance_delete = true
    name                             = "example-volume-att-01"
    volume_prototype {
      iops     = 3000
      profile  = "custom"
      capacity = 200
    }
  }
  */

  user_data      = <<-EOUD
    #!/bin/bash
    cd /root
    touch test.py
    sudo apt -y update
    touch test2.py
    git clone https://github.com/atugman/IBM-Cloud.git
    bash ./IBM-Cloud/Labs/ALB-Lab/lb-user-data.sh
    touch test3.py
    EOUD
}

resource "ibm_is_lb" "example" {
  name    = "example-load-balancer"
  subnets = [ibm_is_subnet.example.id]
}

resource "ibm_is_lb_listener" "example" {
  lb                         = ibm_is_lb.example.id
  port                       = "80"
  protocol                   = "http"
  default_pool = ibm_is_lb_pool.example.id
  #https_redirect_listener    = ibm_is_lb_listener.example.listener_id
  #https_redirect_status_code = 301
  #https_redirect_uri         = "/example?doc=get"
}

resource "ibm_is_lb_pool" "example" {
  name           = "example-pool"
  lb             = ibm_is_lb.example.id
  algorithm      = "round_robin"
  protocol       = "http"
  health_delay   = 5
  health_retries = 2
  health_timeout = 2
  health_type    = "http"
  proxy_protocol = "disabled"
  health_monitor_url = "/"
  #depends_on     = [ibm_is_lb_listener.example]
}

#/*
resource "ibm_is_instance_group" "example" {
  name              = "example-group"
  instance_template = ibm_is_instance_template.example.id
  instance_count    = 3
  subnets           = [ibm_is_subnet.example.id]
  load_balancer     = ibm_is_lb.example.id
  load_balancer_pool = ibm_is_lb_pool.example.pool_id
  application_port  = 80

  //User can configure timeouts
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

#*/