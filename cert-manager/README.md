# Cert Manager Provisioning

## Helm Chart Installation

>
> Requires Helm v3 installed > https://helm.sh/docs/intro/install/
>

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
        --version v1.5.3 \
        --set installCRDs=true
    ```
4. Test the installation

    ```
    oc apply -f sample/test-resource.yaml -n cert-manager
    ```
# Cert Manager is Ready

At this point cert manager is ready to configure your certificate based on your issuer setup.
More information on: https://cert-manager.io/docs/configuration

## Certificate Authority issuer sample

1. Generate CA key pair
  
    >
    > NOTE Verify you have this on your /etc/ssl/openssl.cnf settings
    >

    ```
    [ v3_ca ]
    basicConstraints = critical,CA:TRUE
    subjectKeyIdentifier = hash
    authorityKeyIdentifier = keyid:always,issuer:always
    ```

    ```
    mkdir -p ca/
    
    openssl req -new -nodes -newkey rsa:2048 -x509 -keyout ca/tls.key -out ca/tls.crt -days 365 -subj "/CN=qiot-project.github.io" -extensions v3_ca
    ```
2. Create a secret
  
    `oc create secret generic qiot-ca --from-file=ca/ -n cert-manager`

3. Create Issuer

    `oc apply -f sample/issuer-qiot-ca-sample.yaml -n cert-manager`

4. Request a Certificate

    `oc apply -f sample/certificate-qiot-device-sample.yaml -n cert-manager`

## Vault PKI Infrastructure issuer sample

1. Follow Vault [prerequisite instruction](../vault/README.md)

2. Create Issuer

    >
    > It contains already the caBundle from the current service-ca.crt to validate the vault service.
    >

    `oc apply -f sample/issuer-qiot-vault-sample.yaml -n cert-manager`

4. Request a Certificate

    `oc apply -f sample/certificate-qiot-device-vault-issuer.yaml -n cert-manager`

## Manual Issuer setup

1. Setup PKI engine for each environment {dev,int,prod}

    >
    > Unseal Vault before!!
    >

    ```
    export VAULT_ADDR=https://$(oc get route vault --no-headers -o custom-columns=HOST:.spec.host -n hashicorp)
    export KEYS=BwM/CVRTq0cgYvkZdyqV98uHkxWkTO+eGWO1jZAnTbw=
    export VAULT_TOKEN=s.a5qNdR8daXNuai6g8tboAV6O
    export PROJECT=manufacturing-dev
    export WILDCARD=apps.cluster-5606.5606.sandbox1612.opentlc.com

    sh ../vault-bootstrap/setup.sh ${PROJECT} ${WILDCARD}
    ```

2. Configure the issuer on the target project.

   ```
   helm upgrade --install vault issuer/ -n ${PROJECT}
   ```
 
 3. Install Issuer

    ```
    helm upgrade --install vault issuer -n ${PROJECT} --set issuer.create=true
    ```

4. Verify Dummy Certificate Secret is created

    ```
    oc get secret vault-issuer-dummy-cert -n ${PROJECT}
    ```




