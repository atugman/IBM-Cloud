from ibm_platform_services import IamAccessGroupsV2
from ibm_platform_services import ResourceManagerV2
from ibm_cloud_sdk_core.authenticators import IAMAuthenticator
import os

# set IBM Cloud Account ID as environmental variable first
account_id = os.getenv('IBM_CLOUD_ACCOUNT_ID')

resource_group_service = ResourceManagerV2.new_instance()

for i in range(1,5):
    resource_group_service.create_resource_group(
    account_id=account_id,
    name='python-rg' + str(i)
    )