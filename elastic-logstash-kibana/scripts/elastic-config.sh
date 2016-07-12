#!/bin/bash

oc create configmap elastic-config --from-file=../config/elasticsearch/config
