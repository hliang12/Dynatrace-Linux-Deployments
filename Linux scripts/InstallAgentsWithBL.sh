#!/bin/bash
DATE_WITH_TIME=`date "+[%d/%m/%Y %H:%M:%S]"`
echo $DATE_WITH_TIME "Starting Installation of Dynatrace Agent MSI"

#DTHOME=$1
#VERSION=$2
#bit = $3

[ -z $1 ] && echo $DATE_WITH_TIME "Arg 1 missing"
[ -z $2 ] && echo $DATE_WITH_TIME "Arg 1 missing"
[ -z $3 ] &&  echo $DATE_WITH_TIME "Arg 1 missing" ## bitness do i even need this?


echo $DATE_WITH_TIME  "DT installation location is ${DTHOME}"

echo $DATE_WITH_TIME "Starting to run the installer"

## do tar here

java -jar /opt/dynatrace-agent-.*.jar -b "$3" -t $"1" -y


if [ $? -eq 0 ]; then
	echo $DATE_WITH_TIME "Untar web server agent file successful" | tee deploy.log
else 
	echo $DATE_WITH_TIME "Failed to jar web server agent file, exit code "$?"" | tee deploy.log
	exit
fi

echo $DATE_WITH_TIME "Finished installation if no errors" | tee deploy.log






