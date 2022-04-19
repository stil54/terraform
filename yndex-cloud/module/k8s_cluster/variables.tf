variable "location_subnets" {
  type = list(object({
    id = string
    zone = string
  }))
}

variable env {
  type = string
}

variable network_id {
  type = string
}

variable cluster_name {
  type = string
}

variable cluster_service_account_id {
  type = string
}
variable node_service_account_id {
  type = string
}

variable k8s_version {
  type = string
}

variable release_channel {
  type = string
}

variable cluster_ipv4 {
  type = string
}

variable service_ipv4 {
  type = string
}
