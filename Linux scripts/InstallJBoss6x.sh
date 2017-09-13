#!/bin/bash 

## start installation for JBOSS 6 

touch ./deploy.log

[ -z $1 ] && echo "DTHOME argument missing" | tee -a deploy.log exit 1 ##dthome
[ -z $2 ] && echo "Bitness missing missing" | tee -a deploy.log exit 1 ## bitness 
[ -z $3 ] && echo "Collector IP missing" | tee -a deploy.log exit 1 ## collectr ip 
[ -z $4 ] && echo "Agent Name missing" | tee -a deploy.log exit 1 ## agent name 
[ -z $5 ] && echo "JBOSS dir directory missing missing" | tee -a  deploy.log exit 1 ## jboss dir directory
[ -z $6 ] && echo "JBOSS service name missing missing" | tee -a  deploy.log exit 1 ## jboss dir directory

#DTHOME = $1 
#BITNESS = $2
#COLLECTORIP = $3
#AGENTNAME = $4
#JBOSSDIR = $5

source ./Util.sh

#### CHECK MALFORMED IP
if ! ipValid $COLLECTORIP; then 
	exit 1
fi

#### CHECK correct bitness inputted
BITNESS=""
if [ "$2" = "64" ]; then 
 BITNESS="64"
 echo "64 bit" | tee -a  deploy.log
else 
	if [ "$2" = "32" ]; then 
		echo "32 bit" | tee -a deploy.log
	else 
		echo "Inputted incorrect bitness argument" | te deploy.log
		exit 1
	fi
fi

echo "Checking if jboss and dthome directories exist" | tee -a deploy.log 
if [ -d "$1" ] && [ -d "$5" ]; then
	
	echo "Inserting agent path to run.conf" | tee -a deploy.log
	
	echo "JAVA_OPTS=\"\$JAVA_OPTS -agentpath:\""$1"/agent/lib"$BITNESS"/libdtagent.so\"=name="$4",server="$3"\"" >> "$5"/bin/run.conf
	
	if [ $? -eq 0 ]; then
		echo "Inserted agentpath with no errors" | tee -a deploy.log
	else 
		echo "Failed to insert agent path, exit code 1" | tee -a deploy.log
				
	fi
	
	echo "Restarting Jboss service " | tee -a deploy.log

	### CHECK EXIT ERROR CODE MAYBE ROLLBACK 
	
	if [[ $6 == *".sh" ]]; then
		sh "$5"/bin/shutdown.sh -S
		sh "$5"/bin/run.sh
	else 
		service $6 stop
		service $6 start 
	fi
	
else 
	
	echo "Dynatrace Dir = " + [ -d "$1" ] | tee -a deploy.log
	echo "Tomcat Dir = " + [ -d "$5" ] | tee -a deploy.log
	echo "Please input correct directories" | tee -a deploy.log

fi

echo "Finished" | tee -a  deploy.log

