provider "yandex" {
  cloud_id  = var.cloud_id
  folder_id = var.folder_id
}

locals {
  cluster_service_account_name = var.cluster_name
  cluster_node_service_account_name = "${var.cluster_name}-node"
  location_subnets_node = data.terraform_remote_state.network.outputs.subnets
  location_subnets = [for name, subnet in data.terraform_remote_state.network.outputs.subnets: subnet if name != "database"]
}

module "iam" {
  source = "../../modules/iam"

  cluster_folder_id = var.folder_id
  cluster_service_account_name = local.cluster_service_account_name
  cluster_node_service_account_name = local.cluster_node_service_account_name
}

module "k8s" {
  source = "../../modules/k8s_cluster"
  location_subnets = local.location_subnets
  cluster_service_account_id = module.iam.cluster_service_account_id
  node_service_account_id = module.iam.cluster_node_service_account_id
  cluster_name = var.cluster_name
  env = var.env
  k8s_version = var.k8s_version
  network_id = data.terraform_remote_state.network.outputs.networks[0]
  release_channel = var.release_channel
  cluster_ipv4 = var.cluster_ipv4
  service_ipv4 = var.service_ipv4
}

module "k8s_node_groups" {
  source = "../../modules/k8s_node_groups"
  cluster_id = module.k8s.cluster_id
  cluster_node_groups = var.cluster_node_groups
  env = var.env
  k8s_version = var.k8s_version
  location_subnets = local.location_subnets_node
}

variable cluster_node_groups {
  default = {}
}

variable tf_backend_bucket {
  type = string
}

variable cloud_id {
  type = string
}

variable cluster_ipv4 {
  type = string
}

variable service_ipv4 {
  type = string
}

variable folder_id {
  type = string
}

variable cluster_name {
  type = string
}

variable env {
  type = string
}

variable k8s_version {
  type = string
}

variable release_channel {
  type = string
}


output "cluster_name" {
  description = "Cluster name"
  value = module.k8s.cluster_name
}

output "cluster_id" {
  description = "Cluster id"
  value = module.k8s.cluster_id
}

output "subnets" {
  value = local.location_subnets_node
}
