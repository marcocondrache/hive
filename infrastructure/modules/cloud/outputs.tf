output "cloud_servers" {
  description = "Map of cloud servers"
  value = {
    for name, server in hcloud_server.cloud : name => {
      id = server.id
      name = server.name
      ipv4_address = server.ipv4_address
      ipv6_address = server.ipv6_address
      status = server.status
    }
  }
} 