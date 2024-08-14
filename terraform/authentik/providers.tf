provider "vault" {
  address = "http://10.0.2.2:8200"
}

resource "vault_mount" "kv" {
  path        = "kv"
  type        = "kv"
  options = {
    version = "2"
  }
}

data "vault_kv_secret_v2" "authentik_token" {
  mount = vault_mount.kv.path
  name  = "cluster/security/authentik"
}

provider "authentik" {
  url   = "https://sso.${var.cluster_domain}"
  token = local.authentik_token
  insecure = true
}
