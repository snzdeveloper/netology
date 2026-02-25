resource "yandex_compute_instance" "nat" {

  name        = "nat-vm"
  hostname    = "nat-vm"
  platform_id = "standard-v1"

  resources {
    cores         = 2
    memory        = 1
    core_fraction = 20
  }

  boot_disk {
    initialize_params {
      image_id = var.nat_instance_id
      type     = "network-hdd"
      size     = 5
    }
  }

  metadata = local.metadata

  scheduling_policy { preemptible = true }

  network_interface {
    subnet_id = yandex_vpc_subnet.vpc_public_subnet.id
    nat       = true
    security_group_ids = [ yandex_vpc_security_group.vpc_sg.id ]
    ip_address = var.nat_ip_address
  }

  allow_stopping_for_update = true
}

output "nat-vms" {
  value = {
    for v in [ yandex_compute_instance.nat ]: v.name => "${v.network_interface.0.nat_ip_address}"
  }
}
