#!/bin/bash 


#$TOMCATDIR=$1
#$Version7=$2


touch Rollback.log

## start rollback for tomcat 

[ -z $1 ] && echo "TomCat directory missing missing" | tee -a Rollback.log exit 1 ## tomcat directory

### need path for tomcat? otherwise have to recursively go find it 
#### need a check for setenv.sh if not then create one 

echo "Checking which version of tomcat has been inputted in" | tee -a Rollback.log 

if [ "$2" = "true" ]; then

	echo "Rollback for Tomcat 7" | tee -a Rollback.log 
	echo "Removing agent path from setenv.sh" | tee -a Rollback.log 
	sed -i -e "/export CATALINA_OPTS=(\"\?)-agentpath:.*/d" "$1"/bin/setenv.sh

else 
	echo "Rollback for Tomcat 6 and below" | tee -a Rollback.log 
	echo "Removing agent path from catalina.sh" | tee -a Rollback.log 
	sed -i -e "/export CATALINA_OPTS=(\"\?)-agentpath:.*/d" "$1"/bin/catalina.sh

fi


### uninstall the agent 

#if [-e /etc/init.d/dynaTraceWebServerAgent.service];then

#	rm /etc/init.d dynaTraceWebServerAgent.*

#fi


#if [-d $DTHOME];then
 
#	rm -r $DTHOME
#fi

