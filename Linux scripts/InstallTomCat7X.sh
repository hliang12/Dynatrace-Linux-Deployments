#!/bin/bash

## start installation for tomcat

touch  /opt/deploy.log ## Create a deploy log 
DATE_WITH_TIME=`date "+[%d/%m/%Y %H:%M:%S]"`

##Check if variables are have been inputted 
[ -z $1 ] && echo $DATE_WITH_TIME "DTHOME argument missing" | tee -a deploy.log | exit 1 ##dthome
[ -z $2 ] && echo $DATE_WITH_TIME "Bitness missing missing" | tee -a deploy.log | exit 1 ## bitness
[ -z $3 ] && echo $DATE_WITH_TIME "Collector IP missing" | tee -a deploy.log  | exit 1 ## collectr ip
[ -z $4 ] && echo $DATE_WITH_TIME "Agent Name missing" | tee -a deploy.log | exit 1 ## agent name
[ -z $5 ] && echo $DATE_WITH_TIME "TomCat directory missing missing" | tee -a deploy.log | exit 1 ## tomcat directory
#[ -z $6 ] && echo $DATE_WITH_TIME "TomCat service  missing missing" | tee -a deploy.log  | exit 1 ## tomcat directory

#DTHOME=$1
#BITNESS=$2
#COLLECTORIP =$3
#AGENTNAME=$4
#TOMCATDIR=$5

##import the module Util.sh which is located in /opt
source /opt/Util.sh

BITNESS=""

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
## Check if inputted directories exist
if [ -d "$1" ] && [ -d "$5" ]; then

        ## Insert agent path into setenv.sh 
			echo $DATE_WITH_TIME "Inserting agent path to setenv.sh" | tee -a deploy.log
            echo  "export CATALINA_OPTS=\"-agentpath:"$1"/agent/lib"$BITNESS"/libdtagent.so=name="$4",server="$3"" >> "$5"/bin/setenv.sh
			
		## check if the echo command succeeded, if it failed then exit the script
			if [ $? -eq 0 ]; then
				echo $DATE_WITH_TIME "Inserted agentpath with no errors" | tee -a deploy.log
			else if [ $? -eq 1 ]; then
				echo $DATE_WITH_TIME "Failed to insert agent path, exit code 1" | tee -a deploy.log
				 fi
			fi
		
		## check if the agent path has been inserted , exit if it does not find it
			if grep -q "export CATALINA_OPTS=\"-agentpath:" $5/bin/setenv.sh; then
				#found
					echo $DATE_WITH_TIME "Inserted agentpath successfully" | tee -a deploy.log
			
			else 
				#not found
					echo $DATE_WITH_TIME "Failed to insert agentpath" | tee -a deploy.log
					echo $DATE_WITH_TIME "Exiting script" | tee -a deploy.log
					exit 1
			fi
			
			# CHECK IF SETENV.SH IS EXECUTABLE, not all tomcat 7's have setenv.sh  so echo would create one if it doesn't exist
			if [[ ! -x "$5"bin/setenv.sh ]]; then
				chmod +rx "$5"/bin/setenv.sh
				if [ $? -eq 1 ]; then	
					echo $DATE_WITH_TIME "Failed to make setenv.sh executable" | tee -a deploy.log
					
					### ROLLBACK if the unable to make setenv.sh executable and remove agent pathing
					echo $DATE_WITH_TIME "Rolling Back" | tee -a deploy.log
					sh /opt/RollbackTomCat true
					exit 0 
				fi
			fi

		
			echo $DATE_WITH_TIME "YOU MUST RESTART TOMCAT SERVICES FOR AGENT TO BE INJECTED" | tee -a deploy.log
			
#	if [[ $6 == *".sh" ]]; then
#		if [ $6 == "startup.sh" ];then 
#			sh  $5/bin/shutdown.sh
#			sh  $5/bin/$6 
#		else 
#			sh $5/bin/$6 stop
#			sh $5/bin/$6 start
#		fi
#	else 
#		service $6 stop
#		service $6 start 
#	fi
			
else

        echo $DATE_WITH_TIME "Dynatrace Dir = "  $1
        echo $DATE_WITH_TIME "Tomcat Dir = "  $5
		echo $DATE_WITH_TIME "Please input correct directories"

fi

echo $DATE_WITH_TIME "finished"



