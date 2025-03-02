# Terraform Modules

This directory contains the Terraform modules used in this project.

## Modules

### Cloud

The `cloud` module is responsible for creating and managing cloud instances in Hetzner Cloud. It creates the instances and installs NixOS on them. In this project, `atlas` is considered a cloud instance.

### Edge

The `edge` module is responsible for creating and managing edge instances in Hetzner Cloud. It creates the instances and installs NixOS on them. In this project, `athena` is considered an edge instance.

### Local

The `local` module is responsible for managing local instances. These are instances that already exist and are not created by Terraform. The module installs NixOS on them. In this project, local instances are defined in the `local` map.

### NixOS

The `nixos` module is a reusable module that installs NixOS on a server. It is used by the `cloud`, `edge`, and `local` modules. This module internally defines the path to the SSH keys provisioning script.

## Usage

The modules are used in the main Terraform configuration file (`main.tf`). The `cloud`, `edge`, and `local` modules are instantiated with the appropriate parameters.

```hcl
module "cloud" {
  source = "./modules/cloud"
  
  cloud_instances = local.cloud
  ssh_key_id = hcloud_ssh_key.master.id
  nix_repo = var.nix_repo
  nix_user = var.nix_user
  onepassword_vault = var.onepassword_vault
}

module "edge" {
  source = "./modules/edge"
  
  edge_instances = local.edge
  ssh_key_id = hcloud_ssh_key.master.id
  nix_repo = var.nix_repo
  nix_user = var.nix_user
  onepassword_vault = var.onepassword_vault
}

module "local" {
  source = "./modules/local"
  
  local_instances = local.local
  nix_repo = var.nix_repo
  nix_user = var.nix_user
  onepassword_vault = var.onepassword_vault
}
``` 