resource "authentik_provider_oauth2" "grafana_oauth2" {
  name                  = "grafana"
  client_id             = local.grafana_id
  client_secret         = local.grafana_secret
  authorization_flow    = resource.authentik_flow.provider-authorization-implicit-consent.uuid
  property_mappings     = data.authentik_scope_mapping.oauth2.ids
  access_token_validity = "hours=4"
  redirect_uris         = ["https://grafana.${var.cluster_domain}/login/generic_oauth"]
}

resource "authentik_application" "grafana_application" {
  name               = "Grafana"
  slug               = authentik_provider_oauth2.grafana_oauth2.name
  protocol_provider  = authentik_provider_oauth2.grafana_oauth2.id
  group              = authentik_group.monitoring.name
  open_in_new_tab    = true
  meta_icon          = "https://raw.githubusercontent.com/walkxcode/dashboard-icons/main/png/grafana.png"
  meta_launch_url    = "https://grafana.${var.cluster_domain}/login/generic_oauth"
  policy_engine_mode = "all"
}

resource "authentik_provider_oauth2" "mealie_oauth2" {
  name                  = "mealie"
  client_type           = "public"
  client_id             = local.mealie_id
  authorization_flow    = resource.authentik_flow.provider-authorization-implicit-consent.uuid
  property_mappings     = data.authentik_scope_mapping.oauth2.ids
  access_token_validity = "hours=4"
  redirect_uris = [
    "https://mealie.${var.cluster_domain}/login",
    "https://mealie.${var.cluster_domain}/login?direct=1",
  ]
}

resource "authentik_application" "mealie_application" {
  name               = "Mealie"
  slug               = authentik_provider_oauth2.mealie_oauth2.name
  protocol_provider  = authentik_provider_oauth2.mealie_oauth2.id
  group              = authentik_group.users.name
  open_in_new_tab    = true
  meta_icon          = "https://raw.githubusercontent.com/walkxcode/dashboard-icons/main/png/mealie.png"
  meta_launch_url    = "https://mealie.${var.cluster_domain}"
  policy_engine_mode = "all"
}

resource "authentik_provider_oauth2" "synapse_oauth2" {
  name                  = "synapse"
  client_id             = local.synapse_id
  client_secret         = local.synapse_secret
  authorization_flow    = resource.authentik_flow.provider-authorization-implicit-consent.uuid
  property_mappings     = data.authentik_scope_mapping.oauth2.ids
  access_token_validity = "hours=4"
  redirect_uris         = ["https://matrix.${var.cluster_domain}/_synapse/client/oidc/callback"]
}

resource "authentik_application" "synapse_application" {
  name               = "Synapse"
  slug               = authentik_provider_oauth2.synapse_oauth2.name
  protocol_provider  = authentik_provider_oauth2.synapse_oauth2.id
  group              = authentik_group.users.name
  open_in_new_tab    = true
  meta_icon          = "https://matrix.org/images/matrix-logo-white.svg"
  meta_launch_url    = "https://matrix.${var.cluster_domain}"
  policy_engine_mode = "all"
}
