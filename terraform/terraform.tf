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
}
