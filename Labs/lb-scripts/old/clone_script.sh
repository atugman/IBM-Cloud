#!/bin/bash
# only works on nodes w/ external connectivity
sudo apt -y update
sudo apt -y install apache2
cd /var/www/html
rm index.html
touch index.html
hostname > inst_name.txt
hostname -i > ip.txt
sed 's/\s.*$//' ip.txt > ip_trimmed.txt
export inst_name=`cat inst_name.txt`
export ip=`cat ip_trimmed.txt`
git clone https://github.com/atugman/IBM-Cloud.git
cp ./IBM-Cloud/Labs/lb-scripts/index.html .