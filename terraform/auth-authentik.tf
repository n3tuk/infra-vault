data "authentik_flow" "default_authentication_flow" {
  slug = "default-authentication-flow"
}

data "authentik_flow" "default_authorization_flow" {
  slug = "default-provider-authorization-implicit-consent"
}

data "authentik_flow" "default_invalidation_flow" {
  slug = "default-provider-invalidation-flow"
}

data "authentik_certificate_key_pair" "default_self_signed" {
  name = "authentik Self-signed Certificate"
}

data "authentik_property_mapping_provider_scope" "openid" {
  name = "authentik default OAuth Mapping: OpenID 'openid'"
}

data "authentik_property_mapping_provider_scope" "email" {
  name = "authentik default OAuth Mapping: OpenID 'email'"
}

data "authentik_property_mapping_provider_scope" "profile" {
  name = "authentik default OAuth Mapping: OpenID 'profile'"
}

resource "authentik_property_mapping_provider_scope" "openbao_groups" {
  name        = "custom OAuth Mapping: OpenBao Groups"
  description = "Adds the names of the user's Authentik groups to the ID token issued to OpenBao."

  scope_name = "openbao-groups"
  expression = "return {\"openbao-groups\": [group.name for group in user.ak_groups.all() if group.name.startswith('openbao-')]}"
}

resource "authentik_provider_oauth2" "openbao" {
  name      = "openbao"
  client_id = "openbao"

  authentication_flow = data.authentik_flow.default_authentication_flow.id
  authorization_flow  = data.authentik_flow.default_authorization_flow.id
  invalidation_flow   = data.authentik_flow.default_invalidation_flow.id

  sub_mode    = "user_email"
  grant_types = ["authorization_code", "refresh_token"]

  signing_key = data.authentik_certificate_key_pair.default_self_signed.id

  allowed_redirect_uris = [
    {
      matching_mode     = "strict"
      redirect_uri_type = "authorization"
      url               = "http://localhost:8250/oidc/callback"
    },
    {
      matching_mode     = "strict"
      redirect_uri_type = "authorization"
      url               = "${var.openbao_url}/ui/vault/auth/authentik/oidc/callback"
    },
  ]

  property_mappings = [
    data.authentik_property_mapping_provider_scope.openid.id,
    data.authentik_property_mapping_provider_scope.email.id,
    data.authentik_property_mapping_provider_scope.profile.id,
    authentik_property_mapping_provider_scope.openbao_groups.id,
  ]
}

resource "authentik_application" "openbao" {
  slug = "openbao"
  name = "OpenBao"


  protocol_provider = authentik_provider_oauth2.openbao.id

  group = "OpenBao"

  meta_icon        = "https://assets.n3t.uk/icons/openbao-256x256.png"
  meta_description = "Secrets management for the n3t.uk infrastructure with OpenBao."
  meta_launch_url  = "${var.openbao_url}/ui/vault/auth?with=authentik%2F"
  meta_publisher   = "OpenBao"
  open_in_new_tab  = true
}

resource "vault_jwt_auth_backend" "authentik" {
  path        = "authentik"
  type        = "oidc"
  description = "OIDC authentication for OpenBao users via Authentik."

  oidc_discovery_url = "${var.authentik_url}/application/o/${authentik_application.openbao.slug}/"
  oidc_client_id     = authentik_provider_oauth2.openbao.client_id
  oidc_client_secret = authentik_provider_oauth2.openbao.client_secret

  bound_issuer = "${var.authentik_url}/application/o/${authentik_application.openbao.slug}/"

  default_role = "reader"
}

resource "vault_jwt_auth_backend_role" "authentik_administrator" {
  backend         = vault_jwt_auth_backend.authentik.path
  bound_audiences = [authentik_provider_oauth2.openbao.client_id]

  role_type = "oidc"
  role_name = "administrator"

  user_claim   = "sub"
  groups_claim = "openbao-groups"

  oidc_scopes = [
    "openid",
    "email",
    "profile",
    "openbao-groups"
  ]

  bound_claims = {
    "openbao-groups" = "openbao-administrator"
  }

  allowed_redirect_uris = [
    "${var.openbao_url}/ui/vault/auth/authentik/oidc/callback",
    "http://localhost:8250/oidc/callback",
  ]

  token_policies = [
    vault_policy.administrator.name,
  ]

  token_ttl     = 900  # 15min
  token_max_ttl = 3600 # 1hrs
}

resource "vault_jwt_auth_backend_role" "authentik_secrets_writer" {
  backend         = vault_jwt_auth_backend.authentik.path
  bound_audiences = [authentik_provider_oauth2.openbao.client_id]

  role_type = "oidc"
  role_name = "writer"

  user_claim   = "sub"
  groups_claim = "openbao-groups"

  oidc_scopes = [
    "openid",
    "email",
    "profile",
    "openbao-groups"
  ]

  bound_claims = {
    "openbao-groups" = "openbao-secrets-writer"
  }

  allowed_redirect_uris = [
    "${var.openbao_url}/ui/vault/auth/authentik/oidc/callback",
    "http://localhost:8250/oidc/callback",
  ]

  token_policies = [
    vault_policy.all_secrets_writer.name,
  ]

  token_ttl     = 900   # 15min
  token_max_ttl = 14400 # 4hrs
}

resource "vault_jwt_auth_backend_role" "authentik_secrets_reader" {
  backend         = vault_jwt_auth_backend.authentik.path
  bound_audiences = [authentik_provider_oauth2.openbao.client_id]

  role_type = "oidc"
  role_name = "reader"

  user_claim   = "sub"
  groups_claim = "openbao-groups"

  oidc_scopes = [
    "openid",
    "email",
    "profile",
    "openbao-groups"
  ]

  allowed_redirect_uris = [
    "${var.openbao_url}/ui/vault/auth/authentik/oidc/callback",
    "http://localhost:8250/oidc/callback",
  ]

  token_policies = [
    vault_policy.all_secrets_reader.name,
  ]

  token_ttl     = 900   # 15min
  token_max_ttl = 14400 # 4hrs
}
