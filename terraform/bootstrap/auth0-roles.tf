resource "vault_jwt_auth_backend_role" "administrator" {
  backend = vault_jwt_auth_backend.oidc.path

  role_type    = "oidc"
  oidc_scopes  = ["openid", "email", "profile"]
  user_claim   = "email"
  groups_claim = "user_groups"

  role_name      = "administrator"
  token_policies = ["administrator", "default"]

  allowed_redirect_uris = [
    "https://${terraform.workspace}/ui/vault/auth/oidc/oidc/callback",
    "https://${terraform.workspace}:8200/ui/vault/auth/oidc/oidc/callback",
    "http://localhost:8250/oidc/callback",
  ]

  verbose_oidc_logging = true
}

resource "vault_jwt_auth_backend_role" "reader" {
  backend = vault_jwt_auth_backend.oidc.path

  role_type   = "oidc"
  oidc_scopes = ["openid", "email", "profile"]

  role_name    = "reader"
  user_claim   = "email"
  groups_claim = "user_groups"

  token_policies = ["reader", "default"]

  allowed_redirect_uris = [
    "https://${terraform.workspace}/ui/vault/auth/oidc/oidc/callback",
    "https://${terraform.workspace}:8200/ui/vault/auth/oidc/oidc/callback",
    "http://localhost:8250/oidc/callback",
  ]

  verbose_oidc_logging = true
}
