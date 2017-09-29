#!/bin/bash
DATE_WITH_TIME=`date "+[%d/%m/%Y %H:%M:%S]"`


#### Logs into the server which you have put into as a parameter and username/password and grabs the java agent installer 
touch  /opt/deploy.log
echo $DATE_WITH_TIME "Starting Installation of Dynatrace Agent MSI"



[ -z $1 ] && echo $DATE_WITH_TIME "Dthome directory is missing"
[ -z $2 ] && echo $DATE_WITH_TIME "Agent Version is missing"
[ -z $3 ] && echo $DATE_WITH_TIME "Service account username is missing"
[ -z $4 ] && echo $DATE_WITH_TIME "Service account password is missing"
[ -z $5 ] && echo $DATE_WITH_TIME "File Distribution server is missing" #//itm-not-rob01.uk.experian.local/Dynatrace%20Software/Software/Linux/Agents/  example entry 

echo $DATE_WITH_TIME  "DT installation location is ${DTHOME}"

mkdir /tmp/mountPoint
if [ $? -eq 0 ]; then
	echo $DATE_WITH_TIME "Made mountPoint directory" | tee /opt/deploy.log
else 
	echo $DATE_WITH_TIME "Failed to make mountPoint directory, exit code "$?"" | tee /opt/deploy.log
	exit 
fi


mount -v -t cifs $5 /tmp/mountPoint -o username=$3,password=$4,sec=ntlm
if [ $? -eq 0 ]; then
	echo $DATE_WITH_TIME "Mounted repo location" | tee /opt/deploy.log
else 
	echo $DATE_WITH_TIME "Failed to mount repo location, exit code "$?"" | tee /opt/deploy.log
	exit
fi

cp -p -u /tmp/mountPoint/dynatrace-agent-$2*.tar /opt/dynatrace-agent-$2.tar

if [ $? -eq 0 ]; then
	echo $DATE_WITH_TIME "Copied Web Server agent tar file" | tee /opt/deploy.log
else 
	echo $DATE_WITH_TIME "Failed to copy web server agent tar file, exit code "$?"" | tee /opt/deploy.log
	exit
fi

echo $DATE_WITH_TIME "Finished downloading DT installer"

echo $DATE_WITH_TIME "Starting to run the installer"

## do tar here

JAVAHOME="$(which java)"

#java -jar /opt/dynatrace-agent-"$2" -t $1 -y

${JAVAHOME} -jar /opt/dynatrace-agent-"$2" -t $1 -y

if [ $? -eq 0 ]; then
	echo $DATE_WITH_TIME "Untar web server agent file successful" | tee /opt/deploy.log
else 
	echo $DATE_WITH_TIME "Failed to untar web server agent file, exit code "$?"" | tee /opt/deploy.log
	exit
fi

echo $DATE_WITH_TIME "Unmounting mountPoint" | tee /opt/deploy.log
umount /tmp/mountPoint 

if [ $? -eq 0 ]; then
	echo $DATE_WITH_TIME "Unmounted successfully" | tee /opt/deploy.log
else 
	echo $DATE_WITH_TIME "Failed to unmount, exit code "$?"" | tee /opt/deploy.log
	exit
fi

echo $DATE_WITH_TIME "Removing mountPoint folder" | tee /opt/deploy.log
rm -rf /tmp/mountPoint

if [ $? -eq 0 ]; then
	echo $DATE_WITH_TIME "Removing mountPoint folder" | tee /opt/deploy.log
else 
	echo $DATE_WITH_TIME "Failed to remove mountPoint folder, exit code "$?"" | tee /opt/deploy.log
	exit
fi

echo $DATE_WITH_TIME "Installed okay if no errors"






