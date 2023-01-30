from ibm_platform_services import IamAccessGroupsV2
import os

# set IBM Cloud Account ID as environmental variable first
account_id = os.environ['IBM_CLOUD_ACCOUNT_ID']

service_client = IamAccessGroupsV2.new_instance()

access_group_id = ""

result = service_client.get_access_group(
    access_group_id=access_group_id,
)

print(result)