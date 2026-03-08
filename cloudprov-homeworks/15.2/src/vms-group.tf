# resource "yandex_iam_service_account" "ig-sa" {
#   name        = "ig-sa"
#   description = "Сервисный аккаунт для управления группой ВМ."
# }

# resource "yandex_resourcemanager_folder_iam_member" "compute-editor" {
#   folder_id = var.folder_id
#   role      = "compute.editor"
#   member    = "serviceAccount:${yandex_iam_service_account.ig-sa.id}"
# }

# resource "yandex_resourcemanager_folder_iam_member" "load-balancer-editor" {
#   folder_id = var.folder_id
#   role      = "load-balancer.editor"
#   member    = "serviceAccount:${yandex_iam_service_account.ig-sa.id}"
# }

# resource "yandex_resourcemanager_folder_iam_member" "vpc-user" {
#   folder_id = var.folder_id
#   role      = "vpc.user"
#   member    = "serviceAccount:${yandex_iam_service_account.ig-sa.id}"
# }

resource "yandex_compute_instance_group" "ig-1" {
  name                = "fixed-ig-with-balancer"
  folder_id           = var.folder_id
  #service_account_id  = "${yandex_iam_service_account.ig-sa.id}"
  service_account_id  = var.service_account_id
  deletion_protection = false
  
  instance_template {
    platform_id = "standard-v1"
    resources {
      cores         = 2
      memory        = 1
      core_fraction = 20
    }

    boot_disk {
      mode = "READ_WRITE"
      initialize_params {
        image_id = var.boot_image_id
        type     = "network-hdd"
        size     = 5
      }
    }

    network_interface {
      network_id         = "${yandex_vpc_network.vpc_net.id}"
      subnet_ids         = [ "${yandex_vpc_subnet.vpc_public_subnet.id}" ]
      security_group_ids = [ yandex_vpc_security_group.vpc_sg.id ]
    }

    metadata = local.metadata
  }

  scale_policy {
    fixed_scale {
      size = 3
    }
  }

  allocation_policy {
    zones = [ var.default_zone ]
  }

  deploy_policy {
    max_unavailable = 1
    max_expansion   = 0
  }

  load_balancer {
    target_group_name        = "target-group"
    target_group_description = "Целевая группа Network Load Balancer"
  }
}

resource "yandex_lb_network_load_balancer" "lb-1" {
  name = "network-load-balancer-1"

  listener {
    name = "network-load-balancer-1-listener"
    port = 80
    external_address_spec {
      ip_version = "ipv4"
    }
  }

  attached_target_group {
    target_group_id = yandex_compute_instance_group.ig-1.load_balancer.0.target_group_id

    healthcheck {
      name = "http"
      http_options {
        port = 80
        path = "/index.html"
      }
    }
  }
}
