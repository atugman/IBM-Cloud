# Note that this script uses local files in a ./Downloads folder
# Please replace this path several places in the script below before reusing

printf "\nTask 1: Set the COS region to us-south."
read -p ""
echo 'RUN CMD: ibmcloud cos config region --region "us-south"'
read -p ""
ibmcloud cos config region --region "us-south"

read -p ""
printf "\nTask 2: Retrieve the Cloud Resource Name (CRN) for the COS service instance COS-L3-service.\n"
read -p ""
echo 'RUN CMD: ibmcloud resource service-instance COS-L3-service -id'
read -p ""
ibmcloud resource service-instance COS-L3-service -id

read -p ""
printf "\nTask 3: Set Cloud Resource Name (CRN) for the COS CLI configuration to the COS service instance CRN.\n"
read -p ""
echo 'RUN CMDs: ibmcloud cos config crn -crn `ibmcloud resource service-instance COS-L3-service -id -q | cut -f1 -d' '`'
read -p ""
ibmcloud cos config crn -crn `ibmcloud resource service-instance COS-L3-service -id -q | cut -f1 -d' '`
read -p ""

read -p ""
printf "\nTask 4: Verify CRN and region are set in COS CLI configuration.\n"
read -p ""
echo 'RUN CMD: ibmcloud cos config list'
read -p ""
ibmcloud cos config list
read -p ""

read -p ""
printf "\nTask 5: List all the buckets in the COS service instance.\n"
read -p ""
echo 'RUN CMD: ibmcloud cos buckets'
read -p ""
ibmcloud cos buckets
read -p ""

read -p ""
printf "\nTask 6: List the current content of a bucket.\n"
read -p ""
echo 'RUN CMD: ibmcloud cos objects -bucket cos-l3-with-retention'
read -p ""
ibmcloud cos objects -bucket cos-l3-with-retention
read -p ""

read -p ""
printf "\nTask 7: Upload a file to the COS bucket.\n"
read -p ""
echo 'RUN CMD: ibmcloud cos object-put -bucket cos-l3-with-retention -key at123-check5.jpg -body ./Downloads/at123-check5.jpg'
read -p ""
ibmcloud cos object-put -bucket cos-l3-with-retention -key at123-check5.jpg -body ./Downloads/at123-check5.jpg
read -p ""

read -p ""
printf "\nTask 8: Try uploading the same file again.\n"
read -p ""
echo 'RUN CMD: ibmcloud cos object-put -bucket cos-l3-with-retention -key at123-check5.jpg -body ./Downloads/at123-check5.jpg'
read -p ""
ibmcloud cos object-put -bucket cos-l3-with-retention -key at123-check5.jpg -body ./Downloads/at123-check5.jpg
read -p ""

read -p ""
printf "\nTask 9: Try to download the object.\n"
read -p ""
echo 'RUN CMD: ibmcloud cos object-get -bucket cos-l3-with-retention -key at123-check5.jpg'
read -p ""
ibmcloud cos object-get -bucket cos-l3-with-retention -key at123-check5.jpg
read -p ""

read -p ""
printf "\nTask 10: Try to delete the object, enter y when prompted.\n"
read -p ""
echo 'RUN CMD: ibmcloud cos object-delete -bucket cos-l3-with-retention -key at123-check5.jpg'
read -p ""
ibmcloud cos object-delete -bucket cos-l3-with-retention -key at123-check5.jpg
read -p ""
