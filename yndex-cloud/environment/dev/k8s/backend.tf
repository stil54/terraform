terraform {
  backend "s3" {
    key                         = "k8s_state"
    region                      = "ru-central1"
    endpoint                    = "storage.yandexcloud.net"
    skip_region_validation      = true
    skip_credentials_validation = true
  }
}
