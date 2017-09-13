#!/bin/bash 

#$DTHOME=$1
#$JBOSSDIR=$2

touch Rollback.log

## start rollback for tomcat 
[ -z $1 ] && echo "dthome directory missing missing" | tee Rollback.log exit 1 exit 1 ## tomcat directory
[ -z $2 ] && echo "JBoss directory missing missing" | tee Rollback.log exit 1 exit 1 ## tomcat directory

### need path for tomcat? otherwise have to recursively go find it 
#### need a check for setenv.sh if not then create one 

echo "Removing DTHOME" | tee Rollback.log exit 1
sed -i -e "/JAVA_OPTS=\"\$JAVA_OPTS -agentpath:.*/d" $2/bin/run.conf 


echo "Finihsed if no errors" | tee Rollback.log exit 1
### restart jboss 

