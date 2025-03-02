output "cloud_instances" {
  description = "Cloud instances"
  value = module.cloud.cloud_servers
}

output "edge_instances" {
  description = "Edge instances"
  value = module.edge.edge_servers
}

output "local_instances" {
  description = "Local instances"
  value = module.local.instances
}