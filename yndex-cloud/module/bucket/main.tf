data "yandex_resourcemanager_folder" "cluster_folder" {
  folder_id = var.cluster_folder_id
}

resource "yandex_iam_service_account" "iam" {
  name      = var.name
}

resource "yandex_resourcemanager_folder_iam_member" "iam-editor" {
  folder_id = data.yandex_resourcemanager_folder.cluster_folder.id
  
  for_each = toset(var.role)
  role      = each.key
  
  member    = "serviceAccount:${yandex_iam_service_account.iam.id}"
}

resource "yandex_iam_service_account_static_access_key" "static-key" {
  service_account_id = yandex_iam_service_account.iam.id
  description        = var.description
}

resource "yandex_storage_bucket" "bucket" {
  bucket = var.bucket
  access_key = yandex_iam_service_account_static_access_key.static-key.access_key
  secret_key = yandex_iam_service_account_static_access_key.static-key.secret_key
}
