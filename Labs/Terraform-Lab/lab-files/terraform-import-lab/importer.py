import os
import json

# Prereqs:
# Configure the terraform provider in main.tf
# - Recommend running 'export TF_VAR_api_key=your_api_key' from your terminal
# - Otherwise, terraform will prompt you for the key on a plan/apply command
# Run terraform init
# Populate vpc_name and vpc_id (to be imported) in the two variables below

vpc_name = "terraform-import-demo-vpc"
vpc_id = "r006-8c36b6df-0ad8-4c86-b6b0-ef703531d177"

# write an empty terraform configuration
vpc_tf_file = open("vpc.tf", "w")
vpc_tf_file.write('resource "ibm_is_vpc" "' + vpc_name + '" {}')
vpc_tf_file.close()

# terraform import
os.system("terraform import ibm_is_vpc." + vpc_name + " " + vpc_id)

# write tf show output to json file
os.system("terraform show -json > tf_show_output_.json")

# format json
with open("tf_show_output_.json", "r") as read_file:
    original = json.load(read_file)
    formatted = json.dumps(original, indent=4)

with open("tf_show_output.json", "w") as write_file:
    write_file.write(formatted)

os.system("rm tf_show_output_.json")