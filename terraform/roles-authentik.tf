resource "vault_identity_group" "administrator" {
  name = "administrator"
  type = "external"

  metadata = {
    description = "Full administrative access to OpenBao."
  }

  policies = [
    vault_policy.administrator.name,
  ]
}

resource "authentik_group" "administrator" {
  name = "openbao-administrator"
}

resource "authentik_policy_binding" "administrator" {
  order  = 0
  target = authentik_application.openbao.uuid
  group  = authentik_group.administrator.id
}

resource "vault_identity_group_alias" "authentik_administrator" {
  name           = authentik_group.administrator.name
  mount_accessor = vault_jwt_auth_backend.authentik.accessor
  canonical_id   = vault_identity_group.administrator.id
}

resource "vault_identity_group" "all_secrets_writer" {
  name = "all-secrets-writer"
  type = "external"

  metadata = {
    description = "Allow read/write access to the infrastructure secrets in OpenBao."
  }

  policies = [
    vault_policy.all_secrets_writer.name
  ]
}

resource "authentik_group" "all_secrets_writer" {
  name = "openbao-secrets-writer"
}

resource "authentik_policy_binding" "all_secrets_writer" {
  order  = 1
  target = authentik_application.openbao.uuid
  group  = authentik_group.all_secrets_writer.id
}

resource "vault_identity_group_alias" "authentik_all_secrets_writer" {
  name           = authentik_group.all_secrets_writer.name
  mount_accessor = vault_jwt_auth_backend.authentik.accessor
  canonical_id   = vault_identity_group.all_secrets_writer.id
}

resource "vault_identity_group" "all_secrets_reader" {
  name = "all-secrets-reader"
  type = "external"

  metadata = {
    description = "Allow read-only access to the infrastructure secrets in OpenBao."
  }

  policies = [
    vault_policy.all_secrets_reader.name
  ]
}

resource "authentik_group" "all_secrets_reader" {
  name = "openbao-secrets-reader"
}

resource "authentik_policy_binding" "all_secrets_reader" {
  order  = 2
  target = authentik_application.openbao.uuid
  group  = authentik_group.all_secrets_reader.id
}

resource "vault_identity_group_alias" "authentik_all_secrets_reader" {
  name           = authentik_group.all_secrets_reader.name
  mount_accessor = vault_jwt_auth_backend.authentik.accessor
  canonical_id   = vault_identity_group.all_secrets_reader.id
}
