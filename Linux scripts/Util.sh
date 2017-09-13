#!/bin/bash 

function ipValid {

#### CHECK MALFORMED IP

re='^(0*(1?[0-9]{1,2}|2([0-4][0-9]|5[0-5]))\.){3}'
 re+='0*(1?[0-9]{1,2}|2([‌​0-4][0-9]|5[0-5]))$'
 
if [[ $1 =~ $re ]]; then
  echo "Collector IP Address Welformed" | tee -a deploy.log
  echo "Checking if collector is reachable" | tee -a deploy.log
   (echo > /dev/tcp/"$1"/9998) > /dev/null 2>&1 && echo "Can connect to $1:9998" | tee -a deploy.log || echo "Can't connect to  $1:9998" | tee -a deploy.log
 
else

  echo "Collector IP Address Malformed" | tee -a deploy.log
  
  exit 1 
  
fi


}