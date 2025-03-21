variable "onepassword_vault" {
  description = "1Password vault"
  type        = string
  sensitive = true
}

variable "encryption_passphrase" {
  description = "Passphrase for the encryption"
  type        = string
  sensitive   = true
}

variable "nix_repo" {
  description = "Nix repository"
  type        = string
}

variable "nix_user" {
  description = "Nix user"
  type        = string
}

variable "tailscale_token" {
  description = "Tailscale token"
  type        = string
  sensitive   = true
}

variable "cloudflare_token" {
  description = "Cloudflare token"
  type        = string
  sensitive   = true
}

variable "cloudflare_zone" {
  description = "Cloudflare zone"
  type        = string
}
