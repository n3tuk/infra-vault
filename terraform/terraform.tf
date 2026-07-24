terraform {
  required_version = "~> 1.15.8"

  required_providers {
    vault = {
      source  = "hashicorp/vault"
      version = "5.10.1"
    }
    authentik = {
      source  = "goauthentik/authentik"
      version = "2026.5.0"
    }
    github = {
      source  = "integrations/github"
      version = "6.13.0"
    }
  }

  backend "gcs" {
    bucket = "n3tuk-genuine-caiman-terraform-states"
    prefix = "github/n3tuk/infra-vault"
  }
}

# The Vault provider is authenticated using the VAULT_TOKEN environment variable. During bootstrap this will be the root
# token, provided manually by an Engineer; in CI/CD this will be a short-lived token obtained via the GitHub Actions
# OIDC JWT authentication method configured by this repository.
provider "vault" {
  address = var.openbao_url
}

# The Authentik provider is authenticated using the AUTHENTIK_TOKEN environment variable, which is provided as workflow
# secrets. This will eventually migrate to the Authentik OIDC authentication method using GitHub Action OIDC token.
provider "authentik" {
  url = var.authentik_url
}

# The GitHub provider is authenticated using a GitHub App installation token exchanged for a GITHUB_TOKEN before this
# configuration is run. Using the `token` argument (via the GITHUB_TOKEN environment variable) rather than the
# `app_auth` block avoids a long-standing upstream issue where `terraform validate` fails on an `app_auth {}` block
# without GITHUB_APP_* environment variables are set, and being unable to fall back to GITHUB_TOKEN.
provider "github" {
  owner = local.github_organization
}
