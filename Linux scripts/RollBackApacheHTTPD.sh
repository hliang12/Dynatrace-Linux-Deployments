#!/bin/bash

#apachedir=$1

touch /opt/Rollback.log
DATE_WITH_TIME=`date "+[%d/%m/%Y %H:%M:%S]"`
## start rollback for tomcat
[ -z $1 ] && echo $DATE_WITH_TIME "tomcat directory missing missing" | tee Rollback.log | exit 1 ## tomcat directory

#### need a check for setenv.sh if not then create one
echo $DATE_WITH_TIME "Rollback Apache " | tee Rollback.log 
echo $DATE_WITH_TIME "Removing module from httpd.conf" | tee Rollback.log 
sed -i -e "/LoadModule dtagent.*/d" "$1"/httpd.conf

if grep -q "LoadModule dtagent" $1/bin/setenv.sh; then
			#found
		echo $DATE_WITH_TIME "Successfully removed agent configuration" | tee -a Rollback.log
else 
			#not found
		echo $DATE_WITH_TIME "Failed to remove agent configuration" | tee -a Rollback.log
		echo $DATE_WITH_TIME "Exiting script" | tee -a Rollback.log
		exit 1
fi

#echo $DATE_WITH_TIME "Removing agent node name from httpd.conf" | tee Rollback.log 
#sed -i -e "/ApacheNodeName.*/d" "$1"/httpd.conf


echo $DATE_WITH_TIME "Finished rollback if no errors" | tee Rollback.log 
