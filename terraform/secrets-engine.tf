resource "vault_mount" "github_actions" {
  path = "github-actions"
  type = "kv"

  description = "Secrets for the GitHub Actions workflows as part of the n3t.uk Lab Environment and Organization."

  options = {
    version = "2"
  }

  lifecycle {
    prevent_destroy = true
  }
}

moved {
  from = vault_kv_secret_backend_v2.secrets
  to   = vault_kv_secret_backend_v2.github_actions
}

resource "vault_kv_secret_backend_v2" "github_actions" {
  mount = vault_mount.github_actions.path

  max_versions = 10
  cas_required = true
}

resource "vault_mount" "n3tuk" {
  path = "n3t.uk"
  type = "kv"

  description = "Secrets for the n3t.uk infrastructure and systems."

  options = {
    version = "2"
  }

  lifecycle {
    prevent_destroy = true
  }
}

resource "vault_kv_secret_backend_v2" "n3tuk" {
  mount = vault_mount.n3tuk.path

  max_versions = 10
  cas_required = true
}

resource "vault_mount" "kub3uk" {
  path = "kub3.uk"
  type = "kv"

  description = "Secrets for the kub3.uk Kubernetes clusters."

  options = {
    version = "2"
  }

  lifecycle {
    prevent_destroy = true
  }
}

resource "vault_kv_secret_backend_v2" "kub3uk" {
  mount = vault_mount.kub3uk.path

  max_versions = 10
  cas_required = true
}
