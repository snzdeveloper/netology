resource "yandex_kms_symmetric_key" "key-a" {
  name                = "kms-128"
  description         = "Key for bucket"
  default_algorithm   = "AES_128"
  rotation_period     = "8760h"
  deletion_protection = false
  lifecycle {
    prevent_destroy = false
  }
}
