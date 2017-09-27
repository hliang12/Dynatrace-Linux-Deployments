#!/bin/bash 

## start installation for JBOSS 7
DATE_WITH_TIME=`date "+[%d/%m/%Y %H:%M:%S]"`
touch  /opt/deploy.log

[ -z $1 ] && echo $DATE_WITH_TIME "DTHOME argument missing" | tee -a deploy.log |exit 1 ##dthome
[ -z $2 ] && echo $DATE_WITH_TIME "Bitness missing missing" |tee -a deploy.log | exit 1 ## bitness 
[ -z $3 ] && echo $DATE_WITH_TIME "Collector IP missing" |tee -a deploy.log |exit 1 ## collectr ip ;
[ -z $4 ] && echo $DATE_WITH_TIME "Agent Name missing"  | tee -a deploy.log |exit 1 ## agent name 
[ -z $5 ] && echo $DATE_WITH_TIME "JBOSS dir directory missing missing" | tee -a deploy.log |exit 1 ## jboss dir directory
[ -z $6 ] && echo $DATE_WITH_TIME "mode type is missing" | tee -a deploy.log |exit 1 ## mode type 
#[ -z $7 ] && echo $DATE_WITH_TIME "JBOSS SERVICE" | tee -a deploy.log |exit 1 ## mode type 

#DTHOME=$1 
#BITNESS=$2
#COLLECTORIP=$3
#AGENTNAME=$4
#JBOSSDIR=$5
#MODE=$6


source /opt/Util.sh

#### CHECK MALFORMED IP
if ! ipValid $3; then 
	exit 1
fi

BITNESS=""
if [ "$2" = "64" ]; then 
 BITNESS="64"
 echo $DATE_WITH_TIME "64 bit" | tee -a  deploy.log
else 
	if [ "$2" = "32" ]; then 
		echo $DATE_WITH_TIME "32 bit" | tee -a deploy.log
	else 
		echo $DATE_WITH_TIME "Inputted incorrect bitness argument" | tee deploy.log
		exit 1
	fi
fi


if [ -d "$1" ] && [ -d "$5" ]; then

	if [ "$6" = "standalone" ]; then
		echo $DATE_WITH_TIME "Inserting agent path for jboss standalone mode" | tee -a deploy.log 
		echo  "JAVA_OPTS=\"\$JAVA_OPTS -agentpath:\""$1"/agent/lib"$BITNESS"/libdtagent.so\"=name="$4",server="$3"\"" >> "$5"/bin/standalone.conf

	elif  [ "$6" = "domain" ]; then
		echo $DATE_WITH_TIME "Inserting agent path for jboss domain mode" | tee -a deploy.log 
		echo $DATE_WITH_TIME "Checking if domain.xml cotainst <jvm-options>" | tee -a deploy.log 
		if grep -q "<jvm-options>" ""$5"/domain/configuration/domain.xml"; then
			#found add it into the jvm options part
			
			echo $DATE_WITH_TIME "Found <jvm-options> will add another <options> tag too it" | tee -a deploy.log 
			sed -i "/<jvm-options>/a  <option value=\"-agentpath:\"$1/agent/lib/libdtagent.so\"=name=$4,server=$3\"/>"  $5/domain/configuration/domain.xml
			
			##check if sed worked 
			echo $DATE_WITH_TIME "Check if added the options tag correctly" | tee -a deploy.log 
			if grep -q "<option value=\"-agentpath:\"$1/agent/lib/libdtagent.so\"=name=$4,server=$3\"/>" "$5/domain/configuration/domain.xml" ; then
				## added fine
				echo $DATE_WITH_TIME "Added agent path options in fine"
			else 
				##failed 
				echo $DATE_WITH_TIME "Failed to add the agent"
				exit 1
			fi
			
		else 
			#not found
			echo $DATE_WITH_TIME "No <jvm-options> tag, adding this in with <options> tag " | tee -a deploy.log 
			 sed -i "/<heap .*>/a <jvm-options><option value=\"-agentpath:\"$1/agent/lib/libdtagent.so\"=name=$4,server=$3\"/> <jvm-options/>" $5/domain/configuration/domain.xml

			 ##check if sed worked 
			 echo $DATE_WITH_TIME "Checking if adding successfully" | tee -a deploy.log 
			if grep -q "<jvm-options><option value=\"-agentpath:\"$1/agent/lib/libdtagent.so\"=name=$4,server=$3\"/> <jvm-options/>" "$5/domain/configuration/domain.xml"; then
				## added fine
				echo $DATE_WITH_TIME "Added agent path options in fine"| tee -a deploy.log 
			else 
				##failed 
				echo $DATE_WITH_TIME "Failed to add the agent" | tee -a deploy.log 
				exit 1
			fi
		fi 
		
		echo $DATE_WITH_TIME "YOU MUST RESTART JBOSS SERVICES FOR AGENT TO BE INJECTED" | tee -a deploy.log
#		if [[ $6 == *".sh" ]]; then
#			sh "$5"/bin/shutdown.sh 
#			sh "$5"/bin/run.sh
#		else 
#			service $6 stop
#			service $6 start 
#		fi
		
	else 
		
		echo $DATE_WITH_TIME "Please input a valid mode which JBoss is running in, correct inputs are standalonemode or domainmode"
		exit 1
		
	fi	
		
else 

	echo $DATE_WITH_TIME "Dynatrace Dir =  + " $1
	echo $DATE_WITH_TIME "Tomcat Dir =  + " $5
	echo $DATE_WITH_TIME "Please input correct directories"

fi






