#!/bin/bash

#DTHOME=$1

touch Rollback.log
[ -z $1 ] && echo "dthome directory is missing" | tee Rollback.log exit 1

echo "Checking for dynaTraceWebServerAgent service in init.d" | tee Rollback.log exit 1
if [ -e /etc/init.d/dynaTraceWebServerAgent.service ]; then
		echo "Removing dynaTraceWebServerAgent service" | tee Rollback.log exit 1
        rm /etc/init.d dynaTraceWebServerAgent.*
fi

echo "Checking if dthome directory exists" | tee Rollback.log exit 1
if [ -d $1 ]; then
		echo "Removing DTHOME" | tee Rollback.log exit 1
        rm -r $1
fi
echo "Finished removing dynatrace if no errors" | tee Rollback.log exit 1