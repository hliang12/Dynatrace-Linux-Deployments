#!/bin/bash 

## start installation for tomcat 
touch  ./deploy.log
[ -z $1 ] && echo "DTHOME argument missing" | tee -a deploy.log exit 1 ##dthome
[ -z $2 ] && echo "Bitness missing missing" | tee -a deploy.log exit 1 ## bitness 
[ -z $3 ] && echo "Collector IP missing" | tee -a deploy.log exit 1 ## collectr ip 
[ -z $4 ] && echo "Agent Name missing" | tee -a deploy.log exit 1 ## agent name 
[ -z $5 ] && echo "TomCat directory missing missing" | tee -a deploy.log exit 1 ## tomcat directory
[ -z $6 ] && echo "service name is missing missing" | tee -a deploy.log exit 1 ## tomcat directory

#DTHOME=$1 
#BITNESS=$2
#COLLECTORIP=$3
#AGENTNAME=$4
#TOMCATDIR=$5

source ./Util.sh

### 32 BIT HERE  AS WELL 

BITNESS = ""

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

  ### this is for tomcat 6.x
  ### catalina.sh in tomcat_home/bin

	## does catalina exist? 
	if [ ! -e "$5"/bin/catalina.sh ]; then
		echo "catalina.sh file does not exist in the following directory "$5"/bin/catalina.sh " | tee -a deploy.log
		echo "Exiting script" | tee -a deploy.log
		exit 1
	fi
		
	echo "Inserting agent path to catalina.sh" | tee -a deploy.log
  
    #echo "export CATALINA_OPTS=-agentpath:$1/agent/lib/libdtagent.so=name=$4,server=$3" >> $5/bin/catalina.sh
	

	##### NEED EXIT CODE CUSTOM 
	sed -i "/# OS specific support./i export CATALINA_OPTS=-agentpath:$1/agent/lib$BITNESS/libdtagent.so=name=$4,server=$3" $5/bin/catalina.sh

	### SED EXIT CODE			

	
	###### check for exit code of this sed <- may have to roll back 
	echo "Restarting Tomcat service " | tee -a deploy.log

	#sh $5/bin/catalina.sh stop
	#sh $5/bin/catalina.sh start
	
	if [[ $6 == *".sh" ]]; then
		sh $5/bin/catalina.sh stop
		sh $5/bin/catalina.sh start
	else 
		service $6 stop
		service $6 start 
	fi
	
	## check exit code here as well may have to roll back 

else

	echo "Dynatrace Dir = " + [ -d "$1" ]
	echo "Tomcat Dir = " + [ -d "$5" ]
	echo "Please input correct directories"
	
fi

echo "Installed unless there are errors" | tee -a deploy.log
## may be better to do it wiht service 


