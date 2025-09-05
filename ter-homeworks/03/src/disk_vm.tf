resource "yandex_compute_disk" "disk" {
  count   = 3
  #disk_id = "hdd-${count.value}"
  type    = "network-hdd"
  zone    = var.default_zone
  size    = 1

  labels = {
    environment = "test"
  }
}

resource "yandex_compute_instance" "storage" {
  depends_on = [yandex_compute_instance.db]

  #count = 1

  name        = "storage" #Имя ВМ в облачной консоли
  hostname    = "storage" #формирует FDQN имя хоста, без hostname будет сгенрировано случаное имя.
  platform_id = "standard-v1"

  resources {
    cores         = 2
    memory        = 1
    core_fraction = 20
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu-2004-lts.image_id
      type     = "network-hdd"
      size     = 5
    }
  }

  metadata = local.metadata

  scheduling_policy { preemptible = true }

  network_interface {
    subnet_id = yandex_vpc_subnet.develop.id
    nat       = true
    security_group_ids = [ yandex_vpc_security_group.example.id ]
  }
  allow_stopping_for_update = true

  dynamic "secondary_disk" {
    for_each = yandex_compute_disk.disk
    #name = each.key
    #disk_id = each.value["disk_id"]
    content {
      disk_id = yandex_compute_disk.disk[secondary_disk.key].id
    }
   }
 } 

