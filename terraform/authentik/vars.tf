data "vault_kv_secret_v2" "discord_secret" {
  mount = vault_mount.kv.path
  name  = "cluster/discord"
}

locals {
  authentik_token = lookup(data.vault_kv_secret_v2.authentik_token.data, "AUTHENTIK_TOKEN")
  discord_client_id = lookup(data.vault_kv_secret_v2.discord_secret.data, "DISCORD_CLIENT_ID")
  discord_client_secret = lookup(data.vault_kv_secret_v2.discord_secret.data, "DISCORD_CLIENT_SECRET")
}
