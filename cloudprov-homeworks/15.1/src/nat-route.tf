# Создание таблицы маршрутизации и статического маршрута
resource "yandex_vpc_route_table" "nat-instance-route" {
  # folder_id      = var.folder_id
  name       = "nat-instance-route"
  network_id = yandex_vpc_network.vpc_net.id

  static_route {
    destination_prefix = "0.0.0.0/0"
    next_hop_address   = yandex_compute_instance.nat.network_interface.0.ip_address
  }
}
