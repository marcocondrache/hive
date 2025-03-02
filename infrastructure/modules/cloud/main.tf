variable "instances" {
  description = "Map of cloud instances to create"
  type = map(object({
    type     = string
    host     = string
    location = string
  }))
}

variable "ssh_key" {
  description = "SSH key to use for the instances"
  type        = string
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

# Create Hetzner cloud servers
resource "hcloud_server" "cloud" {
  for_each = var.instances

  name        = each.key
  server_type = each.value.type
  image       = "debian-11"
  ssh_keys    = [var.ssh_key]
  keep_disk   = true
  backups     = false
  location    = each.value.location
}

# Install NixOS on each cloud server
module "nixos" {
  source = "../nixos"
  
  for_each = var.instances
  
  depends_on = [
    hcloud_server.cloud
  ]

  instance_id = hcloud_server.cloud[each.key].id
  install_user = "root"
  target_user = var.nix_user
  target_host = hcloud_server.cloud[each.key].ipv4_address
  
  nix_repo = var.nix_repo
  host_name = each.value.host
  
  onepassword_vault = var.onepassword_vault
  onepassword_item = each.key
} 