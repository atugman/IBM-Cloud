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

#resource "ibm_resource_group" "example" {
#  name = "demo-resource-group"
#}

resource "ibm_is_security_group" "example" {
  name = "flow-logs-demo-security-group"
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
  name = "flog-logs-demo-vpc"
}

resource "ibm_is_public_gateway" "example1" {
  name = "flow-logs-demo-gateway-1"
  #resource_group = ibm_resource_group.example.id
  vpc  = ibm_is_vpc.example.id
  zone = "us-south-1"
}

resource "ibm_is_public_gateway" "example2" {
  name = "flow-logs-demo-gateway-2"
  #resource_group = ibm_resource_group.example.id
  vpc  = ibm_is_vpc.example.id
  zone = "us-south-2"
}

resource "ibm_is_public_gateway" "example3" {
  name = "flow-logs-demo-gateway-3"
  #resource_group = ibm_resource_group.example.id
  vpc  = ibm_is_vpc.example.id
  zone = "us-south-3"
}

resource "ibm_is_subnet" "example1" {
  name            = "flow-logs-demo-subnet-1"
  vpc             = ibm_is_vpc.example.id
  zone            = "us-south-1"
  ipv4_cidr_block = "10.240.10.0/24"
}

resource "ibm_is_subnet" "example2" {
  name            = "flow-logs-demo-subnet-2"
  vpc             = ibm_is_vpc.example.id
  zone            = "us-south-2"
  ipv4_cidr_block = "10.240.65.0/24"
}

resource "ibm_is_subnet" "example3" {
  name            = "flow-logs-demo-subnet-3"
  vpc             = ibm_is_vpc.example.id
  zone            = "us-south-3"
  ipv4_cidr_block = "10.240.129.0/24"
}

resource "ibm_is_subnet_public_gateway_attachment" "example1" {
  subnet                = ibm_is_subnet.example1.id
  public_gateway         = ibm_is_public_gateway.example1.id
}

resource "ibm_is_subnet_public_gateway_attachment" "example2" {
  subnet                = ibm_is_subnet.example2.id
  public_gateway         = ibm_is_public_gateway.example2.id
}

resource "ibm_is_subnet_public_gateway_attachment" "example3" {
  subnet                = ibm_is_subnet.example3.id
  public_gateway         = ibm_is_public_gateway.example3.id
}

resource "ibm_is_ssh_key" "shared_ssh_key" {
  name       = "terraform-key"
  public_key = local.public_key
}

resource "ibm_is_instance_template" "example1" {
  name    = "flow-logs-demo-1"
  #image = "r006-b5427052-bf0d-400a-a55c-e70894560b96"
  image = "r006-3ce2aee4-5eb3-4400-baec-eb840b3343b7"
  profile = "bx2-2x8"
  keys = [ ibm_is_ssh_key.shared_ssh_key.id ]

  primary_network_interface {
    subnet            = ibm_is_subnet.example1.id
    allow_ip_spoofing = false
    security_groups = [ ibm_is_security_group.example.id ]
  }

  vpc  = ibm_is_vpc.example.id
  zone = "us-south-1"

  boot_volume {
    #name                             = "example-boot-volume"
    delete_volume_on_instance_delete = true
  }

  # TODO: update user data

  user_data      = <<-EOUD
    #!/bin/bash
    git clone https://github.com/atugman/IBM-Cloud.git
    EOUD
}

resource "ibm_is_instance_template" "example2" {
  name    = "flow-logs-demo-2"
  #image = "r006-b5427052-bf0d-400a-a55c-e70894560b96"
  image = "r006-3ce2aee4-5eb3-4400-baec-eb840b3343b7"
  profile = "bx2-2x8"
  keys = [ ibm_is_ssh_key.shared_ssh_key.id ]

  primary_network_interface {
    subnet            = ibm_is_subnet.example2.id
    allow_ip_spoofing = false
    security_groups = [ ibm_is_security_group.example.id ]
  }

  vpc  = ibm_is_vpc.example.id
  zone = "us-south-2"

  boot_volume {
    #name                             = "example-boot-volume"
    delete_volume_on_instance_delete = true
  }

  # TODO: update user data

  user_data      = <<-EOUD
    #!/bin/bash
    git clone https://github.com/atugman/IBM-Cloud.git
    EOUD
}

resource "ibm_is_instance_template" "example3" {
  name    = "flow-logs-demo-3"
  #image = "r006-b5427052-bf0d-400a-a55c-e70894560b96"
  image = "r006-3ce2aee4-5eb3-4400-baec-eb840b3343b7"
  profile = "bx2-2x8"
  keys = [ ibm_is_ssh_key.shared_ssh_key.id ]

  primary_network_interface {
    subnet            = ibm_is_subnet.example3.id
    allow_ip_spoofing = false
    security_groups = [ ibm_is_security_group.example.id ]
  }

  vpc  = ibm_is_vpc.example.id
  zone = "us-south-3"

  boot_volume {
    #name                             = "example-boot-volume"
    delete_volume_on_instance_delete = true
  }

  # TODO: update user data

  user_data      = <<-EOUD
    #!/bin/bash
    git clone https://github.com/atugman/IBM-Cloud.git
    EOUD
}

resource "ibm_is_instance" "node-1-1" {
    name = "inst-1-1"
    #subnet = ibm_is_subnet.example1.id
    #ipv4_cidr_block = "10.240.0.11/32"
    instance_template = ibm_is_instance_template.example1.id
    keys = [ ibm_is_ssh_key.shared_ssh_key.id ]
    primary_network_interface {
        name   = "eth0"
        subnet = ibm_is_subnet.example1.id
        primary_ip {
            address = "10.240.10.11"
        }
    }
}

resource "ibm_is_instance" "node-1-2" {
    name = "inst-1-2"
    #subnet = ibm_is_subnet.example1.id
    #ipv4_cidr_block = "10.240.0.11/32"
    instance_template = ibm_is_instance_template.example1.id
    keys = [ ibm_is_ssh_key.shared_ssh_key.id ]
    primary_network_interface {
        name   = "eth0"
        subnet = ibm_is_subnet.example1.id
        primary_ip {
            address = "10.240.10.12"
        }
    }
}

resource "ibm_is_instance" "node-2-1" {
    name = "inst-2-1"
    #ipv4_cidr_block = "10.240.64.11/32"
    instance_template = ibm_is_instance_template.example2.id
    #subnet = ibm_is_subnet.example2.id
    #ipv4_cidr_block = "10.240.0.11/32"
    keys = [ ibm_is_ssh_key.shared_ssh_key.id ]
    primary_network_interface {
        name   = "eth0"
        subnet = ibm_is_subnet.example2.id
        primary_ip {
            address = "10.240.65.21"
        }
    }
}

resource "ibm_is_instance" "node-2-2" {
    name = "inst-2-2"
    instance_template = ibm_is_instance_template.example2.id
    #subnet = ibm_is_subnet.example2.id
    #ipv4_cidr_block = "10.240.0.11/32"
    keys = [ ibm_is_ssh_key.shared_ssh_key.id ]
    primary_network_interface {
        name   = "eth0"
        subnet = ibm_is_subnet.example2.id
        primary_ip {
            address = "10.240.65.22"
        }
    }
}

resource "ibm_is_instance" "node-3-1" {
    name = "inst-3-1"
    #ipv4_cidr_block = "10.240.128.11/32"
    instance_template = ibm_is_instance_template.example3.id
    #subnet = ibm_is_subnet.example3.id
    keys = [ ibm_is_ssh_key.shared_ssh_key.id ]
    primary_network_interface {
        name   = "eth0"
        subnet = ibm_is_subnet.example3.id
        primary_ip {
            address = "10.240.129.31"
        }
    }
}

resource "ibm_is_instance" "node-3-2" {
    name = "inst-3-2"
    #ipv4_cidr_block = "10.240.128.12/32"
    instance_template = ibm_is_instance_template.example3.id
    #subnet = ibm_is_subnet.example3.id
    keys = [ ibm_is_ssh_key.shared_ssh_key.id ]
    primary_network_interface {
        name   = "eth0"
        subnet = ibm_is_subnet.example3.id
        primary_ip {
            address = "10.240.129.32"
        }
    }
}

######### jumpbox with floating IP, using for testing

resource "ibm_is_floating_ip" "example" {
  name    = "example-fip1"
  zone    = "us-south-2"
}

resource "ibm_is_instance" "jumpbox" {
  name    = "jumpbox"
  #image = "r006-b5427052-bf0d-400a-a55c-e70894560b96"
  image = "r006-3ce2aee4-5eb3-4400-baec-eb840b3343b7"
  profile = "bx2-2x8"
  primary_network_interface {
    subnet = ibm_is_subnet.example2.id
    security_groups = [ibm_is_security_group.example.id]
  }
  vpc  = ibm_is_vpc.example.id
  zone = "us-south-2"
  keys = [ibm_is_ssh_key.shared_ssh_key.id]
}

resource "ibm_is_instance_network_interface_floating_ip" "example" {
  instance          = ibm_is_instance.jumpbox.id
  network_interface = ibm_is_instance.jumpbox.primary_network_interface[0].id
  floating_ip       = ibm_is_floating_ip.example.id
}

########

resource "ibm_resource_instance" "example" {
  name              = "flow-logs-cos-instance"
  #resource_group_id = ibm_resource_group.example.id
  service           = "cloud-object-storage"
  plan              = "standard"
  location          = "global"
}

resource "ibm_cos_bucket" "example" {
  bucket_name          = "us-south-flow-logs"
  resource_instance_id = ibm_resource_instance.example.id
  region_location      = "us-south"
  storage_class        = "standard"
}

resource "ibm_is_flow_log" "example1" {
  depends_on     = [ibm_cos_bucket.example]
  name           = "example-instance-flow-log-1"
  target         = ibm_is_subnet.example1.id
  active         = true
  storage_bucket = ibm_cos_bucket.example.bucket_name
}

resource "ibm_is_flow_log" "example2" {
  depends_on     = [ibm_cos_bucket.example]
  name           = "example-instance-flow-log-2"
  target         = ibm_is_subnet.example2.id
  active         = true
  storage_bucket = ibm_cos_bucket.example.bucket_name
}

resource "ibm_is_flow_log" "example3" {
  depends_on     = [ibm_cos_bucket.example]
  name           = "example-instance-flow-log-3"
  target         = ibm_is_subnet.example3.id
  active         = true
  storage_bucket = ibm_cos_bucket.example.bucket_name
}

/*

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

*/