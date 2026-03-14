// Создание статического ключа доступа
resource "yandex_iam_service_account_static_access_key" "sa-static-key" {
  service_account_id = var.service_account_id
  description        = "static access key for object storage"
}

# Создание объекта
resource "yandex_storage_object" "s3obj" {
  depends_on = [ yandex_storage_object.s3img ]
  
  access_key = yandex_iam_service_account_static_access_key.sa-static-key.access_key
  secret_key = yandex_iam_service_account_static_access_key.sa-static-key.secret_key
  bucket     = yandex_storage_bucket.this.bucket
  key        = "index.html"
  source     = "html/index.html"
}

resource "yandex_storage_object" "s3img" {
  access_key = yandex_iam_service_account_static_access_key.sa-static-key.access_key
  secret_key = yandex_iam_service_account_static_access_key.sa-static-key.secret_key
  bucket     = yandex_storage_bucket.this.bucket
  key        = "img.webp"
  source     = "html/FDC Willard.webp"
}
