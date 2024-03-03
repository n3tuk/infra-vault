# n3t.uk Vault Cluster Bootstrap Configuration

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

This is a Terraform Configuration which can be used to bootstrap the initial
configuration for a Vault Cluster. Specifically it will:

1. Configure an Auth0 application and connect the Cluster to it via OIDC
   authentication for Single Sign-On access to the Web and CLI interfaces;
1. Configure client-certificate authentication using the n3t.uk Root Certificate
   Authority as the trusted CA for access;
1. Configure basic `adminitrator` and `reader` Roles which both the
   authentication methods above can be permitted to assume.

## Usage

Before running any `plan` or `apply` for Terraform, the following environment
variables are required to authenticate and authorise the creation and management
of the resources inside the Vault Cluster:

| Key                                            | Description                                                                                                              |
| :--------------------------------------------- | :----------------------------------------------------------------------------------------------------------------------- |
| `n3tuk/auth0/n3tuk/configurator/client-id`     | The Client ID of the machine-to-machine application allowed access to the _Auth0 Management API_                         |
| `n3tuk/auth0/n3tuk/configurator/client-secret` | The Client Secret for the above Client ID allowed access to the _Auth0 Management API_                                   |
| `n3tuk/vault/vault.{e}.{region}.kub3.uk/root`  | The `root` Vault Token created during the initlisation of the `{environment}` Cluster and used to configure the baseline |

```console
$ task init
[terraform:bootstrap:init] Terraform has been successfully initialized!
$ task workspace:{environment}
[terraform:bootstrap:workspace] Switched to workspace "vault.{e}.cym-south-1.kub3.uk".
[terraform:bootstrap:workspace] vault.{e}.cym-south-1.kub3.uk Active
$ task validate
[terraform:bootstrap:validate] Success! The configuration is valid.
[terraform:bootstrap:validate] Passed
$ task plan
[terraform:bootstrap:plan] No changes. Your infrastructure matches the configuration.
$ task apply                                                                                 5s
[terraform:bootstrap:apply] Apply complete! Resources: 0 added, 0 changed, 0 destroyed.
```

<!-- terraform-docs-start -->
<!-- prettier-ignore-start -->

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.7.0 |
| <a name="requirement_auth0"></a> [auth0](#requirement\_auth0) | ~> 1.2.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | ~> 3.6.0 |
| <a name="requirement_vault"></a> [vault](#requirement\_vault) | ~> 3.25.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_auth0"></a> [auth0](#provider\_auth0) | 1.2.0 |
| <a name="provider_random"></a> [random](#provider\_random) | 3.6.0 |
| <a name="provider_vault"></a> [vault](#provider\_vault) | 3.25.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [auth0_client.vault](https://registry.terraform.io/providers/auth0/auth0/latest/docs/resources/client) | resource |
| [auth0_client_credentials.vault](https://registry.terraform.io/providers/auth0/auth0/latest/docs/resources/client_credentials) | resource |
| [auth0_connection_client.vault](https://registry.terraform.io/providers/auth0/auth0/latest/docs/resources/connection_client) | resource |
| [random_string.vault_client_secret](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string) | resource |
| [vault_auth_backend.cert](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/auth_backend) | resource |
| [vault_cert_auth_backend_role.administrator](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/cert_auth_backend_role) | resource |
| [vault_cert_auth_backend_role.reader](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/cert_auth_backend_role) | resource |
| [vault_jwt_auth_backend.oidc](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/jwt_auth_backend) | resource |
| [vault_jwt_auth_backend_role.administrator](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/jwt_auth_backend_role) | resource |
| [vault_jwt_auth_backend_role.reader](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/jwt_auth_backend_role) | resource |
| [vault_policy.administrator](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/policy) | resource |
| [auth0_connection.google_oauth2](https://registry.terraform.io/providers/auth0/auth0/latest/docs/data-sources/connection) | data source |
| [vault_policy_document.administrator](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/data-sources/policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_auth0_domain"></a> [auth0\_domain](#input\_auth0\_domain) | The Domain of the Auth0 account to connect OIDC authention with | `string` | `"n3tuk.uk.auth0.com"` | no |

## Outputs

No outputs.

<!-- prettier-ignore-end -->
<!-- terraform-docs-end -->

## Authors

- Jonathan Wright (<jon@than.io>)
