#!/bin/bash

echo "Starting Installation of Dynatrace Agent MSI"

#DTHOME=$1
#VERSION=$2
#bit = $3

[ -z $1 ] && echo "Arg 1 missing"
[ -z $2 ] && echo "Arg 1 missing"
[ -z $3 ] && echo "Service account user name is missing "
[ -z $4 ] && echo "Arg 1 missing"
[ -z $5 ] && echo "Arg 1 missing"
[ -z $6 ] && echo "Arg 1 missing" 

echo  "DT installation location is ${DTHOME}"

mkdir /tmp/mountPoint
if [ $? -eq 0 ]; then
	echo "Made mountPoint directory" | tee deploy.log
else 
	echo "Failed to make mountPoint directory, exit code "$?"" | tee deploy.log
	exit 
fi


mount -v -t cifs $6 /tmp/mountPoint -o username=$4,password=$5, sec=ntlm
if [ $? -eq 0 ]; then
	echo "Mounted repo location" | tee deploy.log
else 
	echo "Failed to mount repo location, exit code "$?"" | tee deploy.log
	exit
fi

cp -p -u /tmp/mountPoint/dynatrace-agent-$2*.tar /opt/dynatrace-agent-$2.tar

if [ $? -eq 0 ]; then
	echo "Copied Web Server agent tar file" | tee deploy.log
else 
	echo "Failed to copy web server agent tar file, exit code "$?"" | tee deploy.log
	exit
fi

echo "Finished downloading DT installer"

echo "Starting to run the installer"

## do tar here

java -jar /opt/dynatrace-agent-"$2" -b "$3" -t $"1" -y


if [ $? -eq 0 ]; then
	echo "Untar web server agent file successful" | tee deploy.log
else 
	echo "Failed to untar web server agent file, exit code "$?"" | tee deploy.log
	exit
fi

echo "Making Dynatrace Web Server install script executable" | tee deploy.log

chmod +rx dynatrace-ws*.sh 

if [ $? -eq 0 ]; then
	echo "Untar web server agent file successful" | tee deploy.log
else 
	echo "Failed to untar web server agent file, exit code "$?"" | tee deploy.log
	exit
fi

echo "Running dynatrace web server agent install script" | tee deploy.log

sh dynatrace-ws*.sh 

if [ $? -eq 0 ]; then
	echo "Ran dynatrace web server agent install script successfully" | tee deploy.log
else 
	echo "Failed to run web server agent install script, exit code "$?"" | tee deploy.log
	exit
fi

echo "Unmounting mountPoint" | tee deploy.log
umount /tmp/mountPoint 

if [ $? -eq 0 ]; then
	echo "Unmounted successfully" | tee deploy.log
else 
	echo "Failed to unmount, exit code "$?"" | tee deploy.log
	exit
fi

echo "Removing mountPoint folder" | tee deploy.log
rm -rf /tmp/mountPoint

if [ $? -eq 0 ]; then
	echo "Removing mountPoint folder" | tee deploy.log
else 
	echo "Failed to remove mountPoint folder, exit code "$?"" | tee deploy.log
	exit
fi

echo "Installed okay if no errors"






