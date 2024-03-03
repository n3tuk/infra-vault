resource "vault_cert_auth_backend_role" "administrator" {
  backend = vault_auth_backend.cert.path

  name           = "administrator"
  token_policies = ["administrator", "default"]

  certificate = file("${path.module}/n3tuk-root.pem")
}

resource "vault_cert_auth_backend_role" "reader" {
  backend = vault_auth_backend.cert.path

  name           = "reader"
  token_policies = ["reader", "default"]

  certificate = file("${path.module}/n3tuk-root.pem")
}
