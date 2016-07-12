#!/bin/bash

oc create configmap kibana-config --from-file=../config/kibana/config
