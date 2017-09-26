#!/bin/bash 
DATE_WITH_TIME=`date "+[%d/%m/%Y %H:%M:%S]"`

function ipValid {

#### CHECK MALFORMED IP

re='^(0*(1?[0-9]{1,2}|2([0-4][0-9]|5[0-5]))\.){3}'
 re+='0*(1?[0-9]{1,2}|2([‌​0-4][0-9]|5[0-5]))$'
 
 ## checking if the ip address is malformed or not
if [[ $1 =~ $re ]]; then
  echo $DATE_WITH_TIME "Collector IP Address Welformed" | tee -a deploy.log
  echo $DATE_WITH_TIME "Checking if collector is reachable" | tee -a deploy.log
  
  ## This will check if collector ip on port 9998 is reachable <- a time out period of 10 seconds have been set, if it takes longer than assuming cannot connect
    timeout 10 bash -c "echo > /dev/tcp/$1/9998 > /dev/null 2>&1"  && echo $DATE_WITH_TIME "Can connect to $1:9998" | tee -a deploy.log || echo $DATE_WITH_TIME "Can't connect to  $1:9998" | tee -a deploy.log | exit 1
	
else

  echo $DATE_WITH_TIME "Collector IP Address Malformed" | tee -a deploy.log
  
  exit 1 
  
fi


}