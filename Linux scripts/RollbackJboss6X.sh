#!/bin/bash 


#$JBOSSDIR=$1

touch Rollback.log
DATE_WITH_TIME=`date "+[%d/%m/%Y %H:%M:%S]"`
## start rollback for tomcat 
[ -z $1 ] && echo $DATE_WITH_TIME "jboss directory missing missing" | tee Rollback.log | exit 1 ## tomcat directory


### need path for tomcat? otherwise have to recursively go find it 
#### need a check for setenv.sh if not then create one 

echo $DATE_WITH_TIME "Removing DTHOME" | tee Rollback.log | exit 1
sed -i -e "/JAVA_OPTS=\"\$JAVA_OPTS -agentpath:.*/d" $1/bin/run.conf 


if grep -q "JAVA_OPTS=\"\$JAVA_OPTS -agentpath:" $1/bin/run.conf; then
			#found
		echo $DATE_WITH_TIME "Successfully removed agent configuration" | tee -a Rollback.log
else 
			#not found
		echo $DATE_WITH_TIME "Failed to remove agent configuration" | tee -a Rollback.log
		echo $DATE_WITH_TIME "Exiting script" | tee -a Rollback.log
		exit 1
fi



echo $DATE_WITH_TIME "Finihsed if no errors" | tee Rollback.log | exit 1
### restart jboss 

