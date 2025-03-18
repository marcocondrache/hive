data "cloudflare_ip_ranges" "cloudflare" {}

data "tailscale_device" "tailscale" {
  for_each = var.instances
  hostname = each.value.host
}

variable "instances" {
  description = "Map of cloud instances to create"
  type = map(object({
    type     = string
    host     = string
    location = string
  }))
}

variable "ssh_key" {
  description = "SSH key to use for the instances"
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

variable "onepassword_vault" {
  description = "1Password vault"
  type        = string
}

resource "hcloud_placement_group" "cloud" {
  name = "cloud"
  type = "spread"
}

resource "hcloud_firewall" "cloud" {
  name = "cloud"

  rule {
    direction = "in"
    protocol = "tcp"
    port = "443"
    source_ips = concat(data.cloudflare_ip_ranges.cloudflare.ipv4_cidrs, data.cloudflare_ip_ranges.cloudflare.ipv6_cidrs)
    description = "Allow Cloudflare IPs"
  }

  rule {
    direction = "in"
    protocol = "udp"
    port = "41641"
    source_ips = ["0.0.0.0/0", "::/0"]
    description = "Allow tailscale"
  }

  rule {
    direction = "out"
    protocol = "tcp"
    port = "80"
    destination_ips = ["0.0.0.0/0", "::/0"]
    description = "Allow HTTP"
  }

  rule {
    direction = "out"
    protocol = "tcp"
    port = "443"
    destination_ips = ["0.0.0.0/0", "::/0"]
    description = "Allow HTTPS"
  }

  rule {
    direction = "out"
    protocol = "udp"
    port = "3478"
    destination_ips = ["0.0.0.0/0", "::/0"]
    description = "Allow outbound tailscale"
  }

  rule {
    direction = "out"
    protocol = "tcp"
    port = "22"
    destination_ips = ["0.0.0.0/0", "::/0"]
    description = "Allow outbound SSH"
  }

  rule {
    direction = "out"
    protocol = "icmp"
    destination_ips = ["0.0.0.0/0", "::/0"]
    description = "Allow ICMP outbound"
  }
}


resource "hcloud_server" "cloud" {
  depends_on = [
    hcloud_placement_group.cloud
  ]

  for_each = var.instances

  name        = each.key
  server_type = each.value.type
  image       = "debian-11"
  ssh_keys    = [var.ssh_key]
  keep_disk   = true
  backups     = false
  location    = each.value.location

  placement_group_id = hcloud_placement_group.cloud.id
}

resource "hcloud_firewall_attachment" "cloud" {
  depends_on = [ module.nixos ]

  firewall_id = hcloud_firewall.cloud.id
  server_ids   = [for server in hcloud_server.cloud : server.id]
}

module "nixos" {
  source = "../nixos"
  
  for_each = var.instances
  
  depends_on = [
    hcloud_server.cloud
  ]

  instance_id = hcloud_server.cloud[each.key].id
  install_user = "root"

  target_user = var.nix_user
  target_host = coalesce(data.tailscale_device.tailscale[each.key].addresses[0], hcloud_server.cloud[each.key].ipv4_address)
  
  nix_repo = var.nix_repo
  host_name = each.value.host
  
  onepassword_vault = var.onepassword_vault
  onepassword_item = each.key
} 