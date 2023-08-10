import ibm_boto3
from ibm_botocore.client import Config, ClientError
import os
import gzip

# gets file contents of items a bucket
# added break at the end so it will only pull the first item, remove as needed

path = "/Users/andrewtugman/Documents/icos_python_constants/icos_2.txt"

file = open(path)

with open(path) as f:
    data = f.readlines()

# Populate accordingly
COS_ENDPOINT = data[0].strip()
COS_API_KEY_ID = data[1].strip()
COS_INSTANCE_CRN = data[2].strip()
COS_BUCKET_LOCATION = data[3].strip()

cos = ibm_boto3.resource("s3",
    ibm_api_key_id=COS_API_KEY_ID,
    ibm_service_instance_id=COS_INSTANCE_CRN,
    config=Config(signature_version="oauth"),
    endpoint_url=COS_ENDPOINT
)

items = []

def get_buckets():
    print("Retrieving list of buckets")
    all_buckets = []
    try:
        buckets = cos.buckets.all()
        for bucket in buckets:
            print("Bucket Name: {0}".format(bucket.name))
            all_buckets.append(bucket.name)
            print(bucket.name)
        return all_buckets
    except ClientError as be:
        print("CLIENT ERROR: {0}\n".format(be))
    except Exception as e:
        print("Unable to retrieve list buckets: {0}".format(e))

def get_bucket_contents(bucket_name):
    print("Retrieving bucket contents from: {0}".format(bucket_name))
    all_files = []
    try:
        files = cos.Bucket(bucket_name).objects.all()
        for file in files:
            #print("Item: {0} ({1} bytes).".format(file.key, file.size))
            all_files.append(file.key)
        return all_files
    except ClientError as be:
        print("CLIENT ERROR: {0}\n".format(be))
    except Exception as e:
        print("Unable to retrieve bucket contents: {0}".format(e))

def get_item(bucket_name, item_name):
    print("Retrieving item from bucket: {0}, key: {1}".format(bucket_name, item_name))
    try:
        file = cos.Object(bucket_name, item_name).get()
        #file = str(file)
        #f=gzip.open(file,'rb')
        #file_content=f.read()
        return file
        #print("File Contents: {0}".format(file["Body"].read()))
    except ClientError as be:
        print("CLIENT ERROR: {0}\n".format(be))
    except Exception as e:
        print("Unable to retrieve file contents: {0}".format(e))

buckets = get_buckets()
print(buckets)
bucket_contents = get_bucket_contents(buckets[0])


for file in bucket_contents:
    ind_file_contents = get_item(buckets[0], file)
    parsed = ind_file_contents['Body'].__dict__['_raw_stream'].__dict__
    print(parsed)
    # _connection #_pool #_request_url#_original_response
    break


#get_item(bucket_name, items[0][1])
#test_file = get_item(bucket_name, item_name)

#print(type(get_item(bucket_name, item_name)))

#split = test_file.split("'")
#print(test_file)