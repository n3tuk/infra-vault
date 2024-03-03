provider "vault" {
  address      = "https://${terraform.workspace}:8200/"
  ca_cert_file = "/etc/ssl/private/n3tuk-root.pem"
}
