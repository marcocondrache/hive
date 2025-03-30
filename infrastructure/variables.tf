variable "hcloud_token" {
  sensitive = true
  default   = ""
}

variable "encryption_passphrase" {
  description = "Passphrase for encryption"
  sensitive = true
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

variable "kubernetes_path" {
  description = "Path to kubernetes directory"
  type        = string
}
