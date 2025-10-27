#создаем облачную сеть
resource "yandex_vpc_network" "develop" {
  name = var.name
}

#создаем подсеть
resource "yandex_vpc_subnet" "develop" {
  //count = var.counts
  name           = "${var.name}-${var.zone}"
  zone           = var.zone
  network_id     = yandex_vpc_network.develop.id
  v4_cidr_blocks = var.v4_cidr_blocks
}

output "vpc_network" {
  value = yandex_vpc_network.develop
}

output "vpc_subnet" {
  value = yandex_vpc_subnet.develop
}