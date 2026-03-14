resource "yandex_storage_bucket" "this" {
  folder_id = var.folder_id
  bucket    = var.bucket_name

  website {
    index_document = "index.html"
  }

  anonymous_access_flags {
      list        = var.anonymous_access_flags.list
      read        = var.anonymous_access_flags.read
      config_read = var.anonymous_access_flags.config_read
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = yandex_kms_symmetric_key.key-a.id
        sse_algorithm     = "aws:kms"
      }
    }
  }  
}

output "www" {
  value = "http(s)://website.yandexcloud.net/${var.bucket_name}/${yandex_storage_object.s3img.key}"
}