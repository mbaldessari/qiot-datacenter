path "sys/mounts/manufacturing-dev-pki-*" {
  capabilities = ["create", "read", "update", "delete", "list"]
}

path "/manufacturing-dev-pki-*" {
  capabilities = ["create", "read", "update", "delete", "list"]
}