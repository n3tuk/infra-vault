# A dedicated, elevated policy for the n3tuk/infra-vault GitHub repository, which is the administrative repository for
# the OpenBao cluster. This policy is intended to be used by GitHub Actions workflows, when authenticating via GitHub
# Actions OIDC, and provides administrative access to the OpenBao cluster.

path "*" {
  capabilities = ["create", "read", "update", "delete", "list", "sudo"]
}

# However, deny access to the infrastructure secrets stored in the following secrets engines to limit the possibility of
# exfiltration during the compromise of a token, and as this repository is part of the bootstrapping process for the
# OpenBao cluster and cannot use secrets from the infrastructure secrets engine to bootstrap itself.
#
# This is mainly set as security measure (albeit probably not a hugely effective one) to limit the blast radius of a
# potential compromise, stopping the ability to browse and fetch secrets.
%{ for mount in mounts ~}

# ${mount.comment} Secrets Engine
path "${mount.path}/data" {
  capabilities = ["deny"]
}

path "${mount.path}/data/*" {
  capabilities = ["deny"]
}

path "${mount.path}/metadata" {
  capabilities = ["deny"]
}

path "${mount.path}/metadata/*" {
  capabilities = ["deny"]
}
%{ endfor ~}
