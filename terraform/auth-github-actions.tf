resource "github_actions_organization_oidc_subject_claim_customization_template" "organization" {
  include_claim_keys = ["repository"]
}

resource "vault_jwt_auth_backend" "github_actions" {
  path        = "github-actions"
  type        = "jwt"
  description = "JWT authentication for GitHub Actions workflows via GitHub's OIDC provider."

  oidc_discovery_url = "https://token.actions.githubusercontent.com"
  bound_issuer       = "https://token.actions.githubusercontent.com"

  default_role = "github-actions-n3tuk-infra"
}

resource "vault_jwt_auth_backend_role" "infra" {
  backend   = vault_jwt_auth_backend.github_actions.path
  role_name = "github-actions-n3tuk-infra"
  role_type = "jwt"

  bound_audiences = [
    "https://github.com/n3tuk",
  ]

  bound_claims = {
    "repository_owner" = "n3tuk"
  }

  user_claim = "repository"

  token_policies = [
    vault_policy.infra.name
  ]

  # This is a restricted and read-only role, so it shouldn't be necessary for the client to renew its token nor manage
  # additional tokens for access to specific mounts and paths, so we can use a batch token type here.
  token_type    = "batch"
  token_ttl     = 600
  token_max_ttl = 3600
}

resource "vault_policy" "infra" {
  name = "github-actions-n3tuk-infra"

  policy = templatefile("${path.module}/templates/github-actions.hcl", {
    mount    = vault_mount.github_actions.path
    accessor = vault_jwt_auth_backend.github_actions.accessor
  })
}

resource "vault_jwt_auth_backend_role" "infra_vault" {
  backend   = vault_jwt_auth_backend.github_actions.path
  role_name = "github-actions-n3tuk-infra-vault"
  role_type = "jwt"

  bound_audiences = [
    "https://github.com/n3tuk",
  ]

  bound_claims = {
    "repository" = "n3tuk/infra-vault"
  }

  user_claim = "repository"

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

  bound_audiences = [
    "https://github.com/n3tuk",
  ]

  bound_claims = {
    "repository" = "n3tuk/infra-github"
  }

  user_claim = "repository"

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
