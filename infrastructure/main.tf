# TODO: find better way to get the public key
data "github_repository_file" "master" {
  repository          = var.nix_repo
  file                = "home/${var.nix_user}/ssh.pub"
}

resource "hcloud_ssh_key" "master" {
  name = "master"
  public_key = data.github_repository_file.master.content
}

# Cloud module for Hetzner cloud instances
module "cloud" {
  source = "./modules/cloud"
  
  instances = {
    atlas = {
      type = "cax11"
      host = "atlas"
      location = "fsn1"
    }
  }

  nix_repo = var.nix_repo
  nix_user = var.nix_user

  ssh_key = hcloud_ssh_key.master.id
  onepassword_vault = var.onepassword_vault
}

# Edge module for edge instances in Hetzner
module "edge" {
  source = "./modules/edge"

  depends_on = [ module.cloud ]
  
  instances = {
    athena = {
      type = "cax11"
      host = "athena"
      location = "fsn1"
    }
  }
  
  nix_repo = var.nix_repo
  nix_user = var.nix_user

  ssh_key = hcloud_ssh_key.master.id
  onepassword_vault = var.onepassword_vault
}

# Local module for local instances
module "local" {
  source = "./modules/local"

  depends_on = [ module.cloud, module.edge ]
  
  instances = {}

  nix_repo = var.nix_repo
  nix_user = var.nix_user
  onepassword_vault = var.onepassword_vault
}