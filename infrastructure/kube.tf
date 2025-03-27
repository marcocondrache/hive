module "kube-hetzner" {
  providers = {
    hcloud = hcloud
  }
  
  hcloud_token = var.hcloud_token

  source = "kube-hetzner/kube-hetzner/hcloud"

  ssh_public_key = data.github_repository_file.master.content
  ssh_private_key = null

  network_region = "eu-central"
  network_ipv4_cidr = "10.0.0.0/8"

  cluster_ipv4_cidr = "10.42.0.0/16"
  service_ipv4_cidr = "10.43.0.0/16"
  cluster_dns_ipv4 = "10.43.0.10"

  control_plane_nodepools = [
    {
      name        = "atlas-fsn",
      server_type = "cax11",
      location    = "fsn1",
      labels      = ["master"],
      taints      = [],
      count       = 1
    },
    {
      name        = "atlas-nbg",
      server_type = "cax11",
      location    = "nbg1",
      labels      = ["master"],
      taints      = [],
      count       = 1
    },
    {
      name        = "atlas-hel",
      server_type = "cax11",
      location    = "hel1",
      labels      = ["master"],
      taints      = [],
      count       = 1
    }
  ]

  agent_nodepools = [
    {
      name        = "athena",
      server_type = "cax21",
      location    = "fsn1",
      labels      = [],
      taints      = [],
      count       = 2
    },
  ]

  etcd_s3_backup = {
    etcd-s3-endpoint        = "https://a1a4a1f168c2ac3ef604fe82c0758ae7.r2.cloudflarestorage.com"
    etcd-s3-access-key      = var.r2_access_key
    etcd-s3-secret-key      = var.r2_secret_key
  }

  use_control_plane_lb = false
  allow_scheduling_on_control_plane = true
  system_upgrade_use_drain = true

  cluster_name = "hive"
  use_cluster_name_in_node_name = false

  disable_kube_proxy = true
  disable_network_policy = true
  disable_hetzner_csi = true

  ingress_controller = "none"
  enable_cert_manager = false

  extra_firewall_rules = [
    {
      direction       = "in"
      protocol        = "udp"
      port            = "41641"
      description     = "Allow tailscale"
      source_ips      = ["0.0.0.0/0", "::/0"]
      destination_ips = []
    }, 
    {
      direction       = "out"
      protocol        = "udp"
      port            = "3478"
      description     = "Allow tailscale"
      source_ips      = []
      destination_ips = ["0.0.0.0/0", "::/0"]
    }
  ]

  enable_wireguard = true

  cni_plugin = "cilium"
  cilium_version = "1.17.2"

  cilium_values = file("${var.kubernetes_path}/apps/kube-system/cilium/app/helm/values.yaml")

  dns_servers = [
    "1.1.1.1",
    "8.8.8.8",
    "2606:4700:4700::1111",
  ]
  
  create_kubeconfig = false
  create_kustomization = false
}