# export TF_VAR_api_key=<apikey>
variable "api_key" {}

variable "public_key_file"  {
    default = "~/.ssh/id_rsa.pub" 
}

variable "user_data_file" {
    default = "../lb-user-data.sh"
}

variable "user_ip_addr" {
  type = string
}