output "secrets_mount_path" {
  description = "The mount paths of the KV v2 secrets engines used to store infrastructure secrets."

  value = {
    n3tuk          = vault_mount.n3tuk.path
    kub3uk         = vault_mount.kub3uk.path
    github_actions = vault_mount.github_actions.path
  }
}

output "authentik_auth_path" {
  description = "The mount path of the Authentik OIDC authentication backend used to authenticate users."
  value       = vault_jwt_auth_backend.authentik.path
}

output "authentik_auth_accessor" {
  description = "The accessor for the Authentik OIDC authentication backend used to authenticate users."
  value       = vault_jwt_auth_backend.authentik.accessor
}

output "github_actions_auth_path" {
  description = "The mount path of the GitHub Actions OIDC authentication backend used to authenticate GitHub Actions runners."
  value       = vault_jwt_auth_backend.github_actions.path
}

output "github_actions_auth_accessor" {
  description = "The accessor for the GitHub Actions OIDC authentication backend used to authenticate GitHub Actions runners."
  value       = vault_jwt_auth_backend.github_actions.accessor
}

output "authentik_application_slug" {
  description = "The slug of the Authentik application created for OpenBao, used to construct the OIDC discovery URL."
  value       = authentik_application.openbao.slug
}

output "apps_auth_path" {
  description = "The mount path of the AppRole authentication backend used by services."
  value       = vault_auth_backend.approle.path
}

output "app_raft_snapshotter_role_id" {
  description = "The Role ID for the raft-snapshotter AppRole."
  value       = vault_approle_auth_backend_role.raft_snapshotter.role_id
}

output "app_raft_snapshotter_secret_id" {
  description = "The Secret ID for the raft-snapshotter AppRole."
  value       = vault_approle_auth_backend_role_secret_id.raft_snapshotter.secret_id
  sensitive   = true
}
