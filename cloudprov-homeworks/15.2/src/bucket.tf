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
}

output "www" {
  value = "http(s)://website.yandexcloud.net/${var.bucket_name}/${yandex_storage_object.s3img.key}"
}