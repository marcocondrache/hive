output "instances" {
  description = "Map of instances"
  value = {
    for name, instance in var.instances : name => {
      host = instance.host
      address = instance.address
    }
  }
} 