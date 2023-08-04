import json

### Model ###

'''
resource "ibm_is_vpc" "terraform-import-demo-vpc" {
    access_tags                 = []
    classic_access              = false
    default_network_acl_name    = "aftermath-crunchy-resume-defective"
    default_routing_table_name  = "deputize-fog-bulk-daybed"
    default_security_group_name = "drapery-mustang-deliverer-strongman"
    name                        = "terraform-import-demo-vpc"
    resource_group              = "ed55458287a04b48a648a571f45bdae8"
    tags                        = []
    timeouts {}
}
'''

file = open('tf_show_output.json')
tf_show_output = json.load(file)
file.close()

base = tf_show_output['values']['root_module']['resources'][0]['values']

access_tags = []
classic_access = base['classic_access']
default_network_acl_name = base['default_network_acl_name']
default_routing_table_name = base['default_routing_table_name']
default_security_group_name = base['default_security_group_name']
name = base['name']
resource_group = base['resource_group']
tags = base['tags']
timeouts = base['timeouts']

tf_file = open('vpc.tf', 'w')
tf_file.write('resource "ibm_is_vpc" "' + name + '" {')
tf_file.close()

lines = [
    '    access_tags                 = ' + str(access_tags),
    '    classic_access              = ' + str(classic_access).lower(),
    '    default_network_acl_name    = ' + '"' + str(default_network_acl_name) + '"',
    '    default_routing_table_name  = ' + '"' + str(default_routing_table_name) + '"',
    '    default_security_group_name = ' + '"' + str(default_security_group_name) + '"',
    '    name                        = ' + '"' + str(name) + '"',
    '    resource_group              = ' + '"' + str(resource_group) + '"',
    '    tags                        = ' + str(tags),
    '}'
]

tf_file = open('vpc.tf', 'a')

for line in lines:
    tf_file.write('\n')
    tf_file.write(line)

tf_file.close()