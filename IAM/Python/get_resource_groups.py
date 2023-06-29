from ibm_platform_services import IamAccessGroupsV2
from ibm_platform_services import ResourceManagerV2
from ibm_cloud_sdk_core.authenticators import IAMAuthenticator

import os

account_id = os.environ['IBM_CLOUD_ACCOUNT_ID']

path = "/Users/andrewtugman/Documents/icos_python_constants/icos.txt"

file = open(path)
with open(path) as f:
    data = f.readlines()
api_key = data[1].strip()

authenticator = IAMAuthenticator(api_key)
resource_manager_service = ResourceManagerV2(authenticator=authenticator)

resource_group_list = resource_manager_service.list_resource_groups(
  account_id=account_id,
  include_deleted=True,
).get_result()

print(resource_group_list)