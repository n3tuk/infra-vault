---
inclusion: fileMatch
fileMatchPattern: "**/*.tf"
---

# Terraform Conventions

## Version Constraints

- Terraform version: `~> <version>`, where `<version>` is the minimum version that supports all features used in the
  configuration, and normally the latest stable release (e.g. `~> 1.15.8` at the time of writing).
- Pin provider versions exactly (no range operators) in `terraform.tf`.
- Lock file (`.terraform.lock.hcl`) must include platforms: `linux_amd64`, `linux_arm64`, `darwin_arm64`.

GitHub Dependabot will be used to automatically update the Terraform version and provider versions in `terraform.tf` and
the lock file.

## Providers

This configuration uses the following providers:

- `hashicorp/vault` - HashiCorp Vault resource management
- `goauthentik/authentik` - Authentik identity provider integration
- `integrations/github` - GitHub resource management

All provider blocks are declared in `terraform.tf`.

## File Organisation

Terraform files live under the `terraform/` directory with this structure:

- `terraform.tf` - `terraform {}` block with required version and providers, plus the provider blocks
- `variables.tf` - All input variable declarations
- `locals.tf` - Common local value definitions
- `main.tf` - Primary resource and data source definitions
- `outputs.tf` - Output value declarations
- Additional `*.tf` files may be created to group related resources logically

Do not use a monolithic `main.tf` for everything; split resources into purpose-named files when the configuration grows
(the `terraform_standard_module_structure` tflint rule is intentionally disabled).

## Naming Conventions

- Use `snake_case` for all Terraform identifiers: resources, data sources, variables, locals, outputs, and modules.
- This is enforced by tflint's `terraform_naming_convention` rule.
- Do not duplicate the resource type in the name (e.g. `vault_policy.admin` not `vault_policy.vault_policy_admin` nor
  `vault_policy.admin_policy`).
- Resource names should be descriptive and reflect their purpose, not their type (e.g. `vault_policy.admin` not
  `vault_policy.policy`).

## Variables and Outputs

- All variables must have a `description` (enforced by `terraform_documented_variables`).
- All outputs must have a `description` (enforced by `terraform_documented_outputs`).
- Order variables: required first, then optional with defaults (enforced by terraform-docs sort configuration).
- Use appropriate `type` constraints; prefer specific types over `any`.
- Use `validation` blocks where input constraints exist.
- Use `sensitive = true` for any secrets or credentials.

## Formatting and Style

- Run `terraform fmt` to format all `.tf` files (enforced by pre-commit).
- Use 2-space indentation (Terraform's default).
- Align `=` signs within a block for readability where Terraform fmt does so.
- Place the meta-arguments `count`, `for_each` and `provider`, at the top of `resource`, `data` and `ephermal` blocks,
  separated by a blank line from other arguments. `provider` must be placed after `count` and `for_each` if used, and
  with a blank line separating it from the other meta-argument.
- Place the meta-arguments `lifecycle` and `depends_on` at the bottom of `resource`, `data`, and `emphermal` blocks,
  separated by a blank line from other arguments. `lifecycle` must be placed before `depends_on` if used, and with a
  blank line separating it from the other meta-argument. Neither argument should be written as a single line (e.g.
  `lifecycle { create_before_destroy = true }` is not allowed).

## Documentation

- terraform-docs auto-generates documentation into `README.md` using inject mode with markers:
  ```
  <!-- terraform-docs-start -->
  <!-- terraform-docs-end -->
  ```
- Do not manually edit content between these markers; it will be overwritten.
- Run `task terraform:documentation` to regenerate after changing variables, outputs, or resources.

## Linting

TFLint is configured with the following plugin rulesets:

- `terraform` (v0.15.0) - Core Terraform best practices
- `google` (v0.39.0) - Google Cloud rules
- `aws` (v0.48.0) - AWS rules (including ephemeral resources, deprecated IAM policy attributes, and security group
  inline rules)

Run `task terraform:lint` to execute tflint checks.

If there is a known update for any over the plugin rulesets, they should be recommended for updating.

## Security

- Use ephemeral resources where available (Terraform v1.10+ feature, enforced by
  `aws_ephemeral_resources` rule).
- Do not use deprecated `aws_security_group_rule`; use
  `aws_vpc_security_group_ingress_rule` / `aws_vpc_security_group_egress_rule`.
- Do not use inline ingress/egress arguments on `aws_security_group`.
- Do not use deprecated policy attributes on `aws_iam_role`.
- Snyk runs static analysis on Terraform configuration for misconfigurations.
- Do not inline resources to arguments using heredocs (e.g. `aws_iam_policy` with `policy = <<EOF ... EOF`); instead use:
  - A separate `aws_iam_policy_document` data source instead;
  - jsonencode() to convert the document to JSON, or yamlencode() to convert the document to YAML;
  - Use a separate file and `file()` to read it in; or
  - Use a separate templated file and `templatefile()` to read it in.

## Validation Workflow

After making Terraform changes:

1. `task terraform:fmt` - Format with `terraform fmt` and Prettier.
2. `task terraform:lint` - Run tflint checks.
3. `task terraform:validate` - Run `terraform validate` and lock file checks.
4. `task terraform:documentation` - Regenerate terraform-docs.

Or simply run `task develop` to execute all steps.
