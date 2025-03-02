variable "instances" {
  description = "Map of local instances to manage"
  type = map(object({
    host    = string
    address = string
  }))
}

variable "nix_repo" {
  description = "Nix repository"
  type        = string
}

variable "nix_user" {
  description = "Nix user"
  type        = string
}

variable "onepassword_vault" {
  description = "1Password vault"
  type        = string
}

# For local instances, we don't create the servers as they already exist
# We just install NixOS on them

module "nixos" {
  source = "../nixos"
  
  for_each = var.instances
  
  # For local instances, we don't have an instance_id from Hetzner
  # We use a placeholder value
  instance_id = "local-${each.key}"
  install_user = "root"
  target_user = var.nix_user
  target_host = each.value.address
  
  nix_repo = var.nix_repo
  host_name = each.value.host
  
  onepassword_vault = var.onepassword_vault
  onepassword_item = each.key
} 