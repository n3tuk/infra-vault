# n3t.uk Terraform Configuration for OpenBao

This is the [Terraform][terraform] [configuration](terraform/) for the management of the OpenBao service within the
n3t.uk Lab Environment. Specifically OpenBao will be providing the secrets management service, alongside integrations
into both the [Authentik][authentik] OIDC service at [accounts.services.n3t.uk][n3tuk-accounts], and the [GitHub Actions
OIDC][github-actions-oidc] for the purposes of authenticating both users and machine-to-machine access.

> [!TIP]
>
> This documentation provides a high-level overview of this Terraform configuration and the service. For more
> information and resources, please visit the [vault.pages.n3t.uk][gh-pages] Pages site.

[terraform]: https://www.terraform.io/
[authentik]: https://goauthentik.io/
[n3tuk-accounts]: https://accounts.services.n3t.uk/
[github-actions-oidc]: https://docs.github.com/en/actions/concepts/security/openid-connect
[gh-pages]: https://vault.pages.n3t.uk/

## License

This repository and project is licensed under the MIT License. See the [`LICENSE`](LICENSE) file for details.

## Authors

- Jonathan Wright [`@jonathanio`](https://github.com/jonathanio) <jon@than.io>
