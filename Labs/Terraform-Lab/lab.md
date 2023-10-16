Lab Exercise: Basic Handling of Dependent Resources in Terraform
========

### Introduction

Consider the following prerequisites, although feel free to continue reading even if you aren't following along locally.
- IBM Cloud Account & API Key
- Local Terraform installation

Newer terraformers may feel as though some foundational concepts are brushed over, although I've tried to add some verbiage to address this.

We'll use the IBM Cloud Terraform provider to walk through this simple exercise.

### Create main.tf

If you're following along, we'll first want to copy the code contained in ```main.tf``` in [this directory](https://github.com/atugman/IBM-Cloud/tree/main/Labs/Terraform-Lab/lab-files/terraform-basics-labw) locally. 

You can do this via a manual copy and paste, or by cloning the [full repository](https://github.com/atugman/IBM-Cloud/tree/main).

If you elect to use a manual copy and paste - create a file named ```main.tf``` however you'd like, but *make sure it's in its own directory*. From your local terminal, you could run a few commands like:
- ```cd Documents```
- ```mkdir tf-basics-lab && cd tf-basics-lab```
- ```touch main.tf```

 If you prefer to clone the repository, you can do so with this command: ```git clone https://github.com/atugman/IBM-Cloud.git```. Afterwards, navigate to the appropriate subdirectory with ```cd IBM-Cloud/Labs/Terraform-Lab/lab-files/terraform-basics-lab```.

### Terraform init

Once you've copied the code via either method and are in the appropriate directory, naturally we'll start by running the ```terraform init``` command from our local terminal (make sure you're still in the directory containing ```main.tf```).

A successful output will include verbiage along the lines of: 

```
Terraform has been successfully initialized!

You may now begin working with Terraform. Try running "terraform plan" to see
any changes that are required for your infrastructure. All Terraform commands
should now work.
```

### Terraform Environment Variables

Next, let's **securely** use our IBM Cloud credentials (API key) via Terraform Environment Variables. Terraform Environment Variables (just like traditional Linux environmental variables) are extremely helpful in preventing us form exposing credentials in code. Execute the following command in your terminal, supplying your IBM Cloud API key.

```bash
export TF_VAR_api_key=YOUR_IBM_CLOUD_API_KEY
```

### Architecture

We're creating an extremely simple architecture - in fact, one that won't incur any costs. We'll stop short of deploying any actual servers or applications, but rather just a few basic resources (listed below). Nonetheless, keep in mind any dependencies that could exist between these resources!
- VPC & one subnet
- A security group, with a few simple security rules
- A resource group
- An SSH Key
- And a Virtual Server Instance *Template* (again, not an actual instance)

### Terraform plan

Let's run ```terraform plan``` as a best practice. This command will effectively **simulate** changes to your infrastructure (based on your codebase, or any changes to your codebase), without actually implementing these changes. An absolute *must* in production!

Successful execution of this command should result in a terminal message similar to:

```
Plan: 9 to add, 0 to change, 0 to destroy.
```

...along with a list of resources to be added to the Terraform state.

### Terraform apply

Then, run ```terraform apply``` to deploy our initial set of cloud resources.

When prompted, enter 'yes' when Terraform asks if you'd like to perform these actions (confirming that you'd like to create these resources). 

Successful execution of this command should result in a terminal message similar to:

```
Apply complete! Resources: 9 added, 0 changed, 0 destroyed.
```

...again, along with a list of resources that were created and added to the terraform state.

So, we have our initial cloud resources deployed, albeit, for the purposes of this lab, no significant resources have been deployed. 

### Terraform state

You should notice a new file named ```terraform.tfstate```. Terraform stores its state in this JSON file. Feel free to explore the contents of this file. 

Think of the terraform state as a representation of the configurations of deployed resources (or rather, the resources terraform *thinks* are deployed, and their configurations, at a given point in time). Your terraform state will never be updated solely based on a change in one of your code files, but rather after running a ```terraform apply```, a ```terraform plan``` or the less commonly used ```terraform refresh```.

We can also output the contents of our state using the ```terraform state show``` command, followed by desired arguments. Let's run the following command to view the current state of our subnet: ```terraform state show 'ibm_is_subnet.example'```, which should result in a terminal output similar to the following.

```
resource "ibm_is_subnet" "example" {
    access_tags                  = []
    available_ipv4_address_count = 11
    ip_version                   = "ipv4"
    ipv4_cidr_block              = "10.240.64.0/24"
    name                         = "tf-basics-subnet"
    resource_group_name          = "Default"
    resource_status              = "available"
    status                       = "available"
    tags                         = []
    total_ipv4_address_count     = 16
    zone                         = "us-south-2"
}
```

The most important thing to note is that the CIDR block of our subnet is 10.240.64.0/24, just like we defined in our code.

### Updating Terraform Configurations

Suppose we need to update the configuration of one of our resources - let's say something as foundational as the CIDR block of our VPC, or one of the subnets of our VPC. 

Now, hopefully this isn't a change you'll find yourself making often. Defining address spaces in the cloud, and defining them correctly, is a critical early stage exercise of a successful cloud migration. You don't want to be in the business of updating CIDR blocks after you're up and running in the cloud - it's bound to create issues, overlap with address spaces in on-premises networks, or, in our case, cause issues with dependent cloud resources. Regardless of the scenario, updating CIDR blocks (after day 0) is typically very tedious.

But, for the purposes of this exercise, let's update the CIDR block of our subnet to demonstrate how Terraform handles dependent resources.

We'll change the CIDR block of the subnet in ```main.tf``` as shown below. Change the value of the ```ipv4_cidr_block``` attribute of the ```ibm_is_subnet``` resource named ```example``` to ```10.240.64.0/18```. You can copy the code below (including the comments), replacing the original ```ibm_is_subnet``` resource if you'd like. Or simply change ```/24``` to ```/18```.

```terraform
resource "ibm_is_subnet" "example" {
  name            = "tf-basics-subnet"
  vpc             = ibm_is_vpc.example.id
  zone            = "us-south-2"
                    #"10.240.64.0/24" <--- CIDR block of currently deployed infrastructure
  ipv4_cidr_block = "10.240.64.0/18" # <--- New CIDR block to be applied
}
```

### Dependent Resources

After making this change, let's rerun the ```terraform plan``` command to simulate how Terraform would handle these changes.

Analyzing the output, we'll first see that Terraform refreshes the state of each resource stored in the Terraform state. Terraform first checks to see if any changes to our cloud resources were made outside of Terraform (if there has been any configuration drift).

```
ibm_resource_group.example: Refreshing state... [id=f8b67f59696d4a4e8943cfea689492c7]
ibm_is_ssh_key.shared_ssh_key: Refreshing state... [id=r006-ff54c905-891f-4b80-8341-13dd377aac13]
ibm_is_vpc.example: Refreshing state... [id=r006-d858550d-c9c5-45b4-bc35-c80e98de1bf4]
ibm_is_subnet.example: Refreshing state... [id=0727-b68aad4e-3bd1-4857-82f4-db5303d3df04]
ibm_is_security_group.example: Refreshing state... [id=r006-0beee3f9-5f15-4262-bc05-7c899dff1630]
ibm_is_security_group_rule.example2: Refreshing state... [id=r006-0beee3f9-5f15-4262-bc05-7c899dff1630.r006-4c6e398f-4999-4c3c-b69f-e1890bdb8173]
ibm_is_security_group_rule.example1: Refreshing state... [id=r006-0beee3f9-5f15-4262-bc05-7c899dff1630.r006-8a90622c-50a2-45d5-8dd4-1df5d1a54959]
ibm_is_security_group_rule.example: Refreshing state... [id=r006-0beee3f9-5f15-4262-bc05-7c899dff1630.r006-2dd4851f-b17f-432e-81ad-0492b86d77bc]
ibm_is_instance_template.example: Refreshing state... [id=0727-3cbab154-a94e-4d1e-a76c-c1c20182047f]
```

We'll then notice that, due to this one simple change, terraform needs to replace our instance template, as well as the subnet itself. Your terminal output may look different, as I've trimmed the response here.

```
Terraform will perform the following actions:

  # ibm_is_instance_template.example must be replaced
-/+ resource "ibm_is_instance_template" "example" {
      + availability_policy_host_failure  = (known after apply)
      + default_trusted_profile_auto_link = (known after apply)
      ~ id                                = "0727-3cbab154-a94e-4d1e-a76c-c1c20182047f" -> (known after apply)
      + metadata_service_enabled          = (known after apply)
        name                              = "tf-basics"
      ~ placement_target                  = [
          - {
              - crn  = null
              - href = null
              - id   = null
            },
        ] -> (known after apply)
        # (6 unchanged attributes hidden)

        ..........
    }

  # ibm_is_subnet.example must be replaced
-/+ resource "ibm_is_subnet" "example" {
      ~ access_tags                  = [] -> (known after apply)
      ~ available_ipv4_address_count = 251 -> (known after apply)
      ~ ipv4_cidr_block              = "10.240.64.0/24" -> "10.240.64.0/18" # forces replacement
        name                         = "tf-basics-subnet"
      ~ network_acl                  = "r006-6888995e-1fbc-4a51-9d3f-3a6ecac42a42" -> (known after apply)
      + public_gateway               = (known after apply)
      ~ resource_controller_url      = "https://cloud.ibm.com/vpc-ext/network/subnets" -> (known after apply)
      ~ resource_group               = "bf9d125f31ad41df8f528ff5719ee757" -> (known after apply)
      ~ resource_group_name          = "Default" -> (known after apply)
      ~ tags                         = [] -> (known after apply)
      ~ total_ipv4_address_count     = 256 -> (known after apply)
        # (3 unchanged attributes hidden)
    }

Plan: 2 to add, 0 to change, 2 to destroy.
```

Notice Terraform's verbiage, and how our one change "forces replacement" of the subnet itself (and the instance template), as shown in the terminal output.

```
~ ipv4_cidr_block = "10.240.64.0/24" -> "10.240.64.0/18" # forces replacement
```

Just for fun, let's go ahead and apply the change with the ```terraform apply``` command, then we'll wrap up with some final commentary.

As our terraform plan alluded to, our change will force the destruction and recreation of our subnet and instance template.

```
ibm_is_instance_template.example: Destroying... [id=0727-3cbab154-a94e-4d1e-a76c-c1c20182047f]
ibm_is_instance_template.example: Destruction complete after 2s
ibm_is_subnet.example: Destroying... [id=0727-b68aad4e-3bd1-4857-82f4-db5303d3df04]
ibm_is_subnet.example: Still destroying... [id=0727-b68aad4e-3bd1-4857-82f4-db5303d3df04, 10s elapsed]
ibm_is_subnet.example: Destruction complete after 14s
ibm_is_subnet.example: Creating...
ibm_is_subnet.example: Still creating... [10s elapsed]
ibm_is_subnet.example: Creation complete after 12s [id=0727-b0e1b316-bdb3-4baa-bc1c-4fa5a671ff3d]
ibm_is_instance_template.example: Creating...
ibm_is_instance_template.example: Creation complete after 2s [id=0727-a47290d2-1c76-492e-b9f1-bbce6d24bfa6]

Apply complete! Resources: 2 added, 0 changed, 2 destroyed.
```

Had we made these changes directly in the cloud portal, we would have had to complete each of these steps manually. Subnet CIDR blocks and instance templates are immutable resources, and cannot be modified. 

Conducting such tasks manually in production is not an option, and writing custom automation could be cumbersome and could require thorough testing. Custom automation in this sense would need to handle many tasks that Terraform handles natively - storing and refreshing the state - (the program becoming aware current configurations directly from the cloud provider's API), updating or destroying/recreating resources based on specific changes or conditions, understanding dependent resources and the order in which to destroy and recreate them...and there's plenty more to the program.

Terraform, on the other hand, generally handles dependent resources for us, and would throw appropriate error messages in the event that we attempt to make a change that isn't allowed. One last thing to keep in mind - the Terraform [depends_on](https://developer.hashicorp.com/terraform/language/meta-arguments/depends_on) argument, which can be used to further define which resources could be impacted by changes to other resources. We won't take a deep dive of ```depends_on``` here, but know that, even when this argument is necessary, it's still far more simplistic than writing our own custom automation as alluded to above.

### Optional, Extra Credit Exercise

We talked a bit about terraform state earlier in the blog - here is one final simple exercise to illustrate another key functionality of Terraform.

Login to the IBM Cloud portal and make some changes to the rules of your security group, named ```tf-basics-security-group```. Try changing the port numbers of one of the rules, and deleting another rule altogether, directly from the IBM Cloud portal.

How do you think Terraform will respond to changing our cloud resources *outside* the realm of Terraform?

Run a ```terraform plan``` and you should see a message similar to:

```
Plan: 1 to add, 1 to change, 0 to destroy.
```

Terraform is telling us that, on the next ```terraform apply```, it will recreate the security group rule that was deleted, and change the other security group rule *back* to the configuration that was declared in your code.

### Terraform destroy

Be sure to run a final ```terraform destroy``` command (and confirm it) to clean up the environment.