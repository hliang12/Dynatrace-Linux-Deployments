#!/bin/bash 

#$TOMCATDIR=$1
#$Version7=$2

touch /opt/Rollback.log
DATE_WITH_TIME=`date "+[%d/%m/%Y %H:%M:%S]"`
## start rollback for tomcat 

[ -z $1 ] && echo $DATE_WITH_TIME "TomCat directory missing missing" | tee -a Rollback.log | exit 1 ## tomcat directory

### need path for tomcat? otherwise have to recursively go find it 
#### need a check for setenv.sh if not then create one 

echo $DATE_WITH_TIME "Checking which version of tomcat has been inputted in" | tee -a Rollback.log 

if [ "$2" = "true" ]; then

	echo $DATE_WITH_TIME "Rollback for Tomcat 7" | tee -a Rollback.log 
	echo $DATE_WITH_TIME "Removing agent path from setenv.sh" | tee -a Rollback.log 
	sed -i -e "/export CATALINA_OPTS=\"-agentpath:.*/d" "$1"/bin/setenv.sh
	
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
	sed -i -e "/export CATALINA_OPTS=-agentpath:.*/d" $1/bin/catalina.sh
	
	
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


### uninstall the agent 

#if [-e /etc/init.d/dynaTraceWebServerAgent.service];then

#	rm /etc/init.d dynaTraceWebServerAgent.*

#fi


#if [-d $DTHOME];then
 
#	rm -r $DTHOME
#fi

