---
inclusion: manual
---

# Terraform Patterns

<!-- This file documents reusable patterns for common resource groupings in this
     configuration. Include it manually (via # context) when working on specs or
     implementing new features that follow established patterns. -->

## Vault Auth Method Pattern

<!-- How to configure a new auth method end-to-end. Fill in the standard
     grouping of resources you use. Example structure: -->

### Resources

<!--
1. `vault_auth_backend` - Mount the auth method at a path
2. `vault_policy` - Create the policy granting access
3. `vault_<type>_auth_backend_role` - Create the role binding policy to identity
-->

### Naming

<!--
- Auth backend path: `auth/<method>/<purpose>` or `auth/<method>`?
- Policy naming: `<service>-<access-level>` (e.g. `github-actions-readonly`)?
- Role naming: matches the consuming identity?
-->

### Example

<!--
```hcl
resource "vault_auth_backend" "approle" {
  type = "approle"
  path = "approle"
}

resource "vault_policy" "ci_deploy" {
  name   = "ci-deploy"
  policy = file("${path.module}/policies/ci-deploy.hcl")
}

resource "vault_approle_auth_backend_role" "ci_deploy" {
  backend   = vault_auth_backend.approle.path
  role_name = "ci-deploy"

  token_policies = [vault_policy.ci_deploy.name]
  token_ttl      = 3600
  token_max_ttl  = 7200
}
```
-->

## Vault Secret Engine Pattern

<!-- How to mount and configure a new secret engine. -->

### Resources

<!--
1. `vault_mount` - Mount the secret engine at a path
2. `vault_policy` - Policy granting read/write access to the engine's paths
3. Engine-specific resources (e.g. `vault_kv_secret_v2`, `vault_pki_*`)
-->

### Naming

<!--
- Mount path: `secrets/<purpose>` or `<engine-type>/<purpose>`?
- KV structure: what key hierarchy do you use?
-->

### Example

<!--
```hcl
resource "vault_mount" "kv_infrastructure" {
  path = "secrets/infrastructure"
  type = "kv-v2"

  description = "Key-value store for infrastructure secrets"
}

resource "vault_policy" "infrastructure_read" {
  name   = "infrastructure-read"
  policy = <<-EOT
    path "secrets/data/infrastructure/*" {
      capabilities = ["read", "list"]
    }
  EOT
}
```
-->

## Vault Policy Pattern

<!-- How policies are structured and managed. -->

### Structure

All policies should be defined in templated external files managed under the `terraform/templates/` directory within
this repository. This allows for consistent formatting, reuse, and easier management of policy content.

All files should be named according to the policy they define, e.g. `ci-deploy.hcl`, `monitoring-read.hcl`, etc., using
kebab-case for clarity and consistency.

### Capabilities

- Standard capability sets you use:
  - Read-only: `["read", "list"]`
  - Read-write: `["read", "update", "list"]`
  - Admin: `["create", "read", "update", "delete", "list", "sudo"]`

## Authentik OIDC Integration Pattern

Authentik will be configured to provide OIDC authentication for Vault, but only for users, via both the web interface
and the CLI. Machine-to-machine authentication will be handled via GitHub Actions OIDC.

### Resources

Authentik side:

1. `authentik_provider_oauth2` - OIDC provider for Vault
2. `authentik_application` - Application entry in Authentik
3. `authentik_group` - Groups mapping to Vault policies

Vault side:

1. `vault_jwt_auth_backend` - OIDC auth method pointing at Authentik
2. `vault_jwt_auth_backend_role` - Role mapping claims to policies

### Claim Mapping

<!--
- Which Authentik claims map to Vault policies?
- How are groups used for policy assignment?
- What scopes are requested?
-->

### Example

<!--
```hcl
resource "authentik_provider_oauth2" "vault" {
  name               = "vault"
  authorization_flow = data.authentik_flow.default_authorization.id
  client_id          = "vault"
  # ...
}

resource "vault_jwt_auth_backend" "authentik" {
  path               = "oidc"
  type               = "oidc"
  oidc_discovery_url = "https://auth.example.com/application/o/vault/"
  oidc_client_id     = authentik_provider_oauth2.vault.client_id
  oidc_client_secret = authentik_provider_oauth2.vault.client_secret
  # ...
}
```
-->

## GitHub Integration Pattern

<!-- How GitHub resources are managed in relation to Vault. -->

### Resources

<!--
- `github_actions_secret` - Syncing Vault-generated credentials to GitHub?
- `github_repository_environment` - Environment-scoped secrets?
- Other GitHub resources managed here?
-->

### Cross-Provider References

<!--
- How do Vault outputs feed into GitHub resources?
- Are there data sources pulling from one provider into another?
-->

## File Organisation by Feature

<!-- When a feature spans multiple concerns, how are files structured? -->

<!--
Option A: Group by resource type
  - All policies in one file, all auth backends in another

Option B: Group by feature/service
  - `vault-ci.tf` contains the auth backend, role, and policy for CI
  - `vault-monitoring.tf` contains the auth backend, role, and policy for
    monitoring

Which approach does this project prefer?
-->

## Variables Pattern

<!-- How are variables structured for features that repeat? -->

<!--
- Do you use complex variable types (maps of objects) for repeated resources?
- Or individual variables per instance?
- How is `for_each` used with variable-driven resources?

Example:
```hcl
variable "vault_policies" {
  description = "Map of Vault policies to create"
  type = map(object({
    description = string
    policy      = string
  }))
  default = {}
}

resource "vault_policy" "this" {
  for_each = var.vault_policies

  name   = each.key
  policy = each.value.policy
}
```
-->

## Tagging and Metadata

<!-- Standard metadata applied to resources where supported. -->

<!--
- Do Vault resources use descriptions consistently?
- Any standard description format?
- Tags on cloud resources (if any are managed here)?
-->
