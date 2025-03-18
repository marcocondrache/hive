terraform {
  required_providers {
    hcloud = {
      source  = "hetznercloud/hcloud"
      version = "~> 1.45.0"
    }

     tailscale = {
      source = "tailscale/tailscale"
      version = "~> 0.18.0"
    }

     cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 5"
    }

    onepassword = {
      source = "1Password/onepassword"
      version = "~> 2.1.2"
    }
  }
}