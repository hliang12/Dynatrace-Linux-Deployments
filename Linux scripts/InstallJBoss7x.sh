#!/bin/bash 

## start installation for JBOSS 7

[ -z $1 ] && echo "DTHOME argument missing" exit 1 ##dthome
[ -z $2 ] && echo "Bitness missing missing" exit 1 ## bitness 
[ -z $3 ] && echo "Collector IP missing" exit 1 ## collectr ip ;
[ -z $4 ] && echo "Agent Name missing" exit 1 ## agent name 
[ -z $5 ] && echo "JBOSS dir directory missing missing" exit 1 ## jboss dir directory
[ -z $6 ]  && echo "mode type is missing" exit 1 ## mode type 

#DTHOME=$1 
#BITNESS=$2
#COLLECTORIP=$3
#AGENTNAME=$4
#JBOSSDIR=$5
#MODE=$6

standalone=standalonemode
domain=domainmode
 
#check xmlstarlet

#if ! which xmlstarlet 
#then 
#	yum install xmlstarlet
#fi

if [ -d "$1" ] && [ -d "$5" ]; then

	if ["$6" = "standalone"]; then

		echo "JAVA_OPTS=\"$JAVA_OPTS -agentpath:\""$1"/agent/lib/libdtagent.so\"=name="$4",server="$3"\"" >> "$5"/bin/standalone.conf

	elif  [ "${MODE,,}" = "${domain,,}" ]; then
	
		if gep -q "<jvm-options>" ""$5"/domain/configuration/domain.xml"; then
			#found
		else 
			#not found
		fi
		
		## extract out the xmlns and input into variable x 
		
	#	xmlstarlet ed -L -N x="urn:jboss:domain:2.0" -s "//x:server-group/x:jvm" -t elem -n 'option' "$5"/domain/configuration/domain.xml
	#	xmlstarlet ed -L -N x="urn:jboss:domain:2.0" -s "//x:server-group/x:jvm/x:agent" -t attr -n 'option' -v 'agent path' "$5"/domain/configuration/domain.xml
		
	
	else 
		
		echo "Please input a valid mode which JBoss is running in, correct inputs are standalonemode or domainmode"
		
	fi	
		
else 

	echo "Dynatrace Dir = " + [ -d "$DTHOME" ]
	echo "Tomcat Dir = " + [-d "$JBOSSDIR"]
	echo "Please input correct directories"

fi






