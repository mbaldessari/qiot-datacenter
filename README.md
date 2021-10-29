# qiot-manufacturing-datacenter-installer

# OCP Pre chart

## OLM

1. cert-manager
2. AMQ Streams

## Vault

1. Chart Installation Vault
3. Vault Bootstrap (init and unsealed)

```
export WILDCARD=apps.cluster-4ktth.4ktth.sandbox1357.opentlc.com
helm install vault ocp-vault-install --dependency-update --create-namespace --set vault.server.route.host=vault.${WILDCARD} -n hashicorp
```
>
> VAULT_TOKEN and KEYS are on a secret in the hashicorp namespace.
>

>
> A CronJob checks the sealed status, in case the status is sealed will automatically unseal it.
>

# OCP Install Chart

1. Kafka
2. Influxdb2
3. Mongo
4. PostgreSQL
5. Create Vault issuer [WIP]

```
export WILDCARD=apps.cluster-4ktth.4ktth.sandbox1357.opentlc.com
helm install core ocp-install --dependency-update --create-namespace --set issuer.wildcardDomain=${WILDCARD} -n manufacturing-dev
```