#!/bin/bash

#DTHOME=$1
DATE_WITH_TIME=`date "+[%d/%m/%Y %H:%M:%S]"`
touch  /opt/Rollback.log ## Create a rollback log 

##Check if variables are have been inputted 
[ -z $1 ] && echo $DATE_WITH_TIME "dthome directory is missing" | tee /opt/Rollback.log | exit 1

echo $DATE_WITH_TIME "Checking for dynaTraceWebServerAgent service in init.d" | tee /opt/Rollback.log |exit 1

## check if the web server agent service exists, if it does then remove it from /etc/init.d
if [ -e /etc/init.d/dynaTraceWebServerAgent.service ]; then
		echo $DATE_WITH_TIME "Removing dynaTraceWebServerAgent service" | tee /opt/Rollback.log | exit 1
        rm /etc/init.d dynaTraceWebServerAgent.*
fi

## check if the dthome location exists, if it does remove 
echo $DATE_WITH_TIME "Checking if dthome directory exists" | tee /opt/Rollback.log | exit 1
if [ -d $1 ]; then
		echo $DATE_WITH_TIME "Removing DTHOME" | tee /opt/Rollback.log | exit 1
        rm -r $1
fi
echo $DATE_WITH_TIME "Finished removing dynatrace if no errors" | tee /opt/Rollback.log | exit 1