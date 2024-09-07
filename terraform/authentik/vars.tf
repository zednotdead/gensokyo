data "vault_kv_secret_v2" "discord_secret" {
  mount = vault_mount.kv.path
  name  = "cluster/discord"
}

data "vault_kv_secret_v2" "grafana_secret" {
  mount = vault_mount.kv.path
  name  = "cluster/monitoring/grafana"
}

data "vault_kv_secret_v2" "mealie_secret" {
  mount = vault_mount.kv.path
  name  = "cluster/default/mealie"
}

data "vault_kv_secret_v2" "synapse_secret" {
  mount = vault_mount.kv.path
  name  = "cluster/comms/synapse"
}

locals {
  authentik_token = lookup(data.vault_kv_secret_v2.authentik_token.data, "AUTHENTIK_TOKEN")

  discord_client_id     = lookup(data.vault_kv_secret_v2.discord_secret.data, "DISCORD_CLIENT_ID")
  discord_client_secret = lookup(data.vault_kv_secret_v2.discord_secret.data, "DISCORD_CLIENT_SECRET")

  grafana_id     = lookup(data.vault_kv_secret_v2.grafana_secret.data, "GRAFANA_CLIENT_ID")
  grafana_secret = lookup(data.vault_kv_secret_v2.grafana_secret.data, "GRAFANA_CLIENT_SECRET")

  mealie_id     = lookup(data.vault_kv_secret_v2.mealie_secret.data, "CLIENT_ID")

  synapse_id     = lookup(data.vault_kv_secret_v2.synapse_secret.data, "CLIENT_ID")
  synapse_secret = lookup(data.vault_kv_secret_v2.synapse_secret.data, "CLIENT_SECRET")
}
