#!/bin/bash

#apachedir=$1

touch /opt/Rollback.log ## Create a rollback log 
DATE_WITH_TIME=`date "+[%d/%m/%Y %H:%M:%S]"`
## start rollback for tomcat

## check if required variables have been inputted 
[ -z $1 ] && echo $DATE_WITH_TIME "tomcat directory missing missing" | tee /opt/Rollback.log | exit 1 


echo $DATE_WITH_TIME "Rollback Apache " | tee /opt/Rollback.log 
echo $DATE_WITH_TIME "Removing module from httpd.conf" | tee /opt/Rollback.log 

## remove the agent configuration 
sed -i -e "/LoadModule dtagent.*/d" "$1"/httpd.conf

## check if the sed command has removed it 
if ! grep -q "LoadModule dtagent" $1/bin/setenv.sh; then
			#found
		echo $DATE_WITH_TIME "Successfully removed agent configuration" | tee -a /opt/Rollback.log
else 
			#not found
		echo $DATE_WITH_TIME "Failed to remove agent configuration" | tee -a /opt/Rollback.log
		echo $DATE_WITH_TIME "Exiting script" | tee -a /opt/Rollback.log
		exit 1
fi

#echo $DATE_WITH_TIME "Removing agent node name from httpd.conf" | tee /opt/Rollback.log 
#sed -i -e "/ApacheNodeName.*/d" "$1"/httpd.conf


echo $DATE_WITH_TIME "Finished rollback if no errors" | tee /opt/Rollback.log 
