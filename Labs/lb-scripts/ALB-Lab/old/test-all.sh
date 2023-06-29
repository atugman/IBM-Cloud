#!/bin/bash
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
echo "<head>
<title>Load Balancer Lab</title>
</head>
<body>
Traffic is hitting <b>${inst_name}</b> at <b>${ip}</b>
</body>" > index.html