# Provide read and write access (but not create not delete) to all secrets mounts in the OpenBao cluster, allowing
# selected individuals attached to this group permission to read and update secrets in the secrets engines.
%{ for mount in mounts ~}

# ${mount.comment}

path "${mount.path}/data" {
  capabilities = ["read"]
}

path "${mount.path}/data/*" {
  capabilities = ["read", "update", "list"]
}

path "${mount.path}/metadata" {
  capabilities = ["read"]
}

path "${mount.path}/metadata/*" {
  capabilities = ["read", "list"]
}
%{ endfor ~}
