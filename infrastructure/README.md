# n3t.uk Vault Cluster Configuration

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

This is a Terraform Configuration which can be used to provide the general
configuration for a Vault Cluster. Specifically it will:

1. Configure general Roles and Policies for access to resources within the Vault
   Cluster using either SSO or client certificates;
1. Configure the initial PKI resources for the n3t.uk Certificate Authority,
   delegated to each of the Vault Clusters as needed, and the Roles and Policies
   for those too;
1. Configure a general Key/Value v2 resource for anyone to use.

## Usage

Before running any `plan` or `apply` for Terraform, the following environment
variables are required to authenticate and authorise the creation and management
of the resources inside the Vault Cluster:

| Key           | Description                                                                                                                                                                         |
| :------------ | :---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `VAULT_TOKEN` | If not directly authenticated against the Vault Cluster (i.e. using `vault login`) then this environment variable must be set to allow Terraform to manage resources in the Cluster |

### Vault Authentication

As the

[bootstrap]: https://github.com/n3tuk/infra-vault/tree/main/bootstrap/

```console
$ vault login -method=cert role={name}
#   or
$ vault login -method=oidc role={name}
Complete the login via your OIDC provider. Launching browser to:

    https://n3tuk.uk.auth0.com/authorize?client_id={id}&...

Waiting for OIDC authentication to complete...
```

### Deployment

```console
$ task init
[infrastructure:init] Terraform has been successfully initialized!
$ task workspace:{environment}
[infrastructure:workspace] Switched to workspace "vault.{e}.cym-south-1.kub3.uk".
[infrastructure:workspace] vault.{e}.cym-south-1.kub3.uk Active
$ task validate
[infrastructure:validate] Success! The configuration is valid.
[infrastructure:validate] Passed
$ task plan
[infrastructure:plan] No changes. Your infrastructure matches the configuration.
$ task apply
[infrastructure:apply] Apply complete! Resources: 0 added, 0 changed, 0 destroyed.
```

<!-- BEGIN_TF_DOCS -->

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.7.0 |
| <a name="requirement_auth0"></a> [auth0](#requirement\_auth0) | ~> 1.1.2 |
| <a name="requirement_random"></a> [random](#requirement\_random) | ~> 3.6.0 |
| <a name="requirement_vault"></a> [vault](#requirement\_vault) | ~> 3.25.0 |

## Providers

No providers.

## Modules

No modules.

## Resources

No resources.

## Inputs

No inputs.

## Outputs

No outputs.

<!-- END_TF_DOCS -->

## License

Copyright (c) 2024 Jonathan Wright

Permission is hereby granted, free of charge, to any person obtaining a copy of
this software and associated documentation files (the "Software"), to deal in
the Software without restriction, including without limitation the rights to
use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
the Software, and to permit persons to whom the Software is furnished to do so,
subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

## Authors

- Jonathan Wright (<jon@than.io>)
