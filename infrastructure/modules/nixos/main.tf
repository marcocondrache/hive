variable "instance_id" {
  description = "ID of the instance to install NixOS on"
  type        = string
}

variable "install_user" {
  description = "User to use for installation"
  type        = string
  default     = "root"
}

variable "install_host" {
  description = "Host to use for installation"
  type        = string
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

locals {
  nix_options = {
    "tarball-ttl" = 0
  }
}

module "system-build" {
  source = "github.com/nix-community/nixos-anywhere//terraform/nix-build"
  attribute = "github:${var.nix_repo}#nixosConfigurations.${var.host_name}.config.system.build.toplevel"
  nix_options = local.nix_options
}

module "partitioner-build" {
  source = "github.com/nix-community/nixos-anywhere//terraform/nix-build"
  attribute = "github:${var.nix_repo}#nixosConfigurations.${var.host_name}.config.system.build.diskoScriptNoDeps"
  nix_options = local.nix_options
}

module "install" {
  source                       = "github.com/nix-community/nixos-anywhere//terraform/install"
  
  target_user                  = var.install_user
  target_host                  = var.install_host

  nixos_partitioner            = module.partitioner-build.result.out
  nixos_system                 = module.system-build.result.out

  extra_files_script           = "${path.root}/../scripts/ssh-keys-provisioning.sh"
  extra_environment            = {
    OP_VAULT = var.onepassword_vault
    OP_ITEM = var.onepassword_item
  }

  instance_id                  = var.instance_id
  
  build_on_remote              = true
  debug_logging                = true
}

module "configuration" {
  source = "github.com/nix-community/nixos-anywhere//terraform/nixos-rebuild"

  depends_on = [
    module.install
  ]

  nixos_system = module.system-build.result.out

  target_host = var.target_host
  target_user = var.target_user
}