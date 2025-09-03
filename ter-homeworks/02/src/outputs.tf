output "vms" {
    
    value = {
        for k,v in [yandex_compute_instance.web, yandex_compute_instance.db]: v.name => {
            name = v.name
            ip = v.network_interface[0].nat_ip_address
            fqdn = v.fqdn
        }
    }
}
