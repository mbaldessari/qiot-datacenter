#!/bin/bash

if [ "$#" -ne 1 ]; then
    echo "Missing Projects"
fi

export BASE_DOMAIN=${3:-qiot-project.io}
export PROJECT=$1
export PKI=${PROJECT}-pki
export DOMAIN=${PROJECT}.$BASE_DOMAIN
export ROLE=${PROJECT}-$BASE_DOMAIN
export SERVICE_ACCOUNT=default
export WILDCARD_DOMAIN=$2

echo "Clean up on ${PROJECT}"

echo "Disable PKI Engine ${PKI}"

vault secrets disable -tls-skip-verify ${PKI} 

vault delete --tls-skip-verify auth/kubernetes/role/${ROLE}