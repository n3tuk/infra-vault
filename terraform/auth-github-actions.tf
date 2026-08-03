resource "github_actions_organization_oidc_subject_claim_customization_template" "organization" {
  include_claim_keys = ["repository"]
}

resource "vault_jwt_auth_backend" "github_actions" {
  path        = "github-actions"
  type        = "jwt"
  description = "JWT authentication for GitHub Actions workflows via GitHub's OIDC provider."

  oidc_discovery_url = "https://token.actions.githubusercontent.com"
  bound_issuer       = "https://token.actions.githubusercontent.com"
}

resource "vault_jwt_auth_backend_role" "infra_vault" {
  backend   = vault_jwt_auth_backend.github_actions.path
  role_name = "github-actions-n3tuk-infra-vault"
  role_type = "jwt"

  # bound_subject     = "repo:n3tuk@133578724/infra-vault@1295266741:*"
  # bound_claims_type = "string"
  user_claim = "repository"

  bound_audiences = [
    "https://github.com/n3tuk",
  ]

  token_policies = [
    vault_policy.infra_vault.name
  ]

  token_type    = "service"
  token_ttl     = 600
  token_max_ttl = 3600
}

resource "vault_policy" "infra_vault" {
  name = "github-actions-n3tuk-infra-vault"
  policy = templatefile("${path.module}/templates/n3tuk-infra-vault.hcl", {
    mounts = [
      {
        comment = "GitHub Actions Secrets Engine"
        path    = vault_mount.github_actions.path
      },
      {
        comment = "kub3.uk Secrets Engine"
        path    = vault_mount.kub3uk.path
      },
      {
        comment = "n3t.uk Secrets Engine"
        path    = vault_mount.n3tuk.path
      },
    ]
  })
}

resource "vault_jwt_auth_backend_role" "infra_github" {
  backend   = vault_jwt_auth_backend.github_actions.path
  role_name = "github-actions-n3tuk-infra-github"
  role_type = "jwt"

  # bound_subject     = "repo:n3tuk@133578724/infra-github@1310464393:*"
  # bound_claims_type = "string"
  user_claim = "repository"

  bound_audiences = [
    "https://github.com/n3tuk",
  ]

  token_policies = [
    vault_policy.infra_github.name,
  ]

  token_type    = "service"
  token_ttl     = 3600
  token_max_ttl = 3600
}

resource "vault_policy" "infra_github" {
  name = "github-actions-n3tuk-infra-github"
  policy = templatefile("${path.module}/templates/n3tuk-infra-github.hcl", {
    mount = vault_mount.github_actions.path
  })
}
