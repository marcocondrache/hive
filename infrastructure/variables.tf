variable "hcloud_token" {
  sensitive = true
  default   = ""
}

variable "encryption_passphrase" {
  description = "Passphrase for encryption"
  sensitive = true
  type        = string
}

variable "r2_access_key" {
  description = "R2 access key"
  sensitive = true
  type        = string
}

variable "r2_secret_key" {
  description = "R2 secret key"
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