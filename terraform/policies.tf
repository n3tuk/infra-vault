resource "vault_policy" "administrator" {
  name   = "administrator"
  policy = file("${path.module}/templates/administrator.hcl")
}

resource "vault_policy" "all_secrets_writer" {
  name = "all-secrets-writer"

  policy = templatefile("${path.module}/templates/all-secrets-writer.hcl", {
    mounts = [
      {
        comment = "GitHub Actions Secrets Engine"
        path    = vault_mount.github_actions.path
      },
      {
        comment = "Concourse CI Secrets Engine"
        path    = vault_mount.concourse.path
      },
      {
        comment = "kub3.uk Secrets Engine"
        path    = vault_mount.kub3uk.path
      },
      {
        comment = "n3t.uk Secrets Engine"
        path    = vault_mount.n3tuk.path
      },
    ]
  })
}

resource "vault_policy" "all_secrets_reader" {
  name = "all-secrets-reader"

  policy = templatefile("${path.module}/templates/all-secrets-reader.hcl", {
    mounts = [
      {
        comment = "GitHub Actions Secrets Engine"
        path    = vault_mount.github_actions.path
      },
      {
        comment = "Concourse CI Secrets Engine"
        path    = vault_mount.concourse.path
      },
      {
        comment = "kub3.uk Secrets Engine"
        path    = vault_mount.kub3uk.path
      },
      {
        comment = "n3t.uk Secrets Engine"
        path    = vault_mount.n3tuk.path
      },
    ]
  })
}

resource "vault_policy" "raft_snapshotter" {
  name = "raft-snapshotter"

  policy = file("${path.module}/templates/raft-snapshotter.hcl")
}

resource "vault_policy" "concourse" {
  name = "concourse"

  policy = file("${path.module}/templates/concourse.hcl")
}
