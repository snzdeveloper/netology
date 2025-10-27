
resource "yandex_compute_instance" "teamcity-server" {
  depends_on = [ module.cloudinit ]

  count = 1

  name        = "teamcity-server-${count.index+1}" #Имя ВМ в облачной консоли
  hostname    = "teamcity-server-${count.index+1}" #формирует FDQN имя хоста, без hostname будет сгенрировано случаное имя.
  platform_id = "standard-v1"

  resources {
    cores         = 4
    memory        = 4
    core_fraction = 20
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu-2404-lts.image_id
      type     = "network-hdd"
      size     = 25
    }
  }

  metadata = {
    user-data          = module.cloudinit.content
    serial-port-enable = 1
  }

  scheduling_policy { preemptible = true }

  network_interface {
    subnet_id = yandex_vpc_subnet.develop.id
    nat       = true
    # security_group_ids = [ yandex_vpc_security_group.example.id ]
  }
  allow_stopping_for_update = true

}

output "vms-teamcity-server" {
  value = {
    for k,v in yandex_compute_instance.teamcity-server: v.name => "${v.network_interface.0.nat_ip_address}"
  }
}
