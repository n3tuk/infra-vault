# Product Overview

## Purpose

The purpose of this repository is to manage the configuration of HashiCorp Vault (OpenBao fork) using Terraform. It
provides a structured and automated way to define, deploy, and maintain the Vault infrastructure, specifically managing
the services it will operate (secrets management engine) and its integrations with authentication services, such as OIDC
using Authentik and GitHub. By using Terraform, this repository allows for version-controlled infrastructure as code,
enabling teams to collaborate effectively and track changes over time, as well as being tested, validated, and deployed
using CI/CD.

## Architecture

This service is a major component of the n3t.uk infrastructure, being responsible for the management of secrets and
sensitive information covering both the standard operations of services, as well as the deployment and management of the
infrastructure itself through CI/CD.

OpenBao, itself, will not be responsible for the management of authentication (Authentik), nor PKI (step-ca).

It will operate in a highly available configuration, deployed by Ansible across five nodes, with three nodes being the
primary Vault servers, and two nodes being the standby Vault servers with voting rights. The remaining two being standby
Vault servers external to the core network. Inter-node communications will be secured using TLS and operate over a
Tailscale VPN mesh network.

## Managed Resources

The purpose of this Terraform configuration is to configure and manage the OpenBao service itself, including its secrets
management engine and its integrations with authentication services. It will not manage the underlying infrastructure,
which is managed by Ansible, nor will it manage the Authentik service itself, which is managed by its own Ansible
configuration.

It will be expected to integrate OpenBao and Authentik to establish a secure and auditable authentication mechanism for
users through OIDC, and to integrate OpenBao with GitHub Actions to enable machine-to-machine authentication for CI/CD
workflows. It will also be expected to manage secrets engines and general system policies to ensure that the service
operates on the principle of least privilege, and that secrets are managed in a secure and auditable manner.

Access by individual re posties will be configured by the Terraform configuration responsible for that repository's
creation and management.

### Auth Methods

There are three methods of authentication to be supported:

- The `root` token to be backed up and used for emergency access only.
- The Authentik service at <https://auth.n3t.uk>, using OIDC, to provide user authentication for selected users to
  manage and rotated selected secrets.
- The GitHub Actions OIDC service to enable temporary authentication using JWT tokens issues by GitHub for access from
  CI/CD for both reading and managing secrets and resources.

### Secret Engines

This service will operate one secrets engines:

- A KV v2 secrets engine at `secrets` to manage infrastructure secrets for the n3t.uk infrastructure, including GitHub
  Workflows and Kubernetes secrets via the External Secrets Operator (ESO).

### Policies

The OpenBan (Vault) configuration must operate on the principal of least-privilege, ensuring that policies are created
which will limit any user (via Authentik) or machine (via GitHub Actions OIDC) to only view and/or edit the resources
which are necessary.

More specifically:

- Users must only be able to list secrets, and, when explicitly allowed to by the policy, to write or initiate an
  automated rotation of a secret;
- Machines must only be read a secret when explicitly allowed to by the policy.

### Authentik Integration

Authentik will be used as an integration which provides centralised user-based authentication. Email addresses will be
used to identify users and assign them to policies which will allow them to read and/or write secrets. The Authentik
integration will be configured to use OIDC to authenticate users and provide them with a temporary token which will be
used to access the OpenBao service.

### GitHub Integration

GitHub Actions OIDC will be used as an integration which provides centralised machine-based authentication. GitHub
Actions will be configured to use OIDC to authenticate machines and provide them with a temporary token which will be
used to access the OpenBao service.

It should be assumed that the subject claim template will include the following customization, with an immutable subject
claim for security:

```plain
repository, event_name, ref, job_workflow_ref
```

## Environments

OpenBao is a centralised common service, therefore all deployemnts will be to a single environment, and single cluster:
production. There will be no separate development or staging environments, and all changes will be made to the
production environment. This is to ensure that the service is always available and that any changes are made in a
controlled and auditable manner.

By default, the Terraform configuration will be deployed to the production environment using only GitHub Workflows, and
any changes to the configuration will be made via pull requests which will be reviewed and approved by the team before
being merged and deployed.

In the event that a change breaks the ability to deploy further changes, the team will be able to use the `root` token
to access the OpenBao service and make any necessary changes to restore the service directly from their local device.

## Access and Authentication

Terraform will authenticate to the OpenBao service in two ways:

- For bootstrapping the configuration, the `root` token will be used in the local environment to configure the service
  and establish the initial policies and secrets engines. This will be done manually by a team member with access to the
  `root` token.
- For ongoing management of the configuration, Terraform will authenticate to the OpenBao service using GitHub Actions
  OIDC integration. This will be done automatically by the GitHub Workflow, generating a JWT token to authenticate to
  the OpenBao service and manage the configuration.

Terraform will authenticate to the Authentik service using an API token, which will be stored in OpenBao as a workflow
secret to be used to authenticate to the Authentik service when needed. In the future this will be upgraded to using
GitHub Actions OIDC integration to authenticate to the Authentik service directly, but for now it will be done using an
API token.

Terraform will authenticate to GitHub using an App installation, which will be configured to allow the Terraform
configuration to manage the GitHub Organization and its repositories. The App installation will be configured with the
necessary credentials stored in OpenBao as workflow secrets to be used to authenticate to the GitHub API when needed.

## Backups

Appropriate authentication and service configuration should be in place to ensure that the OpenBao service is backed up
and can be restored in the event of a failure. This should include regular backups of the service data. The backup
process will be automated and tested regularly to ensure that it is working correctly.
