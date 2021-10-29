# qiot-manufacturing-datacenter-installer

# OCP Pre Install chart

1. Chart Installation Vault
3. Vault Bootstrap (init and unsealed)

```
export WILDCARD=apps.cluster-4ktth.4ktth.sandbox1357.opentlc.com
oc new-project hashicorp
helm install vault ocp-pre-install --dependency-update --set vault.server.route.host=vault.${WILDCARD} -n hashicorp
```
>
> VAULT_TOKEN and KEYS are on a secret in the hashicorp namespace.
>

>
> A CronJob check the sealed status and in case is sealed will automatically unseal it.
>


# OCP Install Chart

1. Subscription cert-manager
2. Influxdb2
3. Mongo
4. PostgreSQL
5. Create Vault issuer

```
oc new-project manufacturing-dev
helm install core ocp-install --dependency-update -n manufacturing-dev
```