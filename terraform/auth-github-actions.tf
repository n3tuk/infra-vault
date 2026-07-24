resource "github_actions_organization_oidc_subject_claim_customization_template" "organization" {
  include_claim_keys = ["repository", "event_name", "ref", "job_workflow_ref"]
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

  user_claim = "repository"

  bound_audiences   = ["https://github.com/n3tuk"]
  bound_claims_type = "string"

  bound_claims = {
    # Only when used in the subject does GitHub Actions OIDC use the immutable Organization and repository IDs, so
    # checking against the subject rather than the repository claim is the only way to ensure that the role is only used
    # by the intended repository.
    sub = "repo:n3tuk@133578724/infra-vault@1295266741:*"
  }

  token_policies = [
    vault_policy.infra_vault.name
  ]

  # GitHub Actions tokens are single-use; batch tokens are cheaper for OpenBao to issue and do not need to be tracked
  # for renewal, which is appropriate for short-lived CI/CD workflows.
  token_type    = "batch"
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

  user_claim = "repository"

  bound_audiences   = ["https://github.com/n3tuk"]
  bound_claims_type = "string"

  bound_claims = {
    sub = "repo:n3tuk@133578724/infra-github@1310464393:*"
  }

  token_policies = [
    vault_policy.infra_github.name,
  ]

  token_type    = "batch"
  token_ttl     = 3600
  token_max_ttl = 3600
}

resource "vault_policy" "infra_github" {
  name = "github-actions-n3tuk-infra-github"
  policy = templatefile("${path.module}/templates/n3tuk-infra-github.hcl", {
    mount = vault_mount.github_actions.path
  })
}
