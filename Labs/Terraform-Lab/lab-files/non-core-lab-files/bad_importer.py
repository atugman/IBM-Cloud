import os

# Prereqs:
# Configure the terraform provider in main.tf
# Populate vpc_name and vpc_id below
# Run terraform init

vpc_name = "lab-user-10-vpc"
vpc_id = "r006-8c36b6df-0ad8-4c86-b6b0-ef703531d177"

# write an empty configuration - this part is fine!
vpc_tf_file = open("bad_.tf", "w")
vpc_tf_file.write('resource "ibm_is_vpc" "' + vpc_name + '" {}')
vpc_tf_file.close()

# import - this part is fine!
os.system("terraform import ibm_is_vpc." + vpc_name + " " + vpc_id)

# not the designed way to use tf show (doesn't write cleanly to a .tf file)
os.system("terraform show > bad_.tf")