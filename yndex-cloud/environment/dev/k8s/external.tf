data "terraform_remote_state" "network" {
  backend = "s3"
  config = {
    bucket                      = var.tf_backend_bucket
    key                         = "net_state"
    region                      = "ru-central1"
    endpoint                    = "storage.yandexcloud.net"
    skip_region_validation      = true
    skip_credentials_validation = true
  }
}
