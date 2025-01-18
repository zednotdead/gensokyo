terraform {
  required_providers {
    vault = {
      source  = "hashicorp/vault"
      version = "4.6.0"
    }
    authentik = {
      source  = "goauthentik/authentik"
      version = "2024.10.2"
    }
  }
}

variable "cluster_domain" {
  type        = string
  description = "Domain for Authentik"
  sensitive   = false
}

