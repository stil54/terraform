resource "yandex_kubernetes_node_group" "cluster_node_groups" {
  for_each = var.cluster_node_groups

  cluster_id  = var.cluster_id
  name        = each.key
  description = each.value.description
  version     = var.k8s_version

  labels = {
    "env" = var.env
  }

  node_labels = lookup(each.value, "node_labels", null)
  node_taints = lookup(each.value, "node_taints", null)

  instance_template {
    platform_id = each.value.platform_id
    nat         = each.value.nat

    resources {
      memory = each.value.workers.memory
      cores  = each.value.workers.cpu
      // core_fraction = each.value.core_fraction
    }

    boot_disk {
      type = each.value.workers.disk_type
      size = each.value.workers.disk_size
    }

    scheduling_policy {
      preemptible = each.value.workers.preemptible
    }
  }

  deploy_policy {
      max_expansion = each.value.workers.max_exp
      max_unavailable = each.value.workers.max_unav
  }

  scale_policy {
    dynamic "fixed_scale" {
      for_each = flatten([lookup(each.value, "fixed_scale", false ) != false ? [each.value.fixed_scale] : [] ])

      content {
        size = fixed_scale.value.size
      }
    }

    dynamic "auto_scale" {
      for_each = flatten([lookup(each.value, "auto_scale", false ) != false ? [each.value.auto_scale] : [] ])
      
      content {
        min = auto_scale.value.min
        max = auto_scale.value.max
        initial = auto_scale.value.initial
      }
    }
  }

  allocation_policy {
    location {
      zone = var.location_subnets [each.value.subnets].zone
      subnet_id = var.location_subnets [each.value.subnets].id
    }
  }

  maintenance_policy {
    auto_upgrade = false
    auto_repair  = false
  }
}


