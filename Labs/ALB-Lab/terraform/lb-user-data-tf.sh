#!/bin/bash
sudo apt -y update
sudo apt -y install apache2
sudo apt -y install stress 
cd /var/www/html
rm index.html
touch index.html
hostname > inst_name.txt
echo "10.240.64." > ip.txt
a=`ip a`
echo $a | grep -o -P '(?<=10.240.64.).*(?=/28)' > ip.txt
sed 's/\s.*$//' ip.txt > ip_trimmed.txt
export inst_name=`cat inst_name.txt`
export ip=`cat ip_trimmed.txt`
echo $(( $RANDOM % 50 + 1 )) > random_number.txt
export random_number=`cat random_number.txt`
cat <<EOF > index.html
<head>
    <title>Load Balancer Lab!</title>
    </head>
    <body>
    <div>Traffic is hitting <b>${inst_name}</b> at <b>${ip}!</b></div>
    <div>The current stored value is <b>${random_number}</b></div>
    <form action="" id="webForm">
        <h1></h1>
        <input type="text" id="digit" class="form-control" placeholder="Enter a single digit 0-9"><br>
        <h1></h1>
        <button type="submit">Submit</button>
      </form>
    <div id="my-div"></div>
    <script>
        var checker = sessionStorage.getItem("digit")
        if (checker) {
            document.getElementById("my-div").innerHTML = "The current session value is: " + checker
        }
        console.log(sessionStorage.getItem("digit"))
        let webForm = document.getElementById("webForm");
        webForm.addEventListener("submit", (e) => {
        e.preventDefault();
        let digit = document.getElementById("digit");
        if (digit.value.length > 1) {
            alert("Ensure your input is only a single digit!");
        } else {
            document.getElementById("my-div").innerHTML = "The current session value is: " + digit.value
            sessionStorage.setItem("digit", digit.value);
            console.log(sessionStorage.getItem("digit"))
            digit.value = "";
        }
        });
    </script>
</body>
EOF