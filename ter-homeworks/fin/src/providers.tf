terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">=1.8.4"

  # backend "s3" {
  #   endpoints = {
  #     s3       = "https://storage.yandexcloud.net"
  #     dynamodb = "https://docapi.serverless.yandexcloud.net/ru-central1/b1gqtdr2pgmokhdak4fd/etn50v8isbt5csjnrck9"
  #   }
  #   bucket            = "snzdev"
  #   region            = "ru-central1"
  #   key               = "ter-homeworks-fin/terraform.tfstate"

  #   dynamodb_table = "state-lock-table"

  #   skip_region_validation      = true
  #   skip_credentials_validation = true
  #   skip_requesting_account_id  = true # Необходимая опция Terraform для версии 1.6.1 и старше.
  #   skip_s3_checksum            = true # Необходимая опция при описании бэкенда для Terraform версии 1.6.3 и старше.
  # }
}

provider "yandex" {
  //token     = var.token
  service_account_key_file = file("~/.sa-terraform-key.json")
  cloud_id  = var.cloud_id
  folder_id = var.folder_id
  zone      = var.default_zone
}

