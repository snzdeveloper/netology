data "yandex_compute_image" "ubuntu-2004-lts" {
  family = "ubuntu-2004-lts"
}

# создаем открытую ВМ
resource "yandex_compute_instance" "public_vm" {
  # depends_on = [yandex_compute_instance.web]
  # for_each = tomap({ for k,v in var.each_vm: k => v })

  name        = "public-vm" #Имя ВМ в облачной консоли
  hostname    = "public-vm" #формирует FDQN имя хоста, без hostname будет сгенрировано случаное имя.
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
    subnet_id = yandex_vpc_subnet.vpc_public_subnet.id
    nat       = true
    # security_group_ids = [ yandex_vpc_security_group.vpc_sg.id ]
  }
  allow_stopping_for_update = true
}

# создаем приватную ВМ
resource "yandex_compute_instance" "private_vm" {
  # depends_on = [yandex_compute_instance.web]
  # for_each = tomap({ for k,v in var.each_vm: k => v })

  name        = "private-vm" #Имя ВМ в облачной консоли
  hostname    = "private-vm" #формирует FDQN имя хоста, без hostname будет сгенрировано случаное имя.
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
    subnet_id = yandex_vpc_subnet.vpc_private_subnet.id
    nat       = false
    # security_group_ids = [ yandex_vpc_security_group.vpc_sg.id ]
  }
  allow_stopping_for_update = true
}

output "vms" {
  value =  {
    for k,v in [ yandex_compute_instance.public_vm, yandex_compute_instance.private_vm ]: v.name => { 
      vms_nat_ip = v.network_interface[0].nat_ip_address 
      vms_ip = v.network_interface[0].ip_address 
    }
  }
}
