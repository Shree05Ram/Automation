# AiConTest
This repo is used to create a test environment that would contain large number of devices.

## Steps:
1. Clone this repository:
2. Download the targz distribution of any AiAgent. Click [here](https://packages.aikaan.io/targz/aiagent/alchemy/) to browse through the page and downlaod the necessary version of agent.
3. Untar it and put it in *scale/AgentDocker/Patch* directory.
4. Download the config tar file from the controller. The template URL is https://{SERVER_NAME}/api/img/v1/user/{USERID}/dgp/{PROFILEID}/fwdocker
Ex: To download the config tar file from test.aikaan.io with the user admin from the default DGP the URL would be: https://test.aikaan.io:443/api/img/v1/user/dc457ca7-de12-412c-b750-9f88103aa6a1/dgp/e626bdec-343a-47ee-ac3b-663194a25a77/fwdocker . 
Untar the file and put it in *scale/AgentDocker/Patch/opt/aikaan/etc* directory.
5. Open *scale/AgentDocker/Patch/opt/aikaan/etc/telegraf.tmpl.conf* and remove ```go_phery```  configurations.
6. Go to *scale/ScaleOrch* directory and run ```make``` command.
7. Note that the *ScaleOrch* binary file is generated. Now run ```./ScaleOrch -n <No of Instances>```. (Ex: ```./ScaleOrch -n 50```) to create the number of instances.
