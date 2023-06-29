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
echo $(( $RANDOM % 50 + 1 )) > random_number.txt
export random_number=`random_number.txt`
cat <<EOF > index.html
<head>
    <title>Load Balancer Lab!</title>
    </head>
    <body>
    Traffic is hitting <b>${inst_name}</b> at <b>${ip}!</b>
    
    <form action="" id="webForm">
        <h1></h1>
        <input type="text" id="digit" class="form-control" placeholder="Enter a single digit 0-9"><br>
        <h1></h1>
        <button type="submit">Submit</button>
      </form>
    <div id="my-div"></div>
    <div id="test-div"></div>

    <script src="ip_trimmed.txt"></script>
    <script>

        var ip = document.getElementById("ip_addr").src
        console.log(ip,'ip')
        var ip_val = ip.value
        console.log(ip_val)
        var str = ip.split(">").pop();
        console.log(str,'str')
        str.split('<')[0]
        console.log(str,'str2')
        var checker = sessionStorage.getItem({str})
        console.log(str,'final')

    </script>

</body>
EOF