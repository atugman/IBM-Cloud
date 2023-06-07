#!/bin/bash
sudo apt -y update
sudo apt -y install apache2
cd /var/www/html
rm index.html
#touch index.html
apt -y install python3-pip
pip3 install flask
touch server.js
mkdir templates
touch index.html
mv index.html ./templates
hostname > inst_name.txt
hostname -i > ip.txt
sed 's/\s.*$//' ip.txt > ip_trimmed.txt
export inst_name=`cat inst_name.txt`
export ip=`cat ip_trimmed.txt`