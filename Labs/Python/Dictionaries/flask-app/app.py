from flask import Flask, render_template, request, redirect, url_for
import ibm_boto3
from ibm_botocore.client import Config, ClientError
import json
import os

app = Flask(__name__)

students = []

COS_API_KEY_ID = os.environ['TF_VAR_api_key']
COS_INSTANCE_CRN = 'crn:v1:bluemix:public:cloud-object-storage:global:a/475b3414ebd44f2caf3deccbd12a1640:e811eb25-7750-4c74-8f86-c3901b2eb304::'
cos_auth_endpoint = 'https://iam.cloud.ibm.com/identity/token'
COS_ENDPOINT = 'https://s3.us-south.cloud-object-storage.appdomain.cloud'#'YOUR_COS_ENDPOINT'
cos_bucket_name = 'python-app-storage-bucket'
#cos_client_config = Config(signature_version='iam')

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
    except Exception as e:
        print("Unable to retrieve list buckets: {0}".format(e))
#get_buckets()

def get_item(bucket_name, item_name):
    print("Retrieving item from bucket: {0}, key: {1}".format(bucket_name, item_name))
    try:
        file = cos.Object(bucket_name, item_name).get()
        #file = dict(file) # don't delte
        student_data = json.loads(file['Body'].read())
        print(student_data)
        return student_data
        return format(file["Body"].read()).strip("b'")
        #return format(file["Body"].read())
    except ClientError as be:
        print("CLIENT ERROR: {0}\n".format(be))
    except Exception as e:
        print("Unable to retrieve file contents: {0}".format(e))
students = get_item("python-app-storage-bucket","data.json")
print('1:',students)

#download = cos.download_file('python-app-storage-bucket',COS_API_KEY_ID,'data.json')
#print(download)

students_2 = [ 
    {"name": "Student 1", "scores": [0, 0, 0, 0, 0]},
    {"name": "Student 2", "scores": [0, 0, 0, 0, 0]},
    {"name": "Student 3", "scores": [0, 0, 0, 0, 0]},
    {"name": "Student 4", "scores": [0, 0, 0, 0, 0]},
    {"name": "Student 5", "scores": [0, 0, 0, 0, 0]}
]

print('2:',students_2)

'''
def fetch_student_data():
    cos_api_key_id = os.environ['TF_VAR_api_key']
    cos_instance_crn = 'crn:v1:bluemix:public:cloud-object-storage:global:a/475b3414ebd44f2caf3deccbd12a1640:e811eb25-7750-4c74-8f86-c3901b2eb304::'
    cos_auth_endpoint = 'https://iam.cloud.ibm.com/identity/token'
    cos_endpoint = 'https://s3.us-south.cloud-object-storage.appdomain.cloud'#'YOUR_COS_ENDPOINT'
    cos_bucket_name = 'python-app-storage-bucket'
    #cos_client_config = Config(signature_version='iam')

    cos = ibm_boto3.resource('s3',
        ibm_api_key_id=cos_api_key_id,
        ibm_service_instance_id=cos_instance_crn,
        ibm_auth_endpoint=cos_auth_endpoint,
        #config=cos_client_config,
        config=Config(signature_version="oauth"),
        endpoint_url=cos_endpoint)

    try:
        #buckets = cos.buckets.all()
        #print(buckets)
        #files = cos.Bucket(cos_bucket_name).objects.all()
        #print('files:',files)
        obj = cos.get_object(Bucket=cos_bucket_name, Key='data.json')
        student_data = json.loads(obj['Body'].read())
        return student_data
    except Exception as e:
        print(f"Error fetching student data from COS: {e}")
        return []
'''
# Fetch initial student data from COS
#students = fetch_student_data()

def calculate_average(scores):
    print("scores here:",scores)
    send_scores("python-app-storage-bucket","data.json")
    return sum(scores) / len(scores)

@app.context_processor
def utility_processor():
    return dict(calculate_average=calculate_average)

@app.route("/")
def index():
    return render_template("index.html", students=students)

@app.route("/update_scores", methods=["POST"])
def update_scores():
    for student in students:
        for i in range(5):
            score = int(request.form[f"score_{student['name']}_{i+1}"])
            student["scores"][i] = score
    return redirect(url_for("index"))

def send_scores(bucket_name,item_name):
    print('sending scores:',students)
    #print("Creating new item: {0}".format(item_name))
    #with open('mydata.json', 'w') as outfile:
    #    json.dump(students, outfile)
    try:
        body = json.dumps(students)
        #body = str(body)
        cos.Object(bucket_name, item_name).put(
            #Body=str(students) # don't delete
            Body = str(body)
        )
        print("Item: {0} created!".format(item_name))
    except ClientError as be:
        print("CLIENT ERROR: {0}\n".format(be))
    except Exception as e:
        print("Unable to create text file: {0}".format(e))

#def upload_file():
#    cos.upload_file(Filename='mydata.json',Bucket=credentials['BUCKET'],Key='nice_data.json')

if __name__ == "__main__":
    app.run(debug=True)