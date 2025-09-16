# output "out" {

#     value = yandex_compute_instance.db[0].network_interface[0].ip_address
# }

# output "vms-db" {
#   value =  {
#     for k,v in yandex_compute_instance.db[0]: k => { vms = v.network_interface[0].nat_ip_address }
#   }
# }

