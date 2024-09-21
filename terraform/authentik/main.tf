terraform {
  required_providers {
    vault = {
      source  = "hashicorp/vault"
      version = "4.4.0"
    }
    authentik = {
      source  = "goauthentik/authentik"
      version = "2024.8.3"
    }
  }
}

variable "cluster_domain" {
  type        = string
  description = "Domain for Authentik"
  sensitive   = false
}

