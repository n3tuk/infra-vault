# Read-only access to a single repository's namespace of infrastructure secrets stored in the KV v2 secrets engine,
# intended for GitHub Actions workflows authenticating via GitHub Actions OIDC. Machines are only ever granted read
# access, never write access, as described in .kiro/steering/product.md.
path "${mount}/data/{{identity.entity.aliases.${accessor}.name}}" {
  capabilities = ["read"]
}

path "${mount}/data/{{identity.entity.aliases.${accessor}.name}}/*" {
  capabilities = ["read"]
}

path "${mount}/metadata/{{identity.entity.aliases.${accessor}.name}}" {
  capabilities = ["read", "list"]
}

path "${mount}/metadata/{{identity.entity.aliases.${accessor}.name}}/*" {
  capabilities = ["read", "list"]
}
