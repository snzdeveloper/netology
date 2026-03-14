resource "yandex_vpc_network" "vpc_net" {
  name = var.vpc_name
}
resource "yandex_vpc_subnet" "vpc_public_subnet" {
  name           = "public"
  zone           = var.default_zone
  network_id     = yandex_vpc_network.vpc_net.id
  v4_cidr_blocks = var.vpc_public_cidr
}

# //
# // Get information about existing VPC Network.
# //
# data "yandex_vpc_network" "vpcs" {
#   network_id = yandex_vpc_network.vpc_net.id
# }

output "vpcs" {
  //for_each = tomap({ for k,v in yandex_vpc_network.vpc_net.subnet_ids: k => v })
  value = { for k,v in yandex_vpc_network.vpc_net.subnet_ids: k => v }
}

