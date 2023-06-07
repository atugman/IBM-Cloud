#!/bin/bash
sudo apt -y update
sudo apt -y install apache2
cd /var/www/html
rm index.html
touch index.html
hostname > inst_name.txt
hostname -i > ip.txt
sed 's/\s.*$//' ip.txt > ip_trimmed.txt
inst_name=`cat inst_name.txt` # export?
ip=`cat ip_trimmed.txt`

cat <<EOF > index.html
<head>
<title>Load Balancer Lab</title>
</head>
<body>
Traffic is hitting: <div class="span6">$(<inst_name.txt) at $(<ip_trimmed.txt)</div>
EOF