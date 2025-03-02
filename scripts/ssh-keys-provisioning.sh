#!/usr/bin/env bash

# Exit on error
set -e

TARGET_DIR="./persist/etc/ssh"
KEY_PATH="$TARGET_DIR/ssh_host_ed25519_key"
KEY_PUB_PATH="$TARGET_DIR/ssh_host_ed25519_key.pub"

install -m 755 -d "$TARGET_DIR"

# Write keys to files
op read "op://${OP_VAULT}/${OP_ITEM}/private key?ssh-format=openssh" > "$KEY_PATH"
op read "op://${OP_VAULT}/${OP_ITEM}/public key" > "$KEY_PUB_PATH"

# Set appropriate permissions
chmod 600 "$KEY_PATH"
chmod 644 "$KEY_PUB_PATH"

echo "SSH host keys have been successfully provisioned"