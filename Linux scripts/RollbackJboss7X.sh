#!/bin/bash 


#$JBOSSDIR=$1

touch /opt/Rollback.log
DATE_WITH_TIME=`date "+[%d/%m/%Y %H:%M:%S]"`
## start rollback for tomcat 
[ -z $1 ] && echo $DATE_WITH_TIME "jboss directory missing missing" | tee Rollback.log | exit 1 
[ -z $2 ] && echo $DATE_WITH_TIME "missing mode that jboss 7 is running in" | tee Rollback.log | exit 1 

if [ -d "$1" ]; then 

	if [ $2 = "standalone" ]; then 
	
	echo $DATE_WITH_TIME "Removing Dynatrace agent configuration from standalone.conf" | tee Rollback.log | exit 1
	sed -i -e "/JAVA_OPTS=\"\$JAVA_OPTS -agentpath:.*/d" $1/bin/standalone.conf

	if ! grep -q "JAVA_OPTS=\"\$JAVA_OPTS -agentpath:" $1/bin/standalone.conf; then
			#found
			echo $DATE_WITH_TIME "Successfully removed agent configuration" | tee -a Rollback.log
	else 
			#not found
			echo $DATE_WITH_TIME "Failed to remove agent configuration" | tee -a Rollback.log
			echo $DATE_WITH_TIME "Exiting script" | tee -a Rollback.log
			exit 1
	fi
	
	elif [ $2 = "domain" ]; then 
		
		echo $DATE_WITH_TIME "Removing Dynatrace agent configuration from domain.xml" | tee Rollback.log | exit 1
		sed -i -e "/<option value=\"-agentpath:.*/d" $1/domain/configuration/domain.xml

		if ! grep -q "<option value=\"-agentpath:" $1/domain/configuration/domain.xml; then
			#found
				echo $DATE_WITH_TIME "Successfully removed agent configuration" | tee -a Rollback.log
		else 
			#not found
				echo $DATE_WITH_TIME "Failed to remove agent configuration" | tee -a Rollback.log
				echo $DATE_WITH_TIME "Exiting script" | tee -a Rollback.log
				exit 1
		fi
	
	else 
		
		echo $DATE_WITH_TIME "Invalid mode input value, exiting" | tee Rollback.log | exit 1 
	
	fi

else 

	echo $DATE_WITH_TIME "Jboss directory does not exist, exiting" | tee Rollback.log | exit 1 

fi 

echo $DATE_WITH_TIME "Finihsed if no errors" | tee Rollback.log | exit 1
### restart jboss 

