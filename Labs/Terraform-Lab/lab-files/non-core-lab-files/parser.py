import os

with open(r'bad_.tf', 'r') as infile, \
     open(r'bad.tf', 'w') as outfile:
    data = infile.read()
    data = data.replace("[1m[0m", "")
    data = data.replace("[0m[0m", "")
    data = data.replace("[0m", "")
    outfile.write(data)

os.system("rm bad_.tf")