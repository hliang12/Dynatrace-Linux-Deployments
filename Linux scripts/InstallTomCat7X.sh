#!/bin/bash

## start installation for tomcat

touch ./deploy.log

[ -z $1 ] && echo "DTHOME argument missing" | tee -a deploy.log exit 1 ##dthome
[ -z $2 ] && echo "Bitness missing missing" | tee -a deploy.log exit 1 ## bitness
[ -z $3 ] && echo "Collector IP missing" | tee -a deploy.log  exit 1 ## collectr ip
[ -z $4 ] && echo "Agent Name missing" | tee -a deploy.log exit 1 ## agent name
[ -z $5 ] && echo "TomCat directory missing missing" | tee -a deploy.log exit 1 ## tomcat directory
[ -z $6 ] && echo "TomCat service  missing missing" | tee -a deploy.log  exit 1 ## tomcat directory

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
 echo "64 bit" | tee -a deploy.log
else 
	if [ "$2" = "32" ]; then 
		echo "32 bit" | tee -a deploy.log
	else 
		echo "Inputted incorrect bitness argument" | te deploy.log
		exit 1
	fi
fi

#### CHECK MALFORMED IP
if ! ipValid $COLLECTORIP; then 
	exit 1
fi

echo "Checking if tomcat and dthome directories exist" | tee -a deploy.log 

if [ -d "$1" ] && [ -d "$5" ]; then

        ## check catalina_base/bin or catalina_home/bin for setenv.bat/setenv.sh
			echo "Inserting agent path to setenv.sh" | tee -a deploy.log
            echo "export CATALINA_OPTS=-agentpath:"$1"/agent/lib"$BITNESS"/libdtagent.so=name="$4",server="$3"" >> "$5"/bin/setenv.sh
			if [ $? -eq 0 ]; then
				echo "Inserted agentpath with no errors" | tee -a deploy.log
			else if [ $? -eq 1 ]; then
				echo "Failed to insert agent path, exit code 1" | tee -a deploy.log
				 fi
			fi
			
			# CHECK IF SETENV.SH IS EXECUTABLE
			if [[ ! -x "$5"bin/setenv.sh ]]; then
				chmod +rx "$5"/bin/setenv.sh
				
				if [ $? -eq 1 ]; then	
					echo "Failed to make setenv.sh executable" | tee -a deploy.log
					
					### ROLLBACK 
					echo "Rolling Back" | tee -a deploy.log
					sh RollbackTomCat true
					
					exit 0 
				fi
			fi
			
			### CHECK ERROR CODE HERE MAY HAVE TO ROLLBACK 
			### RESTARTS HERE 
			echo "Restarting Tomcat service " | tee -a deploy.log	
			
	if [[ $6 == *".sh" ]]; then
		sh $5/bin/shutdown.sh stop
		sh $5/bin/startup.sh start
	else 
		service $6 stop
		service $6 start 
	fi
			
else

        echo "Dynatrace Dir = " + [ -d "$DTHOME" ]
        echo "Tomcat Dir = " + [ -d "$TOMCATDIR" ]
        echo "Please input correct directories"

fi

echo "finished"



