# n3t.uk Terraform Configurations for Hashicorp Vault

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

This is a [Terraform][terraform] repository for the management of multiple
[Hashicorp Vault][vault] Clusters using (currently) local deployments from
internal systems as this service is not publicly accessible.

[terraform]: https://terraform.io/
[vault]: https://www.vaultproject.io

This will provide standardised configurations for services, such as:

- Establishing an ODIC Connection with Auth0 for user-based authentication and
  authorisation (normally via the User Interface);
- Creating and signing the n3t.uk Certificate Authority configuration with an
  Intermediate Certificate for this Cluster, allowing it to create server and
  client certificates on demand (including using [`certbot`][certbot] and
  [`cert-manager`][cert-manager]); and
- Create the default key/value stores which should be available in each of the
  Vault Clusters.

[certbot]: https://certbot.eff.org/
[cert-manager]: https://cert-manager.io/

## Network

![Network Diagram for Vault Cluster Networking](https://github.com/n3tuk/infra-vault/blob/main/docs/vault-networking.svg?raw=true)

[Vault][vault] is currently an internal-only service and hosted outside of
Kubernetes Clusters (as they are required to provision those clusters for
certificates and secrets).

1. Each Vault Cluster is fronted by between one and three [HAProxy][haproxy]
   Nodes which forwards encrypted traffic onto the backend with the `PROXY`
   protocol.
1. Each HAProxy node listens on a dummy interface called `lb01` sharing the same
   IPv4 and IPv6 address across all nodes in the same Cluster, and is
   responsible for monitoring and checking the Vault backend service for
   availability.
1. Each HAProxy node runs `bird` to provide BGP support back to the core router
   which will route traffic to the shared address to one of the HAProxy nodes,
   while also using the BDF protocol to provide rapid failover of routes if the
   primary node restarts or connectivity is otherwise lost.

[haproxy]: https://www.haproxy.org/

When a User or Service makes a request to a Vault Cluster, the request is sent
to first via the Router (the address does not exist on a network within a
broadcast domain, so there can be no ARP) which forwards the traffic onto an
available HAProxy node. The HAProxy service on that node then forwards the
request onto an available Vault backend service, which in turn internally routes
the request to the current primary node.

This traffic flow should allow the failover of any Vault node and any HAProxy
node (assuming there are more than one of each) and still be able to service
requests within the network.

## Bootstrapping

The [`terraform/bootstrap/`][bootstrap] directory which is used to host the initial
Terraform configuration which will configure the initial authentication and
authorisation in the Vault Cluster.

This explicitly uses the `root` token provided by Vault during the
initialisation of the data store. However, the configuration will create the
initial authentication methods as well as the Roles and Policies needed so the
Cluster can be subsequently be managed without the `root` Token.

[bootstrap]: https://github.com/n3tuk/infra-vault/tree/main/terraform/bootstrap/

```console
$ cd terraform/bootstrap/
$ task workspace:{environment}
[terraform:bootstrap:workspace] Switched to workspace "vault.{e}.cym-south-1.kub3.uk".
[terraform:bootstrap:workspace] vault.{e}.cym-south-1.kub3.uk Active
$ task plan
$ task apply
```

> [!IMPORTANT]
> The `root` token for the cluster should only be used for bootstrapping and
> emergencies. If something happens which prevents normal authentication to the
> Vault Cluster, then this bootstrap configuration and the `root` Token should
> be used to restore it. All other uses should be avoided.

### Initial Authentication

Once the Vault Cluster has been bootstrapped, there are three ways to log into
the system:

1. Go to https://vault.{e}.cym-south-1.kub3.uk and select _OIDC_ from the
   drop-down and enter either `administrator` or `reader` to the _Role_. The
   button should show _Sign in with Auth0_. Click it and sign in.
1. Open the console and log in with the `oidc` method and either the
   `administrator` or `reader` roles, and once the browser

   ```console
   $ vault login -method=oidc role={name}
   Complete the login via your OIDC provider. Launching browser to:

        https://n3tuk.uk.auth0.com/authorize?client_id={id}&...

    Waiting for OIDC authentication to complete...
   ```

## Common Configuration

The [`terraform/common/`][common] workspace hosts the configuration for the
management and configuration of Hashicorp Vault resources. The
[`README.md`][readme] therein for further information on supported `variables`
and `outputs`, as well as the what is managed by the workspace.

[common]: https://github.com/n3tuk/infra-vault/tree/main/terraform/common/
[readme]: https://github.com/n3tuk/infra-vault/blob/main/terraform/common/README.md

> [!TIP]
> Ensure that you have authenticated against the Vault Cluster with your `vault`
> CLI application before running the `plan` or `apply` tasks, or Terraform may
> not be able to connect to the Cluster to review, create, or delete resources.

```console
$ cd terraform/common/
$ task workspace:{environment}
[terraform:common:workspace] Switched to workspace "vault.{e}.cym-south-1.kub3.uk".
[terraform:common:workspace] vault.{e}.cym-south-1.kub3.uk Active
$ task plan
$ task apply
```

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
