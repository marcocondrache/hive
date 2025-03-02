terraform {
  encryption {
    key_provider "pbkdf2" "lab_key" {
      passphrase    = var.encryption_passphrase
      key_length    = 32
      salt_length   = 16
      hash_function = "sha256"
    }

    method "aes_gcm" "secure_method" {
      keys = key_provider.pbkdf2.lab_key
    }

    state {
      method = method.aes_gcm.secure_method
    }
  }
}
