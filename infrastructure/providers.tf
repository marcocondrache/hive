terraform {
  required_version = ">= 1.0.0"

  required_providers {
    hcloud = {
      source  = "hetznercloud/hcloud"
      version = "~> 1.50.0"
    }

    github = {
      source  = "integrations/github"
      version = "~> 6.0"
    }
  }
}