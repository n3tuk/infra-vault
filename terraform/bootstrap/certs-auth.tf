resource "vault_auth_backend" "cert" {
  description = "Client Certificates Backend"

  path = "cert"
  type = "cert"
}
