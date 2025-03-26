# TODO: find better way to get the public key
data "github_repository_file" "master" {
  repository          = var.nix_repo
  file                = "home/${var.nix_user}/ssh.pub"
}