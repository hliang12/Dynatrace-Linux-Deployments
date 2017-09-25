#!/bin/bash 

#$TOMCATDIR=$1
#$Version7=$2

touch /opt/Rollback.log ## Create a rollback log 
DATE_WITH_TIME=`date "+[%d/%m/%Y %H:%M:%S]"`
## start rollback for tomcat 

## check if required variables have been inputted 
[ -z $1 ] && echo $DATE_WITH_TIME "TomCat directory missing missing" | tee -a Rollback.log | exit 1 ## tomcat directory
[ -z $2 ] && echo $DATE_WITH_TIME "Is version 7 boolean has not been inputted" | tee -a Rollback.log | exit 1 ## tomcat directory

echo $DATE_WITH_TIME "Checking which version of tomcat has been inputted in" | tee -a Rollback.log 

## checks if rolling back for version 7 or not. "true" if version 7 
if [ "$2" = "true" ]; then

	echo $DATE_WITH_TIME "Rollback for Tomcat 7" | tee -a Rollback.log 
	echo $DATE_WITH_TIME "Removing agent path from setenv.sh" | tee -a Rollback.log 
	
	## remove the agent configuration 
	sed -i -e "/export CATALINA_OPTS=\"-agentpath:.*/d" "$1"/bin/setenv.sh
	
	## check if the sed command has removed it 
	if grep -q "export CATALINA_OPTS=\"-agentpath:" $1/bin/setenv.sh; then
			#found
		echo $DATE_WITH_TIME "Successfully removed agent configuration" | tee -a Rollback.log
	else 
			#not found
		echo $DATE_WITH_TIME "Failed to remove agent configuration" | tee -a Rollback.log
		echo $DATE_WITH_TIME "Exiting script" | tee -a Rollback.log
		exit 1
	fi
	
	

else 
	echo $DATE_WITH_TIME "Rollback for Tomcat 6 and below" | tee -a Rollback.log 
	echo $DATE_WITH_TIME "Removing agent path from catalina.sh" | tee -a Rollback.log 
	
	## remove the agent configuration 
	sed -i -e "/export CATALINA_OPTS=-agentpath:.*/d" $1/bin/catalina.sh
	
	## check if the sed command has removed it 
	if grep -q "export CATALINA_OPTS=-agentpath:" 1/bin/catalina.sh; then
			#found
		echo $DATE_WITH_TIME "Successfully removed agent configuration" | tee -a Rollback.log
	else 
			#not found
		echo $DATE_WITH_TIME "Failed to remove agent configuration" | tee -a Rollback.log
		echo $DATE_WITH_TIME "Exiting script" | tee -a Rollback.log
		exit 1
	fi

fi


