path "cert-manager-io*" {
  capabilities = ["read", "list"]
}
path "cert-manager-io/roles/qiot-project-github-io" {
  capabilities = ["create", "update"]
}
path "cert-manager-io/sign/qiot-project-github-io" {
  capabilities = ["create", "update"]
}
path "cert-manager-io/issue/qiot-project-github-io"  {
  capabilities = ["create", "update"]
}