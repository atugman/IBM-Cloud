from ibm_platform_services import IamAccessGroupsV2
import os

account_id = os.environ['IBM_CLOUD_ACCOUNT_ID']

service_client = IamAccessGroupsV2.new_instance()

# mass create resource groups, update range loop to increase number created
for i in range(1,5):
    service_client.create_access_group(
            account_id=account_id,
            name="lab-user-" + str(i) + "-access-group",
            description="lab-user-" + str(i) + "-access-group"
        )