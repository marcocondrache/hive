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
      type = "cax21"
      host = "atlas"
      location = "fsn1"
      address = "10.0.1.1"
      master = true
    }

    athena = {
      type = "cax11"
      host = "athena"
      location = "fsn1"
      address = "10.0.1.2"
      master = false
    }
  }

  nix_repo = var.nix_repo
  nix_user = var.nix_user

  ssh_key = hcloud_ssh_key.master.id
  onepassword_vault = var.onepassword_vault
}