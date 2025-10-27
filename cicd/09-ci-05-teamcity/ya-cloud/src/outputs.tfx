
output "totals" {
    #{ for k,v in [yandex_compute_instance.storage]: k => "${v.network_interface.0.nat_ip_address}" }
  value = [ 
    for v in flatten([ yandex_compute_instance.web, [ for k,v in yandex_compute_instance.db: v ], yandex_compute_instance.storage ]): {
      name = "${v.name}"
      id = "${v.id}"
      fqdn = "${v.fqdn}"
    } 
  ]
}
