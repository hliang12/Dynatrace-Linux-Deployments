#!/bin/bash 

## start installation for JBOSS 7
DATE_WITH_TIME=`date "+[%d/%m/%Y %H:%M:%S]"`
touch ./deploy.log

[ -z $1 ] && echo $DATE_WITH_TIME "DTHOME argument missing" | tee -a deploy.log |exit 1 ##dthome
[ -z $2 ] && echo $DATE_WITH_TIME "Bitness missing missing" |tee -a deploy.log | exit 1 ## bitness 
[ -z $3 ] && echo $DATE_WITH_TIME "Collector IP missing" |tee -a deploy.log |exit 1 ## collectr ip ;
[ -z $4 ] && echo $DATE_WITH_TIME "Agent Name missing"  | tee -a deploy.log |exit 1 ## agent name 
[ -z $5 ] && echo $DATE_WITH_TIME "JBOSS dir directory missing missing" | tee -a deploy.log |exit 1 ## jboss dir directory
[ -z $6 ]  && echo $DATE_WITH_TIME "mode type is missing" | tee -a deploy.log |exit 1 ## mode type 

#DTHOME=$1 
#BITNESS=$2
#COLLECTORIP=$3
#AGENTNAME=$4
#JBOSSDIR=$5
#MODE=$6

standalone=standalonemode
domain=domainmode

source ./Util.sh

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
		echo $DATE_WITH_TIME "Inputted incorrect bitness argument" | te deploy.log
		exit 1
	fi
fi


if [ -d "$1" ] && [ -d "$5" ]; then

	if ["$6" = "standalone"]; then

		echo  "JAVA_OPTS=\"$JAVA_OPTS -agentpath:\""$1"/agent/lib"$BITNESS"/libdtagent.so\"=name="$4",server="$3"\"" >> "$5"/bin/standalone.conf

	elif  [ "${MODE,,}" = "${domain,,}" ]; then
	
		if grep -q "<jvm-options>" ""$5"/domain/configuration/domain.xml"; then
			#found add it into the jvm options part
			sed -i "/<jvm-options>/a  <option value=\"-agentpath:\"$1/agent/lib/libdtagent.so\"=name=$4,server=$3\"/>"  $5/domain/configuration/domain.xml
			
			##check if sed worked 
			if grep -q "<option value=\"-agentpath:"; then
				## added fine
			else 
				##failed 
				
			fi
		else 
			#not found
			
			
		fi
		
	else 
		
		echo $DATE_WITH_TIME "Please input a valid mode which JBoss is running in, correct inputs are standalonemode or domainmode"
		
	fi	
		
else 

	echo $DATE_WITH_TIME "Dynatrace Dir =  + " $1
	echo $DATE_WITH_TIME "Tomcat Dir =  + " $5
	echo $DATE_WITH_TIME "Please input correct directories"

fi






