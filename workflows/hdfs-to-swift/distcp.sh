#!/bin/sh

# Set the below parameters empty if username and password are hardcoded via Cloudera Manager
USERNAME_PARAMETER="-D fs.swift.service.<PROVIDER>.username=<username>"
PASSWORD_PARAMETER="-D fs.swift.service.<PROVIDER>.password=<password>"

export HADOOP_USER_NAME=<user-to-run-workflow>

SOURCES=/user/${HADOOP_USER_NAME}/workflows/hdfs-to-swift/sourcelist.txt

# Target swift location, like swift://sasa.cto/demo-applications
TARGET=swift://<CONTAINER-NAME>.<PROVIDER>/<PSEUDO-FOLDER>

hadoop distcp ${USERNAME_PARAMETER} ${PASSWORD_PARAMETER} -owerwrite -delete -update -p -f ${SOURCES} ${TARGET}

RC=$?

if [ $RC -ne 0 ]
    then
	echo "ERROR: Error while doing distsp!"
    else
	echo "SUCCESS: Distcp was successfull!"
fi

exit $RC
