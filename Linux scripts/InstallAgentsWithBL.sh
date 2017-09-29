#!/bin/bash


#####
##### This script is a duplicated of InstallAgent.sh  with slighty modifications - this script will assume that you have followed the steps in BL and transfered the installer 
##### It will then go and unpackage that intsaller
#####

DATE_WITH_TIME=`date "+[%d/%m/%Y %H:%M:%S]"`
touch  /opt/deploy.log
echo $DATE_WITH_TIME "Starting Installation of Dynatrace Agent MSI"


#DTHOME=$1
#VERSION=$2
#bit = $3

[ -z $1 ] && echo $DATE_WITH_TIME "DTHOME argument is missing"
[ -z $2 ] && echo $DATE_WITH_TIME "Agent version is missing"



echo $DATE_WITH_TIME  "DT installation location is ${DTHOME}"

echo $DATE_WITH_TIME "Starting to run the installer"

## get absolute path of java binaries 

JAVAHOME="$(which java)"

#java -jar /opt/dynatrace-agent*.jar -t $1 -y

## unjar dynatrace installer 

${JAVAHOME} -jar  /opt/dynatrace-agent*.jar -t $1 -y

if [ $? -eq 0 ]; then
	echo $DATE_WITH_TIME "Untar web server agent file successful" | tee /opt/deploy.log
else 
	echo $DATE_WITH_TIME "Failed to jar web server agent file, exit code "$?"" | tee /opt/deploy.log
	exit
fi

echo $DATE_WITH_TIME "Finished installation if no errors" | tee /opt/deploy.log






