#!/bin/bash

cd /student/student$stdid/$w
echo " This script resets the HPE CP API Workshop content for:" student$stdid
# associated to studentXY.
##
echo "Setting  environment variables to help cleanup"
##
student="student$stdid" # your Jupyter Notebook student Identifier (i.e.: student<xx>)
username="demoadmin" # your HPE CP tenant login credentials - username 
password="CleanUpDISCO2020" # your HPE CP tenant login credentials - password
##
## fixed environment variables setup by the HPE CP lab administrator
##
controller_endpoint="gateway1.hpedevlab.net:8080"
gateway_host="gateway1.hpedevlab.net"
tenantname="K8sHackTenant"
k8sClusterId="1"  #this is the K8s Cluster Id provided by the HPE CP admisnistrator and assigned to your K8s tenant.
helloWorldApp="hello-world-app.yaml" # the application manifest you will deploy in this lab
tensorFlowApp="tensorflow-notebook-config-cluster.yaml" # the kubedirector application cluster configuration TensorFlow
echo "your operation context is:" $username "on tenant" $tenantname 


##Authenticate as a Tenant admin in the specified tenant:
sessionlocation=$(curl -k -i -s --request POST "https://${controller_endpoint}/api/v2/session" \
--header 'Accept: application/json' \
--header 'Content-Type: application/json' \
--data-raw '{
"name": "'"$username"'",
"password": "'"$password"'",
"tenant_name": "'"$tenantname"'"
}' | grep Location | awk '{print $2}' | tr -d '\r') #we remove any cr that might exist
echo "This is your session location: " $sessionlocation
SessionId=$(echo $sessionlocation | cut -d'/' -f 5) # extract sessionId for later, for logout
echo "This is your session_Id:" $SessionId

echo "Getting the Kubeconfig file for the student tenant working context:"
curl -k -s --request GET "https://${controller_endpoint}/api/v2/k8skubeconfig" \
--header "X-BDS-SESSION: $sessionlocation" \
--header 'Accept: application/json' \
--header 'Content-Type: application/json' > ${student}_kubeconfig
cat ${student}_kubeconfig

echo "Define the Kubeconfig file as a shell environment variable:"
##define the Kubeconfig file as a shell environment variable to tell kubectl where to look for the kubeconfig file
export KUBECONFIG="${student}_kubeconfig"
echo $KUBECONFIG

echo "Verifying the working tenant context:"
kubectl config current-context


echo "Deleting Hello-world and tensorFlow applications"
##-1- Delete Hello World containerized applications:
##Verifying if there is any hello-world app resources. A result of : 1 means no PODs left for hello-world apps.
kubectl get pod | grep hello-world

##Depending on the output of the command, you may want to delete leftover K8s resources for hello-world applications.
echo "Cleanup student$i - Hello-world app"
sed -i "s/example/student$stdid/g" $helloWorldApp
#cat $helloWorldApp
kubectl delete -f $helloWorldApp
echo "reset YAML file after cleanup of student$i"
sed -i "s/${username}/example/g" $helloWorldApp
#cat $helloWorldApp
kubectl get pod | grep hello-world

##-2- Delete kubedirectorapp Tensorflow instances:
##Verifying if there is any kubedirectorapp instances.
kubectl get kubedirectorcluster | grep tensorflow

##Depending on the output of the command, you may want to delete leftover K8s resources for TensorFlow applications.
echo "Cleanup student$stdid - TensorFlow app"
sed -i "s/example/student$stdid/g" $tensorFlowApp
#cat $tensorFlowApp
kubectl delete -f $tensorFlowApp
echo "reset YAML file after cleanup of student$stdid"
sed -i "s/${username}/example/g" $tensorFlowApp
#cat $tensorFlowApp
kubectl get kubedirectorcluster | grep tensorflow

##Close the login session
echo "logging out"

curl -k -i -s --request DELETE "https://${controller_endpoint}/api/v2/session/${SessionId}" \
--header "X-BDS-SESSION: $sessionlocation" \
--header 'Accept: application/json' \
--header 'Content-Type: application/json'
###The status 204 No Content means the session object has been deleted.

echo "Deleting the kubeconfig file"
sudo rm ${student}_kubeconfig