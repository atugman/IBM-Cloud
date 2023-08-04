# Used only for testing purposes! 
# This will undo the work of importer.py and tf_writer.py
# including removing the object from your terraform state
# AND removing your state file
# DO NOT USE THIS!!
terraform state rm 'ibm_is_vpc.terraform-import-demo-vpc'
rm vpc.tf
rm tf_show_output.json
rm bad.tf
rm terraform.tfstate*