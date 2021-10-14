# Install Apicur.io

## Preparation:

Adjust the openshift domain in the 3 YML files with the domain of your datacenter installation.

## Step 0:

- Login to your SNO with oc CLI.

```
oc login -u kubeadmin -p [KUBEADMIN-PASSWORD] --server=https://api.[SNO.DOMAIN].com:6443
```

## Step 1:

- Deploy the database (PostgreSQL) piece.

This template will contain the operators of Openshift-GitOps, AMQ-Broker and the MachineConfig to mount HostPath for persistence of MongoDB and PostgreSQL.

```
oc process -f apicurio-postgres-template.yml | oc create -f -
```

## Step 2:

- Deploy the authentication (Keycloak) piece.

```
Deploy the database piece
```

Configure the Keycloak instance following [the offivcial Apicur.io guide](https://www.apicur.io/studio/docs/setting-up-keycloak-for-use-with-apicurio) starting from chapter 4

## Step 3:

- Deploy Apicur.io components.

```
oc process -f apicurio-template.yml | oc create -f -
```
