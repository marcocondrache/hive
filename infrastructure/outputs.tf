output "cloud_instances" {
  description = "Cloud instances"
  value = module.cloud.cloud_servers
}

output "cloud_network" {
  description = "Cloud network"
  value = module.cloud.cloud_network
}
