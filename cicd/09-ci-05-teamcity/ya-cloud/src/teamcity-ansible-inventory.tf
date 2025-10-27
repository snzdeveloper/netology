
locals{
  instances_yaml= flatten([ yandex_compute_instance.teamcity-server, [ for k,v in yandex_compute_instance.teamcity-agent: v ] ])
}

resource "local_file" "hosts_yaml" {
  depends_on = [ yandex_compute_instance.teamcity-server, yandex_compute_instance.teamcity-agent ]
  
  content =  <<-EOT
  all:
    hosts:
    %{ for i in local.instances_yaml ~}
  ${i["name"]}:
          ansible_host: ${i["network_interface"][0]["nat_ip_address"]}
          ansible_user: ubuntu
    %{ endfor ~}
  EOT
  filename = "${abspath(path.module)}/hosts.yaml"
}
