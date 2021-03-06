#!/bin/bash
DATE_WITH_TIME=`date "+[%d/%m/%Y %H:%M:%S]"`
touch  /opt/deploy.log ## Create a deploy log 

##Check if variables are have been inputted 
[ -z $1 ] && echo $DATE_WITH_TIME "DTHOME argument missing" | tee -a /opt/deploy.log | exit 1 ##dthome
[ -z $2 ] && echo $DATE_WITH_TIME "Bitness missing missing" | tee -a /opt/deploy.log | exit 1 ## bitness 
[ -z $3 ] && echo $DATE_WITH_TIME "Collector IP missing" | tee -a /opt/deploy.log | exit 1 ## collectr ip 
[ -z $4 ] && echo $DATE_WITH_TIME "Agent Name missing"| tee -a /opt/deploy.log | exit 1 ## agent name 
[ -z $5 ] && echo $DATE_WITH_TIME "Apache directory missing missing"| tee -a /opt/deploy.log | exit 1 ## xampp directory
#[ -z $6 ] && echo $DATE_WITH_TIME "Apache service name is missing"| tee -a /opt/deploy.log | exit 1 ## xampp directory

#DTHOME=$1 
#BITNESS=$2
#COLLECTORIP=$3
#AGENTNAME=$4
#APACHEDIR=$5
#APACHETYPE=$6

source /opt/Util.sh

echo $DATE_WITH_TIME "$1 = dthome"
echo $DATE_WITH_TIME "$2 = bit"
echo $DATE_WITH_TIME "$3 = collector"
echo $DATE_WITH_TIME "$4 = agentname"
echo $DATE_WITH_TIME "$5 = apachedir"
echo $DATE_WITH_TIME "$6 = apache service name"

#### CHECK correct bitness inputted
BITNESS=""
if [ "$2" = "64" ]; then 
 BITNESS="64"
 echo $DATE_WITH_TIME "64 bit" | tee -a /opt/deploy.log
else 
	if [ "$2" = "32" ]; then 
		echo $DATE_WITH_TIME "32 bit" | tee -a /opt/deploy.log
	else 
		echo $DATE_WITH_TIME "Inputted incorrect bitness argument" | te /opt/deploy.log
		exit 1
	fi
fi

#### CHECK MALFORMED IP
if ! ipValid $3; then 
	exit 1
fi

echo $DATE_WITH_TIME "Checking if DTHOME and apache directory exists" | tee -a /opt/deploy.log
if [ -d "$1" ] && [ -d "$5" ]; then

			## check if httpd.conf exists
			if [ ! -e "$5"/httpd.conf ]; then
				echo $DATE_WITH_TIME "httpd.conf file does not exist in the following directory "$5"/httpd.confi " | tee -a /opt/deploy.log
				echo $DATE_WITH_TIME "Exiting script" | tee -a /opt/deploy.log
				exit 1
			fi
			
			## add module to httpd.conf
			echo $DATE_WITH_TIME "Adding Agent Module to httpd.conf" | tee -a /opt/deploy.log
			echo  "LoadModule dtagent_module \"$1/agent/lib"$BITNESS"/libdtagent.so\" " >> "$5"/httpd.conf
			
			## check if the echo command succeeded 
			if [ $? -eq 0 ]; then
				echo $DATE_WITH_TIME "Inserted agent module with no errors" | tee -a /opt/deploy.log
			else if [ $? -eq 1 ]; then
				echo $DATE_WITH_TIME "Failed to insert agent module, exit code 1" | tee -a /opt/deploy.log
				 fi
			fi
			
			
			#echo $DATE_WITH_TIME "Adding Agent name to httpd.conf" | tee -a /opt/deploy.log
			#echo $DATE_WITH_TIME "ApacheNodeName \"$4\"" >> "$5"/httpd.conf
			
			echo $DATE_WITH_TIME "Editing agent details in dtwsagent.ini"  | tee -a /opt/deploy.log
			
			## check if the dtwsagent.ini file exists
			if [ ! -e "$1"/agent/conf/dtwsagent.ini ]; then
				echo $DATE_WITH_TIME "dtwsagent.ini file does not exist in the following directory "$1"/agent/conf/dtwsagent.ini " | tee -a /opt/deploy.log
				echo $DATE_WITH_TIME "Rolling back changes" | tee -a /opt/deploy.log
				sh /opt/RollBackApacheHTTPD.sh $5
				echo $DATE_WITH_TIME "Exiting script" | tee -a /opt/deploy.log
				exit 1
			fi
			
			### check if it has been changed already
			## edit stwsagent.ini to set up web server agent to connect to collector and has correct name
			sed -i "s/dtwsagent/$4/g" "$1"/agent/conf/dtwsagent.ini
			sed -i "s/localhost/$3/g" "$1"/agent/conf/dtwsagent.ini

			echo $DATE_WITH_TIME "YOU MUST RESTART APACHE SERVICES FOR AGENT TO BE INJECTED" | tee -a /opt/deploy.log
	
#			if [[ $6 == *".sh" ]]; then
#				sh $5/bin/$6 restart
#			else 
#				service $6 restart
#			fi	
			
			## for restart could use apachectl start | stop | restart
			
			echo $DATE_WITH_TIME "Starting dynatrace web server agent" | tee -a /opt/deploy.log 
			
			### Check for dynatrace user 
			
			if getend passwd | grep appsadm; then
				sudo su appsadm /etc/init.d/dynaTraceWebServerAgent start
			else 
			
				echo $DATE_WITH_TIME "Unable to find appsadm user on the system" | tee -a /opt/deploy.log 
				echo $DATE_WITH_TIME "rolling back and exiting script" | tee -a /opt/deploy.log 
				sh /opt/RollBackApacheHTTPD.sh $5
			fi	
			
	else
	
		echo $DATE_WITH_TIME "Dynatrace Dir = " + [ -d "$1" ] | tee -a /opt/deploy.log 
		echo $DATE_WITH_TIME "Apache Dir = " + [ -d "$5" ] | tee -a /opt/deploy.log 
		echo $DATE_WITH_TIME "Please input correct directories" | tee -a /opt/deploy.log 	
		
fi


############### for apache2
#else
#	touch $apache2DIR+/mods-available/dtagent_module.load
	### change the dynatrace agent module
#	echo $DATE_WITH_TIME "LoadModule dtagent_module \"$DTHOME/agent/lib[64]/libdtagent.so\"" >> $apache2DIR+/mods-available/dtagent_module.load
#	sudo a2enmod dtagent_module  
	## outage
#	sudo service apache2 restart	
#fi
