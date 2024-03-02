provider "auth0" {
  domain = var.auth0_domain
}

# Configure the standard authentication with a custom Auth0 client (application)
# using OIDC, saving the configuration to Vault for access
resource "auth0_client" "vault" {
  name        = "vault-${local.environment}"
  description = "Vault SSO for ${terraform.workspace}"
  logo_uri    = "https://assets.n3t.uk/vault-512x512.png"

  app_type = "regular_web"

  allowed_origins = ["https://${terraform.workspace}"]
  web_origins     = ["https://${terraform.workspace}"]

  callbacks = [
    "https://${terraform.workspace}/ui/vault/auth/auth0/oidc/callback",
    "https://${terraform.workspace}:8200/ui/vault/auth/auth0/oidc/callback",
    "http://localhost:8250/oidc/callback",
  ]

  custom_login_page_on = true
  cross_origin_auth    = false
  oidc_conformant      = true

  grant_types = [
    "implicit",
    "authorization_code",
    "refresh_token",
    "client_credentials",
  ]

  refresh_token {
    leeway          = 0
    token_lifetime  = 2592000
    rotation_type   = "rotating"
    expiration_type = "expiring"
  }

  jwt_configuration {
    alg = "RS256"
  }
}

resource "random_string" "vault_client_secret" {
  length           = 63
  special          = true
  override_special = "+-="
}

resource "auth0_client_credentials" "vault" {
  authentication_method = "client_secret_post"
  client_id             = auth0_client.vault.id
  client_secret         = random_string.vault_client_secret.result
}

data "auth0_connection" "google_oauth2" {
  name = "google-oauth2"
}

resource "auth0_connection_client" "vault" {
  client_id     = auth0_client.vault.id
  connection_id = data.auth0_connection.google_oauth2.id
}

resource "vault_jwt_auth_backend" "oidc" {
  description = "Auth0 OIDC Backend"

  path         = "oidc"
  type         = "oidc"
  default_role = "reader"

  bound_issuer       = "https://n3tuk.uk.auth0.com/"
  oidc_discovery_url = "https://n3tuk.uk.auth0.com/"
  oidc_client_id     = auth0_client.vault.client_id
  oidc_client_secret = random_string.vault_client_secret.result

  tune {
    default_lease_ttl = "1h"
    max_lease_ttl     = "8h"

    token_type = "default-service"
  }
}
