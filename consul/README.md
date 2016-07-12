# Consul Development Template for Openshift

This template is **NOT** intended for production. It is just for development speed up or PoT

## Objects

* Deployment Configuration with the hub images from Hashicorp
* LB Service for TCP ports (8300, 8400 and 8500)
* Route for http service (8500): Web UI and REST API
* Persistent Volume Claim for consul data

## How to use this template

You need to upload the template to your project

```oc create -f consul.yaml```

You need at least one persistent volume to store the configuration. Otherwise, the configuration will be lost if the container is stopped.

Then, go to openshift console, add to project, filter and select consul

After starting the pod, you can select the route to access the web ui. For example, if the route creates the hostname: 

consul-http.10.2.2.2.xip.io, 

you can go to the web ui at:

https://consul-http.10.2.2.2.xip.io/ui



