#!/bin/bash

oc create secret generic htpass-secret --from-file=htpasswd=users.htpasswd -n openshift-config 