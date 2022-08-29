# Creating a new validated pattern or community pattern

The validated patterns community has relied on existing architectures that have been successfully deployed in an enterprise.
The architecture itself is a best practice in assembling technologies and projects to provide a working solution.
How that solution is deployed and managed is a different matter. It may have evolved over time and may have grown
in its deployment such that ongoing maintenance is not sustainable.

The validated patterns framework is much more of a best practice of structuring the various configuration assets
and integrating with GitOps and DevOps tools. Therefore the question really is: how do I move my successful
architecture solution into a sustainable GitOps/DevOps framework? And that is what we are going to do in this section.

***NOTE***

This is a document that is still Work In Progress (WIP).

## Namespaces and Operator Groups

A Kubernetes namespace provides a mechanism to scope resources in a cluster. In OpenShift,
a project is a Kubernetes namespace with additional annotations. Namespaces provide a unique
scope for: Named resources to avoid basic naming collisions.

The **validated patterns framework** allows you to describe the namespaces the pattern requires.
In order to have the Validated Pattern framework to create this namespace all you have to do is
describe them in the **namespaces** section.

```yaml
  # The framework will create the namespace and the operator group
  namespaces:
  - manufacturing-dev
  - hashicorp
```

The VP Framework not only will create the namespace in OpenShift but it will also create an
Operator Group in that namespace. An Operator group, defined by the OperatorGroup resource,
provides multitenant configuration to OLM-installed Operators. An Operator group selects target
namespaces in which to generate required RBAC access for its member Operators.

The **operatorgroupExcludes** sectrion is used in case you want to exclude an operator group from being created in
a specified namespace.

```yaml
  operatorgroupExcludes:
  - <namespace>
```

## Describing Operator Subscriptions

Operators are used in OpenShift as a way to install services that are needed by the application workload.
The Validated Pattern framework gives you a way to describe these operators in a values file that is
specific to your Validated Pattern. The **values-qiot-datacenter.yaml** is the file that describes the
components that will be installed for this **community pattern**.

To describe the operators that the validated pattern framework will deploy on the Kubernetes cluster environment we
first take a look at the subscriptions section included in the **values-qiot-datacenter.yaml** file.

The subscriptions section lists the operators that are needed by the validated pattern. These will be deployed
by the **Validated Patterns framework**. In the **values-qiot-datacenter.yaml** you will find the **subscriptions**
section that will tell the framework to deploy the operators onto the OpenShift cluster.

```yaml
  subscriptions:
 # TODO: Allow namespace to be a list
    amqstreams-dev:
      name: amq-streams
      namespace: manufacturing-dev
      channel: stable
      csv: amqstreams.v2.1.0-6

    cert-manager-dev:
      name: cert-manager
      channel: stable
      source: community-operators
      csv: cert-manager.v1.9.1
```


## ArgoCD sections

```yaml
  projects:
  - qiot-datacenter
```

```yaml
  applications:

    ocp-install:
      name: ocp-install
      namespace: manufacturing-dev
      project: qiot-datacenter
      path: charts/qiot-datacenter/ocp-install

    vault-issuer:
      name: vault-issuer
      namespace: manufacturing-dev
      project: qiot-datacenter
      path: charts/qiot-datacenter/issuer

    ocp-srv-apps:
      name: ocp-srv-apps
      namespace: manufacturing-dev
      project: qiot-datacenter
      path: charts/qiot-datacenter/ocp-srv-install

    vault:
      name: vault
      namespace: hashicorp
      project: qiot-datacenter
      chart: vault
      repoURL: https://hybrid-cloud-patterns.github.io/validated-pattern-charts/
      targetRevision: 0.0.6
      overrides:
      - name: global.openshift
        value: true
      - name: vault.init
        value: true
      - name: vault.enabled
        value: true
      - name: vault.server.route.enable
        value: true
      - name: vault.server.route.host
        value: null
      - name: vault.server.extraEnvironmentVars.VAULT_ADDR
        value: https://vault-internal.hashicorp.svc.cluster.local:8200
```
