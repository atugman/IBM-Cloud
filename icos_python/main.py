# Methods below are from IBM Cloud docs: https://cloud.ibm.com/docs/cloud-object-storage?topic=cloud-object-storage-python#python-examples

import ibm_boto3
from ibm_botocore.client import Config, ClientError
#from ibm_s3transfer.aspera.manager import AsperaTransferManager
#from ibm_s3transfer.aspera.manager import AsperaConfig
import time
import os

# Example constants for IBM COS values

# COS_ENDPOINT = # example: "https://s3.us-east.cloud-object-storage.appdomain.cloud"
# COS_API_KEY_ID = # example: "W00YixxxxxxxxxxMB-odB-2ySfTrFBIQQWanc--P3byk"
# COS_INSTANCE_CRN = # example: "crn:v1:bluemix:public:cloud-object-storage:global:a/3bf0d9003xxxxxxxxxx1c3e97696b71c:d6f04d83-6c4f-4a62-a165-696756d63903::"
# COS_BUCKET_LOCATION = # example: "us-east-standard"

# Constants are currently stored in a separate file to prevent exposing credentials in code
# Below is sample code to load values from another file

path = "/Users/andrewtugman/Documents/icos_python_constants/icos.txt"

file = open(path)

with open(path) as f:
    data = f.readlines()

COS_ENDPOINT = data[0].strip()
COS_API_KEY_ID = data[1].strip()
COS_INSTANCE_CRN = data[2].strip()
COS_BUCKET_LOCATION = data[3].strip()

## Currently using local files and user input for demo files to upload to iCOS
## Optionally you can set up files / file contents as variables as shown here
# bucket_1 = <bucket_name>
# bucket_2 = <bucket_2_name>

# file_1 = "my_first_file.txt"
# file_2 = "my_second_file.txt"

# file_1_contents = "Some text written to file 1"
# file_2_contents = "Some other text written to file 2"

# Create resource
cos = ibm_boto3.resource("s3",
    ibm_api_key_id=COS_API_KEY_ID,
    ibm_service_instance_id=COS_INSTANCE_CRN,
    config=Config(signature_version="oauth"),
    endpoint_url=COS_ENDPOINT
)

def get_buckets():
    print("Retrieving list of buckets")
    try:
        buckets = cos.buckets.all()
        for bucket in buckets:
            print("Bucket Name: {0}".format(bucket.name))
    except ClientError as be:
        print("CLIENT ERROR: {0}\n".format(be))
    except Exception as e:
        print("Unable to retrieve list buckets: {0}".format(e))

def create_bucket(bucket_name):
    print("Creating new bucket: {0}".format(bucket_name))
    try:
        cos.Bucket(bucket_name).create(
            CreateBucketConfiguration={
                "LocationConstraint":COS_BUCKET_LOCATION
            }
        )
        print("Bucket: {0} created!".format(bucket_name))

    except ClientError as be:
        print("CLIENT ERROR: {0}\n".format(be))
    except Exception as e:
        print("Unable to create bucket: {0}".format(e))

def create_text_file(bucket_name, item_name, file_text):
    print("Creating new item: {0}".format(item_name))
    try:
        cos.Object(bucket_name, item_name).put(
            Body=file_text
        )
        print("Item: {0} created!".format(item_name))
    except ClientError as be:
        print("CLIENT ERROR: {0}\n".format(be))
    except Exception as e:
        print("Unable to create text file: {0}".format(e))

def get_bucket_contents(bucket_name):
    print("Retrieving bucket contents from: {0}".format(bucket_name))
    try:
        files = cos.Bucket(bucket_name).objects.all()
        for file in files:
            print("Item: {0} ({1} bytes).".format(file.key, file.size))
    except ClientError as be:
        print("CLIENT ERROR: {0}\n".format(be))
    except Exception as e:
        print("Unable to retrieve bucket contents: {0}".format(e))

def get_item(bucket_name, item_name):
    print("Retrieving item from bucket: {0}, key: {1}".format(bucket_name, item_name))
    try:
        file = cos.Object(bucket_name, item_name).get()
        print("File Contents: {0}".format(file["Body"].read()))
    except ClientError as be:
        print("CLIENT ERROR: {0}\n".format(be))
    except Exception as e:
        print("Unable to retrieve file contents: {0}".format(e))

def delete_item(bucket_name, object_name):
    try:
        #cos.delete_object(Bucket=bucket_name, Key=object_name)
        cos.Object(bucket_name, object_name).delete()
        print("Item: {0} deleted!\n".format(object_name))
    except ClientError as be:
        print("CLIENT ERROR: {0}\n".format(be))
    except Exception as e:
        print("Unable to delete object: {0}".format(e))
'''
def add_protection_configuration_to_bucket(bucket_name):
    try:
        new_protection_config = {
            "Status": "Retention",
            "MinimumRetention": {"Days": 10},
            "DefaultRetention": {"Days": 100},
            "MaximumRetention": {"Days": 1000}
        }
        
        #cos.put_bucket_protection_configuration(Bucket=bucket_name, ProtectionConfiguration=new_protection_config)
        cos.put_bucket_protection_configuration(bucket_name, new_protection_config)
        #cos.Bucket(bucket_name)

        print("Protection added to bucket {0}\n".format(bucket_name))
    except ClientError as be:
        print("CLIENT ERROR: {0}\n".format(be))
    except Exception as e:
        print("Unable to set bucket protection config: {0}".format(e))

def get_protection_configuration_on_bucket(bucket_name):
    try:
        response = cos.get_bucket_protection_configuration(Bucket=bucket_name)

        protection_config = response.get("ProtectionConfiguration")

        print("Bucket protection config for {0}\n".format(bucket_name))
        print(protection_config)
        print("\n")
    except ClientError as be:
        print("CLIENT ERROR: {0}\n".format(be))
    except Exception as e:
        print("Unable to get bucket protection config: {0}".format(e))

def upload_file_with_retention(bucket_name, object_name, path_to_file, retention_period):
    print("Uploading file {0} to object {1} in bucket {2}\n".format(path_to_file, object_name, bucket_name))
    
    args = {
        "RetentionPeriod": retention_period
    }

    cos.upload_file(
        Filename=path_to_file,
        Bucket=bucket_name,
        Key=object_name,
        ExtraArgs=args
    )

    print("File upload complete to object {0} in bucket {1}\n".format(object_name, bucket_name))
'''
'''
# Create Transfer manager
def download_item(bucket_name, object_name, download_filename):

    client = ibm_boto3.client("s3",
        ibm_api_key_id=COS_API_KEY_ID,
        ibm_service_instance_id=COS_INSTANCE_CRN,
        config=Config(signature_version="oauth"),
        endpoint_url=COS_ENDPOINT
    )

    with AsperaTransferManager(client) as transfer_manager:

        # Get object with Aspera
        future = transfer_manager.download(bucket_name, object_name, download_filename)

        # Wait for download to complete
        future.result()
'''

'''
get_buckets()
#create_bucket(bucket_2)
#create_text_file(bucket_2,file_1,"some OTHER text that should be in the file!")
get_bucket_contents(bucket_2)
get_item(bucket_2, file_1)
delete_item(bucket_2, file_1)
get_item(bucket_2, file_1)
'''

program_running = True

while program_running == True:
    #user_input = input("What would you like to do?")
    print("###########################################################")
    print("Welcome to a simple Python app that leverages the iCOS API!")
    print("What iCOS operation would you like to perform?")
    print("###########################################################")
    print('\n')
    print("1. Retrieve list of existing buckets")
    print("2. Create a new iCOS bucket")
    print("3. Create new file in existing bucket")
    print("4. Get bucket contents")
    print("5. Get item contents")
    print("6. Delete item")
    #print("7. Add protection to existing bucket")
    #print("8. Check protection level on existing bucket")
    print("\n")
    user_input = input("Select an option from the list above: ")

    if user_input == "1":
        print("\n")
        get_buckets()
        print("\n")
        user_input_1_2 = input("Press enter to return to main menu or type 'exit' to exit the program. ")
        print("\n")

        if user_input_1_2 == "":
            pass
            os.system("clear")
        elif user_input_1_2 == "exit":
            program_running = False
        else:
            pass
        
    elif user_input == "2":
        user_input_2 = input("Bucket name? ")
        create_bucket(user_input_2)
        user_input_2_2 = input("Press enter to return to main menu or type 'exit' to exit the program. ")

        if user_input_2_2 == "":
            pass
            os.system("clear")
        elif user_input_2_2 == "exit":
            program_running = False
        else:
            pass

        print("\n")

    elif user_input == "3":
        user_input_3_1 = input("Bucket name? ")
        user_input_3_2 = input("File name? ")
        user_input_3_3 = input("File contents? Press enter to retrive the file contents from a local file, otherwise enter the desired text. ")

        if user_input_3_3 == "":
            try:
                with open(user_input_3_2) as file:
                    user_input_3_3 = file.read()
            except:
                print("No local file found, please try again.")
                break

        create_text_file(user_input_3_1, user_input_3_2, user_input_3_3)

        user_input_3_4 = input("Press enter to return to main menu or type 'exit' to exit the program. ")

        if user_input_3_4 == "":
            pass
            os.system("clear")
        elif user_input_3_4 == "exit":
            program_running = False
        else:
            pass

        print("\n")

    elif user_input == "4":
        user_input_4_2 = input("Bucket name? ")
        get_bucket_contents(user_input_4_2)

        user_input_4_3 = input("Press enter to return to main menu or type 'exit' to exit the program. ")

        if user_input_4_3 == "":
            pass
            os.system("clear")
        elif user_input_4_3 == "exit":
            program_running = False
        else:
            pass

        print("\n")
    
    elif user_input == "5":
        user_input_5_2 = input("Bucket name? ")
        user_input_5_3 = input("File name? ")

        get_item(user_input_5_2, user_input_5_3)

        user_input_5_4 = input("Press enter to return to main menu or type 'exit' to exit the program. ")

        if user_input_5_4 == "":
            pass
            os.system("clear")
        elif user_input_5_4 == "exit":
            program_running = False
        else:
            pass

        print("\n")

    elif user_input == "6":
        user_input_6_2 = input("Bucket name? ")
        user_input_6_3 = input("File to delete? ")

        delete_item(user_input_6_2, user_input_6_3)

        user_input_6_4 = input("Press enter to return to main menu or type 'exit' to exit the program. ")

        if user_input_6_4 == "":
            pass
            os.system("clear")
        elif user_input_6_4 == "exit":
            program_running = False
        else:
            pass

        print("\n")

'''

    elif user_input == "7":
        user_input_7_2 = input("Bucket to add protection to? ")
        add_protection_configuration_to_bucket(user_input_7_2)

        user_input_7_3 = input("Press enter to return to main menu or type 'exit' to exit the program. ")

        if user_input_7_3 == "":
            pass
        elif user_input_7_3 == "exit":
            program_running = False
        else:
            pass

        print("\n")

    elif user_input == "8":
        user_input_8_2 = input("Bucket to check protection on? ")
        get_protection_configuration_on_bucket(user_input_8_2)

        user_input_8_3 = input("Press enter to return to main menu or type 'exit' to exit the program. ")

        if user_input_8_3 == "":
            pass
        elif user_input_8_3 == "exit":
            program_running = False
        else:
            pass

        print("\n")

    elif user_input == "9":
        user_input_9_2 = input("Bucket name? ")
        user_input_9_3 = input("Object name? ")
        user_input_9_4 = input("Path? ")
        user_input_9_5 = input("Retention period? ")

        upload_file_with_retention(user_input_9_2, user_input_9_3, user_input_9_4, user_input_9_5)

        user_input_9_6 = input("Press enter to return to main menu or type 'exit' to exit the program. ")

        if user_input_9_6 == "":
            pass
        elif user_input_9_6 == "exit":
            program_running = False
        else:
            pass

        print("\n")
'''