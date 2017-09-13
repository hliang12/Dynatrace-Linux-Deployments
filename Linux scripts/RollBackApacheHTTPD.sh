#!/bin/bash

#jbossdir=$1

touch Rollback.log

## start rollback for tomcat
[ -z $1 ] && echo "tomcat directory missing missing" | tee Rollback.log exit exit 1 ## tomcat directory

### need path for tomcat? otherwise have to recursively go find it
#### need a check for setenv.sh if not then create one
echo "Rollback Apache " | tee Rollback.log 
echo "Removing module from httpd.conf" | tee Rollback.log 
sed -i -e "/LoadModule dtagent.*/d" "$1"/httpd.conf
#echo "Removing agent node name from httpd.conf" | tee Rollback.log 
#sed -i -e "/ApacheNodeName.*/d" "$1"/httpd.conf


echo "Finished rollback if no errors" | tee Rollback.log 
