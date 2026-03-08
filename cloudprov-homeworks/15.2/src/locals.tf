locals {
    metadata = {
        user-data = "${local_file.cloud-config.content}"
    }
}

resource "local_file" "cloud-config" {
  content = templatefile("cloud-config.yaml.tftpl",  { ssh_keys = [ "ubuntu:${file(var.ssh_key_file)}" ], img = "http://website.yandexcloud.net/${var.bucket_name}/${yandex_storage_object.s3img.key}" })
  filename = "cloud-config.yaml"
}
