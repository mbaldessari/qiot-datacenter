# Environment Setup

## Prerequisites

>
> Requires Helm v3 installed > https://helm.sh/docs/intro/install/
>

>
> Requires vault > https://www.vaultproject.io/downloads
>

## Cert Manager Installation

1. Create OpenShift Project.

    `oc new-project cert-manager`

2. Add jetstack helm repository.

    ```bash
    helm repo add jetstack https://charts.jetstack.io
    helm repo update
    ```
3. Launch the helm installation

    ```bash
    helm upgrade --install \
        cert-manager jetstack/cert-manager \
        --namespace cert-manager \
        --version v1.5.4 \
        --set installCRDs=true
    ```
4. Test the installation

    ```
    oc apply -f tests/cert-resource.yaml -n cert-manager
    ```

## Hashicorp Vault Installation

1. Configure Helm Repository

    ```
    helm repo add hashicorp https://helm.releases.hashicorp.com
    helm search repo hashicorp/vault
    ```

2. Install Vault

    ```
    oc new-project hashicorp
    helm install vault hashicorp/vault -f vault/standalone.yaml
    ```

3. Init Vault and Unseal

    ```
    oc rsh vault-0
    vault operator init -key-shares=1 -key-threshold=1

    Unseal Key 1: xxx
    Initial Root Token: xxx

    export KEYS=xxx
    export VAULT_TOKEN=xxx

    vault operator unseal $KEYS
    ```

4. Enable Kubernetes Auth

    ```
    JWT=$(cat /var/run/secrets/kubernetes.io/serviceaccount/token)
    KUBERNETES_HOST=https://${KUBERNETES_PORT_443_TCP_ADDR}:443

    vault auth enable --tls-skip-verify kubernetes
    vault write --tls-skip-verify auth/kubernetes/config token_reviewer_jwt=$JWT kubernetes_host=$KUBERNETES_HOST kubernetes_ca_cert=@/var/run/secrets/kubernetes.io/serviceaccount/ca.crt
    ```

## Cert Manager and Vault PKI Integration

![Cert Manager Vault Integration!](images/architecture.png "Cert Manager Vault Integration")

1. Setup PKI engine for each environment

    >
    > Unseal Vault before!!
    >

    ```
    export VAULT_ADDR=https://$(oc get route vault --no-headers -o custom-columns=HOST:.spec.host -n hashicorp)
    export VAULT_TOKEN=xxx
    export WILDCARD=apps.$(oc get dns cluster -o jsonpath='{.spec.baseDomain}')

    export PROJECT=app-dev
    
    sh vault/pki/setup.sh ${PROJECT} ${WILDCARD}
    ```
 
2. Install Issuer

    ```
    helm upgrade --install ${PROJECT} vault/issuer -n ${PROJECT}
    ```

3. Verify Dummy Certificate Secret is created

    ```
    oc get secret ${PROJECT}-issuer-dummy-cert -n ${PROJECT}
    ```

## Intermedia CA

1. Service Account Vault Role binding

```
vault policy write -tls-skip-verify registration-manufacturing-dev-admin ./policy/registration-admin.hcl

vault write -tls-skip-verify auth/kubernetes/role/manufacturing-dev-reg-policy bound_service_account_names=registration-service bound_service_account_namespaces=manufacturing-dev policies=registration-manufacturing-dev-admin ttl=1h
```

2. Login to Vault with registration-service SA.

```
JWT=$(oc sa get-token registration-service -n manufacturing-dev)

vault write --tls-skip-verify auth/kubernetes/login role=registration-admin jwt=${JWT}

vault write --tls-skip-verify auth/kubernetes/login role=manufacturing-dev-reg-policy jwt=${JWT}

export VAULT_TOKEN=xxx 
```

3. Enable the Intermediate CA

```
vault secrets enable -path=manufacturing-dev-pki-factory01 -tls-skip-verify pki

vault secrets tune -max-lease-ttl=43800h -tls-skip-verify manufacturing-dev-pki-factory01
````

4. Sign it with the rootCA

```
vault write -format=json -tls-skip-verify manufacturing-dev-pki-factory01/intermediate/generate/exported common_name="factory01.manufacturing-dev.qiot-project.io Intermediate Authority" | jq -r '.data.csr' > pki_intermediate.csr

vault write -format=json -tls-skip-verify manufacturing-dev-pki/root/sign-intermediate csr=@pki_intermediate.csr format=pem_bundle ttl="43800h" | jq -r '.data.certificate' > intermediate.cert.pem

vault write -tls-skip-verify manufacturing-dev-pki-factory01/intermediate/set-signed certificate=@intermediate.cert.pem
```