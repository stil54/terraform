output "cluster_name" {
  description = "Cluster name"
  value = yandex_kubernetes_cluster.regional_cluster.name
}

output "cluster_id" {
  value = yandex_kubernetes_cluster.regional_cluster.id
}
