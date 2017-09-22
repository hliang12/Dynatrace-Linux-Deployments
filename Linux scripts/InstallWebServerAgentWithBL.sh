#!/bin/bash
DATE_WITH_TIME=`date "+[%d/%m/%Y %H:%M:%S]"`
touch  /opt/deploy.log
echo $DATE_WITH_TIME "Starting Installation of Dynatrace Agent MSI"

#DTHOME=$1
#VERSION=$2
#bit = $3

[ -z $1 ] && echo $DATE_WITH_TIME "Dthome directory is missing"
[ -z $2 ] && echo $DATE_WITH_TIME "Agent Version is missing"
[ -z $3 ] && echo $DATE_WITH_TIME ""


echo $DATE_WITH_TIME  "DT installation location is $DTHOME"

## tar them 

tar -xvf /opt/dynatrace-wsagent*.tar 

if [ $? -eq 0 ]; then
	echo $DATE_WITH_TIME "Untar web server agent file successful" | tee deploy.log
else 
	echo $DATE_WITH_TIME "Failed to untar web server agent file, exit code "$?"" | tee deploy.log
	exit
fi

echo $DATE_WITH_TIME "Making Dynatrace Web Server install script executable" | tee deploy.log
## make the run script executable

chmod +rx dynatrace-ws*.sh 

if [ $? -eq 0 ]; then
	echo $DATE_WITH_TIME "Untar web server agent file successful" | tee deploy.log
else 
	echo $DATE_WITH_TIME "Failed to untar web server agent file, exit code "$?"" | tee deploy.log
	exit
fi

echo $DATE_WITH_TIME "Running dynatrace web server agent install script" | tee deploy.log

## run the execution script
sh dynatrace-ws*.sh 

if [ $? -eq 0 ]; then
	echo $DATE_WITH_TIME "Ran dynatrace web server agent install script successfully" | tee deploy.log
else 
	echo $DATE_WITH_TIME "Failed to run web server agent install script, exit code "$?"" | tee deploy.log
	exit
fi


## copy dynatrace web server agent service to /etc/init.d

cp $1/dynatrace-$2/init.d/dynaTraceWebServerAgent /etc/init.d

echo $DATE_WITH_TIME "Installed okay if no errors"






