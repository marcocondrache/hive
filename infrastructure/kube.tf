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
      server_type = "cax11",
      location    = "fsn1",
      labels      = [],
      taints      = [],
      count       = 2
    },
  ]

  ingress_controller = "none"

  use_control_plane_lb = true
  control_plane_lb_type = "lb11"
  control_plane_lb_enable_public_interface = true

  enable_cert_manager = false

  etcd_s3_backup = {
    etcd-s3-endpoint        = "https://a1a4a1f168c2ac3ef604fe82c0758ae7.eu.r2.cloudflarestorage.com"
    etcd-s3-access-key      = var.r2_access_key
    etcd-s3-secret-key      = var.r2_secret_key
    etcd-s3-bucket          = "hive"
  }

  allow_scheduling_on_control_plane = true
  system_upgrade_use_drain = true

  cluster_name = "hive"
  use_cluster_name_in_node_name = false

  disable_kube_proxy = true
  disable_network_policy = true
  disable_hetzner_csi = true

  cni_plugin = "cilium"
  cilium_version = "1.17.2"
  cilium_routing_mode = "native"
  cilium_ipv4_native_routing_cidr = "10.0.0.0/8"
  cilium_hubble_enabled = true

  dns_servers = [
    "1.1.1.1",
    "8.8.8.8",
    "2606:4700:4700::1111",
  ]
  
  create_kubeconfig = false
  create_kustomization = false
}