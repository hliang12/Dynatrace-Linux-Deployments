#!/bin/bash 

## start installation for tomcat 


touch  /opt/deploy.log  ## Create a deploy log 
DATE_WITH_TIME=`date "+[%d/%m/%Y %H:%M:%S]"`

##Check if variables are have been inputted 
[ -z $1 ] && echo $DATE_WITH_TIME "DTHOME argument missing" | tee -a deploy.log | exit 1 ##dthome
[ -z $2 ] && echo $DATE_WITH_TIME "Bitness missing missing" | tee -a deploy.log | exit 1 ## bitness 
[ -z $3 ] && echo $DATE_WITH_TIME "Collector IP missing" | tee -a deploy.log | exit 1 ## collectr ip 
[ -z $4 ] && echo $DATE_WITH_TIME "Agent Name missing" | tee -a deploy.log | exit 1 ## agent name 
[ -z $5 ] && echo $DATE_WITH_TIME "TomCat directory missing missing" | tee -a deploy.log | exit 1 ## tomcat directory
[ -z $6 ] && echo $DATE_WITH_TIME "service name is missing missing" | tee -a deploy.log | exit 1 ## tomcat directory

#DTHOME=$1 
#BITNESS=$2
#COLLECTORIP=$3
#AGENTNAME=$4
#TOMCATDIR=$5

##import the module Util.sh which is located in /opt
source /opt/Util.sh

BITNESS = ""

#### CHECK correct bitness inputted
if [ "$2" = "64" ]; then 
 BITNESS="64"
 echo $DATE_WITH_TIME "64 bit" | tee -a deploy.log
else 
	if [ "$2" = "32" ]; then 
		echo $DATE_WITH_TIME "32 bit" | tee -a deploy.log
	else 
		echo $DATE_WITH_TIME "Inputted incorrect bitness argument" | te deploy.log
		exit 1
	fi
fi

#### CHECK MALFORMED IP
if ! ipValid $3; then 
	exit 1
fi


echo $DATE_WITH_TIME "Checking if tomcat and dthome directories exist" | tee -a deploy.log 
## Checking if the Tomcat directories exist
if [ -d "$1" ] && [ -d "$5" ]; then

	## Check if catalina.sh file exists
	if [ ! -e "$5"/bin/catalina.sh ]; then
		echo $DATE_WITH_TIME "catalina.sh file does not exist in the following directory "$5"/bin/catalina.sh " | tee -a deploy.log
		echo $DATE_WITH_TIME "Exiting script" | tee -a deploy.log
		exit 1
	fi
		
	echo $DATE_WITH_TIME "Inserting agent path to catalina.sh" | tee -a deploy.log
	
	## Insert agent path in catalina.sh (The sed command is looking for /# OS specific support. and will insert the agentpath here before it (This will insert the agentpaht at the begining of the file)
	sed -i "/# OS specific support./i export CATALINA_OPTS=-agentpath:$1/agent/lib$BITNESS/libdtagent.so=name=$4,server=$3" $5/bin/catalina.sh
	
	## check if the agent path has inserted properly, if not then exit
	if grep -q "export CATALINA_OPTS=-agentpath:" $5/bin/catalina.sh; then
			#found
			echo $DATE_WITH_TIME "Inserted agentpath successfully" | tee -a deploy.log
			
		else 
			#not found
			echo $DATE_WITH_TIME "Failed to insert agentpath" | tee -a deploy.log
			echo $DATE_WITH_TIME "Exiting script" | tee -a deploy.log
			exit 1
	fi
	
	echo $DATE_WITH_TIME "Restarting Tomcat service " | tee -a deploy.log

	
	## stop and start services depending on if a startup script was inputted as a variable (OUTAGE HERE)
	if [[ $6 == *".sh" ]]; then
		if [ $6 == "startup.sh" ];then 
			sh  $5/bin/shutdown.sh
			sh  $5/bin/$6 
		else 
			sh $5/bin/$6 stop
			sh $5/bin/$6 start
		fi
	else 
		service $6 stop
		service $6 start 
	fi
	
	## check exit code here as well may have to roll back 

else
	## Either of the directories do not exist
	echo $DATE_WITH_TIME "Dynatrace Dir = "  "$1" 
	echo $DATE_WITH_TIME "Tomcat Dir = "  "$5" 
	echo $DATE_WITH_TIME"Please input correct directories"
	
fi

echo $DATE_WITH_TIME "Installed unless there are errors" | tee -a deploy.log
## may be better to do it wiht service 


