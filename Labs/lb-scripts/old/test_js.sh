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
echo "<head>
<title>Load Balancer Lab</title>
</head>
<body>
Traffic is hitting @@inst_name.txt@@ at @@ip_trimmed.txt@@" > index.html


cat <<EOF > index.html
<head>
<title>Load Balancer Lab</title>
</head>
<body>
Traffic is hitting: <div class="span6">$(<inst_name.txt) at $(<ip_trimmed.txt)</div>

    <form action="" id="webForm">
        <h1></h1>
        <input type="text" id="digit" class="form-control" placeholder="Enter a single digit 0-9"><br>
        <h1></h1>
        <button type="submit">Submit</button>
      </form>
    <div id="my-div"></div>
    <div id="test-div"></div>

    <script>

        var checker = sessionStorage.getItem("digit")

        if (checker) {
            document.getElementById("my-div").innerHTML = "The current stored value is: " + checker
        }
        console.log(sessionStorage.getItem("digit"))

        let webForm = document.getElementById("webForm");

        webForm.addEventListener("submit", (e) => {
        e.preventDefault();

        let digit = document.getElementById("digit");

        if (digit.value.length > 1) {
            alert("Ensure your input is only a single digit!");
        } else {

        document.getElementById("my-div").innerHTML = "The current stored value is: " + digit.value

            sessionStorage.setItem("digit", digit.value);

            console.log(sessionStorage.getItem("digit"))
            digit.value = "";
        }
        });
    </script>
</body>
EOF