# qiot-manufacturing-datacenter-installer

steps to install components in Openshift container platform:

## Prerequisites

Download the Openshift client from the [official download page](https://access.redhat.com/downloads/content/290/ver=4.8/rhel---8/4.8.13/x86_64/product-software)

Download helm CLI: https://helm.sh/docs/intro/install/

Login to your SNO with oc CLI.

```
oc login --token=<<USER_TOKEN>> --server=https://api.<<CLUSTER_ADDRESS>>:6443
```

# OCP Vault chart

## Vault

1. Chart Installation Vault
3. Vault Bootstrap (init and unsealed)

```
export WILDCARD=apps.cluster-4ktth.4ktth.sandbox1357.opentlc.com
helm install ocp-vault-install ./ocp-vault-install --dependency-update --create-namespace --set vault.server.route.host=vault.${WILDCARD} --namespace hashicorp
```
>
> VAULT_TOKEN and KEYS are on a secret in the hashicorp namespace.
>

>
> A CronJob checks the sealed status, in case the status is sealed will automatically unseal it.
>


## OLM

1. cert-manager
2. AMQ Streams

```
helm install ocp-pre-install ./ocp-pre-install --create-namespace --namespace manufacturing-dev
```

# OCP Install Chart

1. Kafka
2. Influxdb2
3. Mongo
4. PostgreSQL
5. Create Vault issuer [WIP]

```
export WILDCARD=apps.cluster-4ktth.4ktth.sandbox1357.opentlc.com
helm install core ocp-install --dependency-update --set issuer.wildcardDomain=${WILDCARD} --namespace manufacturing-dev
```