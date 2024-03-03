# n3t.uk Vault Cluster Common Configuration

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

As the Terraform configuration for the general infrastructure deployment
requires that you be authenticated, ensure that you have used the `vault` CLI
application to initiate a `login` request, using either `cert` or `oidc`
methods. The Role should normally be `administrator`.

```console
$ vault login -method=cert role={name}
#   or
$ vault login -method=oidc role={name}
Complete the login via your OIDC provider. Launching browser to:

    https://n3tuk.uk.auth0.com/authorize?client_id={id}&...

Waiting for OIDC authentication to complete...
```

### Deployment

To initiate a deployment, using `task` to both select the Terraform Workspace to
deploy to (normally one of `services`, `development`, or `production`) and then
`plan` and `apply` the configuration.

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

No providers.

## Modules

No modules.

## Resources

No resources.

## Inputs

No inputs.

## Outputs

No outputs.

<!-- prettier-ignore-end -->
<!-- terraform-docs-end -->

## Authors

- Jonathan Wright (<jon@than.io>)
