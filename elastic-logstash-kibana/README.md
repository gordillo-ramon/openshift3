# ELK Development Template for Openshift

This template is **NOT** intended for production. It is just for development speed up or PoT.

## Prerequisites

You should have a elasticsearch/logstash/kibana configuration. A sample one is shown in config folder

## Objects

* Logstash from elastic.co (version 5, currently in alpha4)
	* DeploymentConfig
* ElasticSearch from elastic.co (version 5, currently in alpha4)
	* PersistentVolumeClaim
	* DeploymentConfig
	* Service (9200 and 9300)
* Kibana from elastic.co (version 5, currently in alpha4)
	* DeploymentConfig
	* Service (5601)
	* Route

## How to use this template

Once you have your configuration tested, create a configMap object per product. Sample scripts for doing that with "oc" client are shown in scripts folder.

You need at least one persistent volume to store the elasticsearch data. Otherwise, the data will be lost if the container is stopped.

You need to upload the template to your project

```oc create -f elastic-logstash-kibana.yaml```

Then, go to openshift console, add to project, filter and select elastic-logstash-kibana

After starting the pod, you can select the route to access the web ui for kibana. For example, if the route creates the hostname: 

kibana.10.2.2.2.xip.io, 

you can go to kibana web at:

https://kibana.10.2.2.2.xip.io

Two additional templates are provided, service-logstash.yaml and route-logstash.yaml. The former is an service (port 8080) example in case you want to load-balance logstash ingestion or you need to add a route afterwards, and the latter is an example for a logstash route if the source has no visibility to logstash pod or service.

## Additional resources

A sample docker-compose file for testing locally the elk configuration before setting configMaps in kubernetes is provided in docker-compose folder