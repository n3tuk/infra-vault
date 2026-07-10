# n3t.uk Terraform Configuration for OpenBao

This is the [Terraform][terraform] configuration for the management of the OpenBao service within the n3t.uk
infrastructure. Specifically OpenBao will be providing the secrets management service, alongside integrations into both
the [Authentik][authentik] OIDC service at [auth.n3t.uk][n3tuk-auth], and the [GitHub Actions OIDC][github-actions-oidc]
for the purposes of authenticating both users and machine-to-machine access.

> [!TIP] This documentation provides a high-level overview of this Terraform configuration and the service. For more
> information and resources, please visit the [pages.n3t.uk/infra-openbao][gh-pages] Pages site.

[terraform]: https://www.terraform.io/
[authentik]: https://goauthentik.io/
[n3tuk-auth]: https://auth.n3t.uk/
[github-actions-oidc]: https://docs.github.com/en/actions/concepts/security/openid-connect
[gh-pages]: https://pages.n3t.uk/infra-openbao

<!-- terraform-docs-start -->
<!-- prettier-ignore-start -->

## Requirements

| Name | Version |
| ---- | ------- |
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.15.8 |
| <a name="requirement_authentik"></a> [authentik](#requirement\_authentik) | 2026.5.0 |
| <a name="requirement_github"></a> [github](#requirement\_github) | 6.13.0 |
| <a name="requirement_vault"></a> [vault](#requirement\_vault) | 5.10.1 |

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

- Jonathan Wright <jon@than.io>
