resource "vault_policy" "administrator" {
  name   = "administrator"
  policy = data.vault_policy_document.administrator.hcl
}

data "vault_policy_document" "administrator" {
  rule {
    path         = "*"
    capabilities = ["create", "read", "update", "delete", "list", "sudo"]
  }
}

resource "vault_policy" "reader" {
  name   = "reader"
  policy = data.vault_policy_document.reader.hcl
}

data "vault_policy_document" "reader" {
  rule {
    path         = "sys/health"
    capabilities = ["read", "sudo"]
  }

  rule {
    path         = "sys/policies/acl"
    capabilities = ["list"]
  }

  rule {
    path         = "sys/policies/acl/*"
    capabilities = ["read", "list"]
  }

  rule {
    path         = "auth/*"
    capabilities = ["read", "list"]
  }

  rule {
    path         = "sys/auth"
    capabilities = ["read"]
  }

  rule {
    path         = "sys/mounts/*"
    capabilities = ["read", "list"]
  }

  rule {
    path         = "sys/mounts"
    capabilities = ["read"]
  }
}
