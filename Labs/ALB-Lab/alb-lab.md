# Illustrating the Core Functionality of an Application Load Balancer and Instance Groups on IBM Cloud



## Introduction

This article serves as a guide to constructing a demonstration of an Application Load Balancer (ALB), illustrating exactly how they work, the motives for using one, and a few interesting experiments. Additionally, we'll observe the functionality of an IBM Cloud Instance Group, and illustrate how using one in conjunction with an ALB can help us deliver highly-available and scalable web applications.

ALBs play an important role in how enterprises deliver software (in this case, web-based applications) to their customers. A copious amount of deliberation should be put into validating this kind of architecture, including load balancer configurations, routing algorithms, health checks, persistent storage, etc. Proper consideration and configuration are vital to ensuring applications are fully functional and available to end users.

For a more detailed explanation on load balancing, visit this article from IBM: https://www.ibm.com/topics/load-balancing. Depending on your level of experience in the realm of networking, you may find that the experiments in this writeup are fairly rudimentary. The goal is to bring some foundational concepts to life with unique illustrations while reinforcing concepts vital to application uptime. This writeup should provide exercises appropriate for most experience levels.

We'll start by deploying properly configured VPC infrastructure, including an ALB and instance group, then tamper with the configurations enough to illustrate when and why it might break, why that behavior should or should not be expected, and how to avoid some common pitfalls.

## Prerequisites

An IBM Cloud account with Manager or higher permissions for VPC, and Editor or higher level platform permissions

*Use the code VPC1000 for $1,000 in IBM Cloud VPC credits! This will more than cover the cost of the lab, which will only be a nominal expense since we'll destroy the environment afterwards.*

Chrome, Edge, or Firefox are recommended, although Safari may suffice

## Phase 1 - Create a Virtual Private Cloud (VPC)

From the IBM Cloud Portal, create a VPC with the following configurations, most of which will be pre-populated for you:

**Location**: Region of your choice (Take note of this region, we will need to reference it again several times throughout the lab)

**Name**: lb-demo-vpc

**Resource group**: Default (others can be used as desired)

Maintain the default values of the remaining configurations, including:

- Default Security Group: Should remain checked, allowing SSH and PING

- Classic Access: can remain unchecked

- Default address prefixes: should remain checked

- Subnets: Default values, including address spaces should be used

Your VPC should be created within a few moments. **Navigate to your VPC**, then to the **Default Security Group** listed for your VPC.

From your default security group, navigate to the "**Rules**" tab.

First, as a best practice, let's restrict port 22 to your machine's IP address.

- Select "**Edit**" (using the ellipses) on the inbound rule in which the "Value" is listed as "Ports 22–22."

- In the "**Edit inbound rule**" pane, change "**Source Type**" to "**IP address**" and enter your machines IP address. You can retrieve your machine's IP address by navigating to https://www.ipchicken.com/ in a separate tab

- Keep in mind that your local network is likely using Network Address Translation, which (in short) means that your IP address is being assigned by the local router. In the event that you are completing this lab in multiple sittings in different locations, you'll want to update the IP address in this rule accordingly.

- Save the newly configured rule containing your IP address.

Next, create a new inbound rule with the following configurations.

**IMPORTANT**: Please note that adding this rule will expose virtual server instances that we create in later exercises to the internet over port 80 (HTML protocol). Please ensure you take the proper precautions. If you borrowed a colleague's VPC for this exercise (instead of creating a new VPC as shown in the steps above), please consider the repercussions and leverage strictly lab environments that do not have connectivity to company resources.

## Phase 2 - Create the Load Balancer



## Phase 3 - Create an Instance Template




## Phase 4 - Create an Instance Group



## Phase 5 - Test the Functionality of your Load Balancer



## Phase 6 - Additional Experiments


## Phase 7 - Maybe just a few more experiments…



## Conclusion


## Cleanup


## References