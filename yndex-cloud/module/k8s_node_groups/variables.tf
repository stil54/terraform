variable node_group {
  type = map(
    object({
      description = string
      platform_id = string
      nat = bool
      workers = map(string)
      // subnets = map(string)
    })
  )
}

variable cluster_node_groups {
  default = {}
}

variable location_subnets {
  type = map
}

variable env {
  type = string
}

variable k8s_version {
  type = string
}

variable cluster_id {
  type = string
}
