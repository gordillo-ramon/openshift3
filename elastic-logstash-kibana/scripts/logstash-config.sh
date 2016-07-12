#!/bin/bash

oc create configmap logstash-config --from-file=../config/logstash/conf.d
