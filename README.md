# Hybrid Cloud Community Pattern qiot-manufacturing-datacenter-installer

This repository is based on the qiot-manufacturing-datacenter-installer that can be found in
the [qiot-data-center-installer](https://github.com/qiot-project/qiot-manufacturing-datacenter-installer) that has been
converted to use the Validated Patterns framwork.

The components in this community pattern are now installed using the openshift-gitops ArgoCD implementation.
The state of the pattern is now strictly found in the manifests in *git*.  The validated patterns framework
has been committed to GitOps as a philosophy and operational practice since the beginning.
The framework’s use of ArgoCD as a mechanism for deploying applications and components is proof of our
commitment to GitOps core principles of having a declared desired end state, and a designated agent to
bring about that end state.

## Prerequisites

  - A deployed OpenShift cluster via IPI or UPI
    - The IPI installer will create all the proper components needed to run an OpenShift cluster.

  - When using UPI the cluster will need access to the following services:
    - DNS
    - Storage
    - Configure DHCP.
    - Provision required load balancers.
    - Configure the ports for your machines.
    - Ensure network connectivity.


## How to deploy

There are two ways of deploying this community pattern.

1. From the command line by executing **make install**
2. Installing the Validated Patterns community operator and creating a pattern instance.

### Command Line deployment

You will need to install the **make** utility in order to start the deployment from the command line.

Fedora and Red Hat Linux:
```sh
sudo dnf install make
```

You will also need to set the **KUBECONFIG** environment variable or login using the **oc login** command.

```sh
export KUBECONFIG=<cluster-config-dir>/auth/kubeconfig
```

```sh
oc login --token=<<USER_TOKEN>> --server=https://api.<<CLUSTER_ADDRESS>>:6443
```


## Cleanup

There are a few ways to do the cleanup.  This will be detailed at a later time.


## Components that will get installed

### OLM

1. HashiCorp Vault
1. Cert Manager
1. AMQ Streams
1. Kafka
1. Influxdb2
1. Mongo
1. PostgreSQL
1. Vault issuer
1. Event Collector service
1. Plant Manager service
1. Product Line service
1. Registration service
