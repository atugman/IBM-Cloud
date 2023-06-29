from ibm_vpc import VpcV1
from ibm_cloud_sdk_core.authenticators import IAMAuthenticator
from ibm_cloud_sdk_core import ApiException

from ibm_platform_services import ResourceManagerV2

#vpc_api_endpoint = "https://us-south.iaas.cloud.ibm.com"
vpc_api_endpoint = "https://us-south.iaas.cloud.ibm.com/v1"
path = "/Users/andrewtugman/Documents/icos_python_constants/icos.txt"

file = open(path)
with open(path) as f:
    data = f.readlines()
api_key = data[1].strip()

authenticator = IAMAuthenticator(api_key)
service = VpcV1(authenticator=authenticator)
service.set_service_url(vpc_api_endpoint)

resource_group_id = "025d8f602b8d486383d45d57a8b7aa39"
resource_group_identity_model = {}
resource_group_identity_model['id'] = resource_group_id

address_prefix_management = 'manual'
classic_access = False
name = 'satellite-cloud-innovation-summit'
resource_group = resource_group_identity_model

response = service.create_vpc(
    address_prefix_management=address_prefix_management,
    classic_access=classic_access,
    name=name,
    resource_group=resource_group,
)