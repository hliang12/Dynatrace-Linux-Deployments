#!/bin/bash

## start installation for tomcat

touch ./deploy.log
DATE_WITH_TIME=`date "+[%d/%m/%Y %H:%M:%S]"`
[ -z $1 ] && echo $DATE_WITH_TIME "DTHOME argument missing" | tee -a deploy.log | exit 1 ##dthome
[ -z $2 ] && echo $DATE_WITH_TIME "Bitness missing missing" | tee -a deploy.log | exit 1 ## bitness
[ -z $3 ] && echo $DATE_WITH_TIME "Collector IP missing" | tee -a deploy.log  | exit 1 ## collectr ip
[ -z $4 ] && echo $DATE_WITH_TIME "Agent Name missing" | tee -a deploy.log | exit 1 ## agent name
[ -z $5 ] && echo $DATE_WITH_TIME "TomCat directory missing missing" | tee -a deploy.log | exit 1 ## tomcat directory
[ -z $6 ] && echo $DATE_WITH_TIME "TomCat service  missing missing" | tee -a deploy.log  | exit 1 ## tomcat directory

### need path for tomcat? otherwise have to recursively go find it
#### need a check for setenv.sh if not then create one

#DTHOME=$1
#BITNESS=$2
#COLLECTORIP =$3
#AGENTNAME=$4
#TOMCATDIR=$5

source ./Util.sh

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

if [ -d "$1" ] && [ -d "$5" ]; then

        ## check catalina_base/bin or catalina_home/bin for setenv.bat/setenv.sh
			echo $DATE_WITH_TIME "Inserting agent path to setenv.sh" | tee -a deploy.log
            echo  "export CATALINA_OPTS=\"-agentpath:"$1"/agent/lib"$BITNESS"/libdtagent.so=name="$4",server="$3"" >> "$5"/bin/setenv.sh
			if [ $? -eq 0 ]; then
				echo $DATE_WITH_TIME "Inserted agentpath with no errors" | tee -a deploy.log
			else if [ $? -eq 1 ]; then
				echo $DATE_WITH_TIME "Failed to insert agent path, exit code 1" | tee -a deploy.log
				 fi
			fi
			
			if grep -q "export CATALINA_OPTS=\"-agentpath:" $5/bin/setenv.sh; then
				#found
					echo $DATE_WITH_TIME "Inserted agentpath successfully" | tee -a deploy.log
			
			else 
				#not found
					echo $DATE_WITH_TIME "Failed to insert agentpath" | tee -a deploy.log
					echo $DATE_WITH_TIME "Exiting script" | tee -a deploy.log
					exit 1
			fi
			
			# CHECK IF SETENV.SH IS EXECUTABLE
			if [[ ! -x "$5"bin/setenv.sh ]]; then
				chmod +rx "$5"/bin/setenv.sh
				if [ $? -eq 1 ]; then	
					echo $DATE_WITH_TIME "Failed to make setenv.sh executable" | tee -a deploy.log
					
					### ROLLBACK 
					echo $DATE_WITH_TIME "Rolling Back" | tee -a deploy.log
					sh RollbackTomCat true
					exit 0 
				fi
			fi
			### CHECK ERROR CODE HERE MAY HAVE TO ROLLBACK 
			### RESTARTS HERE 
			echo $DATE_WITH_TIME "Restarting Tomcat service " | tee -a deploy.log	
			
	if [[ $6 == *".sh" ]]; then
		sh $5/bin/shutdown.sh 
		sh $5/bin/startup.sh 
	else 
		service $6 stop
		service $6 start 
	fi
			
else

        echo $DATE_WITH_TIME "Dynatrace Dir = " + [ -d "$DTHOME" ]
        echo $DATE_WITH_TIME "Tomcat Dir = " + [ -d "$TOMCATDIR" ]
        echo $DATE_WITH_TIME "Please input correct directories"

fi

echo $DATE_WITH_TIME "finished"



