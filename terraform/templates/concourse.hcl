# A dedicated policy with permissions to list and read concourse-specific secrets only.

path "concourse/data" {
 capabilities = ["read"]
}

path "concourse/data/*" {
 capabilities = ["read", "list"]
}

path "concourse/metadata" {
 capabilities = ["read"]
}

path "concourse/metadata/*" {
 capabilities = ["read", "list"]
}
