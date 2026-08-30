# n3t.uk Terraform Configuration for OpenBao

This is the [Terraform][terraform] configuration for the management of the OpenBao service within the n3t.uk
infrastructure. Specifically OpenBao will be providing the secrets management service, alongside integrations into both
the [Authentik][authentik] OIDC service at [accounts.services.n3t.uk][n3tuk-accounts], and the [GitHub Actions
OIDC][github-actions-oidc] for the purposes of authenticating both users and machine-to-machine access.

> [!TIP]
>
> This documentation provides a high-level overview of this Terraform configuration and the service. For more
> information and resources, please visit the [pages.n3t.uk/infra-openbao][gh-pages] Pages site.

[terraform]: https://www.terraform.io/
[authentik]: https://goauthentik.io/
[n3tuk-accounts]: https://accounts.services.n3t.uk/
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

| Name | Version |
| ---- | ------- |
| <a name="provider_authentik"></a> [authentik](#provider\_authentik) | 2026.5.0 |
| <a name="provider_github"></a> [github](#provider\_github) | 6.13.0 |
| <a name="provider_vault"></a> [vault](#provider\_vault) | 5.10.1 |

## Modules

No modules.

## Resources

| Name | Type |
| ---- | ---- |
| [authentik_application.openbao](https://registry.terraform.io/providers/goauthentik/authentik/2026.5.0/docs/resources/application) | resource |
| [authentik_group.administrator](https://registry.terraform.io/providers/goauthentik/authentik/2026.5.0/docs/resources/group) | resource |
| [authentik_group.all_secrets_reader](https://registry.terraform.io/providers/goauthentik/authentik/2026.5.0/docs/resources/group) | resource |
| [authentik_group.all_secrets_writer](https://registry.terraform.io/providers/goauthentik/authentik/2026.5.0/docs/resources/group) | resource |
| [authentik_policy_binding.administrator](https://registry.terraform.io/providers/goauthentik/authentik/2026.5.0/docs/resources/policy_binding) | resource |
| [authentik_policy_binding.all_secrets_reader](https://registry.terraform.io/providers/goauthentik/authentik/2026.5.0/docs/resources/policy_binding) | resource |
| [authentik_policy_binding.all_secrets_writer](https://registry.terraform.io/providers/goauthentik/authentik/2026.5.0/docs/resources/policy_binding) | resource |
| [authentik_property_mapping_provider_scope.openbao_groups](https://registry.terraform.io/providers/goauthentik/authentik/2026.5.0/docs/resources/property_mapping_provider_scope) | resource |
| [authentik_provider_oauth2.openbao](https://registry.terraform.io/providers/goauthentik/authentik/2026.5.0/docs/resources/provider_oauth2) | resource |
| [github_actions_organization_oidc_subject_claim_customization_template.organization](https://registry.terraform.io/providers/integrations/github/6.13.0/docs/resources/actions_organization_oidc_subject_claim_customization_template) | resource |
| [vault_approle_auth_backend_role.concourse](https://registry.terraform.io/providers/hashicorp/vault/5.10.1/docs/resources/approle_auth_backend_role) | resource |
| [vault_approle_auth_backend_role.raft_snapshotter](https://registry.terraform.io/providers/hashicorp/vault/5.10.1/docs/resources/approle_auth_backend_role) | resource |
| [vault_approle_auth_backend_role_secret_id.concourse](https://registry.terraform.io/providers/hashicorp/vault/5.10.1/docs/resources/approle_auth_backend_role_secret_id) | resource |
| [vault_approle_auth_backend_role_secret_id.raft_snapshotter](https://registry.terraform.io/providers/hashicorp/vault/5.10.1/docs/resources/approle_auth_backend_role_secret_id) | resource |
| [vault_auth_backend.approle](https://registry.terraform.io/providers/hashicorp/vault/5.10.1/docs/resources/auth_backend) | resource |
| [vault_identity_group.administrator](https://registry.terraform.io/providers/hashicorp/vault/5.10.1/docs/resources/identity_group) | resource |
| [vault_identity_group.all_secrets_reader](https://registry.terraform.io/providers/hashicorp/vault/5.10.1/docs/resources/identity_group) | resource |
| [vault_identity_group.all_secrets_writer](https://registry.terraform.io/providers/hashicorp/vault/5.10.1/docs/resources/identity_group) | resource |
| [vault_identity_group_alias.authentik_administrator](https://registry.terraform.io/providers/hashicorp/vault/5.10.1/docs/resources/identity_group_alias) | resource |
| [vault_identity_group_alias.authentik_all_secrets_reader](https://registry.terraform.io/providers/hashicorp/vault/5.10.1/docs/resources/identity_group_alias) | resource |
| [vault_identity_group_alias.authentik_all_secrets_writer](https://registry.terraform.io/providers/hashicorp/vault/5.10.1/docs/resources/identity_group_alias) | resource |
| [vault_jwt_auth_backend.authentik](https://registry.terraform.io/providers/hashicorp/vault/5.10.1/docs/resources/jwt_auth_backend) | resource |
| [vault_jwt_auth_backend.github_actions](https://registry.terraform.io/providers/hashicorp/vault/5.10.1/docs/resources/jwt_auth_backend) | resource |
| [vault_jwt_auth_backend_role.authentik_administrator](https://registry.terraform.io/providers/hashicorp/vault/5.10.1/docs/resources/jwt_auth_backend_role) | resource |
| [vault_jwt_auth_backend_role.authentik_secrets_reader](https://registry.terraform.io/providers/hashicorp/vault/5.10.1/docs/resources/jwt_auth_backend_role) | resource |
| [vault_jwt_auth_backend_role.authentik_secrets_writer](https://registry.terraform.io/providers/hashicorp/vault/5.10.1/docs/resources/jwt_auth_backend_role) | resource |
| [vault_jwt_auth_backend_role.infra](https://registry.terraform.io/providers/hashicorp/vault/5.10.1/docs/resources/jwt_auth_backend_role) | resource |
| [vault_jwt_auth_backend_role.infra_github](https://registry.terraform.io/providers/hashicorp/vault/5.10.1/docs/resources/jwt_auth_backend_role) | resource |
| [vault_jwt_auth_backend_role.infra_vault](https://registry.terraform.io/providers/hashicorp/vault/5.10.1/docs/resources/jwt_auth_backend_role) | resource |
| [vault_kv_secret_backend_v2.concourse](https://registry.terraform.io/providers/hashicorp/vault/5.10.1/docs/resources/kv_secret_backend_v2) | resource |
| [vault_kv_secret_backend_v2.github_actions](https://registry.terraform.io/providers/hashicorp/vault/5.10.1/docs/resources/kv_secret_backend_v2) | resource |
| [vault_kv_secret_backend_v2.kub3uk](https://registry.terraform.io/providers/hashicorp/vault/5.10.1/docs/resources/kv_secret_backend_v2) | resource |
| [vault_kv_secret_backend_v2.n3tuk](https://registry.terraform.io/providers/hashicorp/vault/5.10.1/docs/resources/kv_secret_backend_v2) | resource |
| [vault_mount.concourse](https://registry.terraform.io/providers/hashicorp/vault/5.10.1/docs/resources/mount) | resource |
| [vault_mount.github_actions](https://registry.terraform.io/providers/hashicorp/vault/5.10.1/docs/resources/mount) | resource |
| [vault_mount.kub3uk](https://registry.terraform.io/providers/hashicorp/vault/5.10.1/docs/resources/mount) | resource |
| [vault_mount.n3tuk](https://registry.terraform.io/providers/hashicorp/vault/5.10.1/docs/resources/mount) | resource |
| [vault_policy.administrator](https://registry.terraform.io/providers/hashicorp/vault/5.10.1/docs/resources/policy) | resource |
| [vault_policy.all_secrets_reader](https://registry.terraform.io/providers/hashicorp/vault/5.10.1/docs/resources/policy) | resource |
| [vault_policy.all_secrets_writer](https://registry.terraform.io/providers/hashicorp/vault/5.10.1/docs/resources/policy) | resource |
| [vault_policy.concourse](https://registry.terraform.io/providers/hashicorp/vault/5.10.1/docs/resources/policy) | resource |
| [vault_policy.infra](https://registry.terraform.io/providers/hashicorp/vault/5.10.1/docs/resources/policy) | resource |
| [vault_policy.infra_github](https://registry.terraform.io/providers/hashicorp/vault/5.10.1/docs/resources/policy) | resource |
| [vault_policy.infra_vault](https://registry.terraform.io/providers/hashicorp/vault/5.10.1/docs/resources/policy) | resource |
| [vault_policy.raft_snapshotter](https://registry.terraform.io/providers/hashicorp/vault/5.10.1/docs/resources/policy) | resource |
| [authentik_certificate_key_pair.default_self_signed](https://registry.terraform.io/providers/goauthentik/authentik/2026.5.0/docs/data-sources/certificate_key_pair) | data source |
| [authentik_flow.default_authentication_flow](https://registry.terraform.io/providers/goauthentik/authentik/2026.5.0/docs/data-sources/flow) | data source |
| [authentik_flow.default_authorization_flow](https://registry.terraform.io/providers/goauthentik/authentik/2026.5.0/docs/data-sources/flow) | data source |
| [authentik_flow.default_invalidation_flow](https://registry.terraform.io/providers/goauthentik/authentik/2026.5.0/docs/data-sources/flow) | data source |
| [authentik_property_mapping_provider_scope.email](https://registry.terraform.io/providers/goauthentik/authentik/2026.5.0/docs/data-sources/property_mapping_provider_scope) | data source |
| [authentik_property_mapping_provider_scope.openid](https://registry.terraform.io/providers/goauthentik/authentik/2026.5.0/docs/data-sources/property_mapping_provider_scope) | data source |
| [authentik_property_mapping_provider_scope.profile](https://registry.terraform.io/providers/goauthentik/authentik/2026.5.0/docs/data-sources/property_mapping_provider_scope) | data source |

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_authentik_url"></a> [authentik\_url](#input\_authentik\_url) | The base URL of the Authentik instance used to provide OIDC authentication for OpenBao users (e.g. `https://accounts.services.n3t.uk`). This is environment-specific and so is not hard-coded into the configuration. | `string` | n/a | yes |
| <a name="input_openbao_url"></a> [openbao\_url](#input\_openbao\_url) | The base URL of the OpenBao instance used to provide the secrets management endpoint (e.g. `https://secrets.services.n3t.uk`). This is environment-specific and so is not hard-coded into the configuration. | `string` | n/a | yes |

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_app_concourse_role_id"></a> [app\_concourse\_role\_id](#output\_app\_concourse\_role\_id) | The Role ID for the Concourse CI AppRole. |
| <a name="output_app_concourse_secret_id"></a> [app\_concourse\_secret\_id](#output\_app\_concourse\_secret\_id) | The Secret ID for the Concourse CI AppRole. |
| <a name="output_app_raft_snapshotter_role_id"></a> [app\_raft\_snapshotter\_role\_id](#output\_app\_raft\_snapshotter\_role\_id) | The Role ID for the raft-snapshotter AppRole. |
| <a name="output_app_raft_snapshotter_secret_id"></a> [app\_raft\_snapshotter\_secret\_id](#output\_app\_raft\_snapshotter\_secret\_id) | The Secret ID for the raft-snapshotter AppRole. |
| <a name="output_apps_auth_path"></a> [apps\_auth\_path](#output\_apps\_auth\_path) | The mount path of the AppRole authentication backend used by services. |
| <a name="output_authentik_application_slug"></a> [authentik\_application\_slug](#output\_authentik\_application\_slug) | The slug of the Authentik application created for OpenBao, used to construct the OIDC discovery URL. |
| <a name="output_authentik_auth_accessor"></a> [authentik\_auth\_accessor](#output\_authentik\_auth\_accessor) | The accessor for the Authentik OIDC authentication backend used to authenticate users. |
| <a name="output_authentik_auth_path"></a> [authentik\_auth\_path](#output\_authentik\_auth\_path) | The mount path of the Authentik OIDC authentication backend used to authenticate users. |
| <a name="output_github_actions_auth_accessor"></a> [github\_actions\_auth\_accessor](#output\_github\_actions\_auth\_accessor) | The accessor for the GitHub Actions OIDC authentication backend used to authenticate GitHub Actions runners. |
| <a name="output_github_actions_auth_path"></a> [github\_actions\_auth\_path](#output\_github\_actions\_auth\_path) | The mount path of the GitHub Actions OIDC authentication backend used to authenticate GitHub Actions runners. |
| <a name="output_secrets_mount_path"></a> [secrets\_mount\_path](#output\_secrets\_mount\_path) | The mount paths of the KV v2 secrets engines used to store infrastructure secrets. |

<!-- prettier-ignore-end -->
<!-- terraform-docs-end -->

## Authors

- Jonathan Wright <jon@than.io>
