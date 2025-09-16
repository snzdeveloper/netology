#считываем данные об образе ОС
data "yandex_compute_image" "ubuntu-2004-lts" {
  family = "ubuntu-2004-lts"
}


#создаем 2 идентичные ВМ
resource "yandex_compute_instance" "web" {
  depends_on = [yandex_compute_instance.db]

  count = 2

  name        = "web-${count.index+1}" #Имя ВМ в облачной консоли
  hostname    = "web-${count.index+1}" #формирует FDQN имя хоста, без hostname будет сгенрировано случаное имя.
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
}

output "vms" {
  value = {
    for k,v in yandex_compute_instance.web: v.name => "${v.network_interface.0.nat_ip_address}"
  }
}
