
#создаем 2 идентичные ВМ
resource "yandex_compute_instance" "teamcity-agent" {
  depends_on = [ module.cloudinit ]
  
  for_each = tomap({ for k,v in var.each_agent: k => v })

  name        = "teamcity-agent-${each.value["name"]}" #Имя ВМ в облачной консоли
  hostname    = "${each.value["name"]}" #формирует FDQN имя хоста, без hostname будет сгенрировано случаное имя.
  platform_id = "standard-v1"

  resources {
    cores         = 2
    memory        = 1
    core_fraction = 20
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu-2404-lts.image_id
      type     = "network-hdd"
      size     = 15
    }
  }

  #metadata = local.metadata
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

output "vms-teamcity-agent" {
  value =  {
    for k,v in yandex_compute_instance.teamcity-agent: v.name => { vms = v.network_interface[0].nat_ip_address }
  }
}
