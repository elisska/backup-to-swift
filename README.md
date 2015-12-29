# HDFS/SWIFT integration

## Initial configuration

* Download the correct version of hadoop-openstack integration lib from [here](http://grepcode.com/project/repository.cloudera.com/content/repositories/releases/org.apache.hadoop/hadoop-openstack/) or use the [attached jar](hadoop-openstack-2.6.0-cdh5.5.1.jar)
* Place it to the folder containing hadoop libraries on every node (if CDH is used then this folder would be /opt/cloudera/parcels/CDH/lib/hadoop)
* Add lines from [configuration.xml](configuration.xml) to **core-site.xml** configuration file (if CLoudera Manager is used, go to YARN configuration, search for _YARN Service Advanced Configuration Snippet (Safety Valve) for core-site.xml_ and add the lines to the section, then restart cluster)
* Test the integration using commands like below:

**Copy data from HDFS to Swift:**

```
hadoop distcp -D fs.swift.service.<PROVIDER>.username=<username> -D fs.swift.service.<PROVIDER>.password=<api-key> -update -p <PATH-ON-HDFS> swift://<CONTAINER-NAME>.<PROVIDER>/<OBJECT-NAME>
```

**Copy data from Swift to HDFS:**

```
hadoop distcp -D fs.swift.service.<PROVIDER>.username=<username> -D fs.swift.service.<PROVIDER>.password=<api-key> -update -p swift://<CONTAINER-NAME>.<PROVIDER>/<OBJECT-NAME> <PATH-ON-HDFS> 
```

## Oozie workflow

You can use Oozie workflow to perform regular backup from HDFS to Swift. 

Please follow the below steps to enable the workflow on your environment.

* Clone the repo to your environment and cd to workflows/hdfs-to-swift
* Edit _hdfs-to-swift.properties_ file and specify parameters specific to your environment
* Edit _sourcelist.txt_ file and specify HDFS directories to backup
* Edit _distcp.sh_ file and specify parameters specific to your environment (edit lines 4, 5, 7 and 12)
* Copy workflow directory to HDFS:

```
hdfs dfs -put -f workflows /user/$USER
```

* Run coordinator job as below:

```
oozie job -oozie http://<oozie-server-hostname>:11000/oozie -run -config workflows/hdfs-to-swift/hdfs-to-swift.properties
```

* Monitor the coordinator and workflow jobs via HUE or Oozie WebUI.
