#!/bin/bash 

## start installation for JBOSS 6 
DATE_WITH_TIME=`date "+[%d/%m/%Y %H:%M:%S]"`
touch  /opt/deploy.log
[ -z $1 ] && echo $DATE_WITH_TIME "DTHOME argument missing" | tee -a deploy.log | exit 1 ##dthome
[ -z $2 ] && echo $DATE_WITH_TIME "Bitness missing missing" | tee -a deploy.log | exit 1 ## bitness 
[ -z $3 ] && echo $DATE_WITH_TIME "Collector IP missing" | tee -a deploy.log | exit 1 ## collectr ip 
[ -z $4 ] && echo $DATE_WITH_TIME "Agent Name missing" | tee -a deploy.log | exit 1 ## agent name 
[ -z $5 ] && echo $DATE_WITH_TIME "JBOSS dir directory missing missing" | tee -a  deploy.log | exit 1 ## jboss dir directory
[ -z $6 ] && echo $DATE_WITH_TIME "JBOSS service name missing missing" | tee -a  deploy.log | exit 1 ## jboss dir directory

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
 echo $DATE_WITH_TIME "64 bit" | tee -a  deploy.log
else 
	if [ "$2" = "32" ]; then 
		echo $DATE_WITH_TIME "32 bit" | tee -a deploy.log
	else 
		echo $DATE_WITH_TIME "Inputted incorrect bitness argument" | te deploy.log
		exit 1
	fi
fi

echo $DATE_WITH_TIME "Checking if jboss and dthome directories exist" | tee -a deploy.log 
if [ -d "$1" ] && [ -d "$5" ]; then
	
	echo $DATE_WITH_TIME "Inserting agent path to run.conf" | tee -a deploy.log
	
	echo "JAVA_OPTS=\"\$JAVA_OPTS -agentpath:\""$1"/agent/lib"$BITNESS"/libdtagent.so\"=name="$4",server="$3"\"" >> "$5"/bin/run.conf
	
	if [ $? -eq 0 ]; then
		echo $DATE_WITH_TIME "Inserted agentpath with no errors" | tee -a deploy.log
	else 
		echo $DATE_WITH_TIME "Failed to insert agent path, exit code 1" | tee -a deploy.log
				
	fi
	
	if grep -q "JAVA_OPTS=\"\$JAVA_OPTS -agentpath:\""$1"/agent/lib"$BITNESS"/libdtagent.so\"=name="$4",server="$3"\"" "$5"/bin/run.conf; then
				#found
			echo $DATE_WITH_TIME "Inserted agentpath successfully" | tee -a deploy.log
			
	else 
				#not found
			echo $DATE_WITH_TIME "Failed to insert agentpath" | tee -a deploy.log
			echo $DATE_WITH_TIME "Exiting script" | tee -a deploy.log
			exit 1
	fi
	
	echo $DATE_WITH_TIME "Restarting Jboss service " | tee -a deploy.log

	### CHECK EXIT ERROR CODE MAYBE ROLLBACK 
	
	if [[ $6 == *".sh" ]]; then
		sh "$5"/bin/shutdown.sh 
		sh "$5"/bin/run.sh
	else 
		service $6 stop
		service $6 start 
	fi
	
else 
	
	echo $DATE_WITH_TIME "Dynatrace Dir = " + [ -d "$1" ] | tee -a deploy.log
	echo $DATE_WITH_TIME "Tomcat Dir = " + [ -d "$5" ] | tee -a deploy.log
	echo $DATE_WITH_TIME "Please input correct directories" | tee -a deploy.log

fi

echo $DATE_WITH_TIME "Finished" | tee -a  deploy.log

