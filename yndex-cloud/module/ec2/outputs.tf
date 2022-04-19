output "instances_id" {
  description = "id of created instances"
  value =  {
    for name,instance in yandex_compute_instance.instances:
      name => instance.id
  }
}

output "instances_ip" {
  description = "ips of created instances"
  value =  {
    for name,instance in yandex_compute_instance.instances:
      name => instance.network_interface.0.ip_address
  }
}

output "instances_external_ips" {
  description = "external ips of created instances"
  value =  {
    for name,instance in yandex_compute_instance.instances:
      name => instance.network_interface.0.nat_ip_address
  }
}
