# A dedicated policy with permissions to trigger a snapshot of the Raft storage backend only.

path "sys/storage/raft/snapshot" {
  capabilities = ["read"]
}
