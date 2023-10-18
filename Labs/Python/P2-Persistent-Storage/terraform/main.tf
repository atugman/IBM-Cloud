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

resource "ibm_resource_instance" "cos_instance" {
  name     = "python-app-storage"
  service  = "cloud-object-storage"
  plan     = "standard"
  location = "global"
}

resource "ibm_cos_bucket" "cos_bucket" {
  bucket_name           = "python-app-storage-bucket"
  resource_instance_id  = ibm_resource_instance.cos_instance.id
  region_location       = "us-south"
  storage_class         = "standard"
}

# Output the COS instance CRN
output "cos_instance_crn" {
  value = ibm_resource_instance.cos_instance.id
}
/*
# Output the COS authentication endpoint
output "cos_auth_endpoint" {
  value = ibm_cos_bucket.cos_instance.credentials[0].auth_endpoint
}


# Output the COS bucket name
output "cos_bucket_name" {
  value = ibm_cos_bucket.cos_bucket.id
}
*/