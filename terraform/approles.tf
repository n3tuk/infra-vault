resource "vault_approle_auth_backend_role" "raft_snapshotter" {
  backend   = vault_auth_backend.approle.path
  role_name = "raft-snapshotter"

  token_policies = [vault_policy.raft_snapshotter.name]

  token_ttl     = 60
  token_max_ttl = 900
}

resource "vault_approle_auth_backend_role_secret_id" "raft_snapshotter" {
  backend   = vault_auth_backend.approle.path
  role_name = vault_approle_auth_backend_role.raft_snapshotter.role_name

  metadata = jsonencode({
    "deployed_by" = "terraform"
    "purpose"     = "openbao-raft-snapshotter-cron-job"
  })
}
