resource "yandex_kubernetes_cluster" "regional_cluster" {
  name        = var.cluster_name
  network_id =  var.network_id

  cluster_ipv4_range = var.cluster_ipv4
  service_ipv4_range = var.service_ipv4

  master {
    regional {
      region = "ru-central1"

      dynamic "location" {
        for_each = var.location_subnets

        content {
          zone      = location.value.zone
          subnet_id = location.value.id
        }
      }
    }

    version   = var.k8s_version
    public_ip = true

    maintenance_policy {
      auto_upgrade = false

      # maintenance_window {
      #   day        = "monday"
      #   start_time = "15:00"
      #   duration   = "3h"
      # }

      # maintenance_window {
      #   day        = "friday"
      #   start_time = "10:00"
      #   duration   = "4h30m"
      # }
    }
  }

  service_account_id = var.cluster_service_account_id
  node_service_account_id = var.node_service_account_id

  network_policy_provider = "CALICO"


  labels = {
    env = var.env
  }

  release_channel = var.release_channel
}
