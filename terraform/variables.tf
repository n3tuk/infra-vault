variable "authentik_url" {
  type        = string
  description = "The base URL of the Authentik instance used to provide OIDC authentication for OpenBao users (e.g. `https://auth.n3t.uk`). This is environment-specific and so is not hard-coded into the configuration."

  validation {
    condition     = can(regex("^https://", var.authentik_url))
    error_message = "The `authentik_url` value must be a valid HTTPS URL."
  }
}

variable "openbao_url" {
  type        = string
  description = "The base URL of the OpenBao instance used to provide the secrets management endpoint (e.g. `https://secrets.n3t.uk`). This is environment-specific and so is not hard-coded into the configuration."

  validation {
    condition     = can(regex("^https://", var.openbao_url))
    error_message = "The `openbao_url` value must be a valid HTTPS URL."
  }
}
