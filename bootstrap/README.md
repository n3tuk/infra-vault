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
[bootstrap:init] Terraform has been successfully initialized!
$ task workspace:{environment}
[bootstrap:workspace] Switched to workspace "vault.{e}.cym-south-1.kub3.uk".
[bootstrap:workspace] vault.{e}.cym-south-1.kub3.uk Active
$ task validate
[bootstrap:validate] Success! The configuration is valid.
[bootstrap:validate] Passed
$ task plan
[bootstrap:plan] No changes. Your infrastructure matches the configuration.
$ task apply                                                                                 5s
[bootstrap:apply] Apply complete! Resources: 0 added, 0 changed, 0 destroyed.
```

<!-- BEGIN_TF_DOCS -->
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
