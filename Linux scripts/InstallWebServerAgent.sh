#!/bin/bash
DATE_WITH_TIME=`date "+[%d/%m/%Y %H:%M:%S]"`
touch  /opt/deploy.log
echo $DATE_WITH_TIME "Starting Installation of Dynatrace Agent MSI"

#DTHOME=$1
#VERSION=$2
#bit = $3

[ -z $1 ] && echo $DATE_WITH_TIME "Dthome directory is missing"
[ -z $2 ] && echo $DATE_WITH_TIME "Agent Version is missing"
[ -z $3 ] && echo $DATE_WITH_TIME ""
[ -z $4 ] && echo $DATE_WITH_TIME "Service account username is missing"
[ -z $5 ] && echo $DATE_WITH_TIME "Service account password is missing"
[ -z $6 ] && echo $DATE_WITH_TIME "File Distribution server is missing" #//itm-not-rob01.uk.experian.local/Dynatrace%20Software/Software/Linux/Agents/  example entry 


echo $DATE_WITH_TIME  "DT installation location is "$1""

## make mount point

mkdir /tmp/mountPoint
if [ $? -eq 0 ]; then
	echo $DATE_WITH_TIME "Made mountPoint directory" | tee deploy.log
else 
	echo $DATE_WITH_TIME "Failed to make mountPoint directory, exit code "$?"" | tee deploy.log
	exit 
fi


## mounting repo location

mount -v -t cifs $6 /tmp/mountPoint -o username=$4,password=$5, sec=ntlm
if [ $? -eq 0 ]; then
	echo $DATE_WITH_TIME "Mounted repo location" | tee deploy.log
else 
	echo $DATE_WITH_TIME "Failed to mount repo location, exit code "$?"" | tee deploy.log
	exit
fi

##copying files over

cp -p -u /tmp/mountPoint/dynatrace-wsagent-$2*.tar /opt/dynatrace-wsagent-$2.tar

if [ $? -eq 0 ]; then
	echo $DATE_WITH_TIME "Copied Web Server agent tar file" | tee deploy.log
else 
	echo $DATE_WITH_TIME "Failed to copy web server agent tar file, exit code "$?"" | tee deploy.log
	exit
fi

echo $DATE_WITH_TIME "Finished downloading DT installer"

echo $DATE_WITH_TIME "Starting to run the installer"

## tar them 

TARHOME="$(which tar)"

#tar -xvf /opt/dynatrace-wsagent-$2.tar

${TARHOME} -xvf /opt/dynatrace-wsagent-$2.tar

if [ $? -eq 0 ]; then
	echo $DATE_WITH_TIME "Untar web server agent file successful" | tee deploy.log
else 
	echo $DATE_WITH_TIME "Failed to untar web server agent file, exit code "$?"" | tee deploy.log
	exit
fi

echo $DATE_WITH_TIME "Making Dynatrace Web Server install script executable" | tee deploy.log
## make the run script executable

chmod +rx /opt/dynatrace-ws*.sh 

if [ $? -eq 0 ]; then
	echo $DATE_WITH_TIME "Untar web server agent file successful" | tee deploy.log
else 
	echo $DATE_WITH_TIME "Failed to untar web server agent file, exit code "$?"" | tee deploy.log
	exit
fi

echo $DATE_WITH_TIME "Running dynatrace web server agent install script" | tee deploy.log

## run the execution script
sh /opt/dynatrace-ws*.sh 

if [ $? -eq 0 ]; then
	echo $DATE_WITH_TIME "Ran dynatrace web server agent install script successfully" | tee deploy.log
else 
	echo $DATE_WITH_TIME "Failed to run web server agent install script, exit code "$?"" | tee deploy.log
	exit
fi

## copy dynatrace web server agent service to /etc/init.d

cp $1/dynatrace-$2/init.d/dynaTraceWebServerAgent /etc/init.d

## CLEANUP 

echo $DATE_WITH_TIME "Unmounting mountPoint" | tee deploy.log
umount /tmp/mountPoint 

if [ $? -eq 0 ]; then
	echo $DATE_WITH_TIME "Unmounted successfully" | tee deploy.log
else 
	echo $DATE_WITH_TIME "Failed to unmount, exit code "$?"" | tee deploy.log
	exit
fi

echo $DATE_WITH_TIME "Removing mountPoint folder" | tee deploy.log
rm -rf /tmp/mountPoint

if [ $? -eq 0 ]; then
	echo $DATE_WITH_TIME "Removing mountPoint folder" | tee deploy.log
else 
	echo $DATE_WITH_TIME "Failed to remove mountPoint folder, exit code "$?"" | tee deploy.log
	exit
fi

echo $DATE_WITH_TIME "Installed okay if no errors"






