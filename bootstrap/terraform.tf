terraform {
  required_version = "~> 1.7.0"

  required_providers {
    random = {
      source  = "hashicorp/random"
      version = "~> 3.6.0"
    }
    vault = {
      source  = "hashicorp/vault"
      version = "~> 3.25.0"
    }
    auth0 = {
      source  = "auth0/auth0"
      version = "~> 1.1.2"
    }
  }

  backend "gcs" {
    bucket = "n3tuk-genuine-caiman-terraform-states"
    prefix = "github/n3tuk/infra-vault/bootstrap"
  }
}
