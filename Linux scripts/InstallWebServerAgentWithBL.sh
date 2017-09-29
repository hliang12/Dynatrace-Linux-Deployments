#!/bin/bash
DATE_WITH_TIME=`date "+[%d/%m/%Y %H:%M:%S]"`
touch  /opt/deploy.log



#####
##### This script is a duplicated of InstallWebServerAgent.sh  with slighty modifications - this script will assume that you have followed the steps in BL and transfered the installer 
##### It will then go and unpackage that intsaller
#####

echo $DATE_WITH_TIME "Starting Installation of Dynatrace Agent MSI"

#DTHOME=$1
#VERSION=$2


[ -z $1 ] && echo $DATE_WITH_TIME "Dthome directory is missing"
[ -z $2 ] && echo $DATE_WITH_TIME "Agent Version is missing"



echo $DATE_WITH_TIME  "DT installation location is $DTHOME"

## ## get tar binaries
TARHOME="$(which tar)"

## untar the dynatrace ws tar file
${TARHOME} -xvf /opt/dynatrace-wsagent*.tar 

#tar -xvf /opt/dynatrace-wsagent*.tar 

if [ $? -eq 0 ]; then
	echo $DATE_WITH_TIME "Untar web server agent file successful" | tee /opt/deploy.log
else 
	echo $DATE_WITH_TIME "Failed to untar web server agent file, exit code "$?"" | tee /opt/deploy.log
	exit
fi

echo $DATE_WITH_TIME "Making Dynatrace Web Server install script executable" | tee /opt/deploy.log
## make the run script executable

chmod +rx /opt/dynatrace-ws*.sh 

if [ $? -eq 0 ]; then
	echo $DATE_WITH_TIME "Untar web server agent file successful" | tee /opt/deploy.log
else 
	echo $DATE_WITH_TIME "Failed to untar web server agent file, exit code "$?"" | tee /opt/deploy.log
	exit
fi

echo $DATE_WITH_TIME "Running dynatrace web server agent install script" | tee /opt/deploy.log

## run the execution script
sh /opt/dynatrace-ws*.sh 

if [ $? -eq 0 ]; then
	echo $DATE_WITH_TIME "Ran dynatrace web server agent install script successfully" | tee /opt/deploy.log
else 
	echo $DATE_WITH_TIME "Failed to run web server agent install script, exit code "$?"" | tee /opt/deploy.log
	exit
fi


## copy dynatrace web server agent service to /etc/init.d

cp $1/init.d/dynaTraceWebServerAgent /etc/init.d

echo $DATE_WITH_TIME "Installed okay if no errors"






