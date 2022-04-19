resource "yandex_compute_instance" "instances" {
  for_each = var.instances
  name        = each.key
  platform_id = each.value.platform_id
  zone        = each.value.zone
  labels      = each.value.labels
  service_account_id = each.value.service_account_id

  allow_stopping_for_update = each.value.allow_stopping_for_update

  resources {
    cores  = each.value.cpu
    core_fraction = each.value.cpu_fraction
    memory = each.value.memory
  }

  boot_disk {
    initialize_params {
      type = each.value.boot_disk_type
      size = each.value.boot_disk_size
      image_id = each.value.image
    }
  }

  scheduling_policy {
    preemptible = each.value.preemptible
  }

  network_interface {
    subnet_id = var.subnet_id
    nat = each.value.is_public
    ipv4=true
    nat_ip_address = lookup(each.value, "external_address", null)
    ip_address = each.value.ip_address
  }

  metadata = {
    user-data = var.user-data
    serial-port-enable = each.value.serial-port-enable
  }

}
