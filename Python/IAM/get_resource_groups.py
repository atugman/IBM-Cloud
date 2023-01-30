from ibm_platform_services import IamAccessGroupsV2
from ibm_platform_services import ResourceManagerV2

import os

account_id = os.environ['IBM_CLOUD_ACCOUNT_ID']

resource_manager_service = ResourceManagerV2.new_instance()

resource_group_list = resource_manager_service.list_resource_groups(
  account_id=account_id,
  include_deleted=True,
)#.get_result()

print(resource_group_list)