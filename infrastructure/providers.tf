terraform {
  required_version = ">= 1.0.0"

  required_providers {
    hcloud = {
      source  = "hetznercloud/hcloud"
      version = "~> 1.45.0"
    }

    tailscale = {
      source = "tailscale/tailscale"
      version = "~> 0.18.0"
    }

    onepassword = {
      source = "1Password/onepassword"
      version = "~> 2.1.2"
    }

    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 5.1.0"
    }

    github = {
      source  = "integrations/github"
      version = "~> 6.0"
    }

    null = {
      source  = "hashicorp/null"
      version = "~> 3.2.0"
    }

    local = {
      source  = "hashicorp/local"
      version = "~> 2.4.0"
    }
  }
}

provider "cloudflare" {
  api_token = var.cloudflare_token
}

provider "tailscale" {
  api_key = var.tailscale_token
}