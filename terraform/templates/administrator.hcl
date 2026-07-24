# Full administrative access to OpenBao, intended only for members of the platform team via the "openbao-admins"
# Authentik group. This grants the "sudo" capability required for privileged operations such as managing auth methods,
# policies, and secrets engines.
path "*" {
  capabilities = ["create", "read", "update", "delete", "list", "sudo"]
}
