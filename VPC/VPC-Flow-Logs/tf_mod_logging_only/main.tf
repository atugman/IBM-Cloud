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

variable "api_key" {}

# only creates a logging instance, considering integrating this into the exercise.

resource "ibm_resource_instance" "instance" {
  name     = "TestLogging"
  service  = "logdna"
  plan     = "7-day"
  location = "us-south"
}

resource "ibm_resource_key" "resourceKey" {
  name                 = "TestKey"
  resource_instance_id = ibm_resource_instance.instance.id
  role                 = "Manager"
}

resource "ibm_ob_logging" "test2" {
  depends_on  = [ibm_resource_key.resourceKey]
  cluster     = "cimmo4ud0tekn04a0lk0"
  instance_id = ibm_resource_instance.instance.guid
}