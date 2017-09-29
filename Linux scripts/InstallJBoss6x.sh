#!/bin/bash 

## start installation for JBOSS 6 
DATE_WITH_TIME=`date "+[%d/%m/%Y %H:%M:%S]"`
touch  /opt/deploy.log ## Create a deploy log 

##Check if variables are have been inputted 
[ -z $1 ] && echo $DATE_WITH_TIME "DTHOME argument missing" | tee -a /opt/deploy.log | exit 1 ##dthome
[ -z $2 ] && echo $DATE_WITH_TIME "Bitness missing missing" | tee -a /opt/deploy.log | exit 1 ## bitness 
[ -z $3 ] && echo $DATE_WITH_TIME "Collector IP missing" | tee -a /opt/deploy.log | exit 1 ## collectr ip 
[ -z $4 ] && echo $DATE_WITH_TIME "Agent Name missing" | tee -a /opt/deploy.log | exit 1 ## agent name 
[ -z $5 ] && echo $DATE_WITH_TIME "JBOSS dir directory missing missing" | tee -a  /opt/deploy.log | exit 1 ## jboss dir directory
#[ -z $6 ] && echo $DATE_WITH_TIME "JBOSS service name missing missing" | tee -a  /opt/deploy.log | exit 1 ## jboss dir directory

#DTHOME = $1 
#BITNESS = $2
#COLLECTORIP = $3
#AGENTNAME = $4
#JBOSSDIR = $5

source /opt/Util.sh

#### CHECK MALFORMED IP
if ! ipValid $3; then 
	exit 1
fi

#### CHECK correct bitness inputted
BITNESS=""
if [ "$2" = "64" ]; then 
 BITNESS="64"
 echo $DATE_WITH_TIME "64 bit" | tee -a  /opt/deploy.log
else 
	if [ "$2" = "32" ]; then 
		echo $DATE_WITH_TIME "32 bit" | tee -a /opt/deploy.log
	else 
		echo $DATE_WITH_TIME "Inputted incorrect bitness argument" | te /opt/deploy.log
		exit 1
	fi
fi

echo $DATE_WITH_TIME "Checking if jboss and dthome directories exist" | tee -a /opt/deploy.log 

## check if directories given exist
if [ -d "$1" ] && [ -d "$5" ]; then
	
	echo $DATE_WITH_TIME "Inserting agent path to run.conf" | tee -a /opt/deploy.log
	
	##inserting agent path
	echo "JAVA_OPTS=\"\$JAVA_OPTS -agentpath:\""$1"/agent/lib"$BITNESS"/libdtagent.so\"=name="$4",server="$3"\"" >> "$5"/bin/run.conf
	
	## check if the echo command worked
	if [ $? -eq 0 ]; then
		echo $DATE_WITH_TIME "Inserted agentpath with no errors" | tee -a /opt/deploy.log
	else 
		echo $DATE_WITH_TIME "Failed to insert agent path, exit code 1" | tee -a /opt/deploy.log
				
	fi
	## check if the agentpathis in run.conf
	if grep -q "JAVA_OPTS=\"\$JAVA_OPTS -agentpath:\""$1"/agent/lib"$BITNESS"/libdtagent.so\"=name="$4",server="$3"\"" "$5"/bin/run.conf; then
				#found
			echo $DATE_WITH_TIME "Inserted agentpath successfully" | tee -a /opt/deploy.log
			
	else 
				#not found
			echo $DATE_WITH_TIME "Failed to insert agentpath" | tee -a /opt/deploy.log
			echo $DATE_WITH_TIME "Exiting script" | tee -a /opt/deploy.log
			exit 1
	fi
	
	echo $DATE_WITH_TIME "YOU MUST RESTART JBOSS SERVICES FOR AGENT TO BE INJECTED" | tee -a /opt/deploy.log


	
#	if [[ $6 == *".sh" ]]; then
#		sh "$5"/bin/shutdown.sh 
#		sh "$5"/bin/run.sh
#	else 
#		service $6 stop
#		service $6 start 
#	fi
	
else 
	
	echo $DATE_WITH_TIME "Dynatrace Dir = " + [ -d "$1" ] | tee -a /opt/deploy.log
	echo $DATE_WITH_TIME "Tomcat Dir = " + [ -d "$5" ] | tee -a /opt/deploy.log
	echo $DATE_WITH_TIME "Please input correct directories" | tee -a /opt/deploy.log

fi

echo $DATE_WITH_TIME "Finished" | tee -a  /opt/deploy.log

