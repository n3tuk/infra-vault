# n3t.uk Terraform Configuration for OpenBao

This is the [Terraform][terraform] [configuration][configuration] for the management of the OpenBao service within the
n3t.uk infrastructure. Specifically OpenBao will be providing the secrets management service, alongside integrations
into both the [Authentik][authentik] OIDC service at [auth.n3t.uk][n3tuk-auth], and the [GitHub Actions
OIDC][github-actions-oidc] for the purposes of authenticating both users and machine-to-machine access.

> [!TIP] This documentation provides a high-level overview of this Terraform configuration and the service. For more
> information and resources, please visit the [pages.n3t.uk/infra-openbao][gh-pages] Pages site.

[terraform]: https://www.terraform.io/
[configuration]: terraform/
[authentik]: https://goauthentik.io/
[n3tuk-auth]: https://auth.n3t.uk/
[github-actions-oidc]: https://docs.github.com/en/actions/concepts/security/openid-connect
[gh-pages]: https://pages.n3t.uk/infra-openbao

## Authors

- Jonathan Wright <jon@than.io>
