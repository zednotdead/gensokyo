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
