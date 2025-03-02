variable "instance_id" {
  description = "ID of the instance to install NixOS on"
  type        = string
}

variable "install_user" {
  description = "User to use for installation"
  type        = string
  default     = "root"
}

variable "target_user" {
  description = "User to use for SSH access after installation"
  type        = string
}

variable "target_host" {
  description = "IP address of the target host"
  type        = string
}

variable "nix_repo" {
  description = "Nix repository"
  type        = string
}

variable "host_name" {
  description = "Hostname for NixOS configuration"
  type        = string
}

variable "onepassword_vault" {
  description = "1Password vault"
  type        = string
}

variable "onepassword_item" {
  description = "1Password item name"
  type        = string
}

module "nixos" {
  source = "github.com/nix-community/nixos-anywhere//terraform/all-in-one"

  nix_options = {
    "tarball-ttl" = 0
  }

  nixos_system_attr      = "github:${var.nix_repo}#nixosConfigurations.${var.host_name}.config.system.build.toplevel"
  nixos_partitioner_attr = "github:${var.nix_repo}#nixosConfigurations.${var.host_name}.config.system.build.diskoScriptNoDeps"

  extra_files_script = "${path.module}/../../scripts/ssh-keys-provisioning.sh"
  extra_environment = {
    OP_VAULT = var.onepassword_vault
    OP_ITEM = var.onepassword_item
  }

  instance_id = var.instance_id
  install_user = var.install_user
  
  target_user = var.target_user
  target_host = var.target_host

  debug_logging = true
} 