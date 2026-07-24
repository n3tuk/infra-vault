# A dedicated, elevated policy for the n3tuk/infra-github GitHub repository, which is the administrative repository for
# the GitHub repositories. This policy is intended to be used by GitHub Actions workflows, when authenticating via
# GitHub Actions OIDC, and provides the ability to create, update, and delete secrets for GitHub repositories, but not
# to read or list them.

path "${mount}/data" {
  capabilities = ["read"]
}

path "${mount}/metadata" {
  capabilities = ["read"]
}

path "${mount}/data/*" {
  capabilities = ["create", "patch", "update", "delete"]
}

path "${mount}/metadata/*" {
  capabilities = ["delete"]
}

# Only allow read-only access to its own secrets namespace, as this is a bootstrapping repository and it should not be
# able to create nor delete its own secrets.

path "${mount}/data/n3tuk/infra-github" {
  capabilities = ["read"]
}

path "${mount}/data/n3tuk/infra-github/*" {
  capabilities = ["read"]
}

path "${mount}/metadata/n3tuk/infra-github" {
  capabilities = ["list", "read"]
}

path "${mount}/metadata/n3tuk/infra-github/*" {
  capabilities = ["list", "read"]
}
